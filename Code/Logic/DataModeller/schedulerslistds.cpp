#include "schedulerslistds.h"

SchedulersListDS::SchedulersListDS(QObject *parent) : QObject(parent),
    m_networkAccessManager(new QNetworkAccessManager(this)),
    m_networkReply(nullptr),
    m_dataBuffer(new QByteArray)
{

}

void SchedulersListDS::fetchSchedulersList()
{

    // Fetch value from settings
    QSettings settings;
    QString baseUrl = settings.value("general/baseUrl").toString();
    QByteArray sessionToken = settings.value("user/sessionToken").toByteArray();
    int profileId = settings.value("user/profileId").toInt();


    QNetworkRequest m_NetworkRequest;
    m_NetworkRequest.setUrl(baseUrl+"/desk_listschedules");


    m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                               "application/x-www-form-urlencoded");
    m_NetworkRequest.setRawHeader("Authorization", sessionToken);

    QJsonObject obj;
    obj.insert("profileId", profileId);
    obj.insert("type", "data_extract");


    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(m_NetworkRequest, strJson.toUtf8());


    connect(m_networkReply,&QIODevice::readyRead,this,&SchedulersListDS::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&SchedulersListDS::dataReadFinished);

}

void SchedulersListDS::addScheduler(SchedulersList *datasource)
{
    emit preItemAdded();
    m_datasource.append(datasource);
    emit postItemAdded();
}

void SchedulersListDS::addScheduler(const int &schedulerId, const QString &schedulerName)
{
    SchedulersList *scheduler = new SchedulersList(schedulerId, schedulerName, this);

    addScheduler(scheduler);
}

QList<SchedulersList *> SchedulersListDS::dataItems()
{
    return m_datasource;
}

void SchedulersListDS::dataReadyRead()
{
    m_dataBuffer->append(m_networkReply->readAll());
}

void SchedulersListDS::dataReadFinished()
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

            for(int i = 0; i< dataArray.size(); i++){

                QJsonObject dataObj = dataArray.at(i).toObject();

                int SchedulerID = dataObj["ScheduleID"].toInt();
                QString SchedulerName = dataObj["Name"].toString();

                this->addScheduler(SchedulerID, SchedulerName);
            }


        }

        //Clear the buffer
        m_dataBuffer->clear();


    }
}
