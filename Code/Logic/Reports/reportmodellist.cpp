#include "reportmodellist.h"

ReportModelList::ReportModelList(QObject *parent) : QObject(parent)
{

}

void ReportModelList::setTmpSql(QString query)
{
    this->mQuerySplitter.setQuery(query);

    // Get Table Names from current query
    QString mainTableName = this->mQuerySplitter.getMainTable();
    QStringList joinTableNames = this->mQuerySplitter.getJoinTables();

    // Insert all Columns for queried tables into Set
    this->getColumnsForTable(mainTableName);
    foreach(QString joinTable, joinTableNames){
        this->getColumnsForTable(joinTable);
    }

    // Record for resulted Column Names
    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:{

        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlStrQueryType);
        QSqlQuery queryResult(query, dbMysql);
        QSqlRecord record = queryResult.record();

//         while(queryResult.next()){
//            int field_idx = queryResult.record().indexOf("email");
//            QString email = queryResult.record().value(field_idx).toString();
//            qDebug() <<email << " Email";
//        }
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
    }

    emit sendFilteredColumn(this->categoryList, this->numericalList, this->dateList);

    this->numericalList.clear();
    this->categoryList.clear();
    this->dateList.clear();
    this->category.clear();
    this->numerical.clear();
    this->date.clear();
}

void ReportModelList::getColumnsForTable(QString tableName)
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
    }
}

void ReportModelList::getData()
{
    QVariantList xAxis;
    QVariantList yAxis;

    QElapsedTimer timer;
    timer.start();

    QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlStrQueryType);
    QString query = "SELECT * FROM test";

    QSqlQuery queryResult(query, dbMysql);

    while(queryResult.next()){

       int field_idx = queryResult.record().indexOf("country");
       QString country = queryResult.record().value(field_idx).toString();
       field_idx = queryResult.record().indexOf("population");
       int population = queryResult.record().value(field_idx).toInt();
       xAxis.append(country);
       yAxis.append(population);
       qDebug() << country << " "  << population;
   }

   emit sendData(xAxis, yAxis);
   qDebug() << timer.elapsed() << " SQL Execution Time in ms ";
}




