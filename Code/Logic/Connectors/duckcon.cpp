#include "duckcon.h"

DuckCon::DuckCon(QObject *parent) : QObject(parent),
    db(nullptr), con(db)
{

}

DuckCon::~DuckCon()
{

}

void DuckCon::createTable(){

    QStringList excelSheetsList;
    QString table = "";
    QString db = Statics::currentDbName;
    std::string csvFile    = db.toStdString();

    QString fileName       = QFileInfo(db).baseName();
    std::string csvdb       = "";

    QString fileExtension = QFileInfo(db).completeSuffix();


    for(int i = 0; i < fileName.length(); i++){

        if(fileName[i].isLetter() || fileName[i].isDigit()){
             table.append(fileName[i]);
        }
    }

    if(fileExtension.toLower() == "json"){
        csvFile = jsonToCsv.convertJsonToCsv(Statics::currentDbName).toStdString();

        csvdb = "'" + csvFile + "'";
        Statics::currentDbName = fileName;
        con.Query("CREATE TABLE " + table.toStdString() + " AS SELECT * FROM read_csv_auto(" + csvdb + ")");

    } else if(fileExtension.toLower() == "xls" || fileExtension.toLower() == "xlsx"){
        excelSheetsList = excelToCsv.convertExcelToCsv(Statics::currentDbName);

        for ( const QString& csvFile : excelSheetsList  ) {
            csvdb = "'" + (csvFile + ".csv").toStdString() + "'";
            Statics::currentDbName = fileName;
           unique_ptr<duckdb::MaterializedQueryResult> res2 = con.Query("CREATE TABLE " + table.toStdString() + " AS SELECT * FROM read_csv_auto(" + csvdb + ")");
            res2->Print();
        }

    } else{
        csvdb = "'" + csvFile + "'";
        Statics::currentDbName = fileName;
        con.Query("CREATE TABLE " + table.toStdString() + " AS SELECT * FROM read_csv_auto(" + csvdb + ")");
    }

    unique_ptr<duckdb::MaterializedQueryResult> res = con.Query("PRAGMA show_tables");
    res->Print();
}


