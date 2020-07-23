#include "tableschemamodel.h"

TableSchemaModel::TableSchemaModel(QObject *parent) : QObject(parent)
{

}

void TableSchemaModel::showSchema(QString query)
{
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

                // Affected column names in teh query
                QJsonArray affectedColumns = tableData["used_columns"].toArray();

                for(int j = 0; j < affectedColumns.size(); j++){
                    queriedColumnNames << tableData["table_name"].toString() + "." +affectedColumns.at(j).toString();
                }

                // Affected table names in the query
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

                allColumnNames.append(outputDataList);

                outputDataList.clear();
            }
        }



        break; // Mysql Type break
    }

    }

    // Emit the signals here
    // For the slots to received the data
    // in QML (UI)

    emit tableSchemaObtained(allColumnNames, queriedColumnNames);


}
