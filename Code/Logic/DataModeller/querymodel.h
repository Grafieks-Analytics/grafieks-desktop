#ifndef QUERYMODELLERMAIN_H
#define QUERYMODELLERMAIN_H

#include <QSqlQueryModel>
#include <QSqlRecord>
#include <QSqlField>
#include <QSqlDatabase>
#include <QObject>
#include <QMap>

#include "../../Connectors/allconnectors.h"
#include "../../constants.h"
#include "../General/datatype.h"
#include "./Workers/generaterolenamesqueryworker.h"
#include "./Workers/setchartdataqueryworker.h"
#include "../General/extractsmanager.h"


class QueryModel : public QSqlQueryModel
{
    Q_OBJECT
    ExtractsManager extractsManager;


public:
    explicit QueryModel(QObject *parent = 0);
    ~QueryModel();

    // QSqlQueryModel method override

    void setQuery(const QString &query, const QSqlDatabase &db = QSqlDatabase());
    void setQuery(const QSqlQuery &query);
    QVariant data(const QModelIndex &index, int role) const override;
    int rowCount(const QModelIndex &parent) const;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void callSql(QString tmpSql);
    Q_INVOKABLE void removeTmpChartData();
    Q_INVOKABLE void setPreviewQuery(int previewRowCount);

    Q_INVOKABLE void createTableTest();
    Q_INVOKABLE void insertTableTest();

public slots:
    void receiveFilterQuery(QString & filteredQuery);
    void setChartData();

    void slotGenerateRoleNames(const QStringList &tableHeaders, const QMap<int, QStringList> &sqlChartHeader);
    void slotSetChartData(bool success);

signals:
    void chartDataChanged(QMap<int, QStringList*> chartData);
    void chartHeaderChanged(QMap<int, QStringList> chartHeader);
    void headerDataChanged(QStringList tableHeaders);
    void sqlHasData(bool hasData);
    void clearTablePreview();
    void errorSignal(QString errMsg);

private:
    QHash<int, QByteArray> m_roleNames;
    void generateRoleNames();
    void executeQuery(QString & query, bool updateChartData = true);

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

};

#endif // QUERYMODELLERMAIN_H
