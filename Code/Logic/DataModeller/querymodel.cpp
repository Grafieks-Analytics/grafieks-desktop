#include "querymodel.h"


QueryModel::QueryModel(GeneralParamsModel *gpm, QObject *parent): QSqlQueryModel(parent), setChartDataWorker(nullptr)
{
    this->generalParamsModel = gpm;
}

QueryModel::~QueryModel()
{
}

void QueryModel::setPreviewQuery(int previewRowCount)
{
    // Signal to clear exisitng data in tables (qml)
    emit clearTablePreview();

    QString finalSql;

    switch (Statics::currentDbIntType) {

    case Constants::mysqlIntType:
    case Constants::mysqlOdbcIntType:
    case Constants::sqliteIntType:
    case Constants::postgresIntType:
    case Constants::mongoIntType:{
        if(this->tmpSql.contains(" limit ", Qt::CaseInsensitive)){
            finalSql = this->tmpSql.split(" limit ", Qt::KeepEmptyParts, Qt::CaseInsensitive).first();
        } else{
            finalSql = this->tmpSql;
        }

        finalSql += " limit " + QString::number(previewRowCount);
        break;
    }

    case Constants::oracleIntType:{
        break;
    }
    case Constants::mssqlIntType:
    case Constants::accessIntType:{

        QString finalSqlInterPart;

        if(this->tmpSql.contains(" top ", Qt::CaseInsensitive)){
            finalSqlInterPart = this->tmpSql.split(" top ", Qt::KeepEmptyParts, Qt::CaseInsensitive).last();
            finalSql = "select top " + QString::number(previewRowCount) + " " + finalSqlInterPart.section(' ', 1);

        } else{
            finalSqlInterPart = this->tmpSql.section(' ', 1);
            finalSql = "select top " + QString::number(previewRowCount) + " " + finalSqlInterPart;
        }
        break;
    }
    }

    this->executeQuery(finalSql);
}

void QueryModel::saveExtractData()
{
    SaveExtractQueryWorker *saveExtractQueryWorker = new SaveExtractQueryWorker(this->tmpSql, this->generalParamsModel->getChangedColumnTypes());
    connect(saveExtractQueryWorker, &SaveExtractQueryWorker::saveExtractComplete, this, &QueryModel::extractSaved, Qt::QueuedConnection);
    connect(saveExtractQueryWorker, &SaveExtractQueryWorker::finished, saveExtractQueryWorker, &SaveExtractQueryWorker::deleteLater, Qt::QueuedConnection);

    saveExtractQueryWorker->start();

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

void QueryModel::callSql(QString tmpSql)
{
    // Signal to clear exisitng data in tables (qml)
    emit clearTablePreview();

    this->tmpSql = tmpSql.simplified();
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
        emit extractFileExceededLimit(true);
    } else {
        emit extractFileExceededLimit(false);
    }

    emit showSaveExtractWaitPopup();

    if(Statics::freeLimitExtractSizeExceeded == true){
        Statics::freeLimitExtractSizeExceeded = false;
    } else {
        emit generateReports();
    }
}


void QueryModel::receiveFilterQuery(QString &filteredQuery)
{
    // Signal to clear exisitng data in tables (qml)
    emit clearTablePreview();

    this->tmpSql = filteredQuery.simplified();
    qDebug() << "RECEIVED SQL" <<  this->tmpSql;
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
