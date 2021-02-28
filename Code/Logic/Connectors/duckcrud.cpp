#include "duckcrud.h"

DuckCRUD::DuckCRUD(QObject *parent) : QObject(parent),
    db(nullptr), con(db)
{

}

void DuckCRUD::createTable(){

    QString db = Statics::currentDbName;
    std::string csvFile    = db.toStdString();
    qDebug() << "DB Name" << db;

    QString fileName       = QFileInfo(db).baseName();
    std::string table      = fileName.toStdString();

    QString fileExtension = QFileInfo(db).completeSuffix();

    if(fileExtension.toLower() == "json"){
       csvFile = jsonToCsv.convertJsonToCsv(Statics::currentDbName).toStdString();

    } else if(fileExtension.toLower() == "xls" || fileExtension.toLower() == "xlsx"){

        csvFile = excelToCsv.convertExcelToCsv(fileName).toStdString();
    }


    std::string csvdb      = "'" + csvFile + "'";
    Statics::currentDbName = fileName;

    qDebug() << csvdb.c_str() << "final db";

    con.Query("CREATE TABLE " + table + " AS SELECT * FROM read_csv_auto(" + csvdb + ")");
//    con.Query("CREATE TABLE table AS SELECT * FROM read_csv_auto('C:\\Users\\chill\\Desktop\\last.csv')");
}

void DuckCRUD::columnData(QString colName, QString index)
{
    Q_UNUSED(colName);

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

void DuckCRUD::receiveCsvFilterQuery(QString query)
{
    QString db = Statics::currentDbName;

    std::string newQuery = query.toStdString();
    std::string csvQuery = "SELECT * FROM " + db.toStdString() + newQuery;

    auto data = con.Query(csvQuery);
    data->Print();

}

