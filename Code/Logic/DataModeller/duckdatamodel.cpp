#include "duckdatamodel.h"

DuckDataModel::DuckDataModel(QObject *parent) : QObject(parent)
{

}

DuckDataModel::DuckDataModel(DuckCon *duckCon, QObject *parent)
{
    Q_UNUSED(parent);
    this->duckCon = duckCon;
}

void DuckDataModel::clearData()
{
    this->colData.clear();

    this->allColumns.clear();
    this->tables.clear();
    duckCon->disconnect();
}

DuckDataModel::~DuckDataModel()
{
    this->allColumns.clear();
    this->colData.clear();

    this->duckCon->disconnect();
}


void DuckDataModel::columnData(QString col, QString tableName, QString options)
{
    QStringList output;
    output = this->getData("SELECT DISTINCT \"" + col + "\" FROM " + tableName);
    emit columnListModelDataChanged(output, options);
}

void DuckDataModel::columnSearchData(QString col, QString tableName, QString searchString, QString options)
{
    QStringList output;
    output = this->getData("SELECT DISTINCT \"" + col + "\" FROM "+ tableName + " WHERE \"" + col + "\" LIKE '%"+searchString+"%'");
    emit columnListModelDataChanged(output, options);
}

QStringList DuckDataModel::getColumnList(QString tableName, QString moduleName)
{
    QStringList output;
    QString fieldName;
    QString fieldType;
    QStringList outputDataList;


    auto data = duckCon->con.Query("PRAGMA table_info('"+ tableName.toStdString() +"')");
    if(!data->error.empty()){
        qWarning() << Q_FUNC_INFO << data->error.c_str();
    } else{

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
    }

    return output;
}

QStringList DuckDataModel::getTableList()
{

    QStringList output;

    switch (Statics::currentDbIntType) {

    case Constants::excelIntType:{
        auto data = duckCon->con.Query("PRAGMA show_tables");
        if(!data->error.empty()){
            qWarning() << Q_FUNC_INFO << data->error.c_str();
        }else {

            int rows = data->collection.Count();

            for(int i = 0; i < rows; i++){
                output << data->GetValue(0, i).ToString().c_str();
            }
        }
        break;
    }

    case Constants::jsonIntType:
    case Constants::csvIntType:{
        output << Statics::currentDbName;
        break;

    }
    }

    this->tables = output;
    return this->tables;
}

QStringList DuckDataModel::filterTableList(QString keyword)
{
    return this->tables.filter(keyword);
}

QStringList DuckDataModel::getDbList()
{
    QStringList output;
    auto data = duckCon->con.Query("PRAGMA database_list");
    if(!data->error.empty()){
        qWarning() << Q_FUNC_INFO << data->error.c_str();
    } else{

        int rows = data->collection.Count();

        for(int i = 0; i < rows; i++){
            output << data->GetValue(0, i).ToString().c_str();
        }
    }

    return output;
}



QStringList DuckDataModel::getData(QString query)
{
    QString db = Statics::currentDbName;
    QStringList out;

    auto data = duckCon->con.Query(query.toStdString());
    if(!data->error.empty()){
        qWarning() << Q_FUNC_INFO << data->error.c_str();
    } else{

        int rows = data->collection.Count();

        for(int i = 0; i < rows; i++){

            duckdb::Value colData = data->GetValue(0, i);
            QString newColData = QString::fromStdString(colData.ToString());

            this->colData.append(newColData);
        }

        out = this->colData;
        emit duckColData(this->colData);
        this->colData.clear();
    }
    return out;
}
