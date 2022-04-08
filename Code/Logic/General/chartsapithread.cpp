#include "chartsapithread.h"

ChartsAPIThread::ChartsAPIThread(QObject *parent) : QObject(parent),
    m_networkAccessManager(new QNetworkAccessManager(this)),
    m_networkReply(nullptr),
    m_dataBuffer(new QByteArray)
{
    this->fetchSettings();
}

ChartsAPIThread::~ChartsAPIThread()
{

}

void ChartsAPIThread::methodSelector(QString functionName, QString reportWhereConditions, QString dashboardWhereConditions, int chartSource, int reportId, int dashboardId)
{

    this->reportWhereConditions = reportWhereConditions;
    this->dashboardWhereConditions = dashboardWhereConditions;
    this->currentChartSource = chartSource;
    this->currentDashboardId = dashboardId;
    this->currentReportId = reportId;
    this->currentFunctionName = functionName;

    if(functionName == "getBarChartValues"){
        this->getBarChartValues();
    } else if(functionName == "getStackedBarChartValues"){
        this->getStackedBarChartValues();
    } else if(functionName == "getGroupedBarChartValues"){
        this->getGroupedBarChartValues();
    } else if(functionName == "getNewGroupedBarChartValues"){
        this->getNewGroupedBarChartValues();
    } else if(functionName == "getAreaChartValues"){
        this->getAreaChartValues();
    } else if(functionName == "getLineChartValues"){
        this->getLineChartValues();
    } else if(functionName == "getLineBarChartValues"){
        this->getLineBarChartValues();
    } else if(functionName == "getPieChartValues"){
        this->getPieChartValues();
    } else if(functionName == "getFunnelChartValues"){
        this->getFunnelChartValues();
    } else if(functionName == "getRadarChartValues"){
        this->getRadarChartValues();
    } else if(functionName == "getScatterChartValues"){
        this->getScatterChartValues();
    } else if(functionName == "getScatterChartNumericalValues"){
        this->getScatterChartNumericalValues();
    } else if(functionName == "getHeatMapChartValues"){
        this->getHeatMapChartValues();
    } else if(functionName == "getSunburstChartValues"){
        this->getSunburstChartValues();
    } else if(functionName == "getWaterfallChartValues"){
        this->getWaterfallChartValues();
    } else if(functionName == "getGaugeChartValues"){
        this->getGaugeChartValues();
    } else if(functionName == "getSankeyChartValues"){
        this->getSankeyChartValues();
    } else if(functionName == "getTreeChartValues"){
        this->getTreeChartValues();
    } else if(functionName == "getTreeMapChartValues"){
        this->getTreeMapChartValues();
    } else if(functionName == "getKPIChartValues"){
        this->getKPIChartValues();
    } else if(functionName == "getTableChartValues"){
        this->getTableChartValues();
    } else if(functionName == "getPivotChartValues"){
        this->getPivotChartValues();
    } else if(functionName == "getStackedAreaChartValues"){
        this->getStackedAreaChartValues();
    } else if(functionName == "getMultiLineChartValues"){
        this->getMultiLineChartValues();
    } else {}
}

void ChartsAPIThread::setAxes(QString &xAxisColumn, QString &yAxisColumn, QString &xSplitKey)
{
    this->xAxisColumn = "";
    this->yAxisColumn = "";
    this->xSplitKey = "";

    this->xAxisColumn = xAxisColumn;
    this->yAxisColumn = yAxisColumn;
    this->xSplitKey = xSplitKey;
}

void ChartsAPIThread::setLists(QVariantList &xAxisColumnList, QVariantList &yAxisColumnList, QVariantList &row3ColumnsList)
{
    this->xAxisColumnList.clear();
    this->yAxisColumnList.clear();
    this->row3ColumnList.clear();

    this->xAxisColumnList = xAxisColumnList;
    this->yAxisColumnList = yAxisColumnList;
    this->row3ColumnList = row3ColumnsList;
}

void ChartsAPIThread::setSankeyDetails(QString &sourceColumn, QString &destinationColumn, QString &measureColumn)
{
    this->sourceColumn = "";
    this->destinationColumn = "";
    this->measureColumn = "";

    this->sourceColumn = sourceColumn;
    this->destinationColumn = destinationColumn;
    this->measureColumn = measureColumn;
}

void ChartsAPIThread::setGaugeKpiDetails(QString &calculateColumn, QString greenValue, QString yellowValue, QString redValue)
{
    this->calculateColumn = calculateColumn;
    this->greenValue = greenValue;
    this->yellowValue = yellowValue;
    this->redValue = redValue;
}

void ChartsAPIThread::setTablePivotDateConversionOptions(QString dateConversionOptions)
{
    this->dateConversionOptions = QJsonDocument::fromJson(dateConversionOptions.toUtf8()).array();
}

void ChartsAPIThread::start()
{
    qDebug() << "Charts API Thread";
}

void ChartsAPIThread::dataReadyRead()
{
    m_dataBuffer->append(m_networkReply->readAll());
}

void ChartsAPIThread::dataReadFinished()
{
    //Parse the JSON
    if( m_networkReply->error()){

        qDebug() << "There was some error : " << m_networkReply->errorString();
    }else{

        QJsonDocument resultJson = QJsonDocument::fromJson(*m_dataBuffer);
        QJsonObject resultObj = resultJson.object();

        QJsonDocument dataDoc =  QJsonDocument::fromJson(resultObj["data"].toString().toUtf8());
        QString msg = resultObj["msg"].toString();
        int code = resultObj["code"].toInt();
        QString strJson(dataDoc.toJson(QJsonDocument::Compact));

        if(code != 200){
            qDebug() << this->currentFunctionName << "Error code" << code << ": " << msg;
        } else {
            if(this->currentFunctionName == "getBarChartValues"){
                emit signalBarChartValues(strJson, this->currentReportId, this->currentDashboardId, this->currentChartSource);
            } else if(this->currentFunctionName == "getStackedBarChartValues"){
                emit signalStackedBarChartValues(strJson, this->currentReportId, this->currentDashboardId, this->currentChartSource);
            } else if(this->currentFunctionName == "getGroupedBarChartValues"){
                emit signalGroupedBarChartValues(strJson, this->currentReportId, this->currentDashboardId, this->currentChartSource);
            } else if(this->currentFunctionName == "getNewGroupedBarChartValues"){
                emit signalNewGroupedBarChartValues(strJson, this->currentReportId, this->currentDashboardId, this->currentChartSource);
            } else if(this->currentFunctionName == "getAreaChartValues"){
                emit signalAreaChartValues(strJson, this->currentReportId, this->currentDashboardId, this->currentChartSource);
            } else if(this->currentFunctionName == "getLineChartValues"){
                emit signalLineChartValues(strJson, this->currentReportId, this->currentDashboardId, this->currentChartSource);
            } else if(this->currentFunctionName == "getLineBarChartValues"){
                emit signalLineBarChartValues(strJson, this->currentReportId, this->currentDashboardId, this->currentChartSource);
            } else if(this->currentFunctionName == "getPieChartValues"){
                emit signalPieChartValues(strJson, this->currentReportId, this->currentDashboardId, this->currentChartSource);
            } else if(this->currentFunctionName == "getFunnelChartValues"){
                emit signalFunnelChartValues(strJson, this->currentReportId, this->currentDashboardId, this->currentChartSource);
            } else if(this->currentFunctionName == "getRadarChartValues"){
                emit signalRadarChartValues(strJson, this->currentReportId, this->currentDashboardId, this->currentChartSource);
            } else if(this->currentFunctionName == "getScatterChartValues"){
                emit signalScatterChartValues(strJson, this->currentReportId, this->currentDashboardId, this->currentChartSource);
            } else if(this->currentFunctionName == "getScatterChartNumericalValues"){
                emit signalScatterChartNumericalValues(strJson, this->currentReportId, this->currentDashboardId, this->currentChartSource);
            } else if(this->currentFunctionName == "getHeatMapChartValues"){
                emit signalHeatMapChartValues(strJson, this->currentReportId, this->currentDashboardId, this->currentChartSource);
            } else if(this->currentFunctionName == "getSunburstChartValues"){
                emit signalSunburstChartValues(strJson, this->currentReportId, this->currentDashboardId, this->currentChartSource);
            } else if(this->currentFunctionName == "getWaterfallChartValues"){
                emit signalWaterfallChartValues(strJson, this->currentReportId, this->currentDashboardId, this->currentChartSource);
            } else if(this->currentFunctionName == "getGaugeChartValues"){
                emit signalGaugeChartValues(strJson, this->currentReportId, this->currentDashboardId, this->currentChartSource);
            } else if(this->currentFunctionName == "getSankeyChartValues"){
                emit signalSankeyChartValues(strJson, this->currentReportId, this->currentDashboardId, this->currentChartSource);
            } else if(this->currentFunctionName == "getTreeChartValues"){
                emit signalTreeChartValues(strJson, this->currentReportId, this->currentDashboardId, this->currentChartSource);
            } else if(this->currentFunctionName == "getTreeMapChartValues"){
                emit signalTreeMapChartValues(strJson, this->currentReportId, this->currentDashboardId, this->currentChartSource);
            } else if(this->currentFunctionName == "getKPIChartValues"){
                emit signalKPIChartValues(strJson, this->currentReportId, this->currentDashboardId, this->currentChartSource);
            } else if(this->currentFunctionName == "getTableChartValues"){
                emit signalTableChartValues(strJson, this->currentReportId, this->currentDashboardId, this->currentChartSource);
            } else if(this->currentFunctionName == "getPivotChartValues"){
                emit signalPivotChartValues(strJson, this->currentReportId, this->currentDashboardId, this->currentChartSource);
            } else if(this->currentFunctionName == "getStackedAreaChartValues"){
                emit signalStackedAreaChartValues(strJson, this->currentReportId, this->currentDashboardId, this->currentChartSource);
            } else if(this->currentFunctionName == "getMultiLineChartValues"){
                emit signalMultiLineChartValues(strJson, this->currentReportId, this->currentDashboardId, this->currentChartSource);
            } else {}
        }
    }

    m_dataBuffer->clear();
}

void ChartsAPIThread::getBarChartValues()
{
    // Fetch value from settings
    QSettings settings;
    QString sitename = settings.value("user/sitename").toString();

    this->m_NetworkRequest.setUrl(this->baseUrl +"/getchart/getBarChartValues");

    this->m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                                     "application/x-www-form-urlencoded");
    this->m_NetworkRequest.setRawHeader("Authorization", this->sessionToken);

    QJsonObject obj;
    obj.insert("profileId", this->profileId);
    obj.insert("uniqueHash", this->sessionToken.toStdString().c_str());
    obj.insert("reportId", this->currentReportId);
    obj.insert("dashboardId", this->currentDashboardId);
    obj.insert("chartSource", this->currentChartSource);
    obj.insert("xAxisColumn", this->xAxisColumn);
    obj.insert("yAxisColumn", this->yAxisColumn);
    obj.insert("dbType", Statics::currentDbClassification);
    obj.insert("dsName", Statics::currentDSFile);
    obj.insert("dbIntType", Statics::currentDbIntType);
    obj.insert("isLive", Statics::currentDbClassification == Constants::duckType ? false : true);
    obj.insert("sitename", sitename);
    obj.insert("reportWhereConditions", this->reportWhereConditions);
    obj.insert("dashboardWhereConditions", this->dashboardWhereConditions);
    obj.insert("joinConditions", this->joinConditions);
    obj.insert("fromDesktop", true);

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(this->m_NetworkRequest, strJson.toUtf8());

    connect(m_networkReply,&QIODevice::readyRead,this,&ChartsAPIThread::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&ChartsAPIThread::dataReadFinished);
}

void ChartsAPIThread::getStackedBarChartValues()
{
    // Fetch value from settings
    QSettings settings;
    QString sitename = settings.value("user/sitename").toString();

    this->m_NetworkRequest.setUrl(this->baseUrl +"/getchart/getStackedBarChartValues");

    this->m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                                     "application/x-www-form-urlencoded");
    this->m_NetworkRequest.setRawHeader("Authorization", this->sessionToken);

    QJsonObject obj;
    obj.insert("profileId", this->profileId);
    obj.insert("uniqueHash", "hash");
    obj.insert("reportId", this->currentReportId);
    obj.insert("dashboardId", this->currentDashboardId);
    obj.insert("chartSource", this->currentChartSource);
    obj.insert("xAxisColumn", this->xAxisColumn);
    obj.insert("yAxisColumn", this->yAxisColumn);
    obj.insert("colorByDataColumns", this->xSplitKey);
    obj.insert("dbType", Statics::currentDbClassification);
    obj.insert("dsName", Statics::currentDSFile);
    obj.insert("dbIntType", Statics::currentDbIntType);
    obj.insert("isLive", Statics::currentDbClassification == Constants::duckType ? false : true);
    obj.insert("sitename", sitename);
    obj.insert("reportWhereConditions", this->reportWhereConditions);
    obj.insert("dashboardWhereConditions", this->dashboardWhereConditions);
    obj.insert("joinConditions", this->joinConditions);
    obj.insert("fromDesktop", true);

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(this->m_NetworkRequest, strJson.toUtf8());

    connect(m_networkReply,&QIODevice::readyRead,this,&ChartsAPIThread::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&ChartsAPIThread::dataReadFinished);
}

void ChartsAPIThread::getGroupedBarChartValues()
{
    // Fetch value from settings
    QSettings settings;
    QString sitename = settings.value("user/sitename").toString();

    this->m_NetworkRequest.setUrl(this->baseUrl +"/getchart/getGroupedBarChartValues");

    this->m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                                     "application/x-www-form-urlencoded");
    this->m_NetworkRequest.setRawHeader("Authorization", this->sessionToken);

    QJsonObject obj;
    obj.insert("profileId", this->profileId);
    obj.insert("uniqueHash", "hash");
    obj.insert("reportId", this->currentReportId);
    obj.insert("dashboardId", this->currentDashboardId);
    obj.insert("chartSource", this->currentChartSource);
    obj.insert("xAxisColumn", this->xAxisColumn);
    obj.insert("yAxisColumn", this->yAxisColumn);
    obj.insert("xSplitKey", this->xSplitKey);
    obj.insert("dbType", Statics::currentDbClassification);
    obj.insert("dsName", Statics::currentDSFile);
    obj.insert("dbIntType", Statics::currentDbIntType);
    obj.insert("isLive", Statics::currentDbClassification == Constants::duckType ? false : true);
    obj.insert("sitename", sitename);
    obj.insert("reportWhereConditions", this->reportWhereConditions);
    obj.insert("dashboardWhereConditions", this->dashboardWhereConditions);
    obj.insert("joinConditions", this->joinConditions);
    obj.insert("fromDesktop", true);

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(this->m_NetworkRequest, strJson.toUtf8());

    connect(m_networkReply,&QIODevice::readyRead,this,&ChartsAPIThread::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&ChartsAPIThread::dataReadFinished);
}

void ChartsAPIThread::getNewGroupedBarChartValues()
{
    // Fetch value from settings
    QSettings settings;
    QString sitename = settings.value("user/sitename").toString();

    this->m_NetworkRequest.setUrl(this->baseUrl +"/getchart/getNewGroupedBarChartValues");

    this->m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                                     "application/x-www-form-urlencoded");
    this->m_NetworkRequest.setRawHeader("Authorization", this->sessionToken);

    QJsonObject obj;
    obj.insert("profileId", this->profileId);
    obj.insert("uniqueHash", "hash");
    obj.insert("reportId", this->currentReportId);
    obj.insert("dashboardId", this->currentDashboardId);
    obj.insert("chartSource", this->currentChartSource);
    obj.insert("xAxisColumn", this->xAxisColumn);
    obj.insert("yAxisColumn", this->yAxisColumn);
    obj.insert("colorByDataColumns", this->xSplitKey);
    obj.insert("dbType", Statics::currentDbClassification);
    obj.insert("dsName", Statics::currentDSFile);
    obj.insert("dbIntType", Statics::currentDbIntType);
    obj.insert("isLive", Statics::currentDbClassification == Constants::duckType ? false : true);
    obj.insert("sitename", sitename);
    obj.insert("reportWhereConditions", this->reportWhereConditions);
    obj.insert("dashboardWhereConditions", this->dashboardWhereConditions);
    obj.insert("joinConditions", this->joinConditions);
    obj.insert("fromDesktop", true);

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(this->m_NetworkRequest, strJson.toUtf8());

    connect(m_networkReply,&QIODevice::readyRead,this,&ChartsAPIThread::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&ChartsAPIThread::dataReadFinished);

}

void ChartsAPIThread::getAreaChartValues()
{
    // Fetch value from settings
    QSettings settings;
    QString sitename = settings.value("user/sitename").toString();

    this->m_NetworkRequest.setUrl(this->baseUrl +"/getchart/getAreaChartValues");

    this->m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                                     "application/x-www-form-urlencoded");
    this->m_NetworkRequest.setRawHeader("Authorization", this->sessionToken);

    QJsonObject obj;
    obj.insert("profileId", this->profileId);
    obj.insert("uniqueHash", "hash");
    obj.insert("reportId", this->currentReportId);
    obj.insert("dashboardId", this->currentDashboardId);
    obj.insert("chartSource", this->currentChartSource);
    obj.insert("xAxisColumn", this->xAxisColumn);
    obj.insert("yAxisColumn", this->yAxisColumn);
    obj.insert("dbType", Statics::currentDbClassification);
    obj.insert("dsName", Statics::currentDSFile);
    obj.insert("dbIntType", Statics::currentDbIntType);
    obj.insert("isLive", Statics::currentDbClassification == Constants::duckType ? false : true);
    obj.insert("sitename", sitename);
    obj.insert("reportWhereConditions", this->reportWhereConditions);
    obj.insert("dashboardWhereConditions", this->dashboardWhereConditions);
    obj.insert("joinConditions", this->joinConditions);
    obj.insert("fromDesktop", true);

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(this->m_NetworkRequest, strJson.toUtf8());

    connect(m_networkReply,&QIODevice::readyRead,this,&ChartsAPIThread::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&ChartsAPIThread::dataReadFinished);
}

void ChartsAPIThread::getLineChartValues()
{

    // Fetch value from settings
    QSettings settings;
    QString sitename = settings.value("user/sitename").toString();

    this->m_NetworkRequest.setUrl(this->baseUrl +"/getchart/getLineChartValues");

    this->m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                                     "application/x-www-form-urlencoded");
    this->m_NetworkRequest.setRawHeader("Authorization", this->sessionToken);

    QJsonObject obj;
    obj.insert("profileId", this->profileId);
    obj.insert("uniqueHash", "hash");
    obj.insert("reportId", this->currentReportId);
    obj.insert("dashboardId", this->currentDashboardId);
    obj.insert("chartSource", this->currentChartSource);
    obj.insert("xAxisColumn", this->xAxisColumn);
    obj.insert("yAxisColumn", this->yAxisColumn);
    obj.insert("xSplitKey", this->xSplitKey);
    obj.insert("dbType", Statics::currentDbClassification);
    obj.insert("dsName", Statics::currentDSFile);
    obj.insert("dbIntType", Statics::currentDbIntType);
    obj.insert("isLive", Statics::currentDbClassification == Constants::duckType ? false : true);
    obj.insert("sitename", sitename);
    obj.insert("reportWhereConditions", this->reportWhereConditions);
    obj.insert("dashboardWhereConditions", this->dashboardWhereConditions);
    obj.insert("joinConditions", this->joinConditions);
    obj.insert("fromDesktop", true);

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(this->m_NetworkRequest, strJson.toUtf8());

    connect(m_networkReply,&QIODevice::readyRead,this,&ChartsAPIThread::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&ChartsAPIThread::dataReadFinished);
}

void ChartsAPIThread::getLineBarChartValues()
{

    // Fetch value from settings
    QSettings settings;
    QString sitename = settings.value("user/sitename").toString();

    this->m_NetworkRequest.setUrl(this->baseUrl +"/getchart/getLineBarChartValues");

    this->m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                                     "application/x-www-form-urlencoded");
    this->m_NetworkRequest.setRawHeader("Authorization", this->sessionToken);

    QJsonObject obj;
    obj.insert("profileId", this->profileId);
    obj.insert("uniqueHash", "hash");
    obj.insert("reportId", this->currentReportId);
    obj.insert("dashboardId", this->currentDashboardId);
    obj.insert("chartSource", this->currentChartSource);
    obj.insert("xAxisColumn", this->xAxisColumn);
    obj.insert("yAxisColumn", this->yAxisColumn);
    obj.insert("xSplitKey", this->xSplitKey);
    obj.insert("dbType", Statics::currentDbClassification);
    obj.insert("dsName", Statics::currentDSFile);
    obj.insert("dbIntType", Statics::currentDbIntType);
    obj.insert("isLive", Statics::currentDbClassification == Constants::duckType ? false : true);
    obj.insert("sitename", sitename);
    obj.insert("reportWhereConditions", this->reportWhereConditions);
    obj.insert("dashboardWhereConditions", this->dashboardWhereConditions);
    obj.insert("joinConditions", this->joinConditions);
    obj.insert("fromDesktop", true);

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(this->m_NetworkRequest, strJson.toUtf8());

    connect(m_networkReply,&QIODevice::readyRead,this,&ChartsAPIThread::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&ChartsAPIThread::dataReadFinished);
}

void ChartsAPIThread::getPieChartValues()
{

    // Fetch value from settings
    QSettings settings;
    QString sitename = settings.value("user/sitename").toString();

    this->m_NetworkRequest.setUrl(this->baseUrl +"/getchart/getPieChartValues");

    this->m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                                     "application/x-www-form-urlencoded");
    this->m_NetworkRequest.setRawHeader("Authorization", this->sessionToken);

    QJsonObject obj;
    obj.insert("profileId", this->profileId);
    obj.insert("uniqueHash", "hash");
    obj.insert("reportId", this->currentReportId);
    obj.insert("dashboardId", this->currentDashboardId);
    obj.insert("chartSource", this->currentChartSource);
    obj.insert("xAxisColumn", this->xAxisColumn);
    obj.insert("yAxisColumn", this->yAxisColumn);
    obj.insert("dbType", Statics::currentDbClassification);
    obj.insert("dsName", Statics::currentDSFile);
    obj.insert("dbIntType", Statics::currentDbIntType);
    obj.insert("isLive", Statics::currentDbClassification == Constants::duckType ? false : true);
    obj.insert("sitename", sitename);
    obj.insert("reportWhereConditions", this->reportWhereConditions);
    obj.insert("dashboardWhereConditions", this->dashboardWhereConditions);
    obj.insert("joinConditions", this->joinConditions);
    obj.insert("fromDesktop", true);

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(this->m_NetworkRequest, strJson.toUtf8());

    connect(m_networkReply,&QIODevice::readyRead,this,&ChartsAPIThread::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&ChartsAPIThread::dataReadFinished);
}

void ChartsAPIThread::getFunnelChartValues()
{

    // Fetch value from settings
    QSettings settings;
    QString sitename = settings.value("user/sitename").toString();

    this->m_NetworkRequest.setUrl(this->baseUrl +"/getchart/getFunnelChartValues");

    this->m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                                     "application/x-www-form-urlencoded");
    this->m_NetworkRequest.setRawHeader("Authorization", this->sessionToken);

    QJsonObject obj;
    obj.insert("profileId", this->profileId);
    obj.insert("uniqueHash", "hash");
    obj.insert("reportId", this->currentReportId);
    obj.insert("dashboardId", this->currentDashboardId);
    obj.insert("chartSource", this->currentChartSource);
    obj.insert("xAxisColumn", this->xAxisColumn);
    obj.insert("yAxisColumn", this->yAxisColumn);
    obj.insert("dbType", Statics::currentDbClassification);
    obj.insert("dsName", Statics::currentDSFile);
    obj.insert("dbIntType", Statics::currentDbIntType);
    obj.insert("isLive", Statics::currentDbClassification == Constants::duckType ? false : true);
    obj.insert("sitename", sitename);
    obj.insert("reportWhereConditions", this->reportWhereConditions);
    obj.insert("dashboardWhereConditions", this->dashboardWhereConditions);
    obj.insert("joinConditions", this->joinConditions);
    obj.insert("fromDesktop", true);

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(this->m_NetworkRequest, strJson.toUtf8());

    connect(m_networkReply,&QIODevice::readyRead,this,&ChartsAPIThread::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&ChartsAPIThread::dataReadFinished);
}

void ChartsAPIThread::getRadarChartValues()
{

    // Fetch value from settings
    QSettings settings;
    QString sitename = settings.value("user/sitename").toString();

    this->m_NetworkRequest.setUrl(this->baseUrl +"/getchart/getRadarChartValues");

    this->m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                                     "application/x-www-form-urlencoded");
    this->m_NetworkRequest.setRawHeader("Authorization", this->sessionToken);

    QJsonObject obj;
    obj.insert("profileId", this->profileId);
    obj.insert("uniqueHash", "hash");
    obj.insert("reportId", this->currentReportId);
    obj.insert("dashboardId", this->currentDashboardId);
    obj.insert("chartSource", this->currentChartSource);
    obj.insert("xAxisColumn", this->xAxisColumn);
    obj.insert("yAxisColumn", this->yAxisColumn);
    obj.insert("dbType", Statics::currentDbClassification);
    obj.insert("dsName", Statics::currentDSFile);
    obj.insert("dbIntType", Statics::currentDbIntType);
    obj.insert("isLive", Statics::currentDbClassification == Constants::duckType ? false : true);
    obj.insert("sitename", sitename);
    obj.insert("reportWhereConditions", this->reportWhereConditions);
    obj.insert("dashboardWhereConditions", this->dashboardWhereConditions);
    obj.insert("joinConditions", this->joinConditions);
    obj.insert("fromDesktop", true);

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(this->m_NetworkRequest, strJson.toUtf8());

    connect(m_networkReply,&QIODevice::readyRead,this,&ChartsAPIThread::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&ChartsAPIThread::dataReadFinished);
}

void ChartsAPIThread::getScatterChartValues()
{

    // Fetch value from settings
    QSettings settings;
    QString sitename = settings.value("user/sitename").toString();

    this->m_NetworkRequest.setUrl(this->baseUrl +"/getchart/getScatterChartValues");

    this->m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                                     "application/x-www-form-urlencoded");
    this->m_NetworkRequest.setRawHeader("Authorization", this->sessionToken);

    QJsonObject obj;
    obj.insert("profileId", this->profileId);
    obj.insert("uniqueHash", "hash");
    obj.insert("reportId", this->currentReportId);
    obj.insert("dashboardId", this->currentDashboardId);
    obj.insert("chartSource", this->currentChartSource);
    obj.insert("xAxisColumn", this->xAxisColumn);
    obj.insert("yAxisColumn", this->yAxisColumn);
    obj.insert("colorByDataColumns", this->xSplitKey);
    obj.insert("dbType", Statics::currentDbClassification);
    obj.insert("dsName", Statics::currentDSFile);
    obj.insert("dbIntType", Statics::currentDbIntType);
    obj.insert("isLive", Statics::currentDbClassification == Constants::duckType ? false : true);
    obj.insert("sitename", sitename);
    obj.insert("reportWhereConditions", this->reportWhereConditions);
    obj.insert("dashboardWhereConditions", this->dashboardWhereConditions);
    obj.insert("joinConditions", this->joinConditions);
    obj.insert("fromDesktop", true);

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(this->m_NetworkRequest, strJson.toUtf8());

    connect(m_networkReply,&QIODevice::readyRead,this,&ChartsAPIThread::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&ChartsAPIThread::dataReadFinished);
}

void ChartsAPIThread::getScatterChartNumericalValues()
{

    // Fetch value from settings
    QSettings settings;
    QString sitename = settings.value("user/sitename").toString();

    this->m_NetworkRequest.setUrl(this->baseUrl +"/getchart/getScatterChartNumericalValues");

    this->m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                                     "application/x-www-form-urlencoded");
    this->m_NetworkRequest.setRawHeader("Authorization", this->sessionToken);

    QJsonObject obj;
    obj.insert("profileId", this->profileId);
    obj.insert("uniqueHash", "hash");
    obj.insert("reportId", this->currentReportId);
    obj.insert("dashboardId", this->currentDashboardId);
    obj.insert("chartSource", this->currentChartSource);
    obj.insert("xAxisColumn", this->xAxisColumn);
    obj.insert("yAxisColumn", this->yAxisColumn);
    obj.insert("dbType", Statics::currentDbClassification);
    obj.insert("dsName", Statics::currentDSFile);
    obj.insert("dbIntType", Statics::currentDbIntType);
    obj.insert("isLive", Statics::currentDbClassification == Constants::duckType ? false : true);
    obj.insert("sitename", sitename);
    obj.insert("reportWhereConditions", this->reportWhereConditions);
    obj.insert("dashboardWhereConditions", this->dashboardWhereConditions);
    obj.insert("joinConditions", this->joinConditions);
    obj.insert("fromDesktop", true);

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(this->m_NetworkRequest, strJson.toUtf8());

    connect(m_networkReply,&QIODevice::readyRead,this,&ChartsAPIThread::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&ChartsAPIThread::dataReadFinished);
}

void ChartsAPIThread::getHeatMapChartValues()
{

    // Fetch value from settings
    QSettings settings;
    QString sitename = settings.value("user/sitename").toString();

    this->m_NetworkRequest.setUrl(this->baseUrl +"/getchart/getHeatMapChartValues");

    this->m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                                     "application/x-www-form-urlencoded");
    this->m_NetworkRequest.setRawHeader("Authorization", this->sessionToken);

    QJsonObject obj;
    obj.insert("profileId", this->profileId);
    obj.insert("uniqueHash", "hash");
    obj.insert("reportId", this->currentReportId);
    obj.insert("dashboardId", this->currentDashboardId);
    obj.insert("chartSource", this->currentChartSource);
    obj.insert("xAxisColumn", this->xAxisColumn);
    obj.insert("yAxisColumn", this->yAxisColumn);
    obj.insert("colorByDataColumns", this->xSplitKey);
    obj.insert("dbType", Statics::currentDbClassification);
    obj.insert("dsName", Statics::currentDSFile);
    obj.insert("dbIntType", Statics::currentDbIntType);
    obj.insert("isLive", Statics::currentDbClassification == Constants::duckType ? false : true);
    obj.insert("sitename", sitename);
    obj.insert("reportWhereConditions", this->reportWhereConditions);
    obj.insert("dashboardWhereConditions", this->dashboardWhereConditions);
    obj.insert("joinConditions", this->joinConditions);
    obj.insert("fromDesktop", true);

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(this->m_NetworkRequest, strJson.toUtf8());

    connect(m_networkReply,&QIODevice::readyRead,this,&ChartsAPIThread::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&ChartsAPIThread::dataReadFinished);
}

void ChartsAPIThread::getSunburstChartValues()
{

    // Fetch value from settings
    QSettings settings;
    QString sitename = settings.value("user/sitename").toString();

    this->m_NetworkRequest.setUrl(this->baseUrl +"/getchart/getSunburstChartValues");

    this->m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                                     "application/x-www-form-urlencoded");
    this->m_NetworkRequest.setRawHeader("Authorization", this->sessionToken);

    QJsonObject obj;
    obj.insert("profileId", this->profileId);
    obj.insert("uniqueHash", "hash");
    obj.insert("reportId", this->currentReportId);
    obj.insert("dashboardId", this->currentDashboardId);
    obj.insert("chartSource", this->currentChartSource);
    obj.insert("xAxisColumn", QJsonArray::fromVariantList(this->xAxisColumnList));
    obj.insert("yAxisColumn", this->yAxisColumn);
    obj.insert("dbType", Statics::currentDbClassification);
    obj.insert("dsName", Statics::currentDSFile);
    obj.insert("dbIntType", Statics::currentDbIntType);
    obj.insert("isLive", Statics::currentDbClassification == Constants::duckType ? false : true);
    obj.insert("sitename", sitename);
    obj.insert("reportWhereConditions", this->reportWhereConditions);
    obj.insert("dashboardWhereConditions", this->dashboardWhereConditions);
    obj.insert("joinConditions", this->joinConditions);
    obj.insert("fromDesktop", true);

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(this->m_NetworkRequest, strJson.toUtf8());

    connect(m_networkReply,&QIODevice::readyRead,this,&ChartsAPIThread::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&ChartsAPIThread::dataReadFinished);
}

void ChartsAPIThread::getWaterfallChartValues()
{

    // Fetch value from settings
    QSettings settings;
    QString sitename = settings.value("user/sitename").toString();

    this->m_NetworkRequest.setUrl(this->baseUrl +"/getchart/getWaterfallChartValues");

    this->m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                                     "application/x-www-form-urlencoded");
    this->m_NetworkRequest.setRawHeader("Authorization", this->sessionToken);

    QJsonObject obj;
    obj.insert("profileId", this->profileId);
    obj.insert("uniqueHash", "hash");
    obj.insert("reportId", this->currentReportId);
    obj.insert("dashboardId", this->currentDashboardId);
    obj.insert("chartSource", this->currentChartSource);
    obj.insert("xAxisColumn", this->xAxisColumn);
    obj.insert("yAxisColumn", this->yAxisColumn);
    obj.insert("dbType", Statics::currentDbClassification);
    obj.insert("dsName", Statics::currentDSFile);
    obj.insert("dbIntType", Statics::currentDbIntType);
    obj.insert("isLive", Statics::currentDbClassification == Constants::duckType ? false : true);
    obj.insert("sitename", sitename);
    obj.insert("reportWhereConditions", this->reportWhereConditions);
    obj.insert("dashboardWhereConditions", this->dashboardWhereConditions);
    obj.insert("joinConditions", this->joinConditions);
    obj.insert("fromDesktop", true);

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(this->m_NetworkRequest, strJson.toUtf8());

    connect(m_networkReply,&QIODevice::readyRead,this,&ChartsAPIThread::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&ChartsAPIThread::dataReadFinished);
}

void ChartsAPIThread::getGaugeChartValues()
{
    // Fetch value from settings
    QSettings settings;
    QString sitename = settings.value("user/sitename").toString();

    this->m_NetworkRequest.setUrl(this->baseUrl +"/getchart/getGaugeChartValues");

    this->m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                                     "application/x-www-form-urlencoded");
    this->m_NetworkRequest.setRawHeader("Authorization", this->sessionToken);

    QJsonObject obj;
    obj.insert("profileId", this->profileId);
    obj.insert("uniqueHash", "hash");
    obj.insert("reportId", this->currentReportId);
    obj.insert("dashboardId", this->currentDashboardId);
    obj.insert("chartSource", this->currentChartSource);
    obj.insert("calculateColumn", this->calculateColumn);
    obj.insert("greenValue", this->greenValue);
    obj.insert("yellowValue", this->yellowValue);
    obj.insert("redValue", this->redValue);
    obj.insert("dbType", Statics::currentDbClassification);
    obj.insert("dsName", Statics::currentDSFile);
    obj.insert("dbIntType", Statics::currentDbIntType);
    obj.insert("isLive", Statics::currentDbClassification == Constants::duckType ? false : true);
    obj.insert("sitename", sitename);
    obj.insert("reportWhereConditions", this->reportWhereConditions);
    obj.insert("dashboardWhereConditions", this->dashboardWhereConditions);
    obj.insert("joinConditions", this->joinConditions);
    obj.insert("fromDesktop", true);

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(this->m_NetworkRequest, strJson.toUtf8());

    connect(m_networkReply,&QIODevice::readyRead,this,&ChartsAPIThread::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&ChartsAPIThread::dataReadFinished);
}

void ChartsAPIThread::getSankeyChartValues()
{
    // Fetch value from settings
    QSettings settings;
    QString sitename = settings.value("user/sitename").toString();

    this->m_NetworkRequest.setUrl(this->baseUrl +"/getchart/getSankeyChartValues");

    this->m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                                     "application/x-www-form-urlencoded");
    this->m_NetworkRequest.setRawHeader("Authorization", this->sessionToken);

    QJsonObject obj;
    obj.insert("profileId", this->profileId);
    obj.insert("uniqueHash", "hash");
    obj.insert("reportId", this->currentReportId);
    obj.insert("dashboardId", this->currentDashboardId);
    obj.insert("chartSource", this->currentChartSource);
    obj.insert("sourceColumn", this->sourceColumn);
    obj.insert("destinationColumn", this->destinationColumn);
    obj.insert("measureColumn", this->measureColumn);
    obj.insert("dbType", Statics::currentDbClassification);
    obj.insert("dsName", Statics::currentDSFile);
    obj.insert("dbIntType", Statics::currentDbIntType);
    obj.insert("isLive", Statics::currentDbClassification == Constants::duckType ? false : true);
    obj.insert("sitename", sitename);
    obj.insert("reportWhereConditions", this->reportWhereConditions);
    obj.insert("dashboardWhereConditions", this->dashboardWhereConditions);
    obj.insert("joinConditions", this->joinConditions);
    obj.insert("fromDesktop", true);

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(this->m_NetworkRequest, strJson.toUtf8());

    connect(m_networkReply,&QIODevice::readyRead,this,&ChartsAPIThread::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&ChartsAPIThread::dataReadFinished);
}

void ChartsAPIThread::getTreeChartValues()
{

    // Fetch value from settings
    QSettings settings;
    QString sitename = settings.value("user/sitename").toString();

    this->m_NetworkRequest.setUrl(this->baseUrl +"/getchart/getTreeChartValues");

    this->m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                                     "application/x-www-form-urlencoded");
    this->m_NetworkRequest.setRawHeader("Authorization", this->sessionToken);

    QJsonObject obj;
    obj.insert("profileId", this->profileId);
    obj.insert("uniqueHash", "hash");
    obj.insert("reportId", this->currentReportId);
    obj.insert("dashboardId", this->currentDashboardId);
    obj.insert("chartSource", this->currentChartSource);
    obj.insert("xAxisColumn", QJsonArray::fromVariantList(this->xAxisColumnList));
    obj.insert("yAxisColumn", this->yAxisColumn);
    obj.insert("dbType", Statics::currentDbClassification);
    obj.insert("dsName", Statics::currentDSFile);
    obj.insert("dbIntType", Statics::currentDbIntType);
    obj.insert("isLive", Statics::currentDbClassification == Constants::duckType ? false : true);
    obj.insert("sitename", sitename);
    obj.insert("reportWhereConditions", this->reportWhereConditions);
    obj.insert("dashboardWhereConditions", this->dashboardWhereConditions);
    obj.insert("joinConditions", this->joinConditions);
    obj.insert("fromDesktop", true);

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(this->m_NetworkRequest, strJson.toUtf8());

    connect(m_networkReply,&QIODevice::readyRead,this,&ChartsAPIThread::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&ChartsAPIThread::dataReadFinished);
}

void ChartsAPIThread::getTreeMapChartValues()
{
    // Fetch value from settings
    QSettings settings;
    QString sitename = settings.value("user/sitename").toString();

    this->m_NetworkRequest.setUrl(this->baseUrl +"/getchart/getTreeMapChartValues");

    this->m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                                     "application/x-www-form-urlencoded");
    this->m_NetworkRequest.setRawHeader("Authorization", this->sessionToken);

    QJsonObject obj;
    obj.insert("profileId", this->profileId);
    obj.insert("uniqueHash", "hash");
    obj.insert("reportId", this->currentReportId);
    obj.insert("dashboardId", this->currentDashboardId);
    obj.insert("chartSource", this->currentChartSource);
    obj.insert("xAxisColumn", QJsonArray::fromVariantList(this->xAxisColumnList));
    obj.insert("yAxisColumn", this->yAxisColumn);
    obj.insert("dbType", Statics::currentDbClassification);
    obj.insert("dsName", Statics::currentDSFile);
    obj.insert("dbIntType", Statics::currentDbIntType);
    obj.insert("isLive", Statics::currentDbClassification == Constants::duckType ? false : true);
    obj.insert("sitename", sitename);
    obj.insert("reportWhereConditions", this->reportWhereConditions);
    obj.insert("dashboardWhereConditions", this->dashboardWhereConditions);
    obj.insert("joinConditions", this->joinConditions);
    obj.insert("fromDesktop", true);

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(this->m_NetworkRequest, strJson.toUtf8());

    connect(m_networkReply,&QIODevice::readyRead,this,&ChartsAPIThread::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&ChartsAPIThread::dataReadFinished);
}

void ChartsAPIThread::getKPIChartValues()
{

    // Fetch value from settings
    QSettings settings;
    QString sitename = settings.value("user/sitename").toString();

    this->m_NetworkRequest.setUrl(this->baseUrl +"/getchart/getKPIChartValues");

    this->m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                                     "application/x-www-form-urlencoded");
    this->m_NetworkRequest.setRawHeader("Authorization", this->sessionToken);

    QJsonObject obj;
    obj.insert("profileId", this->profileId);
    obj.insert("uniqueHash", "hash");
    obj.insert("reportId", this->currentReportId);
    obj.insert("dashboardId", this->currentDashboardId);
    obj.insert("chartSource", this->currentChartSource);
    obj.insert("xAxisColumn", this->calculateColumn);
    obj.insert("dbType", Statics::currentDbClassification);
    obj.insert("dsName", Statics::currentDSFile);
    obj.insert("dbIntType", Statics::currentDbIntType);
    obj.insert("isLive", Statics::currentDbClassification == Constants::duckType ? false : true);
    obj.insert("sitename", sitename);
    obj.insert("reportWhereConditions", this->reportWhereConditions);
    obj.insert("dashboardWhereConditions", this->dashboardWhereConditions);
    obj.insert("joinConditions", this->joinConditions);
    obj.insert("fromDesktop", true);

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(this->m_NetworkRequest, strJson.toUtf8());

    connect(m_networkReply,&QIODevice::readyRead,this,&ChartsAPIThread::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&ChartsAPIThread::dataReadFinished);
}

void ChartsAPIThread::getTableChartValues()
{

    // Fetch value from settings
    QSettings settings;
    QString sitename = settings.value("user/sitename").toString();

    this->m_NetworkRequest.setUrl(this->baseUrl +"/getchart/getTableChartValues");

    this->m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                                     "application/x-www-form-urlencoded");
    this->m_NetworkRequest.setRawHeader("Authorization", this->sessionToken);

    QJsonObject obj;
    obj.insert("profileId", this->profileId);
    obj.insert("uniqueHash", "hash");
    obj.insert("reportId", this->currentReportId);
    obj.insert("dashboardId", this->currentDashboardId);
    obj.insert("chartSource", this->currentChartSource);
    obj.insert("xAxisColumn", QJsonArray::fromVariantList(this->xAxisColumnList));
    obj.insert("yAxisColumn", QJsonArray::fromVariantList(this->yAxisColumnList));
    obj.insert("dateConversionParameters", this->dateConversionOptions);
    obj.insert("dbType", Statics::currentDbClassification);
    obj.insert("dsName", Statics::currentDSFile);
    obj.insert("dbIntType", Statics::currentDbIntType);
    obj.insert("isLive", Statics::currentDbClassification == Constants::duckType ? false : true);
    obj.insert("sitename", sitename);
    obj.insert("reportWhereConditions", this->reportWhereConditions);
    obj.insert("dashboardWhereConditions", this->dashboardWhereConditions);
    obj.insert("joinConditions", this->joinConditions);
    obj.insert("fromDesktop", true);


    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(this->m_NetworkRequest, strJson.toUtf8());

    connect(m_networkReply,&QIODevice::readyRead,this,&ChartsAPIThread::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&ChartsAPIThread::dataReadFinished);

}

void ChartsAPIThread::getPivotChartValues()
{
    // Fetch value from settings
    QSettings settings;
    QString sitename = settings.value("user/sitename").toString();

    this->m_NetworkRequest.setUrl(this->baseUrl +"/getchart/getPivotChartValues");

    this->m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                                     "application/x-www-form-urlencoded");
    this->m_NetworkRequest.setRawHeader("Authorization", this->sessionToken);

    QJsonObject obj;
    obj.insert("profileId", this->profileId);
    obj.insert("uniqueHash", "hash");
    obj.insert("reportId", this->currentReportId);
    obj.insert("dashboardId", this->currentDashboardId);
    obj.insert("chartSource", this->currentChartSource);
    obj.insert("xAxisColumn", QJsonArray::fromVariantList(this->xAxisColumnList));
    obj.insert("yAxisColumn", QJsonArray::fromVariantList(this->yAxisColumnList));
    obj.insert("dateConversionParameters", this->dateConversionOptions);
    obj.insert("dbType", Statics::currentDbClassification);
    obj.insert("dsName", Statics::currentDSFile);
    obj.insert("dbIntType", Statics::currentDbIntType);
    obj.insert("isLive", Statics::currentDbClassification == Constants::duckType ? false : true);
    obj.insert("sitename", sitename);
    obj.insert("reportWhereConditions", this->reportWhereConditions);
    obj.insert("dashboardWhereConditions", this->dashboardWhereConditions);
    obj.insert("joinConditions", this->joinConditions);
    obj.insert("fromDesktop", true);

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(this->m_NetworkRequest, strJson.toUtf8());

    connect(m_networkReply,&QIODevice::readyRead,this,&ChartsAPIThread::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&ChartsAPIThread::dataReadFinished);
}

void ChartsAPIThread::getStackedAreaChartValues()
{
    // Fetch value from settings
    QSettings settings;
    QString sitename = settings.value("user/sitename").toString();

    this->m_NetworkRequest.setUrl(this->baseUrl +"/getchart/getStackedAreaChartValues");

    this->m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                                     "application/x-www-form-urlencoded");
    this->m_NetworkRequest.setRawHeader("Authorization", this->sessionToken);

    QJsonObject obj;
    obj.insert("profileId", this->profileId);
    obj.insert("uniqueHash", "hash");
    obj.insert("reportId", this->currentReportId);
    obj.insert("dashboardId", this->currentDashboardId);
    obj.insert("chartSource", this->currentChartSource);
    obj.insert("xAxisColumn", this->xAxisColumn);
    obj.insert("yAxisColumn", this->yAxisColumn);
    obj.insert("colorByDataColumns", this->xSplitKey);
    obj.insert("dbType", Statics::currentDbClassification);
    obj.insert("dsName", Statics::currentDSFile);
    obj.insert("dbIntType", Statics::currentDbIntType);
    obj.insert("isLive", Statics::currentDbClassification == Constants::duckType ? false : true);
    obj.insert("sitename", sitename);
    obj.insert("reportWhereConditions", this->reportWhereConditions);
    obj.insert("dashboardWhereConditions", this->dashboardWhereConditions);
    obj.insert("joinConditions", this->joinConditions);
    obj.insert("fromDesktop", true);

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(this->m_NetworkRequest, strJson.toUtf8());

    connect(m_networkReply,&QIODevice::readyRead,this,&ChartsAPIThread::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&ChartsAPIThread::dataReadFinished);
}

void ChartsAPIThread::getMultiLineChartValues()
{
    // Fetch value from settings
    QSettings settings;
    QString sitename = settings.value("user/sitename").toString();

    this->m_NetworkRequest.setUrl(this->baseUrl +"/getchart/getMultiLineChartValues");

    this->m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                                     "application/x-www-form-urlencoded");
    this->m_NetworkRequest.setRawHeader("Authorization", this->sessionToken);

    QJsonObject obj;
    obj.insert("profileId", this->profileId);
    obj.insert("uniqueHash", "hash");
    obj.insert("reportId", this->currentReportId);
    obj.insert("dashboardId", this->currentDashboardId);
    obj.insert("chartSource", this->currentChartSource);
    obj.insert("xAxisColumn", this->xAxisColumn);
    obj.insert("yAxisColumn", this->yAxisColumn);
    obj.insert("colorByDataColumns", this->xSplitKey);
    obj.insert("dbType", Statics::currentDbClassification);
    obj.insert("dsName", Statics::currentDSFile);
    obj.insert("dbIntType", Statics::currentDbIntType);
    obj.insert("isLive", Statics::currentDbClassification == Constants::duckType ? false : true);
    obj.insert("sitename", sitename);
    obj.insert("reportWhereConditions", this->reportWhereConditions);
    obj.insert("dashboardWhereConditions", this->dashboardWhereConditions);
    obj.insert("joinConditions", this->joinConditions);
    obj.insert("fromDesktop", true);

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(this->m_NetworkRequest, strJson.toUtf8());

    connect(m_networkReply,&QIODevice::readyRead,this,&ChartsAPIThread::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&ChartsAPIThread::dataReadFinished);
}

void ChartsAPIThread::fetchSettings()
{
    // Fetch value from settings
    QSettings settings;
    this->baseUrl = settings.value("general/chartsUrl").toString();
    this->sessionToken = settings.value("user/sessionToken").toByteArray();
    this->profileId = settings.value("user/profileId").toInt();

}
