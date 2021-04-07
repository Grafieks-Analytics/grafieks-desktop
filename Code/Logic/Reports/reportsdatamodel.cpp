#include "reportsdatamodel.h"

ReportsDataModel::ReportsDataModel(QObject *parent) : QObject(parent)
{

}

ReportsDataModel::ReportsDataModel(DuckCon *duckCon, QObject *parent)
{
    Q_UNUSED(parent);
    this->duckCon = duckCon;
}

void ReportsDataModel::setTmpSql(QString query)
{
    this->mQuerySplitter.setQuery(query);

    // Get Table Names from current query
    QString mainTableName = this->mQuerySplitter.getMainTable();
    QStringList joinTableNames = this->mQuerySplitter.getJoinTables();
    QStringList columnNames = this->mQuerySplitter.getSelectParams();

    // Insert all Columns for queried tables into Set
    this->getColumnsForTable(mainTableName);
    foreach(QString joinTable, joinTableNames){
        this->getColumnsForTable(joinTable);
    }

    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:
    case Constants::mysqlOdbcIntType:
    case Constants::postgresIntType:
    case Constants::mssqlIntType:
    case Constants::sqliteIntType:{

        QString conString;
        switch (Statics::currentDbIntType) {
        case Constants::mysqlIntType:
            conString = Constants::mysqlStrQueryType;
            break;

        case Constants::mysqlOdbcIntType:
            conString = Constants::mysqlOdbcStrQueryType;
            break;

        case Constants::postgresIntType:
            conString = Constants::postgresOdbcStrType;
            break;

        case Constants::mssqlIntType:
            conString = Constants::mssqlOdbcStrType;
            break;

        case Constants::sqliteIntType:
            conString = Constants::sqliteStrType;
            break;
        }

        QSqlDatabase dbString = QSqlDatabase::database(conString);

        QSqlQuery queryResult(query, dbString);
        QSqlRecord record = queryResult.record();

        for(int i = 0; i < record.count(); i++){

            QString fieldName = record.fieldName(i);
            QString tableName = record.field(i).tableName().toUtf8();
            QString tableFieldName = tableName + "." + fieldName;

            if(this->category.contains(tableFieldName)){
                this->categoryList.append(fieldName);
            }
            else if(this->numerical.contains(tableFieldName)){
                this->numericalList.append(fieldName);
            }
            else if(this->date.contains(tableFieldName)){
                this->dateList.append(fieldName);
            }
        }

        break;
    }

    case Constants::excelIntType:
    case Constants::jsonIntType:
    case Constants::csvIntType:{


        QString db = Statics::currentDbName;

        auto result = this->duckCon->con.Query("DESCRIBE " + db.toStdString());

        int rows = result->collection.Count();

        int i = 0;
        while(i < rows){

            duckdb::Value fieldName = result->GetValue(0, i);
            duckdb::Value fieldType = result->GetValue(1, i);

            // string to qstring conversion
            QString newFieldName = QString::fromStdString(fieldName.ToString());
            QString newFilterType = QString::fromStdString(fieldType.ToString());
            QString filterDataType = dataType.dataType(QString::fromStdString(fieldType.ToString()));


            if(filterDataType == Constants::categoricalType){
                this->categoryList.append(newFieldName);
            } else if(filterDataType == Constants::numericalType){
                this->numericalList.append(newFieldName);
            } else if(filterDataType == Constants::dateType){
                this->dateList.append(newFieldName);
            }

            i++;
        }

        break;
    }
    }

    emit sendFilteredColumn(this->categoryList, this->numericalList, this->dateList);

    this->numericalList.clear();
    this->categoryList.clear();
    this->dateList.clear();
    this->category.clear();
    this->numerical.clear();
    this->date.clear();
}

void ReportsDataModel::getColumnsForTable(QString tableName)
{
    QString describeQueryString, fieldName, fieldType;
    QStringList outputDataList;
    QString conString;

    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:
    case Constants::mysqlOdbcIntType:
    case Constants::postgresIntType:
    case Constants::mssqlIntType:
    case Constants::sqliteIntType:{

        switch (Statics::currentDbIntType) {

        case Constants::mysqlIntType:
            conString = Constants::mysqlStrQueryType;
            describeQueryString = "DESCRIBE `" + tableName + "`";
            break;

        case Constants::mysqlOdbcIntType:
            conString = Constants::mysqlOdbcStrQueryType;
            describeQueryString = "DESCRIBE `" + tableName + "`";
            break;

        case Constants::postgresIntType:
            conString = Constants::postgresOdbcStrType;
            describeQueryString = "SELECT column_name, data_type FROM information_schema.columns WHERE\n"
                                  " table_name = '" + tableName  + "'";
            break;

        case Constants::mssqlIntType:
            conString = Constants::mssqlOdbcStrType;
            describeQueryString = "SELECT column_name, data_type FROM information_schema.columns where table_name = '" + tableName  + "'";
            break;

        case Constants::sqliteIntType:
            conString = Constants::sqliteStrType;
            describeQueryString = "PRAGMA table_info(" + tableName + ")";
            break;
        }


        QSqlDatabase dbString = QSqlDatabase::database(conString);


        QSqlQuery describeQuery(describeQueryString, dbString);

        while(describeQuery.next()){

            if(Statics::currentDbIntType == Constants::sqliteIntType){
                fieldName = describeQuery.value(1).toString();
                fieldType = describeQuery.value(2).toString();
            } else{
                fieldName = describeQuery.value(0).toString();
                fieldType = describeQuery.value(1).toString();
            }

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

        break;
    }

    }
}
