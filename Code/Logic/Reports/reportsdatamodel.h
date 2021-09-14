#ifndef REPORTSDATAMODEL_H
#define REPORTSDATAMODEL_H

#include <QObject>
#include <QDebug>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QRegularExpression>

#include "../../constants.h"
#include "../../statics.h"
#include "../../duckdb.hpp"
#include "../General/datatype.h"

class ReportsDataModel : public QObject
{
    Q_OBJECT

    QMap<int, QStringList *> newChartData;
    QMap<int, QMap<int, QStringList>> reportChartData; // <ReportId - <columnKey - Values Array list>>
    QMap<int, QString> newChartHeader;

    QStringList numericalList;
    QStringList categoryList;
    QStringList dateList;
    int reportId;

    DataType dataType;
    QStringList columnData;
    QString whereConditions;

public:
    explicit ReportsDataModel(QObject *parent = nullptr);


    Q_INVOKABLE void searchColumnNames(QString keyword);
    Q_INVOKABLE QStringList fetchColumnData(QString columnName, QString options = "");
    Q_INVOKABLE QStringList searchColumnData(QString keyword);
    Q_INVOKABLE void clearData();
    Q_INVOKABLE void removeTmpChartData();
    Q_INVOKABLE void deleteReportData(int reportId, bool deleteAll = false);

public slots:
    void updateFilterData(QMap<int, QVariantMap> masterReportFilters, int reportId);
    void currentScreenChanged(int currentScreen);
    void getReportId(int reportId);
    void generateColumnsForExtract();
    void generateColumnsForReader(duckdb::Connection *con);

signals:
    void sendFilteredColumn(QStringList allCategorical, QStringList allNumerical, QStringList allDates);
    void reportWhereConditions(QString whereConditions, int currentReportId);
    void columnDataChanged(QStringList columnData, QString options);


private:
    QVariant convertToDateFormatTimeFromString(QString stringDateFormat);
    void generateColumns(duckdb::Connection *con);

};

#endif // REPORTSDATAMODEL_H
