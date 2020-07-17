#include "tableschemamodel.h"

TableSchemaModel::TableSchemaModel(QObject *parent) : QObject(parent)
{

}

QList<QStringList> TableSchemaModel::showSchema(QString query)
{
    QString bingo = "bingo";

    QString explainQueryString, describeQueryString;
    QStringList tableList, outputDataList;


    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:{

        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlStrType);

        // Determine the list of table names
        // from the last query

        explainQueryString = "EXPLAIN FORMAT = JSON "+ query;

        QSqlQuery explainQuery(explainQueryString, dbMysql);

        explainQuery.first();

        QJsonDocument jsonQuery = QJsonDocument::fromJson(explainQuery.value(0).toString().toUtf8());
        QJsonObject objQuery = jsonQuery.object();

        QJsonObject statusObj = objQuery["query_block"].toObject();
        QJsonArray tablesListArray = statusObj["nested_loop"].toArray();

        if(tablesListArray.size() > 0){
            for(int i = 0; i< tablesListArray.size(); i++){
                QJsonObject table = tablesListArray.at(i).toObject();
                QJsonObject tableData = table["table"].toObject();
                tableList << tableData["table_name"].toString();
            }
        } else{
            QJsonObject tableData = statusObj["table"].toObject();
            tableList << tableData["table_name"].toString();
        }

        // Determine the Table structure

        for(QString tableName: tableList){
            describeQueryString = "DESCRIBE " + tableName;

            QSqlQuery describeQuery(describeQueryString, dbMysql);

            while(describeQuery.next()){

                QString fieldName = describeQuery.value(0).toString();
                QString fieldType = describeQuery.value(1).toString();
                outputDataList << tableName << fieldName << fieldType;

                outputData.append(outputDataList);
            }
        }




        break; // Mysql Type break
    }

    }


    return outputData;

}
