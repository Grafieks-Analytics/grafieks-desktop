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

                // Remove characters after `(` and then trim whitespaces
                QString fieldTypeTrimmed = fieldType.mid(0, fieldType.indexOf("(")).trimmed();

                // Get filter data type for QML
                QString filterDataType = this->dataType(fieldTypeTrimmed);

                outputDataList << tableName << fieldName << fieldType << filterDataType;

                // Output data according to Filter type

                if(filterDataType == Constants::categoricalType){
                    allCategorical.append(outputDataList);
                } else if(filterDataType == Constants::numericalType){
                    allNumerical.append(outputDataList);
                } else if(filterDataType == Constants::dateType){
                    allDates.append(outputDataList);
                } else{
                    allOthers.append(outputDataList);
                }

                // Clear Stringlist for future
                outputDataList.clear();
            }
        }



        break; // Mysql Type break
    }

    }

    // Emit the signals here
    // For the slots to received the data
    // in QML (UI)

    emit tableSchemaObtained(allCategorical, allNumerical, allDates, allOthers, queriedColumnNames);


}

QString TableSchemaModel::dataType(QString parameter)
{

    QString output;
    QStringList categorical, numerical, dateformat;

    categorical << "varchar" << "char" << "text" << "tinytext" << "mediumtext" << "longtext" << "boolean" ;
    numerical << "int" << "tinyint" << "smallint" << "mediumint" << "bigint" << "decimal" << "float" << "double" << "real";
    dateformat << "date" << "datetime" << "timestamp" << "time" << "year";

    // Match the incoming parameter and determine filter type

    if(categorical.contains(parameter, Qt::CaseInsensitive)){
        output =  Constants::categoricalType;
    } else if(numerical.contains(parameter, Qt::CaseInsensitive)){
        output =  Constants::numericalType;
    } else if(dateformat.contains(parameter, Qt::CaseInsensitive)){
        output =  Constants::dateType;
    } else{
        output =  Constants::otherType;
    }

    return output;

}
