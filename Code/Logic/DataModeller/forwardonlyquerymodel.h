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
#include "../FreeTier/freetierextractsmanager.h"
#include "./Workers/saveextractforwardonlyworker.h"
#include "../General/generalparamsmodel.h"

class ForwardOnlyQueryModel : public QAbstractTableModel
{
    Q_OBJECT

public:
    explicit ForwardOnlyQueryModel(GeneralParamsModel *gpm, QObject *parent = nullptr);
    ~ForwardOnlyQueryModel();

    Q_INVOKABLE void setQuery(QString query, bool queriedFromDataModeler);
    Q_INVOKABLE void setPreviewQuery(int previewRowCount);
    Q_INVOKABLE void saveExtractData();

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex & = QModelIndex()) const override;
    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

public slots:
    void receiveFilterQuery(QString &existingWhereConditions, QString &newWhereConditions);
    void extractSaved(QString errorMsg);

private:
    void generateRoleNames();
    QString returnConnectionName();
    void slotGenerateRoleNames(const QStringList &tableHeaders, const QMap<int, QStringList> &duckChartHeader, const QHash<int, QByteArray> roleNames, const int internalColCount);
    void extractSizeLimit();


    QHash<int, QByteArray> m_roleNames;
    QList<QStringList> resultData;
    int internalRowCount;
    int internalColCount;
    int previewRowCount;

    QString query;
    QString finalSql;
    QuerySplitter querySplitter;
    GeneralParamsModel *generalParamsModel;

    // Data variables for Charts
    QMap<int, QStringList*> forwardOnlyChartData;
    QMap<int, QStringList> forwardOnlyChartHeader;
    QStringList tableHeaders;

    DataType dataType;
    QStringList columnStringTypes;

    QString existingWhereConditions;
    QString newWhereConditions;
    bool queriedFromDataModeler;

signals:

    void forwardOnlyHeaderDataChanged(QStringList tableHeaders);
    void forwardOnlyHasData(bool hasData);
    void clearTablePreview();
    void errorSignal(QString errMsg);
    void generateReports();
    void showSaveExtractWaitPopup();
    void extractFileExceededLimit(bool freeLimit);
    void extractCreationError(QString errorMessage);



};

#endif // FORWARDONLYQUERYMODEL_H
