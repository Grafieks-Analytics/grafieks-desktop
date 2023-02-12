#ifndef REPORTSDATAMODEL_H
#define REPORTSDATAMODEL_H

#include <QObject>
#include <QDebug>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QSettings>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QNetworkAccessManager>
#include <QRegularExpression>

#include "../../constants.h"
#include "../../statics.h"
#include "../../duckdb.hpp"
#include "../General/datatype.h"
#include "../General/queryjoiner.h"

class ReportsDataModel : public QObject
{
    Q_OBJECT

    QMap<int, QStringList *> newChartData;
    QMap<int, QMap<int, QStringList>> reportChartData; // <ReportId - <columnKey - Values Array list>>
    QMap<int, QString> newChartHeader;

//    QStringList numericalList;
//    QStringList categoryList;
//    QStringList dateList;

    QVariantMap numericalMap;
    QVariantMap categoricalMap;
    QVariantMap dateMap;
    int reportId;

    DataType dataType;
    QueryJoiner qj;
    QStringList columnData;
    QString whereConditions;
    QString APIOptions;
    QVariant x;

    QNetworkAccessManager * m_networkAccessManager;
    QNetworkReply * m_networkReply;
    QByteArray * m_dataBuffer;

    QString liveMasterTable;
    QString liveWhereParams;
    QString liveJoinParams;
    QString liveSelectParams;

public:
    explicit ReportsDataModel(QObject *parent = nullptr);


    Q_INVOKABLE void searchColumnNames(QString keyword);
    Q_INVOKABLE QStringList fetchColumnData(QString columnName, QString options = "");
    Q_INVOKABLE QStringList searchColumnData(QString keyword);
    Q_INVOKABLE QStringList fetchColumnDataLive(QString columnName, QString options = "");
    Q_INVOKABLE void fetchColumnDataAPI(QString columnName, QString options = "");
    Q_INVOKABLE void clearData();
    Q_INVOKABLE void removeTmpChartData();
    Q_INVOKABLE void deleteReportData(int reportId, bool deleteAll = false);

public slots:
    void updateFilterData(QMap<int, QVariantMap> masterReportFilters, int reportId);
    void currentScreenChanged(int currentScreen);
    void getReportId(int reportId);
    void generateColumnsForExtract();
    void generateColumnsForLive(QMap<int, QStringList> sqlHeaders);
    void generateColumnsForReader(duckdb::Connection *con);
    void receiveOriginalConditions(QString selectParams, QString whereParams, QString joinParams, QString masterTable);

    void dataReadyRead();
    void columnReadFinished();
    void columnDataReadFinished();

signals:
    void sendFilteredColumn(QVariantMap allCategoricalMap, QVariantMap allNumericalMap, QVariantMap allDatesMap);
    void reportWhereConditions(QString whereConditions, int currentReportId);
    void columnDataChanged(QStringList columnData, QString options);
    void generateFiltersForAPI();

    void sessionExpired();


private:
    QVariant convertToDateFormatTimeFromString(QString stringDateFormat);
    void generateColumns(duckdb::Connection *con);
    void generateColumnsFromAPI();

};

#endif // REPORTSDATAMODEL_H
