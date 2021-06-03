#ifndef QUERYMODELLER_H
#define QUERYMODELLER_H

#include <QSqlQueryModel>
#include <QSqlRecord>
#include <QSqlField>
#include <QSqlDatabase>
#include <QObject>
#include <QMap>

#include "../../Connectors/allconnectors.h"
#include "../../constants.h"
#include "../General/datatype.h"


class QueryModel : public QSqlQueryModel
{
    Q_OBJECT


public:
    explicit QueryModel(QObject *parent = 0);
    ~QueryModel();

    Q_INVOKABLE void setPreviewQuery(int previewRowCount);

    // QSqlQueryModel method override

    void setQuery(const QString &query, const QSqlDatabase &db = QSqlDatabase());
    void setQuery(const QSqlQuery &query);
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void callSql(QString tmpSql);
    Q_INVOKABLE void removeTmpChartData();

public slots:
    void receiveFilterQuery(QString & filteredQuery);
    void setChartData();
    void setChartHeader(int index, QStringList colInfo);

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
    QString tmpSql;
    bool resetPreviewCount;



};

#endif // QUERYMODELLER_H
