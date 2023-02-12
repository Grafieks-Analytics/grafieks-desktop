#include "projectslistmodel.h"

ProjectsListModel::ProjectsListModel(QObject *parent) : QObject(parent),
    m_networkAccessManager(new QNetworkAccessManager(this)),
    m_networkReply(nullptr),
    m_dataBuffer(new QByteArray)
{

}

void ProjectsListModel::fetchProjectList()
{
    // Fetch value from settings
    QSettings settings;
    QString baseUrl = settings.value("general/baseUrl").toString();
    QByteArray sessionToken = settings.value("user/sessionToken").toByteArray();
    int profileId = settings.value("user/profileId").toInt();

    QNetworkRequest m_NetworkRequest;
    m_NetworkRequest.setUrl(baseUrl+"/desk_listprojects");

    m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                               "application/x-www-form-urlencoded");
    m_NetworkRequest.setRawHeader("Authorization", sessionToken);

    QJsonObject obj;
    obj.insert("profileId", profileId);

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(m_NetworkRequest, strJson.toUtf8());

    connect(m_networkReply,&QIODevice::readyRead,this,&ProjectsListModel::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&ProjectsListModel::dataReadFinished);

}

void ProjectsListModel::dataReadyRead()
{
    m_dataBuffer->append(m_networkReply->readAll());
}

void ProjectsListModel::dataReadFinished()
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

                int projectId = dataObj["ProjectID"].toInt();
                QString projectName = dataObj["Name"].toString();
                QString projectDescription = dataObj["Description"].toString();

                this->projects.insert(projectName, projectId);
            }

        } else {
            if(statusObj["code"].toString() == Constants::sessionExpiredText){
                emit sessionExpired();
            }
        }

    }

    //Clear the buffer
    m_dataBuffer->clear();

    emit signalProjectList(this->projects);
}
