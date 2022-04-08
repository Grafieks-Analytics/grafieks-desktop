#include "credentialsmodel.h"

CredentialsModel::CredentialsModel(QObject *parent) : QObject(parent),
    m_networkAccessManager(new QNetworkAccessManager(this)),
    m_networkReply(nullptr),
    m_dataBuffer(new QByteArray)
{

}

void CredentialsModel::fetchLiveCredentials(QString dsName)
{
    // Fetch value from settings
    QSettings settings;
    QString baseUrl = settings.value("general/baseUrl").toString();
    QByteArray sessionToken = settings.value("user/sessionToken").toByteArray();
    int profileId = settings.value("user/profileId").toInt();

    QNetworkRequest m_NetworkRequest;
    m_NetworkRequest.setUrl(baseUrl+"/desk_fetchcredentials");

    m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                               "application/x-www-form-urlencoded");
    m_NetworkRequest.setRawHeader("Authorization", sessionToken);

    QJsonObject obj;
    obj.insert("profileID", profileId);
    obj.insert("datasourceName", dsName);

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(m_NetworkRequest, strJson.toUtf8());

    connect(m_networkReply,&QIODevice::readyRead,this,&CredentialsModel::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&CredentialsModel::dataReadFinished);
}

void CredentialsModel::dataReadyRead()
{
    m_dataBuffer->append(m_networkReply->readAll());
}

void CredentialsModel::dataReadFinished()
{
    QString dbTypeString;

    //Parse the JSON
    if( m_networkReply->error()){

        qDebug() << "There was some error : " << m_networkReply->errorString();
    }else{

        QJsonDocument resultJson = QJsonDocument::fromJson(* m_dataBuffer);
        QJsonObject resultObj = resultJson.object();

        // If successful, set the variables in settings
        if(resultObj["code"].toInt() == 200){

            QJsonDocument dataDoc = QJsonDocument::fromJson(resultObj["data"].toString().toUtf8());
            QJsonObject dataObj = dataDoc.object();

            QString username = dataObj["username"].toString();
            QString password = dataObj["password"].toString();
            int port = dataObj["port"].toInt();
            QString host = dataObj["host"].toString();
            QString database = dataObj["database"].toString();
            QString realDbName = dataObj["realDbName"].toString();
            int dbType = dataObj["dbType"].toInt();

            switch(dbType){
            case Constants::mysqlIntType:
            case Constants::mysqlOdbcIntType:
                dbTypeString = Constants::mysqlQml;
                break;

            case Constants::mssqlIntType:
                dbTypeString = Constants::mssqlQml;
                break;

            case Constants::postgresIntType:
                dbTypeString = Constants::postgresQml;
                break;

            case Constants::mongoIntType:
                dbTypeString = Constants::mongoQml;
                break;

            case Constants::redshiftIntType:
                dbTypeString = Constants::redshiftQml;
                break;

            case Constants::hiveIntType:
                dbTypeString = Constants::hiveQml;
                break;

            case Constants::impalaIntType:
                dbTypeString = Constants::impalaQml;
                break;

            case Constants::oracleIntType:
                dbTypeString = Constants::oracleQml;
                break;

            case Constants::snowflakeIntType:
                dbTypeString = Constants::snowflakeQml;
                break;

            case Constants::teradataIntType:
                dbTypeString = Constants::teradataQml;
                break;
            }

            this->credentials.insert("username", username);
            this->credentials.insert("password", password);
            this->credentials.insert("port", port);
            this->credentials.insert("database", database);
            this->credentials.insert("realDbName", realDbName);
            this->credentials.insert("host", host);
            this->credentials.insert("dbTypeString", dbTypeString);

        }

    }

    //Clear the buffer
    m_dataBuffer->clear();

    emit signalCredentialsReceived(this->credentials);
    emit openConnection(dbTypeString);
}
