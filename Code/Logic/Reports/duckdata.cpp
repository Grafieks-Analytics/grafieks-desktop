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

void DuckData::getBarChartValues(QString xAxisColumn, QString yAxisColumn, QString yAxisCalculationType)
{

}

void DuckData::getStackedBarChartValues(QString xAxisColumn, QString yAxisColumn, QString yAxisCalculationType, QString groupedBy)
{

}

void DuckData::getAreaChartValues(QString xAxisColumn, QString yAxisColumn, QString xAxisCalculationType, QString yAxisCalculationType)
{

}

void DuckData::getLineChartValues(QString xAxisColumn, QString xAxisCalculationType, QString yAxisColumn, QString yAxisCalculationType)
{

}

void DuckData::getPieChartValues(QString xAxisColumn, QString yAxisColumn, QString yAxisCalculationType)
{

}

void DuckData::getFunnelChartValues(QString xAxisColumn, QString yAxisColumn, QString yAxisCalculationType)
{

}

void DuckData::getRadarChartValues(QString xAxisColumn, QString yAxisColumn, QString yAxisCalculationType)
{

}

void DuckData::getScatterChartValues(QString xAxisColumn, QString yAxisColumn, QString xAxisCalculationType, QString yAxisCalculationType, QString groupedBy)
{

}

void DuckData::getHeatMapChartValues(QString xAxisColumn, QString yAxisColumn, QString groupedBy)
{

}


