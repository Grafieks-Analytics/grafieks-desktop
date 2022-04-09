#include "datasourceds.h"

/*!
 * \brief Constructor function
 * \initializes QNAM, QByteArray, networkReply variables
 * \param parent
 */
DatasourceDS::DatasourceDS(QObject *parent) : QObject(parent),
    m_networkAccessManager(new QNetworkAccessManager(this)),
    m_networkReply(nullptr),
    m_dataBuffer(new QByteArray)
{

}

/*!
 * \brief Fetch datasource from the Grafieks server API
 * \param page (pagination page number)
 * \param fulllist (whether datasource fullList or the ones owned by the current user)
 * \param listview (listview or gridview)
 * \param keyword (search by keyword)
 */
void DatasourceDS::fetchDatsources(int page, bool fulllist, bool listview, QString keyword)
{

    // Fetch value from settings
    QSettings settings;
    QString baseUrl = settings.value("general/baseUrl").toString();
    QByteArray sessionToken = settings.value("user/sessionToken").toByteArray();
    int profileId = settings.value("user/profileId").toInt();


    QNetworkRequest m_NetworkRequest;
    if(keyword == ""){
        m_NetworkRequest.setUrl(baseUrl+"/listdatasources");
    } else{
        m_NetworkRequest.setUrl(baseUrl+"/searchdatasource");
    }

    m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                               "application/x-www-form-urlencoded");
    m_NetworkRequest.setRawHeader("Authorization", sessionToken);

    QJsonObject obj;
    obj.insert("profileId", profileId);
    obj.insert("page", page);
    obj.insert("fulllist", fulllist);
    obj.insert("listview", listview);

    if(keyword != "")
        obj.insert("keyword", keyword);

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(m_NetworkRequest, strJson.toUtf8());


    connect(m_networkReply,&QIODevice::readyRead,this,&DatasourceDS::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&DatasourceDS::dataReadFinished);
}

/*!
 * \brief Delete a Datasource entry from the Grafieks API
 * \param datasourceId (datasource id)
 * \param listIndex (id of the entry in view list)
 */
void DatasourceDS::deleteDatasource(int datasourceId, int listIndex)
{
    // Fetch value from settings
    QSettings settings;
    QString baseUrl = settings.value("general/baseUrl").toString();
    QByteArray sessionToken = settings.value("user/sessionToken").toByteArray();
    int profileId = settings.value("user/profileId").toInt();


    QNetworkRequest m_NetworkRequest;
    m_NetworkRequest.setUrl(baseUrl+"/deletedatasource");


    m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                               "application/x-www-form-urlencoded");
    m_NetworkRequest.setRawHeader("Authorization", sessionToken);

    QJsonObject obj;
    obj.insert("profileId", profileId);
    obj.insert("datasourceId", datasourceId);


    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(m_NetworkRequest, strJson.toUtf8());

    this->removeDatasource(listIndex);


    connect(m_networkReply,&QIODevice::readyRead,this,&DatasourceDS::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&DatasourceDS::dataDeleteFinished);
}


/*!
 * \brief Notify view of a new datasource object
 * \param datasource
 */

void DatasourceDS::addDatasource(Datasource *datasource)
{
    emit preItemAdded();
    m_datasource.append(datasource);
    emit postItemAdded();
}

/*!
 * \brief Add datasource object to the model
 * \param id (datasource id)
 * \param connectedWorkbooksCount (total workbooks in datasource)
 * \param profileId (owner)
 * \param connectionType (live/extract)
 * \param datasourceName
 * \param databaseName
 * \param descriptions
 * \param sourceType (live/extract)
 * \param imageLink (datasource image)
 * \param downloadLink (download link of the datasource)
 * \param createdDate (datasource creation date)
 * \param firstName (owner firstname)
 * \param lastName (owner lastname)
 */
void DatasourceDS::addDatasource(const int & id, const int & connectedWorkbooksCount, const int & profileId, const QString & connectionType, const QString & datasourceName, const QString & databaseName, const QString & descriptions, const QString & sourceType, const QString & imageLink, const QString & downloadLink, const QString & createdDate, const QString & firstName, const QString & lastName, const QString & lastRun, const bool & downloadAllowed, const bool & connectAllowed, const bool & publishAllowed)

{
    Datasource *datasource = new Datasource(id, connectedWorkbooksCount, profileId, connectionType, datasourceName, databaseName, descriptions, sourceType, imageLink, downloadLink, createdDate, firstName, lastName, lastRun, downloadAllowed, connectAllowed, publishAllowed, this);

    addDatasource(datasource);

}

/*!
 * \brief Remove a datasource at index and notify view
 * \param index (datasource id/index)
 */
void DatasourceDS::removeDatasource(int index)
{
    emit preItemRemoved(index);
    m_datasource.removeAt(index);
    emit postItemRemoved();
}

/*!
 * \brief Clear Datasource model & notify view
 */
void DatasourceDS::resetDatasource()
{
    emit preReset();
    m_datasource.clear();
    emit postReset();
}


/*!
 * \brief Returns the data in the model
 * \return QList<Datasource *>
 */
QList<Datasource *> DatasourceDS::dataItems()
{
    return m_datasource;
}

/*!
 * \brief Called when DatasourceDS::fetchDatsources is fired
 * \details populates the data buffer read from the API
 */
void DatasourceDS::dataReadyRead()
{
    m_dataBuffer->append(m_networkReply->readAll());
}

/*!
 * \brief Called when DatasourceDS::fetchDatsources is fired
 * \details  Once called the method reads the data buffer and adds data to the model
 */
void DatasourceDS::dataReadFinished()
{
    //Parse the JSON
    if( m_networkReply->error()){
        qDebug() << "There was some error : " << m_networkReply->errorString();
    }else{

        this->resetDatasource();

        QJsonDocument resultJson = QJsonDocument::fromJson(* m_dataBuffer);
        QJsonObject resultObj = resultJson.object();
        QJsonObject statusObj = resultObj["status"].toObject();


        // If successful, set the variables in settings
        if(statusObj["code"].toInt() == 200){

            QJsonArray dataArray = resultObj["data"].toArray();

            for(int i = 0; i< dataArray.size(); i++){

                QJsonObject dataObj = dataArray.at(i).toObject();

                int DatasourceID = dataObj["DatasourceID"].toInt();
                int ConnectedWorkbooksCount = dataObj["ConnectedWorkbooksCount"].toInt();
                int DSProfileID = dataObj["DSProfileID"].toInt();
                QString ConnectionType = dataObj["ConnectionType"].toString();
                QString DatasourceName = dataObj["DatasourceName"].toString();
                QString DatabaseName = dataObj["DatabaseName"].toString();
                QString Descriptions = dataObj["Description"].toString();
                QString SourceType = dataObj["SourceType"].toString();
                QString ImageLink = dataObj["ImageLink"].toString();
                QString DatasourceLink = dataObj["DatasourceLink"].toString();
                QString CreatedDate = dataObj["CreatedDate"].toString();
                QString Firstname = dataObj["Firstname"].toString();
                QString Lastname = dataObj["Lastname"].toString();
                QString LastRun = dataObj["LastRun"].toString();
                bool DownloadAllowed = dataObj["DownloadAllowed"].toBool();
                bool ConnectAllowed = dataObj["ConnectAllowed"].toBool();
                bool PublishAllowed = dataObj["PublishAllowed"].toBool();


                this->addDatasource(DatasourceID, ConnectedWorkbooksCount, DSProfileID, ConnectionType,DatasourceName, DatabaseName, Descriptions, SourceType, ImageLink, DatasourceLink, CreatedDate, Firstname, Lastname, LastRun, DownloadAllowed, ConnectAllowed, PublishAllowed);
            }


        }
    }

    //Clear the buffer
    m_dataBuffer->clear();
}

/*!
 * \brief Call delete Datasource in Grafieks API
 */
void DatasourceDS::dataDeleteFinished()
{
    //Parse the JSON
    if( m_networkReply->error()){
        qDebug() << "There was some error : " << m_networkReply->errorString();
    }else{

        QJsonDocument resultJson = QJsonDocument::fromJson(* m_dataBuffer);
        QJsonObject resultObj = resultJson.object();
        QJsonObject statusObj = resultObj["status"].toObject();


        // If successful, set the variables in settings
        if(statusObj["code"].toInt() != 200){
            qWarning() << "Failed to delete. " << statusObj["code"].toString();
        }
    }

    //Clear the buffer
    m_dataBuffer->clear();
}


