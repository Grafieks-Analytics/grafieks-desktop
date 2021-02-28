#include "tableschemamodel.h"
#include "iostream"
TableSchemaModel::TableSchemaModel(QObject *parent) : QObject(parent)
{

}

TableSchemaModel::TableSchemaModel(DuckCRUD *duckCRUD, QObject *parent)
{
    Q_UNUSED(parent);
    this->duckCRUD = duckCRUD;
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

    case Constants::mysqlIntType:
    case Constants::mysqlOdbcIntType:{

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

    case Constants::postgresIntType:
    case Constants::redshiftIntType:{

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


    case Constants::excelIntType:{

        QSqlDatabase dbExcel = QSqlDatabase::database(Constants::excelStrQueryType);

        querySplitter.setQueryForClasses(query);
        QStringList tablesList = querySplitter.getJoinTables();
        QString mainTable = querySplitter.getMainTable();
        tablesList.push_back(mainTable);



        for(QString tableName: tablesList){
            describeQueryString = "SELECT column_name, data_type FROM information_schema.columns WHERE table_name = '" + tableName.toLower() + "'";

            QSqlQuery describeQuery(describeQueryString, dbExcel);
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

    case Constants::csvIntType:{

        //        QString db = Statics::currentDbName;
        //        std::string csvFile = db.toStdString();
        //        std::string csvdb = "'" + csvFile + "'";
        //this->duckCRUD->con.Query("CREATE TABLE dataType AS SELECT * FROM read_csv_auto(" + csvdb + ")");

        QString db = Statics::currentDbName;

        auto result = this->duckCRUD->con.Query("DESCRIBE " + db.toStdString());
        result->Print();
        int rows = result->collection.count;
        int i = 0;
        while(i < rows){

            duckdb::Value fieldName = result->GetValue(0, i);
            duckdb::Value fieldType = result->GetValue(1, i);

            // string to qstring conversion
            QString newFieldName = QString::fromStdString(fieldName.ToString());
            QString newFilterType = QString::fromStdString(fieldType.ToString());
            QString filterDataType = dataType.dataType(QString::fromStdString(fieldType.ToString()));

            // qDebug() << i << "  " << newFieldName << " Col ID";

            QString index = QString::number(i);
            outputDataList << index << newFieldName << newFilterType << filterDataType;

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

            i++;
        }

        //        result->Print();

        //        QFile file(Statics::currentDbName);
        //        file.open(QIODevice::ReadOnly);

        //        QTextStream in(&file);

        //        char separator = Statics::separator[0].toLatin1();
        //        QStringList headers = in.readLine().split(separator);
        //        QStringList dataRow = in.readLine().split(separator);

        //        for(int i = 0; i < dataRow.size(); i++){

        //            QString dataType = QString::fromStdString(dataRow[i].toStdString());
        //            dataType = dataType.trimmed();

        //            if(dataType.toInt() || dataType.toFloat()){
        //                QString columnName = headers[i].trimmed();
        //                QString index = QString::number(i);
        //                outputDataList << index << columnName;
        //                allNumerical.append(outputDataList);

        //            }
        //            else{

        //                QString columnName = headers[i].trimmed();
        //                QString index = QString::number(i);
        //                outputDataList << index << columnName;
        //                allCategorical.append(outputDataList);
        //            }
        //            outputDataList.clear();
        //        }

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
