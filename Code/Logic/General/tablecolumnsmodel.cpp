#include "tablecolumnsmodel.h"

TableColumnsModel::TableColumnsModel(QObject *parent) : QObject(parent)
{

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
    case Constants::mysqlOdbcIntType:{

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
    case Constants::postgresIntType:
    case Constants::redshiftIntType:{

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
    }

    emit columnListObtained(allColumns, tableName, moduleName);
    allColumns.clear();
}
