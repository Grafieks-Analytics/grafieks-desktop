#include "tableschemamodel.h"
#include "iostream"
TableSchemaModel::TableSchemaModel(QObject *parent) : QObject(parent)
{

}

TableSchemaModel::TableSchemaModel(DuckCon *duckCon, QObject *parent)
{
    Q_UNUSED(parent);
    this->duckCon = duckCon;
}

/*!
 * \brief Accepts an SQL query parameter and emits a signal with list of information of individual column
 * \details Each signal object contains a list of  <b>tableName, fieldName,  fieldType, filterDataType</b>
 * \code
 * emit tableSchemaObtained(QList <QStringList> allList, QList <QStringList> allCategorical, QList <QStringList> allNumerical, QList <QStringList> allDates, QList <QStringList> allOthers,QStringList queriedColumnNames);
 * \endcode
 *
 */
void TableSchemaModel::showSchema(QString query)
{

    QString explainQueryString, describeQueryString;
    QStringList tableList, outputDataList;


    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:{

        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlStrQueryType);

        // Reset Mysql Profiling so that it doesn't log the query stats
        // Then in the end of this case, Set it back again in the end
        // We donot want to show "EXPLAIN" & "DESCRIBE" output
        // in Test Query Tab

        QSqlQuery profilingUnsetQuery("SET profiling = 0", dbMysql);
        QSqlQuery profilingSetQuery("SET profiling = 1", dbMysql);

        profilingUnsetQuery.exec();

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
                    queriedColumnNames << affectedColumns.at(j).toString();
                }

                // Affected table names in the query
                tableList << tableData["table_name"].toString();

            }
        } else{
            QJsonObject tableData = statusObj["table"].toObject();

            // Affected column names in teh query
            QJsonArray affectedColumns = tableData["used_columns"].toArray();

            for(int j = 0; j < affectedColumns.size(); j++){
                queriedColumnNames << affectedColumns.at(j).toString();
            }

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
                QString filterDataType = dataType.dataType(fieldTypeTrimmed);

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

                // Append all data type to allList as well
                allList.append(outputDataList);

                // Clear Stringlist for future
                outputDataList.clear();
            }
        }

        // Set mysql profiling back again
        profilingSetQuery.exec();



        break; // Mysql Type break
    }

    case Constants::mysqlOdbcIntType:{

        QSqlDatabase dbMysqlOdbc = QSqlDatabase::database(Constants::mysqlOdbcStrQueryType);

        // Reset Mysql Profiling so that it doesn't log the query stats
        // Then in the end of this case, Set it back again in the end
        // We donot want to show "EXPLAIN" & "DESCRIBE" output
        // in Test Query Tab

        QSqlQuery profilingUnsetQuery("SET profiling = 0", dbMysqlOdbc);
        QSqlQuery profilingSetQuery("SET profiling = 1", dbMysqlOdbc);

        profilingUnsetQuery.exec();

        // Determine the list of table names
        // from the last query

        explainQueryString = "EXPLAIN FORMAT = JSON "+ query;
        QSqlQuery explainQuery(explainQueryString, dbMysqlOdbc);


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
                    queriedColumnNames << affectedColumns.at(j).toString();
                }

                // Affected table names in the query
                tableList << tableData["table_name"].toString();

            }
        } else{
            QJsonObject tableData = statusObj["table"].toObject();

            // Affected column names in teh query
            QJsonArray affectedColumns = tableData["used_columns"].toArray();

            for(int j = 0; j < affectedColumns.size(); j++){
                queriedColumnNames << affectedColumns.at(j).toString();
            }

            tableList << tableData["table_name"].toString();

        }



        // Determine the Table structure

        for(QString tableName: tableList){
            describeQueryString = "DESCRIBE " + tableName;

            QSqlQuery describeQuery(describeQueryString, dbMysqlOdbc);

            while(describeQuery.next()){

                QString fieldName = describeQuery.value(0).toString();
                QString fieldType = describeQuery.value(1).toString();

                // Remove characters after `(` and then trim whitespaces
                QString fieldTypeTrimmed = fieldType.mid(0, fieldType.indexOf("(")).trimmed();

                // Get filter data type for QML
                QString filterDataType = dataType.dataType(fieldTypeTrimmed);

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

                // Append all data type to allList as well
                allList.append(outputDataList);

                // Clear Stringlist for future
                outputDataList.clear();
            }
        }

        // Set mysql profiling back again
        profilingSetQuery.exec();



        break; // Mysql Type break
    }


    case Constants::sqliteIntType:{

        QSqlDatabase dbSqlite = QSqlDatabase::database(Constants::sqliteStrQueryType);

        querySplitter.setQueryForClasses(query);
        QStringList tablesList = querySplitter.getJoinTables();
        QString mainTable = querySplitter.getMainTable();
        tablesList.push_back(mainTable);



        for(QString tableName: tablesList){
            describeQueryString = "PRAGMA table_info(" + tableName + ")";

            QSqlQuery describeQuery(describeQueryString, dbSqlite);
            QSqlRecord rec = describeQuery.record();

            while(describeQuery.next()){


                QString fieldName = describeQuery.value(1).toString();
                QString fieldType = describeQuery.value(2).toString();

                // Remove characters after `(` and then trim whitespaces
                QString fieldTypeTrimmed = fieldType.mid(0, fieldType.indexOf("(")).trimmed();

                // Get filter data type for QML
                QString filterDataType = dataType.dataType(fieldTypeTrimmed);

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

                // Append all data type to allList as well
                allList.append(outputDataList);

                // Clear Stringlist for future
                outputDataList.clear();
            }
        }

        break; // Sqlite Type Break
    }

    case Constants::postgresIntType:{

        QSqlDatabase dbPostgres = QSqlDatabase::database(Constants::postgresOdbcStrQueryType);

        querySplitter.setQueryForClasses(query);
        QStringList tablesList = querySplitter.getJoinTables();
        QString mainTable = querySplitter.getMainTable();
        tablesList.push_back(mainTable);



        for(QString tableName: tablesList){
            describeQueryString = "SELECT column_name, data_type FROM information_schema.columns WHERE table_name = '" + tableName.toLower() + "'";

            QSqlQuery describeQuery(describeQueryString, dbPostgres);
            QSqlRecord rec = describeQuery.record();

            while(describeQuery.next()){


                QString fieldName = describeQuery.value(0).toString();
                QString fieldType = describeQuery.value(1).toString();

                // Remove characters after `(` and then trim whitespaces
                QString fieldTypeTrimmed = fieldType.mid(0, fieldType.indexOf("(")).trimmed();

                // Get filter data type for QML
                QString filterDataType = dataType.dataType(fieldTypeTrimmed);

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

                // Append all data type to allList as well
                allList.append(outputDataList);

                // Clear Stringlist for future
                outputDataList.clear();
            }
        }

        break;
    }

    case Constants::redshiftIntType:{

        QSqlDatabase dbRedshift = QSqlDatabase::database(Constants::redshiftOdbcStrQueryType);

        querySplitter.setQueryForClasses(query);
        QStringList tablesList = querySplitter.getJoinTables();
        QString mainTable = querySplitter.getMainTable();
        tablesList.push_back(mainTable);



        for(QString tableName: tablesList){
            describeQueryString = "SELECT column_name, data_type FROM information_schema.columns WHERE table_name = '" + tableName.toLower() + "'";

            QSqlQuery describeQuery(describeQueryString, dbRedshift);
            QSqlRecord rec = describeQuery.record();

            while(describeQuery.next()){


                QString fieldName = describeQuery.value(0).toString();
                QString fieldType = describeQuery.value(1).toString();

                // Remove characters after `(` and then trim whitespaces
                QString fieldTypeTrimmed = fieldType.mid(0, fieldType.indexOf("(")).trimmed();

                // Get filter data type for QML
                QString filterDataType = dataType.dataType(fieldTypeTrimmed);

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

                // Append all data type to allList as well
                allList.append(outputDataList);

                // Clear Stringlist for future
                outputDataList.clear();
            }
        }

        break;
    }


    case Constants::excelIntType:{

        querySplitter.setQueryForClasses(query);
        QStringList tablesList = querySplitter.getJoinTables();
        QString mainTable = querySplitter.getMainTable();
        tablesList.push_back(mainTable);



        for(QString tableName: tablesList){
            auto data = duckCon->con.Query("PRAGMA table_info('"+ tableName.toStdString() +"')");
            int rows = data->collection.Count();
            data->Print();

            for(int i = 0; i < rows; i++){
                QString fieldName =  data->GetValue(1, i).ToString().c_str();
                QString fieldType =  data->GetValue(2, i).ToString().c_str();

                // Get filter data type for QML
                QString filterDataType = dataType.dataType(fieldType);
                outputDataList << tableName << fieldName << fieldType << filterDataType;


                if(filterDataType == Constants::categoricalType){
                    allCategorical.append(outputDataList);
                } else if(filterDataType == Constants::numericalType){
                    allNumerical.append(outputDataList);
                } else if(filterDataType == Constants::dateType){
                    allDates.append(outputDataList);
                } else{
                    allOthers.append(outputDataList);
                }

                // Append all data type to allList as well
                allList.append(outputDataList);

                outputDataList.clear();
            }
        }

        break;
    }

    case Constants::mssqlIntType:{

        QSqlDatabase dbMssql = QSqlDatabase::database(Constants::mssqlOdbcStrQueryType);

        querySplitter.setQueryForClasses(query);
        QStringList tablesList = querySplitter.getJoinTables();
        QString mainTable = querySplitter.getMainTable();
        tablesList.push_back(mainTable);



        for(QString tableName: tablesList){
            describeQueryString = "SELECT column_name, data_type FROM information_schema.columns WHERE table_name = '" + tableName + "'";

            QSqlQuery describeQuery(describeQueryString, dbMssql);
            QSqlRecord rec = describeQuery.record();

            while(describeQuery.next()){


                QString fieldName = describeQuery.value(0).toString();
                QString fieldType = describeQuery.value(1).toString();

                // Remove characters after `(` and then trim whitespaces
                QString fieldTypeTrimmed = fieldType.mid(0, fieldType.indexOf("(")).trimmed();

                // Get filter data type for QML
                QString filterDataType = dataType.dataType(fieldTypeTrimmed);

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

                // Append all data type to allList as well
                allList.append(outputDataList);

                // Clear Stringlist for future
                outputDataList.clear();
            }
        }

        break;
    }

    case Constants::oracleIntType:{

        QSqlDatabase dbOracle = QSqlDatabase::database(Constants::oracleOdbcStrQueryType);

        querySplitter.setQueryForClasses(query);
        QStringList tablesList = querySplitter.getJoinTables();
        QString mainTable = querySplitter.getMainTable();
        tablesList.push_back(mainTable);



        for(QString tableName: tablesList){
            describeQueryString = "SELECT column_name, data_type FROM user_tab_columns WHERE table_name = '" + tableName + "'";

            QSqlQuery describeQuery(describeQueryString, dbOracle);
            QSqlRecord rec = describeQuery.record();

            while(describeQuery.next()){


                QString fieldName = describeQuery.value(0).toString();
                QString fieldType = describeQuery.value(1).toString();

                // Remove characters after `(` and then trim whitespaces
                QString fieldTypeTrimmed = fieldType.mid(0, fieldType.indexOf("(")).trimmed();

                // Get filter data type for QML
                QString filterDataType = dataType.dataType(fieldTypeTrimmed);

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

                // Append all data type to allList as well
                allList.append(outputDataList);

                // Clear Stringlist for future
                outputDataList.clear();
            }
        }

        break;
    }

    case Constants::mongoIntType:{

        QSqlDatabase dbMongo = QSqlDatabase::database(Constants::mongoOdbcStrQueryType);

        querySplitter.setQueryForClasses(query);
        QStringList tablesList = querySplitter.getJoinTables();
        QString mainTable = querySplitter.getMainTable();
        tablesList.push_back(mainTable);



        for(QString tableName: tablesList){
            describeQueryString = "SELECT column_name, data_type FROM user_tab_columns WHERE table_name = '" + tableName + "'";

            QSqlQuery describeQuery(describeQueryString, dbMongo);
            QSqlRecord rec = describeQuery.record();

            while(describeQuery.next()){


                QString fieldName = describeQuery.value(0).toString();
                QString fieldType = describeQuery.value(1).toString();

                // Remove characters after `(` and then trim whitespaces
                QString fieldTypeTrimmed = fieldType.mid(0, fieldType.indexOf("(")).trimmed();

                // Get filter data type for QML
                QString filterDataType = dataType.dataType(fieldTypeTrimmed);

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

                // Append all data type to allList as well
                allList.append(outputDataList);

                // Clear Stringlist for future
                outputDataList.clear();
            }
        }

        break;
    }

    case Constants::impalaIntType:{

        QSqlDatabase dbImpala = QSqlDatabase::database(Constants::impalaOdbcStrQueryType);

        querySplitter.setQueryForClasses(query);
        QStringList tablesList = querySplitter.getJoinTables();
        QString mainTable = querySplitter.getMainTable();
        tablesList.push_back(mainTable);



        for(QString tableName: tablesList){
            describeQueryString = "SELECT column_name, data_type FROM user_tab_columns WHERE table_name = '" + tableName + "'";

            QSqlQuery describeQuery(describeQueryString, dbImpala);
            QSqlRecord rec = describeQuery.record();

            while(describeQuery.next()){


                QString fieldName = describeQuery.value(0).toString();
                QString fieldType = describeQuery.value(1).toString();

                // Remove characters after `(` and then trim whitespaces
                QString fieldTypeTrimmed = fieldType.mid(0, fieldType.indexOf("(")).trimmed();

                // Get filter data type for QML
                QString filterDataType = dataType.dataType(fieldTypeTrimmed);

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

                // Append all data type to allList as well
                allList.append(outputDataList);

                // Clear Stringlist for future
                outputDataList.clear();
            }
        }

        break;
    }

    case Constants::hiveIntType:{

        QSqlDatabase dbHive = QSqlDatabase::database(Constants::hiveOdbcStrQueryType);

        querySplitter.setQueryForClasses(query);
        QStringList tablesList = querySplitter.getJoinTables();
        QString mainTable = querySplitter.getMainTable();
        tablesList.push_back(mainTable);



        for(QString tableName: tablesList){
            describeQueryString = "SELECT column_name, data_type FROM user_tab_columns WHERE table_name = '" + tableName + "'";

            QSqlQuery describeQuery(describeQueryString, dbHive);
            QSqlRecord rec = describeQuery.record();

            while(describeQuery.next()){


                QString fieldName = describeQuery.value(0).toString();
                QString fieldType = describeQuery.value(1).toString();

                // Remove characters after `(` and then trim whitespaces
                QString fieldTypeTrimmed = fieldType.mid(0, fieldType.indexOf("(")).trimmed();

                // Get filter data type for QML
                QString filterDataType = dataType.dataType(fieldTypeTrimmed);

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

                // Append all data type to allList as well
                allList.append(outputDataList);

                // Clear Stringlist for future
                outputDataList.clear();
            }
        }

        break;
    }

    case Constants::snowflakeIntType:{

        QSqlDatabase dbSnowflake = QSqlDatabase::database(Constants::snowflakeOdbcStrQueryType);

        querySplitter.setQueryForClasses(query);
        QStringList tablesList = querySplitter.getJoinTables();
        QString mainTable = querySplitter.getMainTable();
        tablesList.push_back(mainTable);



        for(QString tableName: tablesList){
            describeQueryString = "SELECT column_name, data_type FROM user_tab_columns WHERE table_name = '" + tableName + "'";

            QSqlQuery describeQuery(describeQueryString, dbSnowflake);
            QSqlRecord rec = describeQuery.record();

            while(describeQuery.next()){


                QString fieldName = describeQuery.value(0).toString();
                QString fieldType = describeQuery.value(1).toString();

                // Remove characters after `(` and then trim whitespaces
                QString fieldTypeTrimmed = fieldType.mid(0, fieldType.indexOf("(")).trimmed();

                // Get filter data type for QML
                QString filterDataType = dataType.dataType(fieldTypeTrimmed);

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

                // Append all data type to allList as well
                allList.append(outputDataList);

                // Clear Stringlist for future
                outputDataList.clear();
            }
        }

        break;
    }

    case Constants::teradataIntType:{

        QSqlDatabase dbTeradata = QSqlDatabase::database(Constants::teradataOdbcStrQueryType);

        querySplitter.setQueryForClasses(query);
        QStringList tablesList = querySplitter.getJoinTables();
        QString mainTable = querySplitter.getMainTable();
        tablesList.push_back(mainTable);



        for(QString tableName: tablesList){
            describeQueryString = "SELECT column_name, data_type FROM user_tab_columns WHERE table_name = '" + tableName + "'";

            QSqlQuery describeQuery(describeQueryString, dbTeradata);
            QSqlRecord rec = describeQuery.record();

            while(describeQuery.next()){


                QString fieldName = describeQuery.value(0).toString();
                QString fieldType = describeQuery.value(1).toString();

                // Remove characters after `(` and then trim whitespaces
                QString fieldTypeTrimmed = fieldType.mid(0, fieldType.indexOf("(")).trimmed();

                // Get filter data type for QML
                QString filterDataType = dataType.dataType(fieldTypeTrimmed);

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

                // Append all data type to allList as well
                allList.append(outputDataList);

                // Clear Stringlist for future
                outputDataList.clear();
            }
        }

        break;
    }

    case Constants::accessIntType:{

        QSqlDatabase dbAccess = QSqlDatabase::database(Constants::accessOdbcStrQueryType);

        querySplitter.setQueryForClasses(query);
        QStringList tablesList = querySplitter.getJoinTables();
        QString mainTable = querySplitter.getMainTable();
        tablesList.push_back(mainTable);



        for(QString tableName: tablesList){
            describeQueryString = "SELECT column_name, data_type FROM user_tab_columns WHERE table_name = '" + tableName + "'";

            QSqlQuery describeQuery(describeQueryString, dbAccess);
            QSqlRecord rec = describeQuery.record();

            while(describeQuery.next()){


                QString fieldName = describeQuery.value(0).toString();
                QString fieldType = describeQuery.value(1).toString();

                // Remove characters after `(` and then trim whitespaces
                QString fieldTypeTrimmed = fieldType.mid(0, fieldType.indexOf("(")).trimmed();

                // Get filter data type for QML
                QString filterDataType = dataType.dataType(fieldTypeTrimmed);

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

                // Append all data type to allList as well
                allList.append(outputDataList);

                // Clear Stringlist for future
                outputDataList.clear();
            }
        }

        break;
    }

    case Constants::csvIntType:{

        querySplitter.setQueryForClasses(query);
        QStringList tablesList = querySplitter.getJoinTables();
        QString mainTable = querySplitter.getMainTable();
        tablesList.push_back(mainTable);



        for(QString tableName: tablesList){
            auto data = duckCon->con.Query("PRAGMA table_info('"+ tableName.toStdString() +"')");
            int rows = data->collection.Count();
            data->Print();

            for(int i = 0; i < rows; i++){
                QString fieldName =  data->GetValue(1, i).ToString().c_str();
                QString fieldType =  data->GetValue(2, i).ToString().c_str();

                // Get filter data type for QML
                QString filterDataType = dataType.dataType(fieldType);
                outputDataList << tableName << fieldName << fieldType << filterDataType;


                if(filterDataType == Constants::categoricalType){
                    allCategorical.append(outputDataList);
                } else if(filterDataType == Constants::numericalType){
                    allNumerical.append(outputDataList);
                } else if(filterDataType == Constants::dateType){
                    allDates.append(outputDataList);
                } else{
                    allOthers.append(outputDataList);
                }

                // Append all data type to allList as well
                allList.append(outputDataList);

                outputDataList.clear();
            }
        }

        break;
    }

    case Constants::jsonIntType:{

        querySplitter.setQueryForClasses(query);
        QStringList tablesList = querySplitter.getJoinTables();
        QString mainTable = querySplitter.getMainTable();
        tablesList.push_back(mainTable);



        for(QString tableName: tablesList){
            auto data = duckCon->con.Query("PRAGMA table_info('"+ tableName.toStdString() +"')");
            int rows = data->collection.Count();
            data->Print();

            for(int i = 0; i < rows; i++){
                QString fieldName =  data->GetValue(1, i).ToString().c_str();
                QString fieldType =  data->GetValue(2, i).ToString().c_str();

                // Get filter data type for QML
                QString filterDataType = dataType.dataType(fieldType);
                outputDataList << tableName << fieldName << fieldType << filterDataType;


                if(filterDataType == Constants::categoricalType){
                    allCategorical.append(outputDataList);
                } else if(filterDataType == Constants::numericalType){
                    allNumerical.append(outputDataList);
                } else if(filterDataType == Constants::dateType){
                    allDates.append(outputDataList);
                } else{
                    allOthers.append(outputDataList);
                }

                // Append all data type to allList as well
                allList.append(outputDataList);

                outputDataList.clear();
            }
        }

        break;
    }

    }

    // Emit the signals here
    // For the slots to received the data
    // in QML (UI)

    emit tableSchemaObtained(allList, allCategorical, allNumerical, allDates, allOthers, queriedColumnNames);

    // Clear all stringlist for new values

    queriedColumnNames.clear();
    allCategorical.clear();
    allNumerical.clear();
    allDates.clear();
    allOthers.clear();
    allList.clear();


}
