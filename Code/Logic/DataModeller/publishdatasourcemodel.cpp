#include "publishdatasourcemodel.h"

PublishDatasourceModel::PublishDatasourceModel(QObject *parent) : QObject(parent),
    m_networkAccessManager(new QNetworkAccessManager(this)),
    m_networkReply(nullptr),
    m_tempStorage(new QByteArray)
{

}

void PublishDatasourceModel::publishDatasource(QString dsName, QString description, QString uploadImage, QString sourceType,  int schedulerId,  bool isFullExtract, QString extractColumnName)
{

    // Fetch value from settings
    QSettings settings;
    QString baseUrl = settings.value("general/baseUrl").toString();
    QByteArray sessionToken = settings.value("user/sessionToken").toByteArray();
    int profileId = settings.value("user/profileId").toInt();


    // Extract the exact file path

    // Open file for reading
    QFile imageFile(uploadImage);

    imageFile.open(QIODevice::ReadOnly);

    if(imageFile.isOpen()){

        // Extract the filename
        QFileInfo fileInfo(imageFile.fileName());
        QString filename(fileInfo.fileName());

        // Convert filedata to base64
        QByteArray imageData = imageFile.readAll();
        QString base64Image = QString(imageData.toBase64());

        QNetworkRequest m_NetworkRequest;
        m_NetworkRequest.setUrl(baseUrl+"/desk_newdatasource");

        m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                                   "application/x-www-form-urlencoded");
        m_NetworkRequest.setRawHeader("Authorization", sessionToken);


        QJsonObject obj;
        obj.insert("ProfileID", profileId);
        obj.insert("SchedulerID", schedulerId);
        obj.insert("DatasourceName", dsName);
        obj.insert("Description", description);
        obj.insert("Image", base64Image);
        obj.insert("Filename", filename);
        obj.insert("SourceType", sourceType);
        obj.insert("ColumnName", extractColumnName);
        obj.insert("IsFullExtract", isFullExtract);
        obj.insert("FileData", base64Image);


        QJsonDocument doc(obj);
        QString strJson(doc.toJson(QJsonDocument::Compact));

        m_networkReply = m_networkAccessManager->post(m_NetworkRequest, strJson.toUtf8());

        connect(m_networkReply, &QIODevice::readyRead, this, &PublishDatasourceModel::reading, Qt::UniqueConnection);
        connect(m_networkReply, &QNetworkReply::finished, this, &PublishDatasourceModel::readComplete, Qt::UniqueConnection);

    } else {
        qDebug() << Q_FUNC_INFO << __LINE__  << imageFile.errorString();
    }
}

void PublishDatasourceModel::reading()
{
    m_tempStorage->append(m_networkReply->readAll());
}

void PublishDatasourceModel::readComplete()
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
        this->outputFileName = statusObj["fileName"].toString();

        qDebug() << Q_FUNC_INFO << resultJson;

        m_tempStorage->clear();
    }

    // If saving to database throws error, emit signal
    // else start uploading the extract file
    if(outputStatus.value("code") != 200){
        emit publishDSStatus(outputStatus);
    } else {
        uploadFile();
    }
}

void PublishDatasourceModel::uploadProgress(qint64 bytesSent, qint64 bytesTotal)
{
    int percentageUploaded = 100 * bytesSent/bytesTotal;
    emit dsUploadPercentage(percentageUploaded);
}

void PublishDatasourceModel::uploadFinished()
{
    emit dsUploadFinished();
}

void PublishDatasourceModel::uploadFile()
{
//    QFile dataFile(Statics::extractPath);
    QFile *dataFile = new QFile(Statics::extractPath, this);

    QSettings settings;

    QString baseUrl = settings.value("general/hostname").toString();

    QUrl url("ftp://" + baseUrl + ":" + Secret::ftpPort + "/datasources/" + this->outputFileName);
    url.setUserName(Secret::ftpUser);
    url.setPassword(Secret::ftpPass);
    url.setScheme("ftp");

    if (dataFile->open(QIODevice::ReadOnly))
    {
        // Start upload
        QNetworkReply *reply = m_networkAccessManager->put(QNetworkRequest(url), dataFile);

        if(reply->error()){
            qDebug() << Q_FUNC_INFO << reply->errorString();
        }
        // And connect to the progress upload signal
        connect(reply, &QNetworkReply::uploadProgress, this, &PublishDatasourceModel::uploadProgress);
        connect(reply, &QNetworkReply::finished, this, &PublishDatasourceModel::uploadFinished);
    } else {
        qDebug() << Q_FUNC_INFO << dataFile->isOpen() << dataFile->errorString();
    }
}
