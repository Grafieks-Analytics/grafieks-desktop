#include "duckcon.h"

DuckCon::DuckCon(QObject *parent) : QObject(parent),
    db(nullptr), con(db)
{

}

//DuckCon::~DuckCon()
//{

//}


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
            QFileInfo fi(csvdb.c_str());
            std::unique_ptr<duckdb::MaterializedQueryResult> res2 = con.Query("CREATE TABLE " + fi.baseName().toStdString() + " AS SELECT * FROM read_csv_auto(" + csvdb + ")");
            qDebug() << "ERROR HAPP" <<res2->error.c_str() << res2->error.empty();
        }

    } else{
        csvdb = "'" + csvFile + "'";
        Statics::currentDbName = fileName;
        con.Query("CREATE TABLE " + table.toStdString() + " AS SELECT * FROM read_csv_auto(" + csvdb + ")");
    }

}


