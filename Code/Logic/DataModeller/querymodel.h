#ifndef QUERYMODELLERMAIN_H
#define QUERYMODELLERMAIN_H

#include <QSqlQueryModel>
#include <QSqlRecord>
#include <QSqlField>
#include <QSqlDatabase>
#include <QObject>
#include <QMap>
#include <QTimer>

#include "../../Connectors/allconnectors.h"
#include "../../constants.h"
#include "../General/datatype.h"
#include "./Workers/generaterolenamesqueryworker.h"
#include "./Workers/setchartdataqueryworker.h"
#include "../General/freelimitsmanager.h"
#include "./Workers/saveextractqueryworker.h"

#include "../../duckdb.hpp"


class QueryModel : public QSqlQueryModel
{
    Q_OBJECT


public:
    explicit QueryModel(QObject *parent = 0);
    ~QueryModel();

    // QSqlQueryModel method override

    void setQuery(const QString &query, const QSqlDatabase &db = QSqlDatabase());
    void setQuery(const QSqlQuery &query);
    QVariant data(const QModelIndex &index, int role) const override;
    int rowCount(const QModelIndex &parent) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void callSql(QString tmpSql);
    Q_INVOKABLE void removeTmpChartData();
    Q_INVOKABLE void setPreviewQuery(int previewRowCount);
    Q_INVOKABLE void saveExtractData();

public slots:
    void receiveFilterQuery(QString & filteredQuery);
    void setChartData();

    void slotGenerateRoleNames(const QStringList &tableHeaders, const QMap<int, QStringList> &sqlChartHeader);
    void slotSetChartData(bool success);
    void extractSaved();


signals:
    void chartDataChanged(QMap<int, QStringList*> chartData);
    void chartHeaderChanged(QMap<int, QStringList> chartHeader);
    void headerDataChanged(QStringList tableHeaders);
    void sqlHasData(bool hasData);
    void clearTablePreview();
    void errorSignal(QString errMsg);
    void generateReports();
    void showSaveExtractWaitPopup();
    void extractFileExceededLimit(bool freeLimit);

private:
    QHash<int, QByteArray> m_roleNames;
    void generateRoleNames();
    void executeQuery(QString & query, bool updateChartData = true);
    void extractSizeLimit();

    // Data variables for Charts
    QMap<int, QStringList*> sqlChartData;
    QMap<int, QStringList> sqlChartHeader;
    QStringList tableHeaders;
    int tmpRowCount;
    int tmpColCount;
    QString tmpSql;
    bool resetPreviewCount;
    SetChartDataQueryWorker *setChartDataWorker;
    QSqlQueryModel queryModel;
    int maxRowCount;
    QStringList columnStringTypes;

    QThread extractThread;

};

#endif // QUERYMODELLERMAIN_H
