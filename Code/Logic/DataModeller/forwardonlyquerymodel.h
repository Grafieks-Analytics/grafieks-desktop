#ifndef FORWARDONLYQUERYMODEL_H
#define FORWARDONLYQUERYMODEL_H

#include <QObject>
#include<QAbstractTableModel>
#include <QSqlRecord>
#include <QSqlField>
#include <QSqlDatabase>
#include <QTimer>

#include "../../statics.h"
#include "../../constants.h"
#include "../../duckdb.hpp"

#include "../General/datatype.h"
#include "../General/querysplitter.h"
#include "./Workers/generaterolenamesforwardonlyworker.h"
#include "./Workers/setchartdataforwardonlyworker.h"
#include "../General/freelimitsmanager.h"

class ForwardOnlyQueryModel : public QAbstractTableModel
{
    Q_OBJECT

public:
    explicit ForwardOnlyQueryModel(QObject *parent = nullptr);
    ~ForwardOnlyQueryModel();

    Q_INVOKABLE void setQuery(QString query);
    Q_INVOKABLE void setPreviewQuery(int previewRowCount);
    Q_INVOKABLE void saveExtractData();

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex & = QModelIndex()) const override;
    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void getQueryStats();
    Q_INVOKABLE void removeTmpChartData();

private:
    void generateRoleNames();
    void setQueryResult();
    void setChartHeader(int index, QStringList colInfo);
    QString returnConnectionName();
    void slotGenerateRoleNames(const QStringList &tableHeaders, const QMap<int, QStringList> &duckChartHeader, const QHash<int, QByteArray> roleNames, const int internalColCount);
    void slotSetChartData(bool success);
    void extractSizeLimit();


    QHash<int, QByteArray> m_roleNames;
    QList<QStringList> resultData;
    int internalRowCount;
    int internalColCount;
    int previewRowCount;

    QString query;
    QuerySplitter querySplitter;

    // Data variables for Charts
    QMap<int, QStringList*> forwardOnlyChartData;
    QMap<int, QStringList> forwardOnlyChartHeader;
    QStringList tableHeaders;
    SetChartDataForwardOnlyWorker *setChartDataWorker;

    DataType dataType;
    QStringList columnStringTypes;

signals:
        void chartDataChanged(QMap<int, QStringList*> chartData);
    void chartHeaderChanged(QMap<int, QStringList> chartHeader);
    void forwardOnlyHeaderDataChanged(QStringList tableHeaders);
    void forwardOnlyHasData(bool hasData);
    void clearTablePreview();
    void errorSignal(QString errMsg);
    void generateReports(duckdb::Connection *con);
    void showSaveExtractWaitPopup();
    void extractFileExceededLimit(bool freeLimit);



};

#endif // FORWARDONLYQUERYMODEL_H
