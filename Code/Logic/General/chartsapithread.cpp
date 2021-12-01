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

void ChartsAPIThread::setLists(QVariantList &xAxisColumnList, QVariantList &yAxisColumnList)
{
    this->xAxisColumnList.clear();
    this->yAxisColumnList.clear();

    this->xAxisColumnList = xAxisColumnList;
    this->yAxisColumnList = yAxisColumnList;
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

void ChartsAPIThread::setGaugeKpiDetails(QString &calculateColumn)
{
    this->calculateColumn = calculateColumn;
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
    m_dataBuffer->clear();
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
        QString strJson(dataDoc.toJson(QJsonDocument::Compact));

        qDebug() << "JSON DOC" << strJson;
        emit signalBarChartValues(strJson,3, 0, 5);
    }
}

void ChartsAPIThread::getBarChartValues()
{

    // MAIN CODE

    QNetworkRequest m_NetworkRequest;
    m_NetworkRequest.setUrl(this->baseUrl +"/getchart/getBarChartValues");

    m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                               "application/x-www-form-urlencoded");
    m_NetworkRequest.setRawHeader("Authorization", this->sessionToken);

    QJsonObject obj;
    obj.insert("profileId", this->profileId);
    obj.insert("uniqueHash", "hash");
    obj.insert("reportId", this->currentReportId);
    obj.insert("dashboardId", this->currentDashboardId);
    obj.insert("chartSource", this->currentChartSource);
    obj.insert("xAxisColumn", this->xAxisColumn);
    obj.insert("yAxisColumn", this->yAxisColumn);
    obj.insert("dbType", "extract");
    obj.insert("sourcePath", "c:/Users/chill/Desktop/orders1500.gadse");

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(m_NetworkRequest, strJson.toUtf8());

    connect(m_networkReply,&QIODevice::readyRead,this,&ChartsAPIThread::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&ChartsAPIThread::dataReadFinished);
}

void ChartsAPIThread::getStackedBarChartValues()
{

}

void ChartsAPIThread::getGroupedBarChartValues()
{

}

void ChartsAPIThread::getNewGroupedBarChartValues()
{

}

void ChartsAPIThread::getAreaChartValues()
{

}

void ChartsAPIThread::getLineChartValues()
{

}

void ChartsAPIThread::getLineBarChartValues()
{

}

void ChartsAPIThread::getPieChartValues()
{

}

void ChartsAPIThread::getFunnelChartValues()
{

}

void ChartsAPIThread::getRadarChartValues()
{

}

void ChartsAPIThread::getScatterChartValues()
{

}

void ChartsAPIThread::getScatterChartNumericalValues()
{

}

void ChartsAPIThread::getHeatMapChartValues()
{

}

void ChartsAPIThread::getSunburstChartValues()
{

}

void ChartsAPIThread::getWaterfallChartValues()
{

}

void ChartsAPIThread::getGaugeChartValues()
{

}

void ChartsAPIThread::getSankeyChartValues()
{

}

void ChartsAPIThread::getTreeChartValues()
{

}

void ChartsAPIThread::getTreeMapChartValues()
{

}

void ChartsAPIThread::getKPIChartValues()
{

}

void ChartsAPIThread::getTableChartValues()
{

}

void ChartsAPIThread::getPivotChartValues()
{

}

void ChartsAPIThread::getStackedAreaChartValues()
{

}

void ChartsAPIThread::getMultiLineChartValues()
{

}

void ChartsAPIThread::getLineAreaWaterfallValues(QString &xAxisColumn, QString &yAxisColumn, QString identifier)
{

}

void ChartsAPIThread::getTreeSunburstValues(QVariantList &xAxisColumn, QString &yAxisColumn, QString identifier)
{

}

void ChartsAPIThread::getStackedBarAreaValues(QString &xAxisColumn, QString &yAxisColumn, QString &xSplitKey, QString identifier)
{

}

void ChartsAPIThread::fetchSettings()
{
    // Fetch value from settings
    QSettings settings;
    this->baseUrl = settings.value("general/chartsUrl").toString();
    this->sessionToken = settings.value("user/sessionToken").toByteArray();
    this->profileId = settings.value("user/profileId").toInt();

}
