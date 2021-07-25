#include "generaterolenamesduckworker.h"

GenerateRoleNamesDuckWorker::GenerateRoleNamesDuckWorker(DuckCon *duckCon, QString query, QuerySplitter *querySplitter)
{
    this->duckCon = duckCon;
    this->query = query;
    this->querySplitter = querySplitter;
}

void GenerateRoleNamesDuckWorker::run()
{

    QString colListQuery, conType, fieldName, fieldType, tmpTableName, tmpFieldName;
    DataType dataType;
    QStringList colInfo, tablesList, output;
    QMap<QString, QString> colTypeMap;


    this->roleNames.clear();
    this->tableHeaders.clear();

    QRegularExpression selectListRegex(R"(SELECT\s+(.*?)\sFROM\s)", QRegularExpression::CaseInsensitiveOption);
    QRegularExpressionMatch selectIterator = selectListRegex.match(this->query);
    QString containsStar = selectIterator.captured(1);


    if(containsStar.contains("*", Qt::CaseInsensitive) == true){
        tablesList << this->querySplitter->getMainTable();
        tablesList << this->querySplitter->getJoinTables();

        foreach(QString tableName, tablesList){
            auto data = duckCon->con.Query("PRAGMA table_info('"+ tableName.toStdString() +"')");
            if(data->error.empty()){
                int rows = data->collection.Count();

                for(int i = 0; i < rows; i++){
                    fieldName =  data->GetValue(1, i).ToString().c_str();
                    fieldName = fieldName.trimmed();
                    fieldType = data->GetValue(2, i).ToString().c_str();
                    colInfo << fieldName << dataType.dataType(fieldType) << tableName;

                    this->roleNames.insert(i, fieldName.toUtf8());
                    this->duckChartHeader.insert(i, colInfo);
                    this->tableHeaders.append(fieldName);
                    colInfo.clear();
                }
            } else{
                qWarning() << Q_FUNC_INFO << data->error.c_str();
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
                int j=0;
                foreach(QString tableName, tablesList){

                    tableName = tableName.remove(QRegularExpression("[\"`']+")).trimmed();

                    if(tmpTableName != tableName){
                        colTypeMap = this->returnColumnList(tableName);
                    }

                    if(fieldName.contains(tableName)){

                        tmpFieldName = fieldName;
                        fieldName.remove(tableName + ".");
                        fieldType = colTypeMap.value(fieldName);

                        colInfo << fieldName << dataType.dataType(fieldType) << tablesList.at(j);
                    }
                    tmpTableName = tableName;
                    j++;

                }
            } else{

                if(tmpTableName != tablesList.at(0)){
                    colTypeMap = this->returnColumnList(tablesList.at(0));
                }
                tmpTableName = tablesList.at(0);

                fieldType = colTypeMap.value(fieldName);
                colInfo << fieldName << dataType.dataType(fieldType) << tablesList.at(0);
            }

            this->roleNames.insert(i, fieldName.toUtf8());
            this->duckChartHeader.insert(i, colInfo);
            this->tableHeaders.append(fieldName);

            colInfo.clear();
        }
    }

    emit signalGenerateRoleNames(this->tableHeaders, this->duckChartHeader, this->roleNames, this->internalColCount);
}

QMap<QString, QString> GenerateRoleNamesDuckWorker::returnColumnList(QString tableName)
{

    QMap<QString, QString>colTypeMap;

    auto data = duckCon->con.Query("PRAGMA table_info('"+ tableName.toStdString() +"')");

    if(data->error.empty()){
        int rows = data->collection.Count();

        for(int i = 0; i < rows; i++){
            QString fieldName =  data->GetValue(1, i).ToString().c_str();
            fieldName = fieldName.trimmed();
            QString fieldType = data->GetValue(2, i).ToString().c_str();
            colTypeMap.insert(fieldName, fieldType);
        }
    } else{
        qWarning() << Q_FUNC_INFO << data->error.c_str();
    }

    return colTypeMap;
}
