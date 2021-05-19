#include "forwardonlydatamodel.h"

ForwardOnlyDataModel::ForwardOnlyDataModel(QObject *parent) : QObject(parent)
{

}

void ForwardOnlyDataModel::clearData()
{
    this->allColumns.clear();
    this->colData.clear();
    this->tables.clear();
}

ForwardOnlyDataModel::~ForwardOnlyDataModel()
{

}

void ForwardOnlyDataModel::columnData(QString col, QString tableName, QString options)
{
    QStringList output;
    output = this->getData("SELECT DISTINCT " + col + " FROM "+ tableName);
    emit columnListModelDataChanged(output, options);
}

void ForwardOnlyDataModel::columnSearchData(QString col, QString tableName, QString searchString, QString options)
{
    QStringList output;
    output = this->getData("SELECT DISTINCT " + col + " FROM "+ tableName + " WHERE " + col + " LIKE '%"+searchString+"%'");
    emit columnListModelDataChanged(output, options);
}

QStringList ForwardOnlyDataModel::getColumnList(QString tableName, QString moduleName, QString searchString)
{

    QString conType;
    QString queryString;
    QString fieldName;
    QString fieldType;
    QStringList output;

    switch (Statics::currentDbIntType) {

    case Constants::redshiftIntType:
        conType = Constants::redshiftOdbcStrType;
        queryString = "select \"column\", type from pg_table_def where tablename = '" + tableName  + "'";
        break;

    case Constants::snowflakeIntType:
        conType = Constants::snowflakeOdbcStrType;
        queryString = "DESC TABLE " + tableName;
        break;

    case Constants::teradataIntType:
        conType = Constants::teradataOdbcStrType;
        tableName.remove("\"" + Statics::currentDbName + "\".");
        tableName.remove(Statics::currentDbName + ".");
        tableName.remove("\"");
        queryString = "SELECT ColumnName, ColumnType FROM DBC.Columns WHERE DatabaseName = '" + Statics::currentDbName + "' AND TableName = '" + tableName + "'";
        break;
    }
    QSqlDatabase forwardOnlyDb = QSqlDatabase::database(conType);
    QSqlQuery describeQuery(queryString, forwardOnlyDb);

    if(describeQuery.lastError().type() == QSqlError::NoError){
        while(describeQuery.next()){

            fieldName = describeQuery.value(0).toString().trimmed();
            fieldType = describeQuery.value(1).toString().trimmed();


            // Remove characters after `(` and then trim whitespaces
            QString fieldTypeTrimmed = fieldType.mid(0, fieldType.indexOf("(")).trimmed();
            qDebug() << "fieldTypeTrimmed" <<fieldTypeTrimmed << fieldName << fieldType;

            // Get filter data type for QML
            QString filterDataType = dataType.dataType(fieldTypeTrimmed);

            if(filterDataType == Constants::categoricalType){
                this->category.insert(tableName + "." + fieldName);
            } else if(filterDataType == Constants::numericalType){
                this->numerical.insert(tableName + "." + fieldName);
            } else if(filterDataType == Constants::dateType){
                this->date.insert(tableName + "." + fieldName);
            }
        }
    } else{
        qWarning() << Q_FUNC_INFO << describeQuery.lastError();
    }

    return output;
}

QStringList ForwardOnlyDataModel::getTableList()
{
    QStringList output;

    QString conType;
    QString queryString;

    switch (Statics::currentDbIntType) {

    case Constants::redshiftIntType:
        conType = Constants::redshiftOdbcStrType;
        queryString = "SELECT DISTINCT tablename FROM pg_table_def WHERE schemaname = 'public'";
        break;

    case Constants::snowflakeIntType:
        conType = Constants::snowflakeOdbcStrType;
        queryString = "SHOW TABLES";
        break;

    case Constants::teradataIntType:
        conType = Constants::teradataOdbcStrType;
        queryString = "SELECT TableName FROM DBC.TablesV WHERE TableKind = 'T' and DatabaseName = '" + Statics::currentDbName + "'";
        break;

    }
    QSqlDatabase forwardOnlyDb = QSqlDatabase::database(conType);
    QSqlQuery tableQuery(queryString, forwardOnlyDb);

    if(tableQuery.lastError().type() == QSqlError::NoError){

        while(tableQuery.next()){
            if(Statics::currentDbIntType == Constants::snowflakeIntType){
                output << tableQuery.value(1).toString();
            } else{
                output << tableQuery.value(0).toString();
            }

        }
    } else{
        qWarning() << Q_FUNC_INFO << tableQuery.lastError();
    }

    this->tables = output;
    return this->tables;
}

QStringList ForwardOnlyDataModel::filterTableList(QString keyword)
{
    return this->tables.filter(keyword);
}

QStringList ForwardOnlyDataModel::getDbList()
{
    QStringList output;

    QString conType;
    QString queryString;

    switch (Statics::currentDbIntType) {

    case Constants::redshiftIntType:
        conType = Constants::redshiftOdbcStrType;
        queryString = "SELECT * FROM pg_database";
        break;

    case Constants::snowflakeIntType:
        conType = Constants::snowflakeOdbcStrType;
        queryString = "SHOW DATABASES";
        break;

    case Constants::teradataIntType:
        conType = Constants::teradataOdbcStrType;
        queryString = "SELECT  DatabaseName FROM DBC.TablesV WHERE TableKind = 'T' AND DatabaseName NOT IN ('All', 'DBC', 'Crashdumps', 'dbcmngr', 'Default', 'External_AP', 'EXTUSER', 'LockLogShredder', 'PUBLIC', 'SQLJ', 'Sys_Calendar', 'SysAdmin', 'SYSBAR', 'SYSJDBC', 'SYSLIB', 'SYSSPATIAL', 'SystemFe', 'SYSUDTLIB', 'SYSUIF', 'TD_SERVER_DB', 'TD_SYSFNLIB', 'TD_SYSGPL', 'TD_SYSXML', 'TDMaps', 'TDPUSER', 'TDQCD', 'TDStats', 'tdwm')";
        break;

    }
    QSqlDatabase forwardOnlyDb = QSqlDatabase::database(conType);
    QSqlQuery tableQuery(queryString, forwardOnlyDb);

    if(tableQuery.lastError().type() == QSqlError::NoError){
        while(tableQuery.next()){
            output << tableQuery.value(0).toString();
        }
    } else{
        qWarning() << Q_FUNC_INFO << tableQuery.lastError();
    }

    return output;
}

QStringList ForwardOnlyDataModel::getData(QString queryString)
{

    QString conType;
    QStringList out;
    switch (Statics::currentDbIntType) {

    case Constants::redshiftIntType:
        conType = Constants::redshiftOdbcStrType;
        break;

    case Constants::snowflakeIntType:
        conType = Constants::snowflakeOdbcStrType;
        break;

    case Constants::teradataIntType:
        conType = Constants::teradataOdbcStrType;
        break;

    }

    QSqlDatabase forwardOnlyDb = QSqlDatabase::database(conType);
    QSqlQuery query(queryString, forwardOnlyDb);


    if(query.lastError().type() == QSqlError::NoError){
        while(query.next()){
            this->colData.append(query.value(0).toString());
        }
    } else{
        qWarning() << Q_FUNC_INFO << query.lastError();
    }

    out = this->colData;
    emit forwardColData(this->colData);
    this->colData.clear();
    return out;
}
