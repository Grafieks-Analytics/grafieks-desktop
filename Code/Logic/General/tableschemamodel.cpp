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

        querySplitter.setQueryForClasses(query);
        QStringList tablesList = querySplitter.getJoinTables();
        QString mainTable = querySplitter.getMainTable();
        tablesList.push_back(mainTable);

        QSqlDatabase dbCon = QSqlDatabase::database(dbString);

        for(QString tableName: tablesList){

            tableName = tableName.replace(QRegularExpression("[\"`']"), "");

            QSqlRecord record = dbCon.record(tableName);

            if(!record.isEmpty()){

                for(int i=0; i < record.count(); i++){

                    QString fieldName = record.fieldName(i);
                    QString fieldType = record.field(i).value().typeName();

                    // Get filter data type for QML
                    QString filterDataType = dataType.dataType(fieldType);
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

                    outputDataList.clear();
                }
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
            describeQueryString = "select \"column\", type from pg_table_def where tablename = '" + tableName.replace(QRegularExpression("\""), "")  + "'";

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

    case Constants::impalaIntType:{

        QSqlDatabase dbImpala = QSqlDatabase::database(Constants::impalaOdbcStrQueryType);

        querySplitter.setQueryForClasses(query);
        QStringList tablesList = querySplitter.getJoinTables();
        QString mainTable = querySplitter.getMainTable();
        tablesList.push_back(mainTable);



        for(QString tableName: tablesList){
            tableName = tableName.replace(QRegularExpression("[\"`']"), "");
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
            tableName = tableName.replace(QRegularExpression("[\"`']"), "");
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
            tableName = tableName.replace(QRegularExpression("[\"`']"), "");
            describeQueryString = "DESC TABLE " + tableName;

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
            tableName.remove("\"" + Statics::currentDbName + "\".");
            tableName.remove(Statics::currentDbName + ".");
            tableName.remove("\"");
            describeQueryString = "SELECT ColumnName, ColumnType FROM DBC.Columns WHERE DatabaseName = '" + Statics::currentDbName + "' AND TableName = '" + tableName + "'";

            QSqlQuery describeQuery(describeQueryString, dbTeradata);
            QSqlRecord rec = describeQuery.record();

            while(describeQuery.next()){


                QString fieldName = describeQuery.value(0).toString().trimmed();
                QString fieldType = describeQuery.value(1).toString().trimmed();

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

        QSqlDatabase dbExcel = QSqlDatabase::database(Constants::excelOdbcStrType);

        for(QString tableName: tablesList){

            QString dbQueryString = "SELECT TOP 1 * FROM ["+tableName+"$]";

            QSqlQuery query(dbQueryString, dbExcel);
            QSqlRecord record = query.record();


            if(!record.isEmpty()){

                for(int i=0; i < record.count(); i++){

                    QString fieldName = record.fieldName(i).trimmed();
                    QString fieldType = record.field(i).value().typeName();

                    // Get filter data type for QML
                    QString filterDataType = dataType.dataType(fieldType);

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
                    QMap<QString, QList<QStringList>> allColumns = detectHeaderTypes(line, Statics::separator, Statics::currentDbName);
                }
                lineCounter++;
            }
        }

        file.close();

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

void TableSchemaModel::clearSchema()
{
    // Clear all stringlist for new values
    queriedColumnNames.clear();
    allCategorical.clear();
    allNumerical.clear();
    allDates.clear();
    allOthers.clear();
    allList.clear();


    emit tableSchemaCleared();

}

void TableSchemaModel::setHeaders(const QByteArray line, QString delimiter)
{

    this->csvHeaderDataFinal = line.split(*delimiter.toStdString().c_str());
    this->csvHeaderLength = this->csvHeaderDataFinal.length();

    if (this->csvHeaderDataFinal.at(0).contains("\xEF\xBB\xBF")){
        this->csvHeaderDataFinal[0] =  this->csvHeaderDataFinal.at(0).right(this->csvHeaderDataFinal.at(0).length() - 3);
    }
}

QMap<QString, QList<QStringList>> TableSchemaModel::detectHeaderTypes(const QByteArray line, QString delimiter, QString tableName)
{
    QList<QByteArray> lineData = line.split(*delimiter.toStdString().c_str());

    QStringList output;
    QString fieldName;
    QString fieldType;
    QStringList outputDataList;
    QMap<QString, QList<QStringList>> allColumns;

    for(int i = 0; i < this->csvHeaderLength; i++){

        fieldName = this->csvHeaderDataFinal.at(i);
        fieldType = dataType.variableType(QString(lineData.at(i)));

        // Get filter data type for QML
        QString filterDataType = dataType.dataType(fieldType);

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

    allColumns.insert("categorical", allCategorical);
    allColumns.insert("numerical", allNumerical);
    allColumns.insert("dates", allDates);
    allColumns.insert("others", allOthers);
    allColumns.insert("allList", allList);

    return allColumns;
}
