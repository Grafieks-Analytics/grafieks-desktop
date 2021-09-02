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

void QueryModel::saveExtractData()
{
    QString extractPath = Statics::extractPath;
    QString tableName = Statics::currentDbName;
    duckdb::DuckDB db(extractPath.toStdString());
    duckdb::Connection con(db);

    QStringList colInfo;
    QVariant fieldType;
    DataType dataType;

    QStringList tableHeaders;
    QMap<int, QStringList> sqlChartHeader;
    QHash<int, QByteArray> roleNames;
    QSqlDatabase connection;

    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:{
        connection = QSqlDatabase::database(Constants::mysqlStrQueryType);
        break;
    }

    case Constants::mysqlOdbcIntType:{
        connection = QSqlDatabase::database(Constants::mysqlOdbcStrQueryType);
        break;
    }

    case Constants::sqliteIntType:{
        connection = QSqlDatabase::database(Constants::sqliteStrQueryType);
        break;
    }
    case Constants::postgresIntType:{
        connection = QSqlDatabase::database(Constants::postgresOdbcStrQueryType);
        break;
    }

    case Constants::mssqlIntType:{
        connection = QSqlDatabase::database(Constants::mssqlOdbcStrQueryType);
        break;
    }

    case Constants::oracleIntType:{
        connection = QSqlDatabase::database(Constants::oracleOdbcStrQueryType);
        break;
    }

    case Constants::mongoIntType:{
        connection = QSqlDatabase::database(Constants::mongoOdbcStrQueryType);
        break;
    }

    case Constants::accessIntType:{
        connection = QSqlDatabase::database(Constants::accessOdbcStrQueryType);
        break;
    }

    }

    QSqlQuery query(this->tmpSql, connection);
    QSqlRecord record = query.record();

    QString createTableQuery = "CREATE TABLE " + tableName + "(";

    for(int i = 0; i < record.count(); i++){
        QVariant fieldType = record.field(i).value();
        QString type = dataType.qVariantType(fieldType.typeName());

        QString checkFieldName = record.field(i).tableName() + "." + record.fieldName(i);
        if(Statics::changedHeaderTypes.value(checkFieldName).toString() != ""){
            type = Statics::changedHeaderTypes.value(checkFieldName).toString();

            if(type == Constants::categoricalType){
                type = "VARCHAR";
            } else if(type == Constants::numericalType){
                type = "INTEGER";
            } else {
                type = "TIMESTAMP";
            }
        }

        createTableQuery += "\"" + record.fieldName(i) + "\" " + type + ",";
        this->columnStringTypes.append(type);
    }

    createTableQuery.chop(1);
    createTableQuery += ")";
    qDebug() << createTableQuery;

    auto createT = con.Query(createTableQuery.toStdString());
    if(!createT->success) qDebug() <<Q_FUNC_INFO << "ERROR CREATE EXTRACT" << createT->error.c_str();

    duckdb::Appender appender(con, tableName.toStdString());


    while(query.next()){
        appender.BeginRow();
        for(int i = 0; i < record.count(); i++){
            QString columnType = this->columnStringTypes.at(i);

            if(columnType == "INTEGER"){
                appender.Append(query.value(i).toInt());
            } else if(columnType == "BIGINT"){
                appender.Append(query.value(i).toDouble());
            }  else if(columnType == "FLOAT") {
                appender.Append(query.value(i).toFloat());
            } else if(columnType == "DOUBLE") {
                appender.Append(query.value(i).toDouble());
            } else if(columnType == "DATE"){
                QDate date = query.value(i).toDate();
                int32_t year = date.year();
                int32_t month = date.month();
                int32_t day = date.day();
                appender.Append(duckdb::Date::FromDate(year, month, day));
            } else if(columnType == "TIMESTAMP"){
                QDate date = query.value(i).toDate();
                QTime time = query.value(i).toDateTime().time();
                int32_t year = date.year();
                int32_t month = date.month();
                int32_t day = date.day();
                appender.Append(duckdb::Timestamp::FromDatetime(duckdb::Date::FromDate(year, month, day), duckdb::Time::FromTime(time.hour(), time.minute(), time.second(), 0)));
            }else {
                appender.Append(query.value(i).toString().toUtf8().constData());
            }


        }
        appender.EndRow();
    }
    appender.Close();

    emit generateReports(&con);
    emit showSaveExtractWaitPopup();

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
