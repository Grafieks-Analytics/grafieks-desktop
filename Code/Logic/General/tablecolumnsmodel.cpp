#include "tablecolumnsmodel.h"

TableColumnsModel::TableColumnsModel(QObject *parent) : QObject(parent)
{

}

TableColumnsModel::TableColumnsModel(DuckCon *duckCon, QObject *parent)
{
    this->duckCon = duckCon;
}

/*!
 * \brief Accepts a tableName and displays all the columns
 * \code
 * emit void columnListObtained(QList<QStringList> allColumns);
 * \endcode
 *
 */
void TableColumnsModel::getColumnsForTable(QString tableName, QString moduleName)
{


    QString describeQueryString, fieldName, fieldType;
    QStringList outputDataList;
    qDebug() << tableName <<  moduleName<< Statics::currentDbIntType;

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


            outputDataList << fieldName << filterDataType;

            // Append all data type to allList as well
            allColumns.append(outputDataList);

            outputDataList.clear();
        }
        break;
    }

    case Constants::mysqlOdbcIntType:{

        QSqlDatabase dbMysqlOdbc = QSqlDatabase::database(Constants::mysqlOdbcStrQueryType);

        describeQueryString = "DESCRIBE `" + tableName + "`";

        QSqlQuery describeQuery(describeQueryString, dbMysqlOdbc);

        while(describeQuery.next()){

            fieldName = describeQuery.value(0).toString();
            fieldType = describeQuery.value(1).toString();

            // Remove characters after `(` and then trim whitespaces
            QString fieldTypeTrimmed = fieldType.mid(0, fieldType.indexOf("(")).trimmed();

            // Get filter data type for QML
            QString filterDataType = dataType.dataType(fieldTypeTrimmed);


            outputDataList << fieldName << filterDataType;
            qDebug() << outputDataList << "MYSQL ODBC";

            // Append all data type to allList as well
            allColumns.append(outputDataList);

            outputDataList.clear();
        }
        break;
    }

    case Constants::sqliteIntType:{

        QSqlDatabase dbSqlite = QSqlDatabase::database(Constants::sqliteStrQueryType);

        describeQueryString = "PRAGMA table_info(" + tableName + ")";

        QSqlQuery describeQuery(describeQueryString, dbSqlite);

        while(describeQuery.next()){

            fieldName = describeQuery.value(1).toString();
            fieldType = describeQuery.value(2).toString();

            // Remove characters after `(` and then trim whitespaces
            QString fieldTypeTrimmed = fieldType.mid(0, fieldType.indexOf("(")).trimmed();

            // Get filter data type for QML
            QString filterDataType = dataType.dataType(fieldTypeTrimmed);

            outputDataList << fieldName << filterDataType;

            // Append all data type to allList as well
            allColumns.append(outputDataList);

            outputDataList.clear();
        }
        break;
    }
    case Constants::postgresIntType:{

        QSqlDatabase dbPostgres = QSqlDatabase::database(Constants::postgresOdbcStrType);

        describeQueryString = "SELECT column_name, data_type FROM information_schema.columns WHERE table_name = '" + tableName.toLower()  + "'";

        QSqlQuery describeQuery(describeQueryString, dbPostgres);

        while(describeQuery.next()){

            fieldName = describeQuery.value(0).toString();
            fieldType = describeQuery.value(1).toString();
            // Remove characters after `(` and then trim whitespaces
            QString fieldTypeTrimmed = fieldType.mid(0, fieldType.indexOf("(")).trimmed();

            // Get filter data type for QML
            QString filterDataType = dataType.dataType(fieldTypeTrimmed);

            outputDataList << fieldName << filterDataType;

            // Append all data type to allList as well
            allColumns.append(outputDataList);

            outputDataList.clear();

        }

        break;
    }

    case Constants::redshiftIntType:{

        QSqlDatabase dbRedshift = QSqlDatabase::database(Constants::redshiftOdbcStrType);

        describeQueryString = "SELECT column_name, data_type FROM information_schema.columns WHERE table_name = '" + tableName.toLower()  + "'";

        QSqlQuery describeQuery(describeQueryString, dbRedshift);

        while(describeQuery.next()){

            fieldName = describeQuery.value(0).toString();
            fieldType = describeQuery.value(1).toString();
            // Remove characters after `(` and then trim whitespaces
            QString fieldTypeTrimmed = fieldType.mid(0, fieldType.indexOf("(")).trimmed();

            // Get filter data type for QML
            QString filterDataType = dataType.dataType(fieldTypeTrimmed);

            outputDataList << fieldName << filterDataType;

            // Append all data type to allList as well
            allColumns.append(outputDataList);

            outputDataList.clear();

        }

        break;
    }

    case Constants::excelIntType:{

        auto data = duckCon->con.Query("PRAGMA table_info('"+ tableName.toStdString() +"')");
        int rows = data->collection.Count();

        for(int i = 0; i < rows; i++){
            fieldName =  data->GetValue(1, i).ToString().c_str();
            fieldType =  data->GetValue(2, i).ToString().c_str();

            // Get filter data type for QML
            QString filterDataType = dataType.dataType(fieldType);
            outputDataList << fieldName << filterDataType;

            // Append all data type to allList as well
            allColumns.append(outputDataList);
            outputDataList.clear();
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

            // Get filter data type for QML
            QString filterDataType = dataType.dataType(fieldTypeTrimmed);

            outputDataList << fieldName << filterDataType;

            // Append all data type to allList as well
            allColumns.append(outputDataList);
            outputDataList.clear();

        }

        break;
    }

    case Constants::oracleIntType:{

        QSqlDatabase dbOracle = QSqlDatabase::database(Constants::oracleOdbcStrType);

        describeQueryString = "SELECT column_name, data_type FROM user_tab_columns WHERE table_name = '" + tableName  + "'";

        QSqlQuery describeQuery(describeQueryString, dbOracle);

        while(describeQuery.next()){

            fieldName = describeQuery.value(0).toString();
            fieldType = describeQuery.value(1).toString();
            // Remove characters after `(` and then trim whitespaces
            QString fieldTypeTrimmed = fieldType.mid(0, fieldType.indexOf("(")).trimmed();

            // Get filter data type for QML
            QString filterDataType = dataType.dataType(fieldTypeTrimmed);

            outputDataList << fieldName << filterDataType;

            // Append all data type to allList as well
            allColumns.append(outputDataList);

            outputDataList.clear();

        }

        break;
    }

    case Constants::mongoIntType:{

        QSqlDatabase dbMongo = QSqlDatabase::database(Constants::mongoOdbcStrType);

        describeQueryString = "SELECT column_name, data_type FROM user_tab_columns WHERE table_name = '" + tableName  + "'";

        QSqlQuery describeQuery(describeQueryString, dbMongo);

        while(describeQuery.next()){

            fieldName = describeQuery.value(0).toString();
            fieldType = describeQuery.value(1).toString();
            // Remove characters after `(` and then trim whitespaces
            QString fieldTypeTrimmed = fieldType.mid(0, fieldType.indexOf("(")).trimmed();

            // Get filter data type for QML
            QString filterDataType = dataType.dataType(fieldTypeTrimmed);

            outputDataList << fieldName << filterDataType;

            // Append all data type to allList as well
            allColumns.append(outputDataList);

            outputDataList.clear();

        }

        break;
    }

    case Constants::impalaIntType:{

        QSqlDatabase dbImpala = QSqlDatabase::database(Constants::impalaOdbcStrType);

        describeQueryString = "SELECT column_name, data_type FROM user_tab_columns WHERE table_name = '" + tableName  + "'";

        QSqlQuery describeQuery(describeQueryString, dbImpala);

        while(describeQuery.next()){

            fieldName = describeQuery.value(0).toString();
            fieldType = describeQuery.value(1).toString();
            // Remove characters after `(` and then trim whitespaces
            QString fieldTypeTrimmed = fieldType.mid(0, fieldType.indexOf("(")).trimmed();

            // Get filter data type for QML
            QString filterDataType = dataType.dataType(fieldTypeTrimmed);

            outputDataList << fieldName << filterDataType;

            // Append all data type to allList as well
            allColumns.append(outputDataList);

            outputDataList.clear();

        }

        break;
    }

    case Constants::hiveIntType:{

        QSqlDatabase dbHive = QSqlDatabase::database(Constants::hiveOdbcStrType);

        describeQueryString = "SELECT column_name, data_type FROM user_tab_columns WHERE table_name = '" + tableName  + "'";

        QSqlQuery describeQuery(describeQueryString, dbHive);

        while(describeQuery.next()){

            fieldName = describeQuery.value(0).toString();
            fieldType = describeQuery.value(1).toString();
            // Remove characters after `(` and then trim whitespaces
            QString fieldTypeTrimmed = fieldType.mid(0, fieldType.indexOf("(")).trimmed();

            // Get filter data type for QML
            QString filterDataType = dataType.dataType(fieldTypeTrimmed);

            outputDataList << fieldName << filterDataType;

            // Append all data type to allList as well
            allColumns.append(outputDataList);

            outputDataList.clear();

        }

        break;
    }

    case Constants::snowflakeIntType:{

        QSqlDatabase dbSnowflake = QSqlDatabase::database(Constants::snowflakeOdbcStrType);

        describeQueryString = "SELECT column_name, data_type FROM user_tab_columns WHERE table_name = '" + tableName  + "'";

        QSqlQuery describeQuery(describeQueryString, dbSnowflake);

        while(describeQuery.next()){

            fieldName = describeQuery.value(0).toString();
            fieldType = describeQuery.value(1).toString();
            // Remove characters after `(` and then trim whitespaces
            QString fieldTypeTrimmed = fieldType.mid(0, fieldType.indexOf("(")).trimmed();

            // Get filter data type for QML
            QString filterDataType = dataType.dataType(fieldTypeTrimmed);

            outputDataList << fieldName << filterDataType;

            // Append all data type to allList as well
            allColumns.append(outputDataList);

            outputDataList.clear();

        }

        break;
    }

    case Constants::teradataIntType:{

        QSqlDatabase dbTeradata = QSqlDatabase::database(Constants::teradataOdbcStrType);

        describeQueryString = "SELECT column_name, data_type FROM user_tab_columns WHERE table_name = '" + tableName  + "'";

        QSqlQuery describeQuery(describeQueryString, dbTeradata);

        while(describeQuery.next()){

            fieldName = describeQuery.value(0).toString();
            fieldType = describeQuery.value(1).toString();
            // Remove characters after `(` and then trim whitespaces
            QString fieldTypeTrimmed = fieldType.mid(0, fieldType.indexOf("(")).trimmed();

            // Get filter data type for QML
            QString filterDataType = dataType.dataType(fieldTypeTrimmed);

            outputDataList << fieldName << filterDataType;

            // Append all data type to allList as well
            allColumns.append(outputDataList);

            outputDataList.clear();

        }

        break;
    }

    case Constants::accessIntType:{

        QSqlDatabase dbTeradata = QSqlDatabase::database(Constants::accessOdbcStrType);

        describeQueryString = "SELECT column_name, data_type FROM user_tab_columns WHERE table_name = '" + tableName  + "'";

        QSqlQuery describeQuery(describeQueryString, dbTeradata);

        while(describeQuery.next()){

            fieldName = describeQuery.value(0).toString();
            fieldType = describeQuery.value(1).toString();
            // Remove characters after `(` and then trim whitespaces
            QString fieldTypeTrimmed = fieldType.mid(0, fieldType.indexOf("(")).trimmed();

            // Get filter data type for QML
            QString filterDataType = dataType.dataType(fieldTypeTrimmed);

            outputDataList << fieldName << filterDataType;

            // Append all data type to allList as well
            allColumns.append(outputDataList);

            outputDataList.clear();

        }

        break;
    }

    case Constants::csvIntType:
    case Constants::jsonIntType:{

        auto data = duckCon->con.Query("PRAGMA table_info('"+ tableName.toStdString() +"')");
        int rows = data->collection.Count();

        for(int i = 0; i < rows; i++){
            fieldName =  data->GetValue(1, i).ToString().c_str();
            fieldType =  data->GetValue(2, i).ToString().c_str();

            // Get filter data type for QML
            QString filterDataType = dataType.dataType(fieldType);
            outputDataList << fieldName << filterDataType;

            // Append all data type to allList as well
            allColumns.append(outputDataList);
            outputDataList.clear();
        }

        break;
    }
    }

    emit columnListObtained(allColumns, tableName, moduleName);
    allColumns.clear();
}
