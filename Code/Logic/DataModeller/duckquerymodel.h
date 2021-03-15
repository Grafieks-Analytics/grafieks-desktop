#ifndef DUCKQUERYMODEL_H
#define DUCKQUERYMODEL_H

#include<QAbstractTableModel>
#include <QObject>

#include "../../duckdb.hpp"
#include "../../statics.h"
#include "../../constants.h"
#include "../Connectors/duckcon.h"

#include "../General/datatype.h"
#include "../General/querysplitter.h"

class DuckQueryModel : public QAbstractTableModel
{
    Q_OBJECT

public:
    explicit DuckQueryModel(QObject *parent = nullptr);
    explicit DuckQueryModel(DuckCon *duckCon, QObject *parent = nullptr);

    Q_INVOKABLE void setQuery(QString query);
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex & = QModelIndex()) const override;
    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void getQueryStats();

private:
    void generateRoleNames();
    void setQueryResult();
    void setChartData(std::unique_ptr<duckdb::MaterializedQueryResult> &totalRows);
    void setChartHeader(int index, QString colName);

    QHash<int, QByteArray> m_roleNames;
    QList<QStringList> resultData;
    int internalRowCount;
    int internalColCount;

    DuckCon *duckCon;
    QString query;
    QuerySplitter querySplitter;

    // Data variables for Charts
    QMap<int, QStringList*> duckChartData;
    QMap<int, QString> duckChartHeader;

signals:
    void headerDataChanged(Qt::Orientation orientation, int first, int last) const;
    void chartDataChanged(QMap<int, QStringList*> chartData);
    void chartHeaderChanged(QMap<int, QString> chartHeader);

};

#endif // DUCKQUERYMODEL_H