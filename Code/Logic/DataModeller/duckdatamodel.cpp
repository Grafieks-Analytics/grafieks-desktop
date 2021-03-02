#include "duckdatamodel.h"

DuckDataModel::DuckDataModel(QObject *parent) : QObject(parent),
    db(nullptr), con(db)
{

}

void DuckDataModel::columnData(QString col, QString index)
{

    QString db = Statics::currentDbName;
    qDebug() << "LISTING" << db;

    auto data = con.Query("SELECT * FROM " + db.toStdString());
    int rows = data->collection.count;
    int colidx = index.toInt();

    for(int i = 0; i < rows; i++){

        duckdb::Value colData = data->GetValue(colidx, i);
        QString newColData = QString::fromStdString(colData.ToString());

        this->colData.append(newColData);
    }

    emit csvColData(this->colData);
    this->colData.clear();
}


void DuckDataModel::receiveCsvFilterQuery(QString query)
{
    QString db = Statics::currentDbName;

    std::string newQuery = query.toStdString();
    std::string csvQuery = "SELECT * FROM " + db.toStdString() + newQuery;

    auto data = con.Query(csvQuery);
    data->Print();
}
