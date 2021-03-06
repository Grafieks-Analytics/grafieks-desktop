#include "duckdatamodel.h"

DuckDataModel::DuckDataModel(QObject *parent) : QObject(parent)
{

}

DuckDataModel::DuckDataModel(DuckCon *duckCon, QObject *parent)
{
    this->duckCon = duckCon;
}

void DuckDataModel::columnData(QString col, QString index)
{

    QString db = Statics::currentDbName;

    auto data = duckCon->con.Query("SELECT * FROM " + db.toStdString());
    int rows = data->collection.Count();
    int colidx = index.toInt();

    for(int i = 0; i < rows; i++){

        duckdb::Value colData = data->GetValue(colidx, i);
        QString newColData = QString::fromStdString(colData.ToString());

        this->colData.append(newColData);
    }

    emit duckColData(this->colData);
    this->colData.clear();
}

QStringList DuckDataModel::getColumnList(QString tableName, QString moduleName)
{
    QStringList output;
    QString fieldName;
    QString fieldType;
    QStringList outputDataList;

    auto data = duckCon->con.Query("PRAGMA table_info('"+ tableName.toStdString() +"')");
    int rows = data->collection.Count();

    for(int i = 0; i < rows; i++){
        output << data->GetValue(0, i).ToString().c_str();
        fieldName =  data->GetValue(1, i).ToString().c_str();
        fieldType =  data->GetValue(2, i).ToString().c_str();

        // Get filter data type for QML
        QString filterDataType = dataType.dataType(fieldType);
        outputDataList << fieldName << filterDataType;

        // Append all data type to allList as well
        allColumns.append(outputDataList);
        outputDataList.clear();
    }

    emit columnListObtained(allColumns, tableName, moduleName);

    return output;
}

QStringList DuckDataModel::getTableList()
{

    QStringList output;
    auto data = duckCon->con.Query("PRAGMA show_tables");
    int rows = data->collection.Count();

    for(int i = 0; i < rows; i++){
        output << data->GetValue(0, i).ToString().c_str();
    }

    return output;
}

QStringList DuckDataModel::getDbList()
{
    QStringList output;
    auto data = duckCon->con.Query("PRAGMA database_list");
    int rows = data->collection.Count();

    for(int i = 0; i < rows; i++){
        output << data->GetValue(0, i).ToString().c_str();
    }

    return output;
}

void DuckDataModel::setQuery(QString query)
{
    this->query = query;
    querySplitter.setQueryForClasses(this->query);
}

QStringList DuckDataModel::getRoles()
{
    QStringList output, outputList;
    output = querySplitter.getSelectParams();

    QRegularExpression selectListRegex(R"(SELECT\s+(.*?)\sFROM\s)", QRegularExpression::CaseInsensitiveOption);
    QRegularExpressionMatch selectIterator = selectListRegex.match(this->query);
    QString containsStar = selectIterator.captured(1);

    if(containsStar.contains("*", Qt::CaseInsensitive) == true){
        QStringList tablesList;
        tablesList << querySplitter.getMainTable();
        tablesList << querySplitter.getJoinTables();

        QString tableName;
        foreach(tableName, tablesList){
            auto data = duckCon->con.Query("PRAGMA table_info('"+ tableName.toStdString() +"')");
            int rows = data->collection.Count();
            QString fieldName;

            for(int i = 0; i < rows; i++){
                fieldName =  data->GetValue(1, i).ToString().c_str();
                outputList.append(fieldName);
            }
        }

    } else{
        outputList = output;
    }

    return outputList;
}

QList<QStringList> DuckDataModel::getQueryResult()
{
    QList<QStringList> output;
    auto result = duckCon->con.Query(this->query.toStdString());
   result->collection.Print();

    return output;
}

void DuckDataModel::getQueryStats()
{
    auto result = duckCon->con.Query("PRAGMA profiling_output");
    result->Print();
}


void DuckDataModel::receiveCsvFilterQuery(QString query)
{
    QString db = Statics::currentDbName;

    std::string newQuery = query.toStdString();
    std::string csvQuery = "SELECT * FROM " + db.toStdString() + newQuery;

    auto data = duckCon->con.Query(csvQuery);
    data->Print();
}
