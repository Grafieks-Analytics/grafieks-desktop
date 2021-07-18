#ifndef REPORTSDATAMODEL_H
#define REPORTSDATAMODEL_H

#include <QObject>
#include <QDebug>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>

#include "../../constants.h"

class ReportsDataModel : public QObject
{
    Q_OBJECT

    QMap<int, QList<int> *> newChartData;
    QMap<int, QMap<int, QList<int>>> reportChartData; // <ReportId - <columnKey - Values Array list>>
    QMap<int, QString> newChartHeader;

    QStringList numericalList;
    QStringList categoryList;
    QStringList dateList;
    int reportId;

public:
    explicit ReportsDataModel(QObject *parent = nullptr);


    Q_INVOKABLE void searchColumnNames(QString keyword);
    Q_INVOKABLE QList<int> fetchColumnData(QString columnName, QString options = "");
    Q_INVOKABLE QStringList searchColumnData(QString columnName, QString keyword);
    Q_INVOKABLE void clearData();
    Q_INVOKABLE void removeTmpChartData();
    Q_INVOKABLE void deleteReportData(int reportId, bool deleteAll = false);

public slots:
    void getChartData(QMap<int, QStringList*> chartData);
    void getChartHeader(QMap<int, QStringList> chartHeader);
    void updateFilterData(QMap<int, QVariantMap> masterReportFilters, int reportId);
    void currentScreenChanged(int currentScreen);
    void getReportId(int reportId);

signals:
    void sendFilteredColumn(QStringList allCategorical, QStringList allNumerical, QStringList allDates);
    void reportDataChanged(QMap<int, QMap<int, QStringList>> reportChartData, int currentReportId);
    void columnDataChanged(QList<int> columnData, QString options);


private:
    QVariant convertToDateFormatTimeFromString(QString stringDateFormat);

};

#endif // REPORTSDATAMODEL_H
