#include "schedulerds.h"

SchedulerDS::SchedulerDS(QObject *parent) : QObject(parent),
    m_networkAccessManager(new QNetworkAccessManager(this)),
    m_networkReply(nullptr),
    m_dataBuffer(new QByteArray)
{

}

void SchedulerDS::fetchSchedulers()
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

    connect(m_networkReply,&QIODevice::readyRead,this,&SchedulerDS::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&SchedulerDS::dataReadFinished);
}

void SchedulerDS::addScheduler(Scheduler *schedule)
{
    emit preItemAdded();
    m_scheduler.append(schedule);
    emit postItemAdded();
}


void SchedulerDS::addScheduler(const int & schedulerId, const QString & schedulerName)

{
    Scheduler *scheduler = new Scheduler(schedulerId, schedulerName, this);

    addScheduler(scheduler);

}


QList<Scheduler *> SchedulerDS::dataItems()
{
    return m_scheduler;
}

void SchedulerDS::dataReadyRead()
{
    m_dataBuffer->append(m_networkReply->readAll());
}

void SchedulerDS::dataReadFinished()
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

                int ScheduleID = dataObj["ScheduleID"].toInt();
                QString SchedulerName = dataObj["Name"].toString();
                this->addScheduler(ScheduleID, SchedulerName);
            }

        }
    }
    //Clear the buffer
    m_dataBuffer->clear();
}

