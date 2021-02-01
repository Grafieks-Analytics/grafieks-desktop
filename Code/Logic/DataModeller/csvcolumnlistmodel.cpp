#include "csvcolumnlistmodel.h"

CsvColumnListModel::CsvColumnListModel(QObject *parent) : QObject(parent),
    db(nullptr), con(db)
{

}

void CsvColumnListModel::columnCsvData(QString colName, QString index)
{
        qDebug() << colName << "column name";

        QString db = Statics::currentDbName;
        std::string csvFile = db.toStdString();

        std::string csvdb = "'" + csvFile + "'";

        auto data = con.Query("SELECT * FROM read_csv_auto(" + csvdb + ")");

        int rows = data->collection.count;
        int colidx = index.toInt();
        qDebug() << colidx << "Index column";
        for(int i = 0; i < rows; i++){

            duckdb::Value colData = data->GetValue(colidx, i);
            QString newColData = QString::fromStdString(colData.ToString());

            qDebug() << newColData << " COl data";

            this->columnData.append(newColData);
        }
        emit csvColData(this->columnData);
        this->columnData.clear();
}

