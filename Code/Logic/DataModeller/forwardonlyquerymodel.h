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
#include "./Workers/saveextractforwardonlyworker.h"
#include "./Workers/saveliveforwardonlyworker.h"
#include "../General/generalparamsmodel.h"

class ForwardOnlyQueryModel : public QAbstractTableModel
{
    Q_OBJECT

public:
    explicit ForwardOnlyQueryModel(GeneralParamsModel *gpm, QObject *parent = nullptr);
    ~ForwardOnlyQueryModel();

    Q_PROPERTY(bool ifPublish READ ifPublish WRITE setIfPublish NOTIFY ifPublishChanged)

    Q_INVOKABLE void setQuery(QString query, bool queriedFromDataModeler);
    Q_INVOKABLE void setPreviewQuery(int previewRowCount);
    Q_INVOKABLE void saveExtractData();
    Q_INVOKABLE void saveLiveData();

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex & = QModelIndex()) const override;
    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    bool ifPublish() const;

public slots:
    void receiveFilterQuery(QString &existingWhereConditions, QString &newWhereConditions);
    void extractSaved(QString errorMsg);
    void liveSaved(QString errorMessage, QString selectParams, QString whereConditions, QString joinConditions, QString masterTable);

    void setIfPublish(bool ifPublish);

private:
    void generateRoleNames();
    QString returnConnectionName();
    void slotGenerateRoleNames(const QStringList &tableHeaders, const QMap<int, QStringList> &duckChartHeader, const QHash<int, QByteArray> roleNames, const int internalColCount);
    void extractSizeLimit();

    void liveSizeLimit(QString selectParams, QString whereConditions, QString joinConditions, QString masterTable);


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
    QList<QStringList> resultData;
    QString tmpSql;

    DataType dataType;
    QStringList columnStringTypes;

    QString existingWhereConditions;
    QString newWhereConditions;
    bool queriedFromDataModeler;

    QString liveQuery;
    bool m_ifPublish;
    bool ifLive;

signals:

    void forwardOnlyHeaderDataChanged(QStringList tableHeaders);
    void forwardDataChanged(QList<QStringList> resultData);
    void forwardOnlyHasData(bool hasData);
    void clearTablePreview();
    void errorSignal(QString errMsg);
    void generateExtractReports();
    void generateLiveReports(QString query);
    void showSaveExtractWaitPopup();
    void extractFileExceededLimit(bool freeLimit, bool ifPublish);
    void liveFileExceededLimit(bool freeLimit, bool ifPublish);
    void extractCreationError(QString errorMessage);
    void liveFileSaved(bool ifPublish);
    void liveCreationError(QString errorMessage);
    void liveHeaderGenerated(QMap<int, QStringList> sqlHeaders);
    void liveQueryParams(QString selectParams, QString whereParams, QString joinParams, QString masterTable);



    void ifPublishChanged(bool ifPublish);
};

#endif // FORWARDONLYQUERYMODEL_H
