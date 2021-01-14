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
    QStringList columnNames = this->mQuerySplitter.getSelectParams();
    qDebug() << columnNames << "Just Query";
    qDebug() << mainTableName << " Main Table ";
    // Insert all Columns for queried tables into Set
    this->getColumnsForTable(mainTableName);
    foreach(QString joinTable, joinTableNames){
        this->getColumnsForTable(joinTable);
    }

    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:{

        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlOdbcStrQueryType);
        QSqlQuery queryResult(query, dbMysql);
        QSqlRecord record = queryResult.record();
        qDebug() << queryResult.record();
        qDebug() << queryResult.lastError().databaseText();

        //         while(queryResult.next()){
        //            int field_idx = queryResult.record().indexOf("email");
        //            QString email = queryResult.record().value(field_idx).toString();
        //            qDebug() <<email << " Email";
        //        }
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

        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::postgresOdbcStrType);

        QSqlQuery queryResult(query, dbMysql);
        QSqlRecord record = queryResult.record();
        qDebug() << queryResult.record();
        qDebug() << queryResult.lastError().databaseText();

        //         while(queryResult.next()){
        //            int field_idx = queryResult.record().indexOf("email");
        //            QString email = queryResult.record().value(field_idx).toString();
        //            qDebug() <<email << " Email";
        //        }
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

    }
}

void ReportModelList::getData()
{
    QVariantList xAxis;
    QVariantList yAxis;

    QElapsedTimer timer;
    QElapsedTimer timer2;
    timer2.start();
    timer.start();

    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:{
        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlOdbcStrQueryType);
        QString query = "SELECT date, volume FROM testnew";

        QSqlQuery queryResult(query, dbMysql);
        qDebug() << timer2.elapsed() << "Before ";

        bool flag = true;
        qDebug() << queryResult.size() << " Size ";
        int field_idx = queryResult.record().indexOf("date");
        int id = queryResult.record().indexOf("volume");
        while(queryResult.next()){


            //int field_idx = queryResult.record().indexOf("date");
            //int field_idx = queryResult.record().indexOf("date");

            QString date = queryResult.record().value(field_idx).toString();
            //field_idx = queryResult.record().indexOf("volume");

            int open = queryResult.record().value(id).toInt();

            xAxis.append(date);
            yAxis.append(open);

            if(flag)
            {
                qDebug() << date << " "  << open;
                flag = 0;
            }

        }

        //emit sendData(xAxis, yAxis);
        qDebug() << timer.elapsed() << " SQL Execution Time in ms ";
        //emit sendData(xAxis, yAxis);
    }
    }
}




