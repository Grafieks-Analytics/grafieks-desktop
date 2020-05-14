#include "datasourceds.h"

DatasourceDS::DatasourceDS(QObject *parent) : QObject(parent),
    m_networkAccessManager(new QNetworkAccessManager(this)),
    m_networkReply(nullptr),
    m_dataBuffer(new QByteArray)
{

}

void DatasourceDS::fetchDatsources(int page, bool fulllist, bool listview)
{

    // Fetch value from settings
    QSettings settings;
    QString baseUrl = settings.value("general/baseUrl").toString();
    QByteArray sessionToken = settings.value("user/sessionToken").toByteArray();
    int profileId = settings.value("user/profileId").toInt();

    QNetworkRequest m_NetworkRequest;
    m_NetworkRequest.setUrl(baseUrl+"/listdatasources");

    m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                               "application/x-www-form-urlencoded");
    m_NetworkRequest.setRawHeader("Authorization", sessionToken);

    QJsonObject obj;
    obj.insert("profileId", profileId);
    obj.insert("page", page);
    obj.insert("fulllist", fulllist);
    obj.insert("listview", listview);


    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(m_NetworkRequest, strJson.toUtf8());


    connect(m_networkReply,&QIODevice::readyRead,this,&DatasourceDS::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&DatasourceDS::dataReadFinished);
}

void DatasourceDS::addDatasource(Datasource *datasource)
{
    emit preItemAdded();
    m_datasource.append(datasource);
    emit postItemAdded();
}


void DatasourceDS::addDatasource(const int & id, const int & connectedWorkbooksCount, const int & profileId, const QString & connectionType, const QString & datasourceName, const QString & descriptions, const QString & sourceType, const QString & imageLink, const QString & downloadLink, const QString & createdDate, const QString & firstName, const QString & lastName)

{
    Datasource *datasource = new Datasource(id, connectedWorkbooksCount, profileId, connectionType, datasourceName, descriptions, sourceType, imageLink, downloadLink, createdDate, firstName, lastName, this);

    addDatasource(datasource);
}

void DatasourceDS::removeDatasource(int index)
{
    emit preItemRemoved(index);
    m_datasource.removeAt(index);
    emit postItemRemoved();
}



QList<Datasource *> DatasourceDS::dataItems()
{
    return m_datasource;
}

void DatasourceDS::dataReadyRead()
{
    m_dataBuffer->append(m_networkReply->readAll());
}

void DatasourceDS::dataReadFinished()
{
    //Parse the JSON
    if( m_networkReply->error()){
        qDebug() << "There was some error : " << m_networkReply->errorString();
    }else{

        QJsonDocument resultJson = QJsonDocument::fromJson(* m_dataBuffer);
        QJsonObject resultObj = resultJson.object();
        QJsonObject statusObj = resultObj["status"].toObject();



        // If successful, set the variables in settings
        if(statusObj["code"].toInt() == 200){

            QJsonArray dataArray = resultObj["data"].toArray();

            for(int i = 0; i<= dataArray.size(); i++){

                QJsonObject dataObj = dataArray.at(i).toObject();

                int DatasourceID = dataObj["DatasourceID"].toInt();
                int ConnectedWorkbooksCount = dataObj["ConnectedWorkbooksCount"].toInt();
                int DSProfileID = dataObj["DSProfileID"].toInt();
                QString ConnectionType = dataObj["ConnectionType"].toString();
                QString DatasourceName = dataObj["DatasourceName"].toString();
                QString Descriptions = dataObj["Description"].toString();
                QString SourceType = dataObj["SourceType"].toString();
                QString ImageLink = dataObj["ImageLink"].toString();
                QString DatasourceLink = dataObj["DatasourceLink"].toString();
                QString CreatedDate = dataObj["CreatedDate"].toString();
                QString Firstname = dataObj["Firstname"].toString();
                QString Lastname = dataObj["Lastname"].toString();


                this->addDatasource(DatasourceID, ConnectedWorkbooksCount, DSProfileID, ConnectionType,DatasourceName,  Descriptions, SourceType, ImageLink, DatasourceLink, CreatedDate, Firstname, Lastname);
            }

        }

        //Clear the buffer
        m_dataBuffer->clear();
    }
}
