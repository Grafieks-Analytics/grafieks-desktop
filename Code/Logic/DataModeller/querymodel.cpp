#include "querymodel.h"


QueryModel::QueryModel(QObject *parent): QSqlQueryModel(parent), resetPreviewCount(false), setChartDataWorker(nullptr)
{
}

QueryModel::~QueryModel()
{
}

void QueryModel::setPreviewQuery(int previewRowCount)
{
    // Signal to clear exisitng data in tables (qml)
    emit clearTablePreview();

    if(previewRowCount > this->tmpRowCount){
        this->maxRowCount = this->tmpRowCount;
    } else{
        this->maxRowCount = previewRowCount;
    }

    QString finalSql;

    switch (Statics::currentDbIntType) {

    case Constants::mysqlIntType:
    case Constants::mysqlOdbcIntType:
    case Constants::sqliteIntType:
    case Constants::postgresIntType:
    case Constants::mongoIntType:{
        if(this->tmpSql.toLower().contains(" limit ", Qt::CaseInsensitive)){
            finalSql = this->tmpSql.toLower().split(" limit ").first();
        } else{
            finalSql = this->tmpSql.toLower();
        }

        finalSql += " limit " + QString::number(maxRowCount);
        break;
    }

    case Constants::oracleIntType:{
        break;
    }
    case Constants::mssqlIntType:
    case Constants::accessIntType:{

        QString finalSqlInterPart;

        if(this->tmpSql.toLower().contains(" top ", Qt::CaseInsensitive)){
            finalSqlInterPart = this->tmpSql.toLower().split(" top ").last();
            finalSql = "select top " + QString::number(maxRowCount) + " " + finalSqlInterPart.section(' ', 1);

        } else{
            finalSqlInterPart = this->tmpSql.toLower().section(' ', 1);
            finalSql = "select top " + QString::number(maxRowCount) + " " + finalSqlInterPart;
        }
        break;
    }
    }

    // For custom preview count
    this->resetPreviewCount = true;

    this->executeQuery(finalSql, false);

    qDebug() << "ROW COUNT" <<QSqlQueryModel::rowCount() << maxRowCount;

    if(QSqlQueryModel::rowCount() > 0){
        emit sqlHasData(true);
    } else{
        emit sqlHasData(false);
    }
}

void QueryModel::createTableTest()
{
    QList<QByteArray> columnNames;
    QVector<int> columnIntTypes;
    QStringList columnStringTypes;
    QString tableName;

    // 这是什么,学校,ab
//    QString x = "这是什么";
    QString x = "aa";
    columnNames.append(x.toUtf8());
//    x = "学校";
    x = "ab";
    columnNames.append(x.toUtf8());
    x = "ac";
    columnNames.append(x.toUtf8());

    columnIntTypes.append(Constants::varcharIntType);
    columnIntTypes.append(Constants::varcharIntType);
//    columnIntTypes.append(Constants::dateIntType);
    columnIntTypes.append(Constants::doubleIntType);

    columnStringTypes.append(Constants::varcharStringType);
    columnStringTypes.append(Constants::varcharStringType);
//    columnStringTypes.append(Constants::dateStringType);
    columnStringTypes.append(Constants::doubleStringType);

    extractsManager.createTable(columnNames, columnIntTypes, columnStringTypes, "TAB1");
}

void QueryModel::insertTableTest()
{
    // Query model section starts

//     QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlStrType);
//     QSqlQuery query("SELECT * FROM test_final", dbMysql);
//     extractsManager.uploadQueryData(&query);

    // Query model section ends

    // CSV model starts
     QFile file("C:\\Users\\chill\\Desktop\\ex.csv");
     file.open(QFile::ReadOnly | QFile::Text);
     extractsManager.uploadCSVData(&file);
    // CSV model ends
}


void QueryModel::setQuery(const QString &query, const QSqlDatabase &db)
{
    this->removeTmpChartData();

    QSqlQueryModel::setQuery(query, db);

    if(QSqlQueryModel::lastError().type() != QSqlError::NoError){
        qWarning() << Q_FUNC_INFO << QSqlQueryModel::lastError();
        emit errorSignal(QSqlQueryModel::lastError().text());
    } else{

        if(this->resetPreviewCount == false){
            this->tmpRowCount = QSqlQueryModel::rowCount();
            this->tmpColCount = QSqlQueryModel::columnCount();
        }

        generateRoleNames();
        emit errorSignal("");
    }
}

void QueryModel::setQuery(const QSqlQuery &query)
{

    this->removeTmpChartData();

    QSqlQueryModel::setQuery(query);

    if(QSqlQueryModel::lastError().type() != QSqlError::NoError){
        qWarning() << Q_FUNC_INFO << QSqlQueryModel::lastError();
        emit errorSignal(QSqlQueryModel::lastError().text());
    } else{

        if(this->resetPreviewCount == false){
            this->tmpRowCount = QSqlQueryModel::rowCount();
            this->tmpColCount = QSqlQueryModel::columnCount();
        }

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

int QueryModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return this->maxRowCount;
}


QHash<int, QByteArray> QueryModel::roleNames() const
{
    return {{Qt::DisplayRole, "display"}};
}

void QueryModel::callSql(QString tmpSql)
{
    // Signal to clear exisitng data in tables (qml)
    emit clearTablePreview();

    // For custom preview count
    this->resetPreviewCount = false;

    this->tmpSql = tmpSql.simplified();
    this->executeQuery(this->tmpSql, true);
}

void QueryModel::removeTmpChartData()
{
    this->sqlChartData.clear();
    this->sqlChartHeader.clear();
    this->tableHeaders.clear();

    emit sqlHasData(false);
    emit headerDataChanged(this->tableHeaders);
    emit chartHeaderChanged(this->sqlChartHeader);
}

void QueryModel::setChartData()
{
    this->setChartDataWorker = new SetChartDataQueryWorker(this, this->tmpRowCount, this->tmpColCount);
    connect(setChartDataWorker, &SetChartDataQueryWorker::signalSetChartData, this, &QueryModel::slotSetChartData, Qt::QueuedConnection);
    connect(setChartDataWorker, &SetChartDataQueryWorker::finished, setChartDataWorker, &QObject::deleteLater, Qt::QueuedConnection);
    setChartDataWorker->setObjectName("Grafieks Query Chart Data");
    setChartDataWorker->start(QThread::InheritPriority);

}


void QueryModel::slotGenerateRoleNames(const QStringList &tableHeaders, const QMap<int, QStringList> &sqlChartHeader)
{
    this->tableHeaders = tableHeaders;
    this->sqlChartHeader = sqlChartHeader;

    emit headerDataChanged(this->tableHeaders);
    emit chartHeaderChanged(this->sqlChartHeader);
}

void QueryModel::slotSetChartData(bool success)
{
    if(success){
        emit chartDataChanged(setChartDataWorker->getSqlChartData());
    }
}


void QueryModel::receiveFilterQuery(QString &filteredQuery)
{
    // Signal to clear exisitng data in tables (qml)
    emit clearTablePreview();

    // For custom preview count
    this->resetPreviewCount = false;

    this->tmpSql = filteredQuery;
    this->executeQuery(this->tmpSql, true);
}

void QueryModel::generateRoleNames()
{

    GenerateRoleNamesQueryWorker *generateRoleNameWorker = new GenerateRoleNamesQueryWorker(this);
    connect(generateRoleNameWorker, &GenerateRoleNamesQueryWorker::signalGenerateRoleNames, this, &QueryModel::slotGenerateRoleNames, Qt::QueuedConnection);
    connect(generateRoleNameWorker, &GenerateRoleNamesQueryWorker::finished, generateRoleNameWorker, &QObject::deleteLater, Qt::QueuedConnection);
    generateRoleNameWorker->setObjectName("Grafieks Query Rolenames");
    generateRoleNameWorker->start();
}

void QueryModel::executeQuery(QString &query, bool updateChartData)
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
        if(updateChartData == true){
            this->setChartData();
        }

        break;
    }

    case Constants::mysqlOdbcIntType:{
        QSqlDatabase dbMysqlOdbc = QSqlDatabase::database(Constants::mysqlOdbcStrQueryType);
        this->setQuery(query, dbMysqlOdbc);
        if(updateChartData == true){
            this->setChartData();
        }
        break;
    }

    case Constants::sqliteIntType:{
        QSqlDatabase dbSqlite = QSqlDatabase::database(Constants::sqliteStrQueryType);
        this->setQuery(query, dbSqlite);
        if(updateChartData == true)
            this->setChartData();
        break;
    }
    case Constants::postgresIntType:{
        QSqlDatabase dbPostgres = QSqlDatabase::database(Constants::postgresOdbcStrQueryType);
        this->setQuery(query, dbPostgres);
        if(updateChartData == true)
            this->setChartData();
        break;
    }

    case Constants::mssqlIntType:{
        QSqlDatabase dbMssql = QSqlDatabase::database(Constants::mssqlOdbcStrQueryType);
        this->setQuery(query, dbMssql);
        if(updateChartData == true)
            this->setChartData();
        break;
    }

    case Constants::oracleIntType:{
        QSqlDatabase dbOracle = QSqlDatabase::database(Constants::oracleOdbcStrQueryType);
        this->setQuery(query, dbOracle);
        if(updateChartData == true)
            this->setChartData();
        break;
    }

    case Constants::mongoIntType:{
        QSqlDatabase dbMongo = QSqlDatabase::database(Constants::mongoOdbcStrQueryType);
        this->setQuery(query, dbMongo);
        if(updateChartData == true)
            this->setChartData();
        break;
    }

    case Constants::accessIntType:{
        QSqlDatabase dbAccess = QSqlDatabase::database(Constants::accessOdbcStrQueryType);
        this->setQuery(query, dbAccess);
        if(updateChartData == true)
            this->setChartData();
        break;
    }

    }
}
