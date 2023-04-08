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
#include "../General/generalparamsmodel.h"

#include "./Workers/saveextractexcelworker.h"

class ExcelQueryModel : public QAbstractTableModel
{
    Q_OBJECT

    int previewRowCount;
    QList<QStringList> resultData;
    QString jsonData;
    QString query;
    QString finalSql;
    int internalColCount;
    QuerySplitter querySplitter;
    GeneralParamsModel *generalParamsModel;

    QHash<int, QByteArray> m_roleNames;

    QStringList selectParams;
    QStringList tableParams;
    QStringList whereParams;

    QString exisitingWhereConditions;
    QString newWhereConditions;
    bool queriedFromDataModeler;

public:
    explicit ExcelQueryModel(GeneralParamsModel *gpm, QObject *parent = nullptr);
    Q_PROPERTY(bool ifPublish READ ifPublish WRITE setIfPublish NOTIFY ifPublishChanged)

    Q_INVOKABLE void setQuery(QString query, bool queriedFromDataModeler);
    Q_INVOKABLE void setPreviewQuery(int previewRowCount);

    Q_INVOKABLE void saveExtractData();

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex & = QModelIndex()) const override;
    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    bool ifPublish() const;

public slots:
    void receiveExcelFilterQuery(QString &existingWhereConditions, QString &newWhereConditions);
    void extractSaved(QString errorMsg);

    void setIfPublish(bool ifPublish);

private:
    void generateRoleNames();
    void extractSizeLimit();

    bool m_ifPublish;

signals:
    void excelHeaderDataChanged(QStringList tableHeaders);
    void excelDataChanged(QString jsonData);
    void excelHasData(bool hasData);
    void clearTablePreview();
    void errorSignal(QString errMsg);
    void signalGenerateRoleNames(const QStringList &tableHeaders, const QMap<int, QStringList> &sqlChartHeader);
    void generateExtractReports();
    void showSaveExtractWaitPopup();
    void extractFileExceededLimit(bool freeLimit, bool ifPublish);
    void extractCreationError(QString errorMessage);

    void ifPublishChanged(bool ifPublish);
};

#endif // EXCELQUERYMODEL_H
