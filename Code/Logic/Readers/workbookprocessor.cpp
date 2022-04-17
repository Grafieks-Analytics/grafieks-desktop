#include "workbookprocessor.h"

WorkbookProcessor::WorkbookProcessor(GeneralParamsModel *gpm, QObject *parent) : QObject(parent)
{
    this->generalParamsModel = gpm;
}

void WorkbookProcessor::setArgumentsFromMenu(QString filePath)
{
    this->filePath = filePath;
    Statics::editMode = true;
    this->processDS();
}

void WorkbookProcessor::setArgumentsByFile(QString filePath)
{
    this->filePath = filePath;
    Statics::editMode = true;
    this->receivedArgument = true;
}

bool WorkbookProcessor::receivedArgumentStatus()
{
    return this->receivedArgument;
}

void WorkbookProcessor::processDS()
{
    QFile fileWorkbook(this->filePath);

    if(!fileWorkbook.open(QIODevice::ReadOnly | QIODevice::Truncate)){
        qDebug() << Q_FUNC_INFO << "Could not open file for reading" << fileWorkbook.errorString();
    } else {
        QByteArray workbookData;
        QDataStream in(&fileWorkbook);
        in >> workbookData;

        QJsonParseError jsonError;
        QJsonDocument doc = QJsonDocument::fromJson(workbookData, &jsonError);
        if( jsonError.error != QJsonParseError::NoError ){
            qDebug() << Q_FUNC_INFO << QString("Json error: %1").arg(jsonError.errorString()) ;
        } else if(doc.isNull()){
            qDebug() << Q_FUNC_INFO << "Blank JsonDocument" ;
        } else {

            if(doc.object().value("connectionType").toString() == Constants::duckType){

                QString filePath = doc.object().value("datasourcePath").toString();
                QFileInfo fi(filePath);

                QString fileName = fi.fileName();
                // For excel, csv, json, access and other in memory
                QString dsType = Constants::duckType;
                Statics::currentDSFile = fileName;
                Statics::currentDbClassification = dsType;

                if(!fi.exists()){
                    emit dsMissing(dsType, fileName);
                } else {
                    generalParamsModel->setFromLiveFile(false);
                    this->processRemaining(doc);

                    emit processExtractFromWorkbook(filePath);
                }

            } else {

                QString filePath = doc.object().value("datasourcePath").toString();
                QFileInfo fi(filePath);

                QString fileName = fi.fileName();
                // For sqltype and forward type
                QString dsType = Constants::sqlType;
                Statics::currentDSFile = fileName;
                Statics::currentDbClassification = dsType;

                if(!fi.exists()){
                   emit dsMissing(dsType, fileName);
                } else {
                    generalParamsModel->setFromLiveFile(true);
                    generalParamsModel->setJsonFromWorkbook(doc);

                    emit processLiveFromWorkbook(filePath);
                }
            }
        }
    }

    fileWorkbook.close();
}

void WorkbookProcessor::processAfterSelectingDS(QString dsPath)
{
    QFile fileWorkbook(this->filePath);

    if(!fileWorkbook.open(QIODevice::ReadOnly | QIODevice::Truncate)){
        qDebug() << Q_FUNC_INFO << "Could not open file for reading" << fileWorkbook.errorString();
    } else {
        QByteArray workbookData;
        QDataStream in(&fileWorkbook);
        in >> workbookData;

        QJsonParseError jsonError;
        QJsonDocument doc = QJsonDocument::fromJson(workbookData, &jsonError);

        if(doc.object().value("connectionType").toString() == Constants::duckType){

            QString filePath = dsPath;
            QFileInfo fi(filePath);

            emit processExtractFromWorkbook(filePath);
            this->processRemaining(doc);


        } else {

            QString filePath = dsPath;
            QFileInfo fi(filePath);

            emit processLiveFromWorkbook(filePath);
            this->processRemaining(doc);
        }

    }

    fileWorkbook.close();
}

void WorkbookProcessor::processAfterSelectinOnlineDS()
{
    QFile fileWorkbook(this->filePath);

    if(!fileWorkbook.open(QIODevice::ReadOnly | QIODevice::Truncate)){
        qDebug() << Q_FUNC_INFO << "Could not open file for reading" << fileWorkbook.errorString();
    } else {
        QByteArray workbookData;
        QDataStream in(&fileWorkbook);
        in >> workbookData;

        QJsonParseError jsonError;
        QJsonDocument doc = QJsonDocument::fromJson(workbookData, &jsonError);

        this->processRemaining(doc);

    }

    fileWorkbook.close();
}

void WorkbookProcessor::saveWorkbooks(QString filePath)
{
    QJsonObject finalObj;


    QString tmpFilePath = QCoreApplication::applicationDirPath() + "/" + "tmp/";
    QDir directory(tmpFilePath);
    QVariantMap filesMap;

    if(directory.exists()){
        QStringList files = directory.entryList();

        foreach(QString file, files){
            if(file != "." && file != ".."){
                QFile fi(tmpFilePath + file);
                fi.open(QIODevice::ReadOnly);
                QByteArray ba;
                ba = fi.readAll().toBase64();

                filesMap.insert(file, ba);
            }
        }

    }

    // Current timestamp
    quint64 currentTimestamp = QDateTime::currentMSecsSinceEpoch();

    // This is to identify the extract irrespective of its filename
    // This will not change when updated
    QString uniqueHash = generalParamsModel->randomStringGenerator();

    // File Headers
    finalObj.insert("app_version", Constants::appVersion);
    finalObj.insert("mode", Constants::currentMode);
    finalObj.insert("workbook_version", Constants::workbookVersion);
    finalObj.insert("unique_hash", uniqueHash); // This is to identify the extract irrespective of its filename
    finalObj.insert("last_update", QString::number(currentTimestamp));
    finalObj.insert("connectionType", Statics::currentDbClassification == Constants::duckType ? Constants::duckType : Constants::sqlType);

    finalObj.insert("reportParams", this->reportParams);
    finalObj.insert("dashboardParams", this->dashboardParams);
    finalObj.insert("tableColumns", this->tableColumnParams);
    finalObj.insert("joinAndWhereParams", this->joinAndWhereParams);

    if(Statics::dsType == Constants::liveType){
        finalObj.insert("currentDbIntType", Statics::currentDbIntType);
        finalObj.insert("currentDbName", Statics::currentDbName);
        finalObj.insert("currentDbStrType", Statics::currentDbStrType);
        finalObj.insert("currentDbClassification", Statics::currentDbClassification);

        finalObj.insert("datasourcePath", Statics::livePath);
    } else {

        finalObj.insert("datasourcePath", Statics::extractPath);
    }

    finalObj.insert("files", QJsonObject::fromVariantMap(filesMap));

    QJsonDocument doc(finalObj);
    QByteArray docByteArray = doc.toJson(QJsonDocument::Compact);


    QFile fileWorkbook(filePath);

    if (!fileWorkbook.open(QIODevice::WriteOnly)){
        qDebug() << Q_FUNC_INFO << " Could not open file for writing" << fileWorkbook.errorString();
    } else {
       QDataStream out(&fileWorkbook);
       out << docByteArray;

//         fileWorkbook.write(docByteArray);

        fileWorkbook.flush();
        fileWorkbook.close();
    }

    emit workbookSaved();
}

void WorkbookProcessor::processJsonAfterLoginCredentials()
{
    this->processRemaining(generalParamsModel->getJsonFromWorkbook());
}

void WorkbookProcessor::getReportParams(QJsonObject reportParams)
{
    this->reportParams = reportParams;
    qDebug() << Q_FUNC_INFO << "Slot Report params" << reportParams;
}

void WorkbookProcessor::getDashboardParams(QJsonObject dashboardParams)
{
    this->dashboardParams = dashboardParams;
    qDebug() << Q_FUNC_INFO << "Slot Dashboard params" << dashboardParams;
}

void WorkbookProcessor::getTableColumns(QJsonObject tableColumns)
{
    this->tableColumnParams = tableColumns;
    qDebug() << Q_FUNC_INFO << "Slot Table Column params" << tableColumns;
}

void WorkbookProcessor::getJoinAndWhereParams(QJsonObject joinAndWhereParams)
{
    qDebug() << Q_FUNC_INFO << "GOT WHERE" << joinAndWhereParams;
    this->joinAndWhereParams = joinAndWhereParams;
}

void WorkbookProcessor::processRemaining(QJsonDocument doc)
{
    // First process the files if any (images and text reports)
    QJsonObject files = doc.object().value("files").toObject();
    if(files.count() > 0){

        QString tmpFilePath = QCoreApplication::applicationDirPath() + "/" + "tmp/";
        QDir tmpDir(tmpFilePath);

        // Check if tmp directory exists
        if (!tmpDir.exists()) QDir().mkdir(tmpFilePath);

        QStringList filesList = files.keys();
        foreach(QString file, filesList){
            QByteArray data = QByteArray::fromBase64(QByteArray::fromBase64(files.value(file).toString().toUtf8()));

            QFile fiWrite(tmpFilePath + file);
            fiWrite.open(QIODevice::WriteOnly);
            fiWrite.write(data);
            fiWrite.close();
        }

    }

    emit sendDSDashboardParams(doc.object().value("dashboardParams").toObject());
    emit sendDSReportParams(doc.object().value("reportParams").toObject());
    emit sendDSTableColumns(doc.object().value("tableColumns").toObject());
    emit sendDSJoinAndWhereParams(doc.object().value("joinAndWhereParams").toObject());
}
