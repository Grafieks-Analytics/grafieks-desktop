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

    QString fileName       = QFileInfo(db).baseName().toLower();
    std::string csvdb       = "";

    QString fileExtension = QFileInfo(db).completeSuffix();
    qDebug() << fileName << fileExtension << "DUCK FILE INFO";


    fileName = fileName.remove(QRegularExpression("[^A-Za-z0-9]"));
    table = fileName;

    if(fileExtension.toLower() == "json"){
        csvFile = jsonToCsv.convertJsonToCsv(Statics::currentDbName).toStdString();

        csvdb = "'" + csvFile + "'";
        Statics::currentDbName = fileName;
        std::unique_ptr<duckdb::MaterializedQueryResult> res = con.Query("CREATE TABLE " + table.toStdString() + " AS SELECT * FROM read_csv_auto(" + csvdb + ", HEADER=TRUE)");

        if(res->error.empty() == false){
            emit importError("Please select a valid JSON format and remove special characters from input file");
            qWarning() << "JSON import issue" << res->error.c_str();
        }
        res.release();

    } else if(fileExtension.toLower() == "xls" || fileExtension.toLower() == "xlsx"){
        excelSheetsList = excelToCsv.convertExcelToCsv(Statics::currentDbName);


        for ( const QString& csvFile : excelSheetsList  ) {
            csvdb = "'" + (csvFile + ".csv").toStdString() + "'";
            QFileInfo fi(csvdb.c_str());
            Statics::currentDbName = fileName;
            std::unique_ptr<duckdb::MaterializedQueryResult> res = con.Query("CREATE TABLE " + fi.baseName().toStdString() + " AS SELECT * FROM read_csv_auto(" + csvdb + ", HEADER=TRUE)");
            qDebug() << res->error.c_str();
            if(res->error.empty() == false){
                emit importError("Please remove special characters from input Excel file");
                qWarning() << "Excel import issue" << res->error.c_str();
                break;
            }
            res.release();
        }

    } else{
        csvdb = "'" + csvFile + "'";
        Statics::currentDbName = fileName;
        std::unique_ptr<duckdb::MaterializedQueryResult> res = con.Query("CREATE TABLE " + table.toStdString() + " AS SELECT * FROM read_csv_auto(" + csvdb + ", HEADER=TRUE)");
        if(res->error.empty() == false){
            emit importError("Please remove special characters from input CSV file");
            qWarning() << "CSV import issue" << res->error.c_str();
        }
        res.release();
    }

}
