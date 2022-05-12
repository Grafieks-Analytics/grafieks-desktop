#include "publishworkbookmodel.h"

PublishWorkbookModel::PublishWorkbookModel(QObject *parent) : QObject(parent),
    m_networkAccessManager(new QNetworkAccessManager(this)),
    m_networkReply(nullptr),
    m_tempStorage(new QByteArray)
{

}

void PublishWorkbookModel::publishWorkbook(int projectId, QString wbName, QString description, QString uploadImage, int dashboardCount, QString dashboardDetails)
{
    // Fetch value from settings
    QSettings settings;
    QString baseUrl = settings.value("general/baseUrl").toString();
    QByteArray sessionToken = settings.value("user/sessionToken").toByteArray();
    int profileId = settings.value("user/profileId").toInt();

    QString filename;
    QString base64Image;

    // Extract the exact file path
    // Open file for reading
    QFile imageFile(uploadImage);

    imageFile.open(QIODevice::ReadOnly);

    if(imageFile.isOpen()){

        // Extract the filename
        QFileInfo fileInfo(imageFile.fileName());
        QString filename = fileInfo.fileName();

        // Convert filedata to base64
        QByteArray imageData = imageFile.readAll();
        QString base64Image = QString(imageData.toBase64());
    } else {
        qDebug() << Q_FUNC_INFO << __LINE__  << imageFile.errorString();
    }

    QNetworkRequest m_NetworkRequest;
    m_NetworkRequest.setUrl(baseUrl+"/desk_newworkbook");

    m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                               "application/x-www-form-urlencoded");
    m_NetworkRequest.setRawHeader("Authorization", sessionToken);


    QJsonObject obj;
    obj.insert("profileId", profileId);
    obj.insert("projectID", projectId);
    obj.insert("workbookFile", this->workbookFilePath);
    obj.insert("workbookName", wbName);
    obj.insert("description", description);
    obj.insert("image", base64Image);
    obj.insert("fileName", filename);
    obj.insert("dashboardCount", dashboardCount);
    obj.insert("dashboardDetails", dashboardDetails);

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(m_NetworkRequest, strJson.toUtf8());

    connect(m_networkReply, &QIODevice::readyRead, this, &PublishWorkbookModel::reading, Qt::UniqueConnection);
    connect(m_networkReply, &QNetworkReply::finished, this, &PublishWorkbookModel::readComplete, Qt::UniqueConnection);


}

void PublishWorkbookModel::workbookFile(QString workbookFilePath)
{
    this->workbookFilePath = workbookFilePath;
}

void PublishWorkbookModel::reading()
{
    m_tempStorage->append(m_networkReply->readAll());
}

void PublishWorkbookModel::readComplete()
{
    if(m_networkReply->error()){
        qDebug() << __FILE__ << __LINE__ << m_networkReply->errorString();

        // Set the output
        outputStatus.insert("code", m_networkReply->error());
        outputStatus.insert("msg", m_networkReply->errorString());

    } else{
        QJsonDocument resultJson = QJsonDocument::fromJson(* m_tempStorage);
        QJsonObject resultObj = resultJson.object();
        QJsonObject statusObj = resultObj["status"].toObject();

        // Set the output
        outputStatus.insert("code", statusObj["code"].toInt());
        outputStatus.insert("msg", statusObj["msg"].toString());
        this->outputFileName = statusObj["workbook"].toString();

        qDebug() << Q_FUNC_INFO << resultJson;


    }

     m_tempStorage->clear();

     if(outputStatus.value("msg") == Constants::sessionExpiredText){
        emit sessionExpired();
     } else {
         // If saving to database throws error, emit signal
         // else start uploading the extract file
         if(outputStatus.value("code") != 200){
             emit publishWbStatus(outputStatus);
         } else {
             uploadFile();
         }
     }

}

void PublishWorkbookModel::uploadProgress(qint64 bytesSent, qint64 bytesTotal)
{
    int percentageUploaded = 100 * bytesSent/bytesTotal;
    emit wbUploadPercentage(percentageUploaded);
}

void PublishWorkbookModel::uploadFinished()
{
    // Fetch value from settings
    QSettings settings;
    QString baseUrl = settings.value("general/baseUrl").toString();
    QByteArray sessionToken = settings.value("user/sessionToken").toByteArray();
    int profileId = settings.value("user/profileId").toInt();

    QNetworkRequest m_NetworkRequest;
    m_NetworkRequest.setUrl(baseUrl+"/copyfiles");

    m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                               "application/x-www-form-urlencoded");
    m_NetworkRequest.setRawHeader("Authorization", sessionToken);


    QJsonObject obj;
    obj.insert("ProfileID", profileId);
    obj.insert("Extract", "");
    obj.insert("Live", "");
    obj.insert("Workbook", this->outputFileName);

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(m_NetworkRequest, strJson.toUtf8());

    emit wbUploadFinished();
}

void PublishWorkbookModel::uploadFile()
{
    //    QFile dataFile(Statics::extractPath);
    QFile *dataFile = new QFile(this->workbookFilePath, this);

    QSettings settings;

    //        QString ftpAddress = settings.value("general/ftpAddress").toString();
    QString ftpAddress = Constants::defaultFTPEndpoint;
    QString siteName = settings.value("user/sitename").toString();
    QString ftpUser = settings.value("user/ftpUser").toString();
    QString ftpPass = settings.value("user/ftpPass").toString();
    QString ftpPort = settings.value("user/ftpPort").toString();

    QUrl url("ftp://" + ftpAddress + ":" + ftpPort + "/" + siteName + "/workbooks/" + this->outputFileName);
    url.setUserName(ftpUser);
    url.setPassword(ftpPass);
    url.setScheme("ftp");

    if (dataFile->open(QIODevice::ReadOnly))
    {
        // Start upload
        QNetworkReply *reply = m_networkAccessManager->put(QNetworkRequest(url), dataFile);

        if(reply->error()){
            qDebug() << Q_FUNC_INFO << reply->errorString();
        }
        // And connect to the progress upload signal
        connect(reply, &QNetworkReply::uploadProgress, this, &PublishWorkbookModel::uploadProgress);
        connect(reply, &QNetworkReply::finished, this, &PublishWorkbookModel::uploadFinished);
    } else {
        qDebug() << Q_FUNC_INFO << dataFile->isOpen() << dataFile->errorString();
    }
}
