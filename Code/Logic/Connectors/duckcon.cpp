#include "duckcon.h"

DuckCon::DuckCon(QObject *parent) : QObject(parent),
    db(nullptr), con(db)
{

}

void DuckCon::dropTables()
{
    for ( QString tableName : this->tables  ) {
        std::string table =  tableName.toStdString();

        std::unique_ptr<duckdb::MaterializedQueryResult> res = con.Query("DROP TABLE " + table);
        if(res->error.empty() == false){
            qWarning() << "Issue deleting Duck table" << table.c_str() << res->error.c_str();
        } else{
            res.release();
        }
    }
}



void DuckCon::createTable(){

    QStringList excelSheetsList;
    QString table = "";
    QString db = Statics::currentDbName;
    std::string csvFile    = db.toStdString();

    QString fileName       = QFileInfo(db).baseName().toLower();
    std::string csvdb       = "";
    bool errorStatus = false;

    QString fileExtension = QFileInfo(db).completeSuffix();
    qDebug() << fileName << fileExtension << "DUCK FILE INFO`";


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
        } else{
            this->tables.append(table);
            res.release();
        }


    } else if(fileExtension.toLower() == "xls" || fileExtension.toLower() == "xlsx"){
        excelSheetsList = excelToCsv.convertExcelToCsv(Statics::currentDbName);


        for ( const QString& csvFile : excelSheetsList  ) {
            csvdb = "'" + (csvFile + ".csv").toStdString() + "'";
            QFileInfo fi(csvdb.c_str());
            Statics::currentDbName = fileName;
            std::unique_ptr<duckdb::MaterializedQueryResult> res = con.Query("CREATE TABLE " + fi.baseName().toStdString() + " AS SELECT * FROM read_csv_auto(" + csvdb + ", HEADER=TRUE)");

            if(res->error.empty() == false){
                errorStatus = true;
                qWarning() << "Excel import issue" << res->error.c_str();
                break;
            } else{
                this->tables.append(fi.baseName());
                res.release();
            }
        }

        if(errorStatus == true){
            emit importError("Please remove special characters from input Excel file");
        }

    } else{
        csvdb = "'" + csvFile + "'";
        Statics::currentDbName = fileName;
        std::unique_ptr<duckdb::MaterializedQueryResult> res = con.Query("CREATE TABLE " + table.toStdString() + " AS SELECT * FROM read_csv_auto(" + csvdb + ", HEADER=TRUE)");
        if(res->error.empty() == false){
            emit importError("Please remove special characters from input CSV file");
            qWarning() << "CSV import issue" << res->error.c_str();
        } else{
            this->tables.append(table);
            res.release();
        }
    }

}
