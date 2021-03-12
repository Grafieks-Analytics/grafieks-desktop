#include "duckdatamodel.h"

DuckDataModel::DuckDataModel(QObject *parent) : QObject(parent)
{

}

DuckDataModel::DuckDataModel(DuckCon *duckCon, QObject *parent)
{
    this->duckCon = duckCon;
}


void DuckDataModel::columnData(QString col, QString tableName)
{

    qDebug() << col << tableName << "DUCK CALL";
    QString db = Statics::currentDbName;

    auto data = duckCon->con.Query("SELECT " + col.toStdString() + " FROM " + tableName.toStdString());
    int rows = data->collection.Count();

    for(int i = 0; i < rows; i++){

        duckdb::Value colData = data->GetValue(0, i);
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

    switch (Statics::currentDbIntType) {

    case Constants::excelIntType:{
        auto data = duckCon->con.Query("PRAGMA show_tables");
        int rows = data->collection.Count();

        for(int i = 0; i < rows; i++){
            output << data->GetValue(0, i).ToString().c_str();
        }
        break;
    }

    case Constants::jsonIntType:
    case Constants::csvIntType:{
        output << Statics::currentDbName;
        break;

    }
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



void DuckDataModel::receiveCsvFilterQuery(QString query)
{
    QString db = Statics::currentDbName;

    std::string newQuery = query.toStdString();
    std::string csvQuery = "SELECT * FROM " + db.toStdString() + newQuery;

    auto data = duckCon->con.Query(csvQuery);
    data->Print();
}
