#include "tablecolumnsmodel.h"

TableColumnsModel::TableColumnsModel(QObject *parent) : QObject(parent)
{

}

TableColumnsModel::TableColumnsModel(DuckCon *duckCon, QObject *parent)
{
    Q_UNUSED(parent);
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

    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:
    case Constants::mysqlOdbcIntType:
    case Constants::mongoIntType:{
        QString dbString;

        switch (Statics::currentDbIntType) {

        case Constants::mysqlIntType:
            dbString = Constants::mysqlStrQueryType;
            break;

        case Constants::mysqlOdbcIntType:
            dbString = Constants::mysqlOdbcStrQueryType;
            break;

        case Constants::mongoIntType:
            dbString = Constants::mongoOdbcStrQueryType;
            break;

        }

        QSqlDatabase dbCon = QSqlDatabase::database(dbString);

        describeQueryString = "DESCRIBE `" + tableName + "`";

        QSqlQuery describeQuery(describeQueryString, dbCon);

        if(describeQuery.lastError().type() == QSqlError::NoError){
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
        } else{
            qWarning() << Q_FUNC_INFO << describeQuery.lastError();
        }
        break;
    }


    case Constants::sqliteIntType:{

        QSqlDatabase dbSqlite = QSqlDatabase::database(Constants::sqliteStrQueryType);

        describeQueryString = "PRAGMA table_info(" + tableName + ")";

        QSqlQuery describeQuery(describeQueryString, dbSqlite);

        if(describeQuery.lastError().type() == QSqlError::NoError){
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
        } else{
            qWarning() << Q_FUNC_INFO << describeQuery.lastError();
        }
        break;
    }
    case Constants::postgresIntType:{

        QSqlDatabase dbPostgres = QSqlDatabase::database(Constants::postgresOdbcStrType);

        describeQueryString = "SELECT column_name, data_type FROM information_schema.columns WHERE table_name = '" + tableName.toLower()  + "'";

        QSqlQuery describeQuery(describeQueryString, dbPostgres);

        if(describeQuery.lastError().type() == QSqlError::NoError){
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
        } else{
            qWarning() << Q_FUNC_INFO << describeQuery.lastError();
        }
        break;
    }

    case Constants::redshiftIntType:{

        QSqlDatabase dbRedshift = QSqlDatabase::database(Constants::redshiftOdbcStrType);

        describeQueryString = "select \"column\", type from pg_table_def where tablename = '" + tableName  + "'";

        QSqlQuery describeQuery(describeQueryString, dbRedshift);

        if(describeQuery.lastError().type() == QSqlError::NoError){
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
        } else{
            qWarning() << Q_FUNC_INFO << describeQuery.lastError();
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

        if(describeQuery.lastError().type() == QSqlError::NoError){
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
        } else{
            qWarning() << Q_FUNC_INFO << describeQuery.lastError();
        }
        break;
    }

    case Constants::oracleIntType:{

        QSqlDatabase dbOracle = QSqlDatabase::database(Constants::oracleOdbcStrType);

        describeQueryString = "SELECT column_name, data_type FROM user_tab_columns WHERE table_name = '" + tableName  + "'";

        QSqlQuery describeQuery(describeQueryString, dbOracle);

        if(describeQuery.lastError().type() == QSqlError::NoError){
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
        } else{
            qWarning() << Q_FUNC_INFO << describeQuery.lastError();
        }
        break;
    }

    case Constants::impalaIntType:{

        QSqlDatabase dbImpala = QSqlDatabase::database(Constants::impalaOdbcStrType);

        describeQueryString = "SELECT column_name, data_type FROM user_tab_columns WHERE table_name = '" + tableName  + "'";

        QSqlQuery describeQuery(describeQueryString, dbImpala);

        if(describeQuery.lastError().type() == QSqlError::NoError){
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
        } else{
            qWarning() << Q_FUNC_INFO << describeQuery.lastError();
        }
        break;
    }

    case Constants::hiveIntType:{

        QSqlDatabase dbHive = QSqlDatabase::database(Constants::hiveOdbcStrType);

        describeQueryString = "SELECT column_name, data_type FROM user_tab_columns WHERE table_name = '" + tableName  + "'";

        QSqlQuery describeQuery(describeQueryString, dbHive);

        if(describeQuery.lastError().type() == QSqlError::NoError){
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
        } else{
            qWarning() << Q_FUNC_INFO << describeQuery.lastError();
        }
        break;
    }

    case Constants::snowflakeIntType:{

        QSqlDatabase dbSnowflake = QSqlDatabase::database(Constants::snowflakeOdbcStrType);

        describeQueryString = "DESC TABLE " + tableName;

        QSqlQuery describeQuery(describeQueryString, dbSnowflake);

        if(describeQuery.lastError().type() == QSqlError::NoError){
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
        } else{
            qWarning() << Q_FUNC_INFO << describeQuery.lastError();
        }
        break;
    }

    case Constants::teradataIntType:{

        QSqlDatabase dbTeradata = QSqlDatabase::database(Constants::teradataOdbcStrType);

        describeQueryString = "SELECT ColumnName, ColumnType FROM DBC.Columns WHERE DatabaseName = '" + Statics::currentDbName + "' AND TableName = '" + tableName + "'";

        QSqlQuery describeQuery(describeQueryString, dbTeradata);

        if(describeQuery.lastError().type() == QSqlError::NoError){
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
        } else{
            qWarning() << Q_FUNC_INFO << describeQuery.lastError();
        }
        break;
    }

    case Constants::accessIntType:{

        QSqlDatabase dbTeradata = QSqlDatabase::database(Constants::accessOdbcStrType);

        describeQueryString = "SELECT column_name, data_type FROM user_tab_columns WHERE table_name = '" + tableName  + "'";

        QSqlQuery describeQuery(describeQueryString, dbTeradata);

        if(describeQuery.lastError().type() == QSqlError::NoError){
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
        } else{
            qWarning() << Q_FUNC_INFO << describeQuery.lastError();
        }
        break;
    }

    case Constants::csvIntType:
    case Constants::jsonIntType:{

        auto data = duckCon->con.Query("PRAGMA table_info('"+ tableName.toStdString() +"')");
        if(data->error.empty()){
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
        }  else{
            qWarning() << Q_FUNC_INFO << data->error.c_str();
        }

        break;
    }
    }

    emit columnListObtained(allColumns, tableName, moduleName);
    allColumns.clear();
}
