#include "duckcon.h"

DuckCon::DuckCon(QObject *parent) : QObject(parent),
    db(nullptr), con(db)
{
    // Excel
    connect(&threadExcel, &QThread::started, &excelToCsv, &ExcelCon::convertExcelToCsv, Qt::QueuedConnection);
    connect(&excelToCsv, &ExcelCon::convertedExcelPaths, this, &DuckCon::convertedExcelPaths, Qt::QueuedConnection);

    // CSV
//    connect(&threadCsv, &QThread::started, this, &DuckCon::convertedCsvPath, Qt::QueuedConnection);

    // JSON
    connect(&threadJson, &QThread::started, &jsonToCsv, &JsonCon::convertJsonToCsv, Qt::QueuedConnection);
    connect(&jsonToCsv, &JsonCon::convertedJsonPaths, this, &DuckCon::convertedJsonPaths, Qt::QueuedConnection);
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
    this->excelSheetsList = paths;


    QString table = "";
    QString db = Statics::currentDbName;
    std::string csvFile    = db.toStdString();

    QString fileName       = QFileInfo(db).baseName().toLower();
    std::string csvdb       = "";
    bool errorStatus = false;

    QString fileExtension = QFileInfo(db).completeSuffix();

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

    threadExcel.quit();

    emit excelLoginStatus(this->response, this->directLogin);

    if(errorStatus == true){
        emit importError("File format is not valid UTF-8. Please provide a valid UTF-8 file", "excel");
    }

}

void DuckCon::convertedCsvPath()
{
    bool errorStatus = false;
    QString table = "";
    QString db = Statics::currentDbName;
    std::string csvFile    = db.toStdString();

    QString fileName       = QFileInfo(db).baseName().toLower();
    std::string csvdb       = "";

    QString fileExtension = QFileInfo(db).completeSuffix();

    fileName = fileName.remove(QRegularExpression("[^A-Za-z0-9]"));
    table = fileName;

    csvdb = "'" + csvFile + "'";
    Statics::currentDbName = fileName;
    std::unique_ptr<duckdb::MaterializedQueryResult> res = con.Query("CREATE TABLE " + table.toStdString() + " AS SELECT * FROM read_csv_auto(" + csvdb + ", HEADER=TRUE)");
    if(res->error.empty() == false){
        errorStatus = true;
        qWarning() << Q_FUNC_INFO << "CSV import issue" << res->error.c_str();
    } else{
        this->tables.append(table);
        res.release();
    }

    emit csvLoginStatus(this->response, this->directLogin);

    if(errorStatus == true){
        emit importError("File format is not valid UTF-8. Please provide a valid UTF-8 file", "csv");
    }
}

void DuckCon::convertedJsonPaths(QString path)
{

    QString table = "";
    QString db = Statics::currentDbName;
    std::string csvFile    = path.toStdString();

    QString fileName       = QFileInfo(db).baseName().toLower();
    std::string csvdb       = "";

    QString fileExtension = QFileInfo(db).completeSuffix();

    fileName = fileName.remove(QRegularExpression("[^A-Za-z0-9]"));
    table = fileName;

    csvdb = "'" + csvFile + "'";
    Statics::currentDbName = fileName;
    std::unique_ptr<duckdb::MaterializedQueryResult> res = con.Query("CREATE TABLE " + table.toStdString() + " AS SELECT * FROM read_csv_auto(" + csvdb + ", HEADER=TRUE)");

    if(res->error.empty() == false){
        emit importError("Please select a valid JSON format and remove special characters from input file", "json");
        qWarning() << Q_FUNC_INFO << "JSON import issue" << res->error.c_str();
    } else{
        this->tables.append(table);
        res.release();
    }

    emit jsonLoginStatus(this->response, this->directLogin);
    threadJson.quit();
}



void DuckCon::createTable(QString dbName, bool directLogin, QVariantMap response){

    this->directLogin = directLogin;
    this->response = response;

    QString db = Statics::currentDbName;
    QString fileName       = QFileInfo(db).baseName().toLower();
    QString fileExtension = QFileInfo(db).completeSuffix();
    fileName = fileName.remove(QRegularExpression("[^A-Za-z0-9]"));

    if(fileName.trimmed().length() > 0){
        if(fileExtension.toLower() == "json"){

            jsonToCsv.moveToThread(&threadJson);
            threadJson.start();

        } else if(fileExtension.toLower() == "xls" || fileExtension.toLower() == "xlsx"){

            excelToCsv.moveToThread(&threadExcel);
            threadExcel.start();

        } else{
//            moveToThread(&threadCsv);
//            threadCsv.start();
            convertedCsvPath();
        }

    }

}
