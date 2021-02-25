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

QString DuckData::getBarChartValues(QString xAxisColumn, QString yAxisColumn, QString yAxisCalculationType)
{
    QJsonArray data;
    QJsonArray xAxisData;
    QJsonArray yAxisData;

    QString db = Statics::currentDbName;
    std::string query = " SELECT " + xAxisColumn.toStdString() + " FROM " + db.toStdString();

    auto result = this->duckCRUD->con.Query(query);

    int rows = result->collection.count;

    for(int i = 0; i < rows; i++){

        duckdb::Value value = result->GetValue(0 , i);
        QJsonValue newValue = QString::fromStdString(value.ToString());
        xAxisData.append(newValue);

    }

    query = " SELECT " + yAxisColumn.toStdString() + " FROM " + db.toStdString();
    result = this->duckCRUD->con.Query(query);
    rows  = result->collection.count;

    for(int i = 0; i < rows; i++){

        duckdb::Value value = result->GetValue(0 , i);
        QJsonValue newValue = QString::fromStdString(value.ToString());
        yAxisData.append(newValue);

    }

    QJsonArray colData;
    colData.append(xAxisData);
    colData.append(yAxisData);

    QJsonArray columns;
    columns.append(xAxisColumn);
    columns.append(yAxisColumn);


    data.append(colData);
    data.append(columns);

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson();

    return strData;
}


QString DuckData::getStackedBarChartValues(QString xAxisColumn, QString yAxisColumn, QString yAxisCalculationType, QString groupedBy)
{
    QJsonArray data;
    QJsonArray xAxisData;
    QJsonArray yAxisData;

    QString db = Statics::currentDbName;
    std::string query = " SELECT " + xAxisColumn.toStdString() + " FROM " + db.toStdString();

    auto result = this->duckCRUD->con.Query(query);

    int rows = result->collection.count;

    for(int i = 0; i < rows; i++){

        duckdb::Value value = result->GetValue(0 , i);
        QJsonValue newValue = QString::fromStdString(value.ToString());
        xAxisData.append(newValue);

    }

    query = " SELECT " + yAxisColumn.toStdString() + " FROM " + db.toStdString();
    result = this->duckCRUD->con.Query(query);
    rows  = result->collection.count;

    for(int i = 0; i < rows; i++){

        duckdb::Value value = result->GetValue(0 , i);
        QJsonValue newValue = QString::fromStdString(value.ToString());
        yAxisData.append(newValue);

    }

    QJsonArray colData;
    colData.append(xAxisData);
    colData.append(yAxisData);

    QJsonArray columns;
    columns.append(xAxisColumn);
    columns.append(yAxisColumn);


    data.append(colData);
    data.append(columns);

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson();

    return strData;
}

QString DuckData::getAreaChartValues(QString xAxisColumn, QString yAxisColumn, QString xAxisCalculationType, QString yAxisCalculationType)
{
    QJsonArray data;
    QJsonArray colData;

    QString db = Statics::currentDbName;

    std::string query = " SELECT " + xAxisColumn.toStdString() + " FROM " + db.toStdString();
    auto resultX = this->duckCRUD->con.Query(query);

    query = " SELECT " + yAxisColumn.toStdString() + " FROM " + db.toStdString();
    auto resultY = this->duckCRUD->con.Query(query);

    int rows = resultX->collection.count;
    for(int i = 0; i < rows; i++){

        duckdb::Value valueX = resultX->GetValue(0 , i);
        duckdb::Value valueY = resultY->GetValue(0, i);

        QJsonArray axisData;
        QJsonValue newValueX = QString::fromStdString(valueX.ToString());
        QJsonValue newValueY = QString::fromStdString(valueY.ToString());

        axisData.append(newValueX);
        axisData.append(newValueY);
        colData.append(axisData);

    }

    QJsonArray columns;
    columns.append(xAxisColumn);
    columns.append(yAxisColumn);


    data.append(colData);
    data.append(columns);

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson();
    return strData;
}

QString DuckData::getLineChartValues(QString xAxisColumn, QString yAxisColumn, QString xAxisCalculationType, QString yAxisCalculationType)
{
    QJsonArray data;
    QJsonArray colData;

    QString db = Statics::currentDbName;

    std::string query = " SELECT " + xAxisColumn.toStdString() + " FROM " + db.toStdString();
    auto resultX = this->duckCRUD->con.Query(query);

    query = " SELECT " + yAxisColumn.toStdString() + " FROM " + db.toStdString();
    auto resultY = this->duckCRUD->con.Query(query);

    int rows = resultX->collection.count;
    for(int i = 0; i < rows; i++){

        duckdb::Value valueX = resultX->GetValue(0 , i);
        duckdb::Value valueY = resultY->GetValue(0, i);

        QJsonArray axisData;
        QJsonValue newValueX = QString::fromStdString(valueX.ToString());
        QJsonValue newValueY = QString::fromStdString(valueY.ToString());

        axisData.append(newValueX);
        axisData.append(newValueY);
        colData.append(axisData);

    }

    QJsonArray columns;
    columns.append(xAxisColumn);
    columns.append(yAxisColumn);

    data.append(colData);
    data.append(columns);

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson();
    return strData;
}

QString DuckData::getPieChartValues(QString xAxisColumn, QString yAxisColumn, QString yAxisCalculationType)
{
    QJsonArray data;
    QJsonObject obj;

    QString db = Statics::currentDbName;

    std::string query = " SELECT " + xAxisColumn.toStdString() + " FROM " + db.toStdString();
    auto resultX = this->duckCRUD->con.Query(query);

    query = " SELECT " + yAxisColumn.toStdString() + " FROM " + db.toStdString();
    auto resultY = this->duckCRUD->con.Query(query);

    int rows = resultX->collection.count;
    for(int i = 0; i < rows; i++){

        duckdb::Value valueX = resultX->GetValue(0 , i);
        duckdb::Value valueY = resultY->GetValue(0, i);

        QString newValueX = QString::fromStdString(valueX.ToString());
        QJsonValue newValueY = QString::fromStdString(valueY.ToString());
        obj.insert(newValueX, newValueY);

    }

    QJsonDocument doc;
    doc.setObject(obj);

    QString strData = doc.toJson();
    return strData;
}

QString DuckData::getFunnelChartValues(QString xAxisColumn, QString yAxisColumn, QString yAxisCalculationType)
{
    QJsonArray data;
    QJsonArray axisData;

    QString db = Statics::currentDbName;

    std::string query = " SELECT " + xAxisColumn.toStdString() + " FROM " + db.toStdString();
    auto resultX = this->duckCRUD->con.Query(query);

    query = " SELECT " + yAxisColumn.toStdString() + " FROM " + db.toStdString();
    auto resultY = this->duckCRUD->con.Query(query);

    int rows = resultX->collection.count;
    for(int i = 0; i < rows; i++){

        duckdb::Value valueX = resultX->GetValue(0 , i);
        duckdb::Value valueY = resultY->GetValue(0, i);

        QJsonObject obj;

        QJsonValue newValueX = QString::fromStdString(valueX.ToString());
        QJsonValue newValueY = QString::fromStdString(valueY.ToString());
        obj.insert("key", newValueX);
        obj.insert("value", newValueY);
        axisData.append(obj);

    }

    data.append(axisData);

    QJsonArray columns;
    columns.append(xAxisColumn);
    columns.append(yAxisColumn);

    data.append(columns);

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson();
    return strData;
}

QString DuckData::getRadarChartValues(QString xAxisColumn, QString yAxisColumn, QString yAxisCalculationType)
{
    QJsonArray data;
    QJsonArray xAxisData;
    QJsonArray yAxisData;

    QString db = Statics::currentDbName;
    std::string query = " SELECT " + xAxisColumn.toStdString() + " FROM " + db.toStdString();

    auto result = this->duckCRUD->con.Query(query);

    int rows = result->collection.count;

    for(int i = 0; i < rows; i++){

        duckdb::Value value = result->GetValue(0 , i);
        QJsonValue newValue = QString::fromStdString(value.ToString());
        xAxisData.append(newValue);

    }

    query = " SELECT " + yAxisColumn.toStdString() + " FROM " + db.toStdString();
    result = this->duckCRUD->con.Query(query);
    rows  = result->collection.count;

    for(int i = 0; i < rows; i++){

        duckdb::Value value = result->GetValue(0 , i);
        QJsonValue newValue = QString::fromStdString(value.ToString());
        yAxisData.append(newValue);

    }

    QJsonArray colData;
    colData.append(xAxisData);
    colData.append(yAxisData);

    QJsonArray columns;
    columns.append(xAxisColumn);
    columns.append(yAxisColumn);


    data.append(colData);
    data.append(columns);

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson();

    return strData;
}

QString DuckData::getScatterChartValues(QString xAxisColumn, QString yAxisColumn, QString xAxisCalculationType, QString yAxisCalculationType, QString groupedBy)
{
    QJsonArray data;
    QJsonArray xAxisData;
    QJsonArray yAxisData;

    QString db = Statics::currentDbName;
    std::string query = " SELECT " + xAxisColumn.toStdString() + " FROM " + db.toStdString();

    auto result = this->duckCRUD->con.Query(query);

    int rows = result->collection.count;

    for(int i = 0; i < rows; i++){

        duckdb::Value value = result->GetValue(0 , i);
        QJsonValue newValue = QString::fromStdString(value.ToString());
        xAxisData.append(newValue);

    }

    query = " SELECT " + yAxisColumn.toStdString() + " FROM " + db.toStdString();
    result = this->duckCRUD->con.Query(query);
    rows  = result->collection.count;

    for(int i = 0; i < rows; i++){

        duckdb::Value value = result->GetValue(0 , i);
        QJsonValue newValue = QString::fromStdString(value.ToString());
        yAxisData.append(newValue);

    }

    QJsonArray colData;
    colData.append(xAxisData);
    colData.append(yAxisData);

    QJsonArray columns;
    columns.append(xAxisColumn);
    columns.append(yAxisColumn);


    data.append(colData);
    data.append(columns);

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson();

    return strData;
}

QString DuckData::getHeatMapChartValues(QString xAxisColumn, QString yAxisColumn, QString groupedBy)
{
    QJsonArray data;
    QJsonArray xAxisData;
    QJsonArray yAxisData;

    QString db = Statics::currentDbName;
    std::string query = " SELECT " + xAxisColumn.toStdString() + " FROM " + db.toStdString();

    auto result = this->duckCRUD->con.Query(query);

    int rows = result->collection.count;

    for(int i = 0; i < rows; i++){

        duckdb::Value value = result->GetValue(0 , i);
        QJsonValue newValue = QString::fromStdString(value.ToString());
        xAxisData.append(newValue);

    }

    query = " SELECT " + yAxisColumn.toStdString() + " FROM " + db.toStdString();
    result = this->duckCRUD->con.Query(query);
    rows  = result->collection.count;

    for(int i = 0; i < rows; i++){

        duckdb::Value value = result->GetValue(0 , i);
        QJsonValue newValue = QString::fromStdString(value.ToString());
        yAxisData.append(newValue);

    }

    QJsonArray colData;
    colData.append(xAxisData);
    colData.append(yAxisData);

    QJsonArray columns;
    columns.append(xAxisColumn);
    columns.append(yAxisColumn);


    data.append(colData);
    data.append(columns);

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson();

    return strData;
}


