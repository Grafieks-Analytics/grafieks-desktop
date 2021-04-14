#include "querymodel.h"


QueryModel::QueryModel(QObject *parent): QSqlQueryModel(parent)
{

}

QueryModel::~QueryModel()
{
    this->sqlChartData.clear();
    this->sqlChartHeader.clear();

    QSqlQueryModel::clear();
}

void QueryModel::setQuery(const QString &query, const QSqlDatabase &db)
{

    QSqlQueryModel::setQuery(query, db);
    if(QSqlQueryModel::lastError().type() != QSqlError::NoError)
        qWarning() << QSqlQueryModel::lastError();

    generateRoleNames();
}

void QueryModel::setQuery(const QSqlQuery &query)
{

    QSqlQueryModel::setQuery(query);
    if(QSqlQueryModel::lastError().type() != QSqlError::NoError)
        qWarning() << QSqlQueryModel::lastError();

    generateRoleNames();
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
    QString simpliFiedSql = tmpSql.simplified();
    this->executeQuery(simpliFiedSql);
}

void QueryModel::removeTmpChartData()
{
    this->~QueryModel();
}

void QueryModel::setChartData()
{
    int totalCols = this->columnCount();
    int totalRows = this->rowCount();

    for(int j = 0; j < totalRows; j++){
        for(int i = 0; i < totalCols; i++){

            if(j == 0){
                this->sqlChartData[i] = new QStringList(record(0).field(i).value().toString());
            } else{
                this->sqlChartData.value(i)->append(record(j).field(i).value().toString());
                this->sqlChartData[i] = sqlChartData.value(i);
            }
        }
    }

    if(totalRows > 0){
        emit sqlHasData(true);
    } else{
        emit sqlHasData(false);
    }

    emit chartDataChanged(this->sqlChartData);
}

void QueryModel::setChartHeader(int index, QStringList colInfo)
{
    this->sqlChartHeader.insert(index, colInfo);
}


void QueryModel::receiveFilterQuery(QString &filteredQuery)
{
    this->executeQuery(filteredQuery);
}

void QueryModel::generateRoleNames()
{

    QStringList colInfo;
    QVariant fieldType;
    DataType dataType;

    m_roleNames.clear();
    this->tableHeaders.clear();

    for( int i = 0; i < record().count(); i ++) {

        m_roleNames.insert(Qt::UserRole + i + 1, record().fieldName(i).toUtf8());
        fieldType = record().field(i).value();
        colInfo << record().fieldName(i) << dataType.dataType(fieldType.typeName())  << record().field(i).tableName();

        this->setChartHeader(i, colInfo);
        this->tableHeaders.append(record().fieldName(i));
        colInfo.clear();
    }

    emit headerDataChanged(this->tableHeaders);
    emit chartHeaderChanged(this->sqlChartHeader);
}

void QueryModel::executeQuery(QString &query)
{

    // For Databases which only allow Forward Only queries
    // Look into ForwardOnlyQueryModel, ForwardOnlyDataModel
    // SnowFlake
    // Redshift

    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:{
        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlStrQueryType);
        this->setQuery(query, dbMysql);
        this->setChartData();
        break;
    }

    case Constants::mysqlOdbcIntType:{
        QSqlDatabase dbMysqlOdbc = QSqlDatabase::database(Constants::mysqlOdbcStrQueryType);
        this->setQuery(query, dbMysqlOdbc);
        this->setChartData();
        break;
    }

    case Constants::sqliteIntType:{
        QSqlDatabase dbSqlite = QSqlDatabase::database(Constants::sqliteStrQueryType);
        this->setQuery(query, dbSqlite);
        this->setChartData();
        break;
    }
    case Constants::postgresIntType:{
        QSqlDatabase dbPostgres = QSqlDatabase::database(Constants::postgresOdbcStrQueryType);
        this->setQuery(query, dbPostgres);
        this->setChartData();
        break;
    }

    case Constants::redshiftIntType:{
        QSqlDatabase dbRedshift = QSqlDatabase::database(Constants::redshiftOdbcStrQueryType);
        this->setQuery(query, dbRedshift);
        this->setChartData();
        break;
    }

    case Constants::excelIntType:{
        QSqlDatabase dbExcel = QSqlDatabase::database(Constants::excelStrQueryType);
        this->setQuery(query, dbExcel);
        this->setChartData();
        break;
    }
    case Constants::mssqlIntType:{
        QSqlDatabase dbMssql = QSqlDatabase::database(Constants::mssqlOdbcStrQueryType);
        this->setQuery(query, dbMssql);
        this->setChartData();
        break;
    }

    case Constants::oracleIntType:{
        QSqlDatabase dbOracle = QSqlDatabase::database(Constants::oracleOdbcStrQueryType);
        this->setQuery(query, dbOracle);
        this->setChartData();
        break;
    }

    case Constants::mongoIntType:{
        QSqlDatabase dbMongo = QSqlDatabase::database(Constants::mongoOdbcStrQueryType);
        this->setQuery(query, dbMongo);
        this->setChartData();
        break;
    }

    case Constants::impalaIntType:{
        QSqlDatabase dbImpala = QSqlDatabase::database(Constants::impalaOdbcStrQueryType);
        this->setQuery(query, dbImpala);
        this->setChartData();
        break;
    }

    case Constants::hiveIntType:{
        QSqlDatabase dbHive = QSqlDatabase::database(Constants::hiveOdbcStrQueryType);
        this->setQuery(query, dbHive);

        break;
    }

    case Constants::teradataIntType:{
        QSqlDatabase dbTeradata = QSqlDatabase::database(Constants::teradataOdbcStrQueryType);
        this->setQuery(query, dbTeradata);
        this->setChartData();
        break;
    }

    case Constants::accessIntType:{
        QSqlDatabase dbAccess = QSqlDatabase::database(Constants::accessOdbcStrQueryType);
        this->setQuery(query, dbAccess);
        this->setChartData();
        break;
    }

    }
}
