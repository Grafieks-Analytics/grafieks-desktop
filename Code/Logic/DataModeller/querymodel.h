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
#include "../General/generalparamsmodel.h"

#include "../../duckdb.hpp"


class QueryModel : public QSqlQueryModel
{
    Q_OBJECT


public:
    explicit QueryModel(GeneralParamsModel *gpm, QObject *parent = 0);
    ~QueryModel();

    // QSqlQueryModel method override

    void setQuery(const QString &query, const QSqlDatabase &db = QSqlDatabase());
    void setQuery(const QSqlQuery &query);
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void callSql(QString tmpSql);
    Q_INVOKABLE void setPreviewQuery(int previewRowCount);
    Q_INVOKABLE void saveExtractData();

public slots:
    void receiveFilterQuery(QString & filteredQuery);

    void slotGenerateRoleNames(const QStringList &tableHeaders, const QMap<int, QStringList> &sqlChartHeader);
    void extractSaved(QString errorMessage);


signals:
    void headerDataChanged(QStringList tableHeaders);
    void sqlHasData(bool hasData);
    void clearTablePreview();
    void errorSignal(QString errMsg);
    void generateReports();
    void showSaveExtractWaitPopup();
    void extractFileExceededLimit(bool freeLimit);
    void extractCreationError(QString errorMessage);

private:
    QHash<int, QByteArray> m_roleNames;
    void generateRoleNames();
    void executeQuery(QString & query);
    void extractSizeLimit();

    // Data variables for Charts
    QMap<int, QStringList*> sqlChartData;
    QMap<int, QStringList> sqlChartHeader;
    QStringList tableHeaders;
    int tmpRowCount;
    int tmpColCount;
    QString tmpSql;
    SetChartDataQueryWorker *setChartDataWorker;
    QSqlQueryModel queryModel;
    QStringList columnStringTypes;

    QThread extractThread;
    GeneralParamsModel *generalParamsModel;

};

#endif // QUERYMODELLERMAIN_H
