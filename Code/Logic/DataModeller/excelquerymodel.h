#ifndef EXCELQUERYMODEL_H
#define EXCELQUERYMODEL_H

#include <QObject>
#include <QAbstractTableModel>
#include <QSqlDatabase>
#include <QSqlField>
#include <QSqlRecord>
#include <QSqlQueryModel>
#include <QTimer>

#include "../../statics.h"
#include "../../constants.h"

#include "../General/datatype.h"
#include "../../duckdb.hpp"
#include "../General/querysplitter.h"

#include "./Workers/saveextractexcelworker.h"
#include "./filtercategoricallistmodel.h"
#include "./filterdatelistmodel.h"
#include "./filternumericallistmodel.h"
#include "../General/freelimitsmanager.h"

class ExcelQueryModel : public QAbstractTableModel
{
    Q_OBJECT

    int previewRowCount;
    QList<QStringList> resultData;
    QString query;
    int internalColCount;
    QuerySplitter querySplitter;

    QHash<int, QByteArray> m_roleNames;

    QStringList selectParams;
    QStringList tableParams;
    QStringList whereParams;

    FilterCategoricalListModel *categoricalFilter;
    FilterNumericalListModel *numericalFilter;
    FilterDateListModel *dateFilter;
    int totalFiltersCount;

    DataType dataType;
    QStringList hideParams;
    QStringList columnStringTypes;
    QVector<int> rejectIds;

public:
    explicit ExcelQueryModel(QObject *parent = nullptr);

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

public slots:
    void receiveExcelFilterQuery(QString query);
    void slotGenerateRoleNames(const QStringList &tableHeaders, const QMap<int, QStringList> &duckChartHeader, const QHash<int, QByteArray> roleNames, const int internalColCount);
    void slotSetChartData(bool success);
    void extractSaved();

private:
    void generateRoleNames();
    void setQueryResult();
    QMap<QString, QString> returnColumnList(QString tableName);
    void setChartHeader(int index, QStringList colInfo);
    void extractSizeLimit();

signals:
    void chartDataChanged(QMap<int, QStringList*> chartData);
    void chartHeaderChanged(QMap<int, QStringList> chartHeader);
    void excelHeaderDataChanged(QStringList tableHeaders);
    void excelHasData(bool hasData);
    void clearTablePreview();
    void errorSignal(QString errMsg);
    void signalGenerateRoleNames(const QStringList &tableHeaders, const QMap<int, QStringList> &sqlChartHeader);
    void generateReports();
    void showSaveExtractWaitPopup();
    void extractFileExceededLimit(bool freeLimit);

};

#endif // EXCELQUERYMODEL_H
