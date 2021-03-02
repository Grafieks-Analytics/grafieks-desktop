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
        qDebug() << "JSON ENTERER";
        csvFile = jsonToCsv.convertJsonToCsv(Statics::currentDbName).toStdString();

        csvdb      = "'" + csvFile + "'";
        Statics::currentDbName = fileName;
        con.Query("CREATE TABLE " + table.toStdString() + " AS SELECT * FROM read_csv_auto(" + csvdb + ")");

    } else if(fileExtension.toLower() == "xls" || fileExtension.toLower() == "xlsx"){
        qDebug() << "Sheet name" << Statics::currentDbName;
        excelSheetsList = excelToCsv.convertExcelToCsv(Statics::currentDbName);

        for ( const QString& csvFile : excelSheetsList  ) {

            csvdb      = "'" + csvFile.toStdString() + "'";
            Statics::currentDbName = fileName;
            con.Query("CREATE TABLE " + table.toStdString() + " AS SELECT * FROM read_csv_auto(" + csvdb + ")");
        }

    } else{
        csvdb      = "'" + csvFile + "'";
        Statics::currentDbName = fileName;
        con.Query("CREATE TABLE " + table.toStdString() + " AS SELECT * FROM read_csv_auto(" + csvdb + ")");
    }
}


