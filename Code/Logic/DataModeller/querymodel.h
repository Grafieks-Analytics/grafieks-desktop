#ifndef QUERYMODELLERMAIN_H
#define QUERYMODELLERMAIN_H

#include <QSqlQueryModel>
#include <QSqlRecord>
#include <QSqlField>
#include <QSqlQueryModel>
#include <QSqlDatabase>
#include <QObject>
#include <QMap>
#include <QTimer>

#include "../../Connectors/allconnectors.h"
#include "../../constants.h"
#include "../General/datatype.h"
#include "./Workers/generaterolenamesqueryworker.h"
#include "./Workers/setchartdataqueryworker.h"
#include "../FreeTier/freetierextractsmanager.h"
#include "./Workers/saveextractqueryworker.h"
#include "./Workers/savelivequeryworker.h"
#include "../General/generalparamsmodel.h"

#include "../../duckdb.hpp"


class QueryModel : public QSqlQueryModel
{
    Q_OBJECT


public:
    explicit QueryModel(GeneralParamsModel *gpm, QObject *parent = 0);
    ~QueryModel();

    Q_PROPERTY(bool ifPublish READ ifPublish WRITE setIfPublish NOTIFY ifPublishChanged);

    // QSqlQueryModel method override

    void setQuery(const QString &query, const QSqlDatabase &db = QSqlDatabase());
    void setQuery(const QSqlQuery &query);
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void callSql(QString tmpSql, bool queriedFromDataModeler);
    Q_INVOKABLE void setPreviewQuery(int previewRowCount);
    Q_INVOKABLE void saveExtractData();
    Q_INVOKABLE void saveLiveData();

    bool ifPublish() const;

public slots:
    void receiveFilterQuery(QString &existingWhereConditions, QString &newWhereConditions);

    void slotGenerateRoleNames(const QStringList &tableHeaders, const QMap<int, QStringList> &sqlChartHeader);
    void extractSaved(QString errorMessage);
    void liveSaved(QString errorMessage);


    void setIfPublish(bool ifPublish);

signals:
    void headerDataChanged(QStringList tableHeaders);
    void sqlHasData(bool hasData);
    void clearTablePreview();
    void errorSignal(QString errMsg);
    void generateExtractReports();
    void generateLiveReports();
    void showSaveExtractWaitPopup();
    void extractFileExceededLimit(bool freeLimit, bool ifPublish);
    void liveFileSaved(bool ifPublish);
    void extractCreationError(QString errorMessage);
    void liveCreationError(QString errorMessage);

    void ifPublishChanged(bool ifPublish);

private:
    QHash<int, QByteArray> m_roleNames;
    void generateRoleNames();
    void executeQuery(QString & query);
    void extractSizeLimit();
    void liveSizeLimit();

    // Data variables for Charts
    QMap<int, QStringList*> sqlChartData;
    QMap<int, QStringList> sqlChartHeader;
    QStringList tableHeaders;
    int tmpRowCount;
    int tmpColCount;
    QString tmpSql;
    QString finalSql;
    SetChartDataQueryWorker *setChartDataWorker;
    QSqlQueryModel queryModel;
    QStringList columnStringTypes;

    QString existingWhereConditions;
    QString newWhereConditions;
    bool queriedFromDataModeler;

    QThread extractThread;
    GeneralParamsModel *generalParamsModel;

    bool m_ifPublish;
};

#endif // QUERYMODELLERMAIN_H
