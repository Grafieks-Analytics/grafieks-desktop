#include "generaterolenamesforwardonlyworker.h"


GenerateRoleNamesForwardOnlyWorker::GenerateRoleNamesForwardOnlyWorker(QSqlDatabase *dbForward, QString query, QuerySplitter *querySplitter)
{
    this->dbForward = dbForward;
    this->query = query;
    this->querySplitter = querySplitter;
}

void GenerateRoleNamesForwardOnlyWorker::run()
{

    QString colListQuery, conType, fieldName, fieldType, tmpTableName, tmpFieldName;
    DataType dataType;
    QStringList colInfo, tablesList, output;
    QMap<QString, QString> colTypeMap;

    roleNames.clear();
    this->tableHeaders.clear();


    QRegularExpression selectListRegex(R"(SELECT\s+(.*?)\sFROM\s)", QRegularExpression::CaseInsensitiveOption);
    QRegularExpressionMatch selectIterator = selectListRegex.match(this->query);
    QString containsStar = selectIterator.captured(1);

    if(containsStar.contains("*", Qt::CaseInsensitive) == true){
        tablesList << this->querySplitter->getMainTable();
        tablesList << this->querySplitter->getJoinTables();

        foreach(QString tableName, tablesList){

            QString conQuery = this->returnDatatypeQuery(tableName);
            QString conName = this->returnConnectionName();

            QSqlQuery q(conQuery, *dbForward);

            if(q.lastError().type() == QSqlError::NoError){
                int i = 0;

                while(q.next()){
                    fieldName = q.value(0).toString().trimmed();
                    fieldType = q.value(1).toString().trimmed();
                    colInfo << fieldName << dataType.dataType(fieldType) << tableName;

                    roleNames.insert(i, fieldName.toUtf8());
                    this->forwardOnlyChartHeader.insert(i, colInfo);

                    this->tableHeaders.append(fieldName);
                    this->internalColCount++;
                    colInfo.clear();
                    i++;
                }
            } else{
                qWarning() << Q_FUNC_INFO << q.lastError();
            }
        }

    } else{
        output = this->querySplitter->getSelectParams();
        tablesList << this->querySplitter->getMainTable();
        tablesList << this->querySplitter->getJoinTables();


        this->internalColCount = output.length();

        for(int i =0; i < output.length(); i++){
            fieldName = output[i].remove(QRegularExpression("[\"`']+")).trimmed();

            // If fieldname contains a dot(.), then probably it might have joins
            // Else for sure it doesnt contain a join
            if(fieldName.contains(".")){
                foreach(QString tableName, tablesList){

                    if(Statics::currentDbIntType == Constants::teradataIntType){
                        tableName.remove("\"" + Statics::currentDbName + "\".");
                        tableName.remove(Statics::currentDbName + ".");
                        tableName.remove("\"");
                    }

                    tableName = tableName.remove(QRegularExpression("[\"`']+")).trimmed();

                    if(tmpTableName != tableName){
                        colTypeMap = this->returnColumnList(tableName);
                    }

                    if(fieldName.contains(tableName)){

                        try{
                            tmpFieldName = fieldName;
                            fieldName.remove(tableName + ".");
                            fieldType = colTypeMap.value(fieldName);
                            colInfo << fieldName << dataType.dataType(fieldType.left(fieldType.indexOf("("))) << tableName;

                        } catch(std::exception &e){
                            qDebug() << e.what();
                        }
                    }
                    tmpTableName = tableName;

                }
            } else{

                if(tmpTableName != tablesList.at(0)){
                    colTypeMap = this->returnColumnList(tablesList.at(0));
                }
                tmpTableName = tablesList.at(0);

                fieldType = colTypeMap.value(fieldName);
                colInfo << fieldName << dataType.dataType(fieldType.left(fieldType.indexOf("("))) << tablesList.at(0);
            }


            try{
                roleNames.insert(i, fieldName.toUtf8());
                this->forwardOnlyChartHeader.insert(i, colInfo);
                this->tableHeaders.append(fieldName);
            }catch(std::exception &er){
                qDebug() << er.what();
            }

            colInfo.clear();

        }

    }

    emit signalGenerateRoleNames(this->tableHeaders, this->forwardOnlyChartHeader, this->roleNames, this->internalColCount);
}

QString GenerateRoleNamesForwardOnlyWorker::returnDatatypeQuery(QString tableName)
{

    QString colListQuery;

    switch(Statics::currentDbIntType){
    case Constants::redshiftIntType:
        colListQuery = "select \"column\", type from pg_table_def where tablename = '" + tableName  + "'";
        break;

    case Constants::snowflakeIntType:
        colListQuery = "desc table " + tableName;
        break;

    case Constants::teradataIntType:
        tableName.remove("\"" + Statics::currentDbName + "\".");
        tableName.remove(Statics::currentDbName + ".");
        tableName.remove("\"");
        colListQuery = "SELECT ColumnName, ColumnType FROM DBC.Columns WHERE DatabaseName = '" + Statics::currentDbName + "' AND TableName = '" + tableName + "'";
        break;

    }

    return colListQuery;
}

QString GenerateRoleNamesForwardOnlyWorker::returnConnectionName()
{

    QString conType;

    switch(Statics::currentDbIntType){

    case Constants::redshiftIntType:
        conType = Constants::redshiftOdbcStrType;
        break;

    case Constants::snowflakeIntType:
        conType = Constants::snowflakeOdbcStrType;
        break;

    case Constants::teradataIntType:
        conType = Constants::teradataOdbcStrType;
        break;
    }

    return conType;
}

QMap<QString, QString> GenerateRoleNamesForwardOnlyWorker::returnColumnList(QString tableName)
{

    QString conQuery = this->returnDatatypeQuery(tableName);
    QString conName = this->returnConnectionName();
    QMap<QString, QString>colTypeMap;

    QSqlQuery q(conQuery, *dbForward);

    if(q.lastError().type() == QSqlError::NoError){
        while(q.next()){
            QString fieldName = q.value(0).toString().trimmed();
            QString fieldType = q.value(1).toString().trimmed();
            colTypeMap.insert(fieldName, fieldType);
        }
    } else{
        qWarning() << Q_FUNC_INFO << q.lastError() << conName;
    }

    return colTypeMap;
}
