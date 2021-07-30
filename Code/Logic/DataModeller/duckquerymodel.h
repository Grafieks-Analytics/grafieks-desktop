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
#include "./Workers/generaterolenamesduckworker.h"
#include "./Workers/setchartdataduckworker.h"

class DuckQueryModel : public QAbstractTableModel
{
    Q_OBJECT

public:
    explicit DuckQueryModel(QObject *parent = nullptr);
    explicit DuckQueryModel(DuckCon *duckCon, QObject *parent = nullptr);
    ~DuckQueryModel();

    Q_INVOKABLE void setQuery(QString query);
    Q_INVOKABLE void setPreviewQuery(int previewRowCount);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex & = QModelIndex()) const override;
    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void getQueryStats();
    Q_INVOKABLE void removeTmpChartData();

public slots:
    void receiveCsvFilterQuery(QString query);
    void slotGenerateRoleNames(const QStringList &tableHeaders, const QMap<int, QStringList> &duckChartHeader, const QHash<int, QByteArray> roleNames, const int internalColCount);
    void slotSetChartData(bool success);

private:
    void generateRoleNames();
    void setQueryResult();
    QMap<QString, QString> returnColumnList(QString tableName);
    void setChartHeader(int index, QStringList colInfo);

    QHash<int, QByteArray> m_roleNames;
    QList<QStringList> resultData;
    int internalRowCount;
    int internalColCount;
    int previewRowCount;

    DuckCon *duckCon;
    QString query;
    QuerySplitter querySplitter;

    // Data variables for Charts
    QMap<int, QStringList*> duckChartData;
    QMap<int, QStringList> duckChartHeader;
    QStringList tableHeaders;
    SetChartDataDuckWorker *setChartDataWorker;

signals:
    void chartDataChanged(QMap<int, QStringList*> chartData);
    void chartHeaderChanged(QMap<int, QStringList> chartHeader);
    void duckHeaderDataChanged(QStringList tableHeaders);
    void duckHasData(bool hasData);
    void clearTablePreview();
    void errorSignal(QString errMsg);

};

#endif // DUCKQUERYMODEL_H
