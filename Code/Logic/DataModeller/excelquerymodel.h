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
#include "../FreeTier/freetierextractsmanager.h"

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

public slots:
    void receiveExcelFilterQuery(QString query);
    void extractSaved();

private:
    void generateRoleNames();
    void extractSizeLimit();

signals:
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
