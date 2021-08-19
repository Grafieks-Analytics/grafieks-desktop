#include "newtablecolumnsmodel.h"

NewTableColumnsModel::NewTableColumnsModel(QObject *parent) : QObject(parent)
{

}

NewTableColumnsModel::NewTableColumnsModel(DuckCon *duckCon, QObject *parent)
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
void NewTableColumnsModel::getColumnsForTable(QString tableName, QString moduleName)
{


    QString describeQueryString, fieldName, fieldType;
    QStringList outputDataList;

    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:
    case Constants::mysqlOdbcIntType:
    case Constants::sqliteIntType:
    case Constants::postgresIntType:
    case Constants::oracleIntType:
    case Constants::mssqlIntType:
    case Constants::accessIntType:
    case Constants::mongoIntType:{
        QString dbString;

        switch (Statics::currentDbIntType) {

        case Constants::mysqlIntType:
            dbString = Constants::mysqlStrQueryType;
            break;
        case Constants::mysqlOdbcIntType:
            dbString = Constants::mysqlOdbcStrQueryType;
            break;
        case Constants::sqliteIntType:
            dbString = Constants::sqliteStrQueryType;
            break;
        case Constants::postgresIntType:
            dbString = Constants::postgresOdbcStrQueryType;
            break;
        case Constants::oracleIntType:
            dbString = Constants::oracleOdbcStrQueryType;
            break;
        case Constants::mssqlIntType:
            dbString = Constants::mssqlOdbcStrQueryType;
            break;
        case Constants::accessIntType:
            dbString = Constants::accessOdbcStrQueryType;
            break;
        case Constants::mongoIntType:
            dbString = Constants::mongoOdbcStrQueryType;
            break;

        }

        QSqlDatabase dbCon = QSqlDatabase::database(dbString);
        QSqlRecord record = dbCon.record(tableName);

        if(!record.isEmpty()){

            for(int i=0; i < record.count(); i++){

                fieldName = record.fieldName(i);
                fieldType = record.field(i).value().typeName();

                // Get filter data type for QML
                QString filterDataType = dataType.dataType(fieldType);
                outputDataList << fieldName << filterDataType;

                // Append all data type to allList as well
                allColumns.append(outputDataList);

                outputDataList.clear();
            }
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

        tableName.remove("\"" + Statics::currentDbName + "\".");
        tableName.remove(Statics::currentDbName + ".");
        tableName.remove("\"");
        describeQueryString = "SELECT ColumnName, ColumnType FROM DBC.Columns WHERE DatabaseName = '" + Statics::currentDbName + "' AND TableName = '" + tableName + "'";

        QSqlQuery describeQuery(describeQueryString, dbTeradata);

        if(describeQuery.lastError().type() == QSqlError::NoError){
            while(describeQuery.next()){

                fieldName = describeQuery.value(0).toString().trimmed();
                fieldType = describeQuery.value(1).toString().trimmed();
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
        QSqlDatabase dbExcel = QSqlDatabase::database(Constants::excelOdbcStrType);
        QString dbQueryString = "select * from ["+tableName+"$] LIMIT 1";

        QSqlQuery query(dbQueryString, dbExcel);
        QSqlRecord record = query.record();


        if(!record.isEmpty()){

            for(int i=0; i < record.count(); i++){

                fieldName = record.fieldName(i);
                fieldType = record.field(i).value().typeName();

                // Get filter data type for QML
                QString filterDataType = dataType.dataType(fieldType);
                outputDataList << fieldName << filterDataType;

                // Append all data type to allList as well
                allColumns.append(outputDataList);

                outputDataList.clear();
            }
        }
        break;
    }
    case Constants::csvIntType:
    case Constants::jsonIntType:{

        QFile file(Statics::csvJsonPath);

        if(!file.open(QFile::ReadOnly | QFile::Text)) {
            qDebug() << "Cannot open file" << file.errorString();
        } else {
            int lineCounter = 0;
            while(lineCounter < 2){
                const QByteArray line = file.readLine().simplified();

                if(lineCounter == 0){
                    setHeaders(line, Statics::separator);
                } else {
                    allColumns = detectHeaderTypes(line, Statics::separator);
                }
                lineCounter++;
            }
        }

        file.close();

        break;
    }
    }

    emit columnListObtained(allColumns, tableName, moduleName);
    allColumns.clear();
}

void NewTableColumnsModel::clearColumns()
{
    allColumns.clear();
    QString tableName = "";
    QString moduleName = "";
    emit columnListObtained(allColumns, tableName, moduleName);
}

void NewTableColumnsModel::setHeaders(const QByteArray line, QString delimiter)
{
    this->csvHeaderDataFinal = line.split(*delimiter.toStdString().c_str());
    this->csvHeaderLength = this->csvHeaderDataFinal.length();

    if (this->csvHeaderDataFinal.at(0).contains("\xEF\xBB\xBF")){
        this->csvHeaderDataFinal[0] =  this->csvHeaderDataFinal.at(0).right(this->csvHeaderDataFinal.at(0).length() - 3);
    }

}

QList<QStringList> NewTableColumnsModel::detectHeaderTypes(const QByteArray line, QString delimiter)
{
    QList<QByteArray> lineData = line.split(*delimiter.toStdString().c_str());

    QStringList output;
    QString fieldName;
    QString fieldType;
    QStringList outputDataList;
    QList<QStringList> allColumns;

    for(int i = 0; i < this->csvHeaderLength; i++){

        fieldName = this->csvHeaderDataFinal.at(i);
        fieldType = dataType.variableType(QString(lineData.at(i)));

        outputDataList << fieldName << fieldType;

        // Append all data type to allList as well
        allColumns.append(outputDataList);
        outputDataList.clear();
    }

    return allColumns;
}
