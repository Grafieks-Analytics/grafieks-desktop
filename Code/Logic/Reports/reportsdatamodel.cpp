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

    case Constants::mysqlIntType:{

        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlStrQueryType);
        QSqlQuery queryResult(query, dbMysql);
        QSqlRecord record = queryResult.record();
        qDebug() << queryResult.record();
        qDebug() << queryResult.lastError().databaseText();

        for(int i = 0; i < record.count(); i++){

            QString fieldName = record.fieldName(i);
            QString tableName = record.field(i).tableName();
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
    case Constants::mysqlOdbcIntType:{

        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlOdbcStrQueryType);
        QSqlQuery queryResult(query, dbMysql);
        QSqlRecord record = queryResult.record();
        qDebug() << queryResult.record();
        qDebug() << queryResult.lastError().databaseText();

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
    case Constants::postgresIntType:{

        QSqlDatabase dbPostgres = QSqlDatabase::database(Constants::postgresOdbcStrType);

        QSqlQuery queryResult(query, dbPostgres);
        QSqlRecord record = queryResult.record();
        qDebug() << queryResult.record();
        qDebug() << queryResult.lastError().databaseText();

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

    case Constants::mssqlIntType:{

        QSqlDatabase dbMssql = QSqlDatabase::database(Constants::mssqlOdbcStrType);

        QSqlQuery queryResult(query, dbMssql);
        QSqlRecord record = queryResult.record();
        qDebug() << queryResult.record();
        qDebug() << queryResult.lastError().databaseText();

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

    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:{

        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlStrQueryType);

        describeQueryString = "DESCRIBE `" + tableName + "`";

        QSqlQuery describeQuery(describeQueryString, dbMysql);

        while(describeQuery.next()){

            fieldName = describeQuery.value(0).toString();
            fieldType = describeQuery.value(1).toString();

            // Remove characters after `(` and then trim whitespaces
            QString fieldTypeTrimmed = fieldType.mid(0, fieldType.indexOf("(")).trimmed();

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

    case Constants::mysqlOdbcIntType:{

        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlOdbcStrQueryType);

        describeQueryString = "DESCRIBE `" + tableName + "`";

        QSqlQuery describeQuery(describeQueryString, dbMysql);

        while(describeQuery.next()){

            fieldName = describeQuery.value(0).toString();
            fieldType = describeQuery.value(1).toString();

            // Remove characters after `(` and then trim whitespaces
            QString fieldTypeTrimmed = fieldType.mid(0, fieldType.indexOf("(")).trimmed();

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
    case Constants::postgresIntType:{

        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::postgresOdbcStrType);


        describeQueryString = "SELECT column_name, data_type FROM information_schema.columns WHERE\n"
                              " table_name = '" + tableName  + "'";

        QSqlQuery describeQuery(describeQueryString, dbMysql);

        while(describeQuery.next()){

            fieldName = describeQuery.value(0).toString();
            fieldType = describeQuery.value(1).toString();
            qDebug() << fieldName << " " << fieldType << "Postgres";
            // Remove characters after `(` and then trim whitespaces
            QString fieldTypeTrimmed = fieldType.mid(0, fieldType.indexOf("(")).trimmed();

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

    case Constants::mssqlIntType:{

        QSqlDatabase dbMssql = QSqlDatabase::database(Constants::mssqlOdbcStrType);

        describeQueryString = "SELECT column_name, data_type FROM information_schema.columns where table_name = '" + tableName  + "'";

        QSqlQuery describeQuery(describeQueryString, dbMssql);

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

        break;
    }

    }
}
