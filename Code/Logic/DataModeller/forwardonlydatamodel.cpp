#include "forwardonlydatamodel.h"

ForwardOnlyDataModel::ForwardOnlyDataModel(QObject *parent) : QObject(parent)
{

}

ForwardOnlyDataModel::~ForwardOnlyDataModel()
{
    this->allColumns.clear();
    this->colData.clear();
}

void ForwardOnlyDataModel::columnData(QString col, QString tableName, QString searchString)
{

    QString conType;
    QString queryString;
    switch (Statics::currentDbIntType) {

    case Constants::redshiftIntType:
        conType = Constants::redshiftOdbcStrType;
        if (searchString != ""){
            queryString = "SELECT " + col + " FROM "+ tableName + " WHERE " + col + " LIKE '%"+searchString+"%'";
        } else{
            queryString = "SELECT " + col + " FROM "+ tableName;
        }
        queryString = "";
        break;

    case Constants::snowflakeIntType:
        conType = Constants::snowflakeOdbcStrType;
        if (searchString != ""){
            queryString = "SELECT " + col + " FROM "+ tableName + " WHERE " + col + " LIKE '%"+searchString+"%'";
        } else{
            queryString = "SELECT " + col + " FROM "+ tableName;
        }
        queryString = "";
        break;

    }
    QSqlDatabase forwardOnlyDb = QSqlDatabase::database(conType);
    QSqlQuery query(queryString, forwardOnlyDb);

    if(query.lastError().type() == QSqlError::NoError){
        int i = 0;
        while(query.next()){
            qDebug() << query.value(i);
            i++;
        }
    } else{
        qWarning() << Q_FUNC_INFO << query.lastError();
    }
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

    }
    QSqlDatabase forwardOnlyDb = QSqlDatabase::database(conType);
    QSqlQuery describeQuery(queryString, forwardOnlyDb);

    if(describeQuery.lastError().type() == QSqlError::NoError){
        while(describeQuery.next()){

            fieldName = describeQuery.value(0).toString();
            fieldType = describeQuery.value(1).toString();


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

    return output;
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

void ForwardOnlyDataModel::receiveCsvFilterQuery(QString query)
{

}
