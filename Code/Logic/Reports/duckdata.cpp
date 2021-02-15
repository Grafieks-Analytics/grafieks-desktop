#include "duckdata.h"

DuckData::DuckData(QObject *parent) : QObject(parent)
{

}

DuckData::DuckData(DuckCRUD *duckCRUD, QObject *parent)
{
    Q_UNUSED(parent);
    this->duckCRUD = duckCRUD;

    QString db = Statics::currentDbName;

    auto result = this->duckCRUD->con.Query("DESCRIBE " + db.toStdString());

    int rows = result->collection.count;

    for(int i = 0 ; i < rows; i++){

        duckdb::Value fieldName = result->GetValue(0, i);
        duckdb::Value fieldType = result->GetValue(1, i);

        // string to qstring conversion
        QString newFieldName = QString::fromStdString(fieldName.ToString());
        QString newFilterType = QString::fromStdString(fieldType.ToString());

        this->colInfo.insert(newFieldName, {i, newFilterType});
    }
}


