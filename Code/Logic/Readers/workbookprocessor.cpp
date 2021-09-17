#include "workbookprocessor.h"

WorkbookProcessor::WorkbookProcessor(GeneralParamsModel *gpm, QObject *parent) : QObject(parent)
{
    this->generalParamsModel = gpm;
}

void WorkbookProcessor::setArgumentsFromMenu(QString filePath)
{
    this->filePath = filePath;
    this->processExtract();
}

void WorkbookProcessor::setArgumentsByFile(QString filePath)
{
    this->filePath = filePath;
    this->receivedArgument = true;
}

bool WorkbookProcessor::receivedArgumentStatus()
{
    return this->receivedArgument;
}

void WorkbookProcessor::processExtract()
{
    QFile fileWorkbook(filePath);

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

            if(doc.object().value("connectionType").toString() == Constants::extractType){

                QFileInfo fi(doc.object().value("datasourcePath").toString());
                if(!fi.exists())
                    emit extractMissing();

            } else {
                qDebug() << Q_FUNC_INFO << "Live type not processed yet";
            }


            emit sendExtractDashboardParams(doc.object().value("dashboardParams").toObject());
            emit sendExtractReportParams(doc.object().value("reportParams").toObject());

        }
    }
}

void WorkbookProcessor::saveWorkbooks(QString filePath)
{
    QJsonObject finalObj;
    finalObj.insert("reportParams", this->reportParams);
    finalObj.insert("dashboardParams", this->dashboardParams);
    finalObj.insert("connectionType", Statics::dsType);

    if(Statics::dsType == Constants::liveType){
        finalObj.insert("currentDbIntType", Statics::currentDbIntType);
        finalObj.insert("currentDbName", Statics::currentDbName);
        finalObj.insert("currentDbStrType", Statics::currentDbStrType);
        finalObj.insert("currentDbClassification", Statics::currentDbClassification);

        finalObj.insert("driver", "driver");
        finalObj.insert("host", "host");
        finalObj.insert("db", "db");
        finalObj.insert("port", "port");
        finalObj.insert("username", "username");
        finalObj.insert("password", "password");
    } else {

        finalObj.insert("datasourcePath", Statics::extractPath);
    }


    QJsonDocument doc(finalObj);
    QByteArray docByteArray = doc.toJson(QJsonDocument::Compact);


    QFile fileWorkbook(filePath);

    if (!fileWorkbook.open(QIODevice::WriteOnly)){
        qDebug() << Q_FUNC_INFO << " Could not open file for writing" << fileWorkbook.errorString();
    } else {
        QDataStream out(&fileWorkbook);
        out << docByteArray;

        fileWorkbook.flush();
        fileWorkbook.close();
    }
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
