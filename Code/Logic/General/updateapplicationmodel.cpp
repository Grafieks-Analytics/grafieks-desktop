#include "updateapplicationmodel.h"

UpdateApplicationModel::UpdateApplicationModel(QObject *parent) : QObject(parent),
    m_networkAccessManager(new QNetworkAccessManager(this)),
    m_networkReply(nullptr),
    m_dataBuffer(new QByteArray)
{

}

void UpdateApplicationModel::checkLatestApplication()
{
    QString currentAppVersionCode = Constants::appVersionCode;

    // Fetch value from settings
    QSettings settings;
    QString sitename = settings.value("user/sitename").toString();
//    QString baseUrl = settings.value("general/baseUrl").toString();
    QString baseUrl = Constants::defaultAPIEndpoint;

    this->m_NetworkRequest.setUrl(baseUrl +"/desk_appdetails");

    m_networkReply = m_networkAccessManager->post(this->m_NetworkRequest, "");
    connect(m_networkReply,&QIODevice::readyRead,this,&UpdateApplicationModel::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&UpdateApplicationModel::dataReadFinished);
}

void UpdateApplicationModel::promptUpdater()
{
    QProcess::startDetached(QDir::currentPath() + "/updates.exe");
    QApplication::quit();
}

void UpdateApplicationModel::checkDsVersion(QString currentVersion)
{

}

void UpdateApplicationModel::checkWbVersion(QString currentVersion)
{

}

void UpdateApplicationModel::promptUpdate()
{

}

void UpdateApplicationModel::dataReadyRead()
{
    m_dataBuffer->append(m_networkReply->readAll());
}

void UpdateApplicationModel::dataReadFinished()
{
    QString appVersion;
    QString appVersionCode;
    QString workbookVersion;
    QString liveVersion;
    QString extractVersion;

    QString currentAppVersionCode = Constants::appVersionCode;

    //Parse the JSON
    if( m_networkReply->error()){
        qDebug() << "There was some error : " << m_networkReply->errorString();
    }else{

        QJsonDocument resultJson = QJsonDocument::fromJson(* m_dataBuffer);
        QJsonObject resultObj = resultJson.object();
        QJsonObject statusObj = resultObj["status"].toObject();


        // If successful, set the variables in settings
        if(statusObj["code"].toInt() == 200){

            QJsonObject dataObj = resultObj["data"].toObject();


            appVersion = dataObj["appVersion"].toString();
            appVersionCode = dataObj["appVersionCode"].toString();
            workbookVersion = dataObj["workbookVersion"].toString();
            liveVersion = dataObj["liveVersion"].toString();
            extractVersion = dataObj["extractVersion"].toString();

        } else {
            if(statusObj["msg"] == Constants::sessionExpiredText){
            }
        }
    }


     QString latestAppVersionCode = appVersionCode.replace(".", "");
     currentAppVersionCode = currentAppVersionCode.replace(".", "");

     if(currentAppVersionCode.toInt() < latestAppVersionCode.toInt()){
        emit updateAppVersion(Constants::appVersionCode, appVersionCode);
     }


    //Clear the buffer
    m_dataBuffer->clear();
}
