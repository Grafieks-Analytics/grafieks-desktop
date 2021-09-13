#include "duckthread.h"

DuckThread::DuckThread(duckdb::DuckDB *db, duckdb::Connection *con, QObject *parent) : QObject(parent)
{
    this->con = con;
    this->db = db;

    fileType = "";
    errorStatus = false;
}

void DuckThread::start()
{
    qDebug() << "DuckThread started";
}

void DuckThread::processFile(QString fileType)
{
    if(fileType == "excel"){
        this->processExcel();
    } else if(fileType == "json"){
        this->processJson();
    } else {
        this->processCsv();
    }
}

void DuckThread::passExcelParams(QStringList excelSheetsList)
{
    this->excelSheetsList = excelSheetsList;
}

void DuckThread::passJsonParams(QString jsonPath)
{
    this->jsonPath = jsonPath;
}

void DuckThread::processCsv()
{
    this->fileType = "csv";

    QString table = "";
    QString db = Statics::currentDbName;
    std::string csvFile    = db.toStdString();

    QString fileName       = QFileInfo(db).baseName().toLower();
    std::string csvdb       = "";

    QString fileExtension = QFileInfo(db).completeSuffix();

    fileName = fileName.remove(QRegularExpression("[^A-Za-z0-9]"));
    table = fileName;

    csvdb = "'" + csvFile + "'";
//    Statics::currentDbName = fileName;
//    std::unique_ptr<duckdb::MaterializedQueryResult> res = con->Query("CREATE TABLE " + table.toStdString() + " AS SELECT * FROM read_csv_auto(" + csvdb + ", HEADER=TRUE)");

//    if(res->error.empty() == false){
//        this->errorStatus = true;
//        qWarning() << Q_FUNC_INFO << "CSV import issue" << res->error.c_str();
//    } else{
//        this->tables.append(table);
//        res.release();
//    }

    QStringList dbs;
    dbs.append(db);
    emit processingFinished(this->fileType, this->errorStatus, dbs);
}

void DuckThread::processExcel()
{
    this->fileType = "excel";

    QString table = "";
    QString db = Statics::currentDbName;
    std::string csvFile    = db.toStdString();

    QString fileName       = QFileInfo(db).baseName().toLower();
    std::string csvdb       = "";

    QString fileExtension = QFileInfo(db).completeSuffix();

    fileName = fileName.remove(QRegularExpression("[^A-Za-z0-9]"));
    table = fileName;

    for ( const QString& csvFile : this->excelSheetsList  ) {

        csvdb = "'" + (csvFile + ".csv").toStdString() + "'";
        QFileInfo fi(csvdb.c_str());
        Statics::currentDbName = fileName;
        std::unique_ptr<duckdb::MaterializedQueryResult> res = con->Query("CREATE TABLE " + fi.baseName().toStdString() + " AS SELECT * FROM read_csv_auto(" + csvdb + ", HEADER=TRUE)");

        if(res->error.empty() == false){
            this->errorStatus = true;

            qWarning() << Q_FUNC_INFO << "Excel import issue" << res->error.c_str();
            break;
        } else{
            this->tables.append(fi.baseName());
            res.release();
        }
    }

    emit processingFinished(this->fileType, this->errorStatus, this->tables);
}

void DuckThread::processJson()
{
    this->fileType = "json";

    QString table = "";
    QString db = Statics::currentDbName;
    std::string csvFile    = this->jsonPath.toStdString();

    QString fileName       = QFileInfo(db).baseName().toLower();
    std::string csvdb       = "";

    QString fileExtension = QFileInfo(db).completeSuffix();

    fileName = fileName.remove(QRegularExpression("[^A-Za-z0-9]"));
    table = fileName;

    csvdb = "'" + csvFile + "'";
    Statics::currentDbName = fileName;
    std::unique_ptr<duckdb::MaterializedQueryResult> res = con->Query("CREATE TABLE " + table.toStdString() + " AS SELECT * FROM read_csv_auto(" + csvdb + ", HEADER=TRUE)");

    if(res->error.empty() == false){
        this->errorStatus = true;

        qWarning() << Q_FUNC_INFO << "JSON import issue" << res->error.c_str();
    } else{
        this->tables.append(table);
        res.release();
    }

    emit processingFinished(this->fileType, this->errorStatus, this->tables);
}
