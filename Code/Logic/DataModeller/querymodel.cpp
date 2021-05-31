#include "querymodel.h"


QueryModel::QueryModel(QObject *parent): QSqlQueryModel(parent), resetPreviewCount(false)
{

}

QueryModel::~QueryModel()
{
}

void QueryModel::setPreviewQuery(int previewRowCount)
{
    // Signal to clear exisitng data in tables (qml)
    emit clearTablePreview();

    int tmpRowCount = 0;
    int maxRowCount = 0;

    tmpRowCount = this->rowCount();
    if(previewRowCount > tmpRowCount){
        maxRowCount = tmpRowCount;
    } else{
        maxRowCount = previewRowCount;
    }

    // For custom preview count
    this->resetPreviewCount = true;

    this->previewRowCount = maxRowCount;
    this->executeQuery(this->tmpSql, false);

    if(this->rowCount() > 0){
        emit sqlHasData(true);
    } else{
        emit sqlHasData(false);
    }
}

void QueryModel::setQuery(const QString &query, const QSqlDatabase &db)
{
    this->removeTmpChartData();

    QSqlQueryModel::setQuery(query, db);

    if(QSqlQueryModel::lastError().type() != QSqlError::NoError)
        qWarning() << Q_FUNC_INFO << QSqlQueryModel::lastError();

    if(this->resetPreviewCount == false)
        this->previewRowCount =  QSqlQueryModel::rowCount();

    generateRoleNames();
}

void QueryModel::setQuery(const QSqlQuery &query)
{

    this->removeTmpChartData();

    QSqlQueryModel::setQuery(query);

    if(QSqlQueryModel::lastError().type() != QSqlError::NoError)
        qWarning() << Q_FUNC_INFO << QSqlQueryModel::lastError();

    if(this->resetPreviewCount == false)
        this->previewRowCount =  QSqlQueryModel::rowCount();

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

int QueryModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return this->previewRowCount;
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

//    QSqlQueryModel::clear();

    emit sqlHasData(false);
//    emit chartDataChanged(this->sqlChartData);
    emit headerDataChanged(this->tableHeaders);
    emit chartHeaderChanged(this->sqlChartHeader);
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

    emit chartDataChanged(this->sqlChartData);
}

void QueryModel::setChartHeader(int index, QStringList colInfo)
{
    this->sqlChartHeader.insert(index, colInfo);
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

    case Constants::excelIntType:{
        QSqlDatabase dbExcel = QSqlDatabase::database(Constants::excelStrQueryType);
        this->setQuery(query, dbExcel);
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

    case Constants::impalaIntType:{
        QSqlDatabase dbImpala = QSqlDatabase::database(Constants::impalaOdbcStrQueryType);
        this->setQuery(query, dbImpala);
        if(updateChartData == true)
            this->setChartData();
        break;
    }

    case Constants::hiveIntType:{
        QSqlDatabase dbHive = QSqlDatabase::database(Constants::hiveOdbcStrQueryType);
        this->setQuery(query, dbHive);
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
