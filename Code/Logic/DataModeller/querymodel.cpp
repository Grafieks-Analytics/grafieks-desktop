#include "querymodel.h"


QueryModel::QueryModel(GeneralParamsModel *gpm, QObject *parent): QSqlQueryModel(parent), setChartDataWorker(nullptr)
{
    this->generalParamsModel = gpm;
    this->ifLive = false;
}

QueryModel::~QueryModel()
{
}

void QueryModel::setPreviewQuery(int previewRowCount)
{
    // Signal to clear exisitng data in tables (qml)
    emit clearTablePreview();


    switch (Statics::currentDbIntType) {

    case Constants::mysqlIntType:
    case Constants::mysqlOdbcIntType:
    case Constants::sqliteIntType:
    case Constants::postgresIntType:
    case Constants::mongoIntType:{
        if(this->tmpSql.contains(" limit ", Qt::CaseInsensitive)){
            this->finalSql = this->tmpSql.split(" limit ", Qt::KeepEmptyParts, Qt::CaseInsensitive).first();
        } else{
            this->finalSql = this->tmpSql;
        }

        if(this->queriedFromDataModeler && this->newWhereConditions.trimmed().length() > 0)
            this->finalSql += " WHERE " + this->newWhereConditions;

        this->finalSql += " limit " + QString::number(previewRowCount);
        break;
    }

    case Constants::oracleIntType:{
        break;
    }
    case Constants::mssqlIntType:
    case Constants::accessIntType:{

        QString finalSqlInterPart;
        QString finalWhereConditions;

        if(this->queriedFromDataModeler && this->newWhereConditions.trimmed().length() > 0)
            finalWhereConditions = " WHERE " + this->newWhereConditions;

        if(this->tmpSql.contains(" top ", Qt::CaseInsensitive)){
            finalSqlInterPart = this->tmpSql.split(" top ", Qt::KeepEmptyParts, Qt::CaseInsensitive).last();
            this->finalSql = "select top " + QString::number(previewRowCount) + " " + finalSqlInterPart.section(' ', 1) + finalWhereConditions;

        } else{
            finalSqlInterPart = this->tmpSql.section(' ', 1);
            this->finalSql = "select top " + QString::number(previewRowCount) + " " + finalSqlInterPart + finalWhereConditions;
        }
        break;
    }
    }

    this->executeQuery(this->finalSql);
}

void QueryModel::saveExtractData()
{
    QString extractQuery;
    if(this->queriedFromDataModeler && this->newWhereConditions.trimmed().length() > 0){
        extractQuery = this->tmpSql +  " WHERE " + this->newWhereConditions;
    } else {
        extractQuery = this->tmpSql;
    }

    // For .gadse, we dont need to save headers
    this->ifLive = false;

    SaveExtractQueryWorker *saveExtractQueryWorker = new SaveExtractQueryWorker(extractQuery, this->generalParamsModel->getChangedColumnTypes());
    connect(saveExtractQueryWorker, &SaveExtractQueryWorker::saveExtractComplete, this, &QueryModel::extractSaved, Qt::QueuedConnection);
    connect(saveExtractQueryWorker, &SaveExtractQueryWorker::finished, saveExtractQueryWorker, &SaveExtractQueryWorker::deleteLater, Qt::QueuedConnection);

    saveExtractQueryWorker->start();

}

void QueryModel::saveLiveData()
{

    if(this->queriedFromDataModeler && this->newWhereConditions.trimmed().length() > 0){
        this->liveQuery = this->tmpSql +  " WHERE " + this->newWhereConditions;
    } else {
        this->liveQuery = this->tmpSql;
    }

    // For .gads, we need to save headers
    this->ifLive = true;


    SaveLiveQueryWorker *saveLiveQueryWorker = new SaveLiveQueryWorker(this->liveQuery, this->generalParamsModel->getChangedColumnTypes());
    connect(saveLiveQueryWorker, &SaveLiveQueryWorker::saveLiveComplete, this, &QueryModel::liveSaved, Qt::QueuedConnection);
    connect(saveLiveQueryWorker, &SaveExtractQueryWorker::finished, saveLiveQueryWorker, &SaveLiveQueryWorker::deleteLater, Qt::QueuedConnection);

    saveLiveQueryWorker->start();

}

bool QueryModel::ifPublish() const
{
    return m_ifPublish;
}

void QueryModel::setQuery(const QString &query, const QSqlDatabase &db)
{
    QSqlQueryModel::setQuery(query, db);

    if(QSqlQueryModel::lastError().type() != QSqlError::NoError){
        qWarning() << Q_FUNC_INFO << QSqlQueryModel::lastError();
        emit errorSignal(QSqlQueryModel::lastError().text());
    } else{

        this->tmpRowCount = QSqlQueryModel::rowCount();
        this->tmpColCount = QSqlQueryModel::columnCount();

        generateRoleNames();
        emit errorSignal("");
    }
}

void QueryModel::setQuery(const QSqlQuery &query)
{

    QSqlQueryModel::setQuery(query);

    if(QSqlQueryModel::lastError().type() != QSqlError::NoError){
        qWarning() << Q_FUNC_INFO << QSqlQueryModel::lastError();
        emit errorSignal(QSqlQueryModel::lastError().text());
    } else{

        this->tmpRowCount = QSqlQueryModel::rowCount();
        this->tmpColCount = QSqlQueryModel::columnCount();

        generateRoleNames();
        emit errorSignal("");
    }
}

QVariant QueryModel::data(const QModelIndex &index, int role) const
{
    QVariant value;

    if(role < Qt::UserRole) {
        value = QSqlQueryModel::data(index, role);
    }
    else {
        int columnIdx = role - Qt::UserRole - 1;
        QModelIndex modelIndex = this->index(index.row(), columnIdx);
        value = QSqlQueryModel::data(modelIndex, Qt::DisplayRole);
    }

    return value;
}


QHash<int, QByteArray> QueryModel::roleNames() const
{
    return {{Qt::DisplayRole, "display"}};
}

void QueryModel::callSql(QString tmpSql, bool queriedFromDataModeler)
{
    // Signal to clear exisitng data in tables (qml)
    emit clearTablePreview();

    this->tmpSql = tmpSql.simplified();
    this->queriedFromDataModeler = queriedFromDataModeler;
}

void QueryModel::slotGenerateRoleNames(const QStringList &tableHeaders, const QMap<int, QStringList> &sqlChartHeader)
{
    this->tableHeaders = tableHeaders;
    this->sqlChartHeader = sqlChartHeader;

    if(QSqlQueryModel::rowCount() > 0){
        emit sqlHasData(true);
    } else{
        emit sqlHasData(false);
    }

    // For .gads file, we need to save headers and data types
    if(this->ifLive){

        QString livePath = Statics::livePath;
        duckdb::DuckDB db(livePath.toStdString());
        duckdb::Connection con(db);

        QString headersCreateQuery = "CREATE TABLE " + Constants::masterHeadersTable + "(column_name VARCHAR, data_type VARCHAR, table_name VARCHAR)";
        QString headersInsertQuery = "INSERT INTO " + Constants::masterHeadersTable + " VALUES ";

        foreach(QStringList values, this->sqlChartHeader){
            headersInsertQuery += "('"+ values.at(0) +"', '"+ values.at(1) +"', '"+ values.at(2) +"'),";
        }
        headersInsertQuery.chop(1);

        auto queryHeadersCreate = con.Query(headersCreateQuery.toStdString());
        if(!queryHeadersCreate->success) qDebug() << queryHeadersCreate->error.c_str() << headersCreateQuery;
        auto queryHeaderInsert = con.Query(headersInsertQuery.toStdString());
        if(!queryHeaderInsert->success) qDebug() << queryHeaderInsert->error.c_str() << headersInsertQuery;

        if(queryHeadersCreate->success && queryHeaderInsert->success){
            emit showSaveExtractWaitPopup();
            emit liveHeaderGenerated(this->sqlChartHeader);
        } else {
            qWarning() << Q_FUNC_INFO << "HEADER WRITING FAILED";
        }
    }

    emit headerDataChanged(this->tableHeaders);
}


void QueryModel::extractSaved(QString errorMessage)
{
    // Delete if the extract size is larger than the permissible limit
    // This goes using QTimer because, syncing files cannot be directly deleted

    if(errorMessage.length() == 0){
        FreeTierExtractsManager freeTierExtractsManager;
        QTimer::singleShot(Constants::timeDelayCheckExtractSize, this, &QueryModel::extractSizeLimit);
    } else {
        emit extractCreationError(errorMessage);
    }
}

void QueryModel::liveSaved(QString errorMessage, QString selectParams, QString whereConditions, QString joinConditions, QString masterTable)
{
    // Delete if the extract size is larger than the permissible limit
    // This goes using QTimer because, syncing files cannot be directly deleted

    if(errorMessage.length() == 0){
        liveSizeLimit(selectParams, whereConditions, joinConditions, masterTable);
    } else {
        emit liveCreationError(errorMessage);
    }
}

void QueryModel::setIfPublish(bool ifPublish)
{
    if (m_ifPublish == ifPublish)
        return;

    m_ifPublish = ifPublish;
    emit ifPublishChanged(m_ifPublish);
}

void QueryModel::extractSizeLimit()
{
    QString extractPath = Statics::extractPath;
    int size = 0;
    int maxFreeExtractSize = Constants::freeTierExtractLimit; // This many bytes in a GB

    QFile fileInfo(extractPath);
    fileInfo.open(QFile::ReadWrite);
    fileInfo.setPermissions(QFileDevice::WriteUser | QFileDevice::ReadUser | QFileDevice::ExeUser);

    size = fileInfo.size();
    fileInfo.close();

    QFile file(extractPath);
    if(size > maxFreeExtractSize){
        if(!file.remove(extractPath)){
            qDebug() << Q_FUNC_INFO << file.errorString();
        }
        Statics::freeLimitExtractSizeExceeded = true;
        emit extractFileExceededLimit(true, m_ifPublish);
    } else {
        emit extractFileExceededLimit(false, m_ifPublish);
    }

    emit showSaveExtractWaitPopup();

    if(Statics::freeLimitExtractSizeExceeded == true){
        Statics::freeLimitExtractSizeExceeded = false;
    } else {
        emit generateExtractReports();
    }
}

void QueryModel::liveSizeLimit(QString selectParams, QString whereConditions, QString joinConditions, QString masterTable)
{

    QString livePath = Statics::livePath;
    int size = 0;

    QFile fileInfo(livePath);
    fileInfo.open(QFile::ReadWrite);
    fileInfo.setPermissions(QFileDevice::WriteUser | QFileDevice::ReadUser | QFileDevice::ExeUser);

    size = fileInfo.size();
    fileInfo.close();

    // Generate headers to be saved for .gads file
    this->setPreviewQuery(0);

    emit liveFileSaved(m_ifPublish);
    emit generateLiveReports(this->tmpSql);
    emit liveQueryParams(selectParams, whereConditions, joinConditions, masterTable);
}


void QueryModel::receiveFilterQuery(QString &existingWhereConditions, QString &newWhereConditions)
{
    // Signal to clear exisitng data in tables (qml)
    emit clearTablePreview();

    this->existingWhereConditions = existingWhereConditions;
    this->newWhereConditions = newWhereConditions;
}

void QueryModel::generateRoleNames()
{

    GenerateRoleNamesQueryWorker *generateRoleNameWorker = new GenerateRoleNamesQueryWorker(this);
    connect(generateRoleNameWorker, &GenerateRoleNamesQueryWorker::signalGenerateRoleNames, this, &QueryModel::slotGenerateRoleNames, Qt::QueuedConnection);
    connect(generateRoleNameWorker, &GenerateRoleNamesQueryWorker::finished, generateRoleNameWorker, &QObject::deleteLater, Qt::QueuedConnection);
    generateRoleNameWorker->setObjectName("Grafieks Query Rolenames");
    generateRoleNameWorker->start();
}

void QueryModel::executeQuery(QString &query)
{

    // For Databases which only allow Forward Only queries
    // Look into ForwardOnlyQueryModel, ForwardOnlyDataModel
    // SnowFlake
    // Redshift
    // Teradata

    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:{
        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlStrQueryType);
        this->setQuery(query, dbMysql);
        break;
    }

    case Constants::mysqlOdbcIntType:{
        QSqlDatabase dbMysqlOdbc = QSqlDatabase::database(Constants::mysqlOdbcStrQueryType);
        this->setQuery(query, dbMysqlOdbc);
        break;
    }

    case Constants::sqliteIntType:{
        QSqlDatabase dbSqlite = QSqlDatabase::database(Constants::sqliteStrQueryType);
        this->setQuery(query, dbSqlite);
        break;
    }
    case Constants::postgresIntType:{
        QSqlDatabase dbPostgres = QSqlDatabase::database(Constants::postgresOdbcStrQueryType);
        this->setQuery(query, dbPostgres);
        break;
    }

    case Constants::mssqlIntType:{
        QSqlDatabase dbMssql = QSqlDatabase::database(Constants::mssqlOdbcStrQueryType);
        this->setQuery(query, dbMssql);
        break;
    }

    case Constants::oracleIntType:{
        QSqlDatabase dbOracle = QSqlDatabase::database(Constants::oracleOdbcStrQueryType);
        this->setQuery(query, dbOracle);
        break;
    }

    case Constants::mongoIntType:{
        QSqlDatabase dbMongo = QSqlDatabase::database(Constants::mongoOdbcStrQueryType);
        this->setQuery(query, dbMongo);
        break;
    }

    case Constants::accessIntType:{
        QSqlDatabase dbAccess = QSqlDatabase::database(Constants::accessOdbcStrQueryType);
        this->setQuery(query, dbAccess);
        break;
    }

    }
}
