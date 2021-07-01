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

    QMap<int, QStringList *> newChartData;
    QMap<QString, QMap<int, QStringList>> reportChartData; // <ReportId - <columnKey - Values Array list>>
    QMap<int, QString> newChartHeader;

    QStringList numericalList;
    QStringList categoryList;
    QStringList dateList;
    QString reportId;

public:
    explicit ReportsDataModel(QObject *parent = nullptr);


    Q_INVOKABLE void searchColumnNames(QString keyword);
    Q_INVOKABLE QStringList fetchColumnData(QString columnName, QString options = "");
    Q_INVOKABLE QStringList searchColumnData(QString columnName, QString keyword);
    Q_INVOKABLE void clearData();
    Q_INVOKABLE void removeTmpChartData();

public slots:
    void getChartData(QMap<int, QStringList*> chartData);
    void getChartHeader(QMap<int, QStringList> chartHeader);
    void updateFilterData(QMap<int, QVariantMap> masterReportFilters, QString reportId);
    void currentScreenChanged(int currentScreen);
    void getReportId(QString reportId);

signals:
    void sendFilteredColumn(QStringList allCategorical, QStringList allNumerical, QStringList allDates);
    void reportDataChanged(QMap<QString, QMap<int, QStringList>> reportChartData, QString currentReportId);
    void columnDataChanged(QStringList columnData, QString options);


private:
    QVariant convertToDateFormatTimeFromString(QString stringDateFormat);

};

#endif // REPORTSDATAMODEL_H
