#include "duckcon.h"

DuckCon::DuckCon(QObject *parent) : QObject(parent),
    db(nullptr), con(db)
{
    // IMPORTANT
    // Multithreaded signal and slots only
    // All main thread signal and slots are written in main.cpp

    connect(&thread, &QThread::started, &excelToCsv, &ExcelCon::convertExcelToCsv, Qt::QueuedConnection);
    connect(&excelToCsv, &ExcelCon::convertedExcelPaths, this, &DuckCon::convertedExcelPaths, Qt::QueuedConnection);
    connect(&thread2, &QThread::started, this, &DuckCon::processThis, Qt::QueuedConnection);
    connect(&thread2, &QThread::finished, this, &DuckCon::processThat, Qt::QueuedConnection);

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

void DuckCon::convertedExcelPaths(QStringList paths)
{
    qDebug() << "CONV EXCEL PATHS" << paths;
    this->excelSheetsList = paths;

    emit test();
    thread.quit();

    moveToThread(&thread2);
    thread2.start();
}

void DuckCon::processThis()
{

    QString table = "";
    QString db = Statics::currentDbName;
    std::string csvFile    = db.toStdString();

    QString fileName       = QFileInfo(db).baseName().toLower();
    std::string csvdb       = "";

    QString fileExtension = QFileInfo(db).completeSuffix();
    qDebug() << fileName << fileExtension << db << "DUCK FILE INFO`";


    fileName = fileName.remove(QRegularExpression("[^A-Za-z0-9]"));
    table = fileName;

    for ( const QString& csvFile : this->excelSheetsList  ) {

        csvdb = "'" + (csvFile + ".csv").toStdString() + "'";
        QFileInfo fi(csvdb.c_str());
        Statics::currentDbName = fileName;
        std::unique_ptr<duckdb::MaterializedQueryResult> res = con.Query("CREATE TABLE " + fi.baseName().toStdString() + " AS SELECT * FROM read_csv_auto(" + csvdb + ", HEADER=TRUE)");

        if(res->error.empty() == false){
            errorStatus = true;
            qWarning() << Q_FUNC_INFO << "Excel import issue" << res->error.c_str();
            break;
        } else{
            this->tables.append(fi.baseName());
            res.release();
        }
    }

    thread2.quit();
}

void DuckCon::processThat()
{
    emit excelLoginStatus(this->response, this->directLogin);

    if(this->errorStatus == true){
        emit importError("File format is not valid UTF-8. Please provide a valid UTF-8 file", "excel");
    }
}



void DuckCon::createTable(QString dbName, bool directLogin, QVariantMap response){


    this->directLogin = directLogin;
    this->response = response;

    QString table = "";
    QString db = Statics::currentDbName;
    std::string csvFile    = db.toStdString();

    QString fileName       = QFileInfo(db).baseName().toLower();
    std::string csvdb       = "";
    bool errorStatus = false;

    QString fileExtension = QFileInfo(db).completeSuffix();
    qDebug() << fileName << fileExtension << db << "DUCK FILE INFO`";


    fileName = fileName.remove(QRegularExpression("[^A-Za-z0-9]"));
    table = fileName;

    if(fileName.trimmed().length() > 0){
        if(fileExtension.toLower() == "json"){
//            csvFile = jsonToCsv.convertJsonToCsv(Statics::currentDbName).toStdString();

//            csvdb = "'" + csvFile + "'";
//            Statics::currentDbName = fileName;
//            std::unique_ptr<duckdb::MaterializedQueryResult> res = con.Query("CREATE TABLE " + table.toStdString() + " AS SELECT * FROM read_csv_auto(" + csvdb + ", HEADER=TRUE)");

//            if(res->error.empty() == false){
//                emit importError("Please select a valid JSON format and remove special characters from input file", "json");
//                qWarning() << Q_FUNC_INFO << "JSON import issue" << res->error.c_str();
//            } else{
//                this->tables.append(table);
//                res.release();
//            }


        } else if(fileExtension.toLower() == "xls" || fileExtension.toLower() == "xlsx"){

            excelToCsv.moveToThread(&thread);
            thread.start();

        } else{
            csvdb = "'" + csvFile + "'";
            Statics::currentDbName = fileName;
            std::unique_ptr<duckdb::MaterializedQueryResult> res = con.Query("CREATE TABLE " + table.toStdString() + " AS SELECT * FROM read_csv_auto(" + csvdb + ", HEADER=TRUE)");
            if(res->error.empty() == false){
                emit importError("File format is not valid UTF-8. Please provide a valid UTF-8 file", "csv");
                qWarning() << Q_FUNC_INFO << "CSV import issue" << res->error.c_str();
            } else{
                this->tables.append(table);
                res.release();
            }
        }

    }

}
