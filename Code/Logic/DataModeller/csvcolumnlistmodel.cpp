#include "csvcolumnlistmodel.h"
#include "iostream"

CsvColumnListModel::CsvColumnListModel(QObject *parent) : QObject(parent),
    db(nullptr), con(db)
{

}

void CsvColumnListModel::columnCsvData(QString colName, QString index)
{

        QString db = Statics::currentDbName;
        std::string csvFile = db.toStdString();

        std::string csvdb = "'" + csvFile + "'";

        auto data = con.Query("SELECT * FROM read_csv_auto(" + csvdb + ")");

        int rows = data->collection.count;
        int colidx = index.toInt();

        for(int i = 0; i < rows; i++){

            duckdb::Value colData = data->GetValue(colidx, i);
            QString newColData = QString::fromStdString(colData.ToString());

            this->columnData.append(newColData);
        }

        emit csvColData(this->columnData);
        this->columnData.clear();
}

void CsvColumnListModel::receiveCsvFilterQuery(QString query)
{
    QString db = Statics::currentDbName;

    std::string csvFile = db.toStdString();
    std::string newQuery = query.toStdString();

    std::string csvdb = "'" + csvFile + "'";

    std::string csvQuery = "SELECT * FROM read_csv_auto(" + csvdb + ")" + newQuery;

    std::cout << csvQuery <<  " csv query " << endl;

    auto data = con.Query(csvQuery);

    data->Print();

}

