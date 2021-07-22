#include "duckcon.h"

DuckCon::DuckCon(QObject *parent) : QObject(parent),
    db(nullptr), con(db)
{
    errorStatus = false;
    fileType = "";

    // Excel
    connect(&threadExcel, &QThread::started, &excelToCsv, &ExcelCon::convertExcelToCsv, Qt::QueuedConnection);
    connect(&excelToCsv, &ExcelCon::convertedExcelPaths, this, &DuckCon::convertedExcelPaths, Qt::QueuedConnection);

    // CSV
    connect(&threadCsv, &QThread::started, this, &DuckCon::convertedCsvPath, Qt::QueuedConnection);
    connect(this, &DuckCon::signalProcessingFinished, this, &DuckCon::endCsvThread, Qt::QueuedConnection);

    // JSON
    connect(&threadJson, &QThread::started, &jsonToCsv, &JsonCon::convertJsonToCsv, Qt::QueuedConnection);
    connect(&jsonToCsv, &JsonCon::convertedJsonPaths, this, &DuckCon::convertedJsonPaths, Qt::QueuedConnection);

    // Common
    connect(&threadExcel, &QThread::finished, this, &DuckCon::processingFinished, Qt::QueuedConnection);
    connect(&threadCsv, &QThread::finished, this, &DuckCon::processingFinished, Qt::QueuedConnection);
    connect(&threadJson, &QThread::finished, this, &DuckCon::processingFinished, Qt::QueuedConnection);
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
        std::unique_ptr<duckdb::MaterializedQueryResult> res = con.Query("CREATE TABLE " + fi.baseName().toStdString() + " AS SELECT * FROM read_csv_auto(" + csvdb + ", HEADER=TRUE)");


        if(res->error.empty() == false){
            this->errorStatus = true;

            qWarning() << Q_FUNC_INFO << "Excel import issue" << res->error.c_str();
            break;
        } else{
            this->tables.append(fi.baseName());
            res.release();
        }
    }

    threadExcel.quit();
}

void DuckCon::convertedCsvPath()
{
    qDebug() << "PROJECT IGI";
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
    Statics::currentDbName = fileName;
    qDebug() << "PROJECT IGI1";
    std::unique_ptr<duckdb::MaterializedQueryResult> res = con.Query("CREATE TABLE " + table.toStdString() + " AS SELECT * FROM read_csv_auto(" + csvdb + ", HEADER=TRUE)");
    qDebug() << "PROJECT IGI2";
    if(res->error.empty() == false){
        this->errorStatus = true;
        qWarning() << Q_FUNC_INFO << "CSV import issue" << res->error.c_str();
    } else{
        this->tables.append(table);
        res.release();
    }

    signalProcessingFinished();
}

void DuckCon::convertedJsonPaths(QString path)
{

    this->fileType = "json";

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
        this->errorStatus = true;

        qWarning() << Q_FUNC_INFO << "JSON import issue" << res->error.c_str();
    } else{
        this->tables.append(table);
        res.release();
    }
    threadJson.quit();
}

void DuckCon::endCsvThread()
{
    qDebug() << "PROJECT IGIO" << threadCsv.currentThread()<< QThread::currentThread();

    threadCsv.terminate();
    qDebug() << threadCsv.isRunning();
}

void DuckCon::processingFinished()
{
    qDebug() << "PROJECT IGO";
    if(this->fileType == "json"){
        emit jsonLoginStatus(this->response, this->directLogin);
    } else if(this->fileType == "excel"){
        emit excelLoginStatus(this->response, this->directLogin);
    } else {
        emit csvLoginStatus(this->response, this->directLogin);
    }

    if(this->errorStatus == true){
        emit importError("File format is not valid UTF-8. Please provide a valid UTF-8 file", this->fileType);
    }
}



void DuckCon::createTable(QString dbName, bool directLogin, QVariantMap response){

    Q_UNUSED(dbName);

    this->directLogin = directLogin;
    this->response = response;

    QString db = Statics::currentDbName;
    QString fileName       = QFileInfo(db).baseName().toLower();
    QString fileExtension = QFileInfo(db).completeSuffix();
    fileName = fileName.remove(QRegularExpression("[^A-Za-z0-9]"));

    if(fileName.trimmed().length() > 0){
        if(fileExtension.toLower() == "json"){

            jsonToCsv.moveToThread(&threadJson);
            threadJson.setObjectName("Grafieks Json Process");
            threadJson.start(QThread::InheritPriority);

        } else if(fileExtension.toLower() == "xls" || fileExtension.toLower() == "xlsx"){

            excelToCsv.moveToThread(&threadExcel);
            threadExcel.setObjectName("Grafieks Excel Process");
            threadExcel.start(QThread::InheritPriority);

        } else{
            moveToThread(&threadCsv);
            threadCsv.start(QThread::InheritPriority);
        }
    }
}
