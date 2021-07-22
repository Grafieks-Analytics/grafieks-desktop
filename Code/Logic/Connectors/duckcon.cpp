#include "duckcon.h"

DuckCon::DuckCon(QObject *parent) : QObject(parent),
    db(nullptr), con(db), duckThread{new DuckThread(&db, &con)}
{
    threadName = "Grafieks File Process Thread";

    // Excel
    connect(&threadExcel, &QThread::started, &excelToCsv, &ExcelCon::convertExcelToCsv, Qt::QueuedConnection);
    connect(&excelToCsv, &ExcelCon::convertedExcelPaths, this, &DuckCon::convertedExcelPaths, Qt::QueuedConnection);

    // JSON
    connect(&threadJson, &QThread::started, &jsonToCsv, &JsonCon::convertJsonToCsv, Qt::QueuedConnection);
    connect(&jsonToCsv, &JsonCon::convertedJsonPaths, this, &DuckCon::convertedJsonPaths, Qt::QueuedConnection);

    // Common
    connect(&processThread, &QThread::started, this->duckThread, &DuckThread::start, Qt::QueuedConnection);
    connect(this->duckThread, &DuckThread::processingFinished, this, &DuckCon::processingFinished, Qt::QueuedConnection);
}

void DuckCon::callThread()
{
    if(!processThread.isRunning()){
        processThread.setObjectName(this->threadName);
        duckThread->moveToThread(&processThread);
        processThread.start();
    }
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
    threadExcel.quit();

    this->callThread();
    duckThread->passExcelParams(paths);
    duckThread->processFile("excel");
}

void DuckCon::convertedCsvPath()
{
    this->callThread();
    duckThread->processFile("csv");
}

void DuckCon::convertedJsonPaths(QString path)
{
    threadJson.quit();

    this->callThread();
    duckThread->passJsonParams(path);
    duckThread->processFile("json");
}


void DuckCon::processingFinished(QString fileType, bool errorStatus, QStringList tables )
{
    if(fileType == "json"){
        emit jsonLoginStatus(this->response, this->directLogin);
    } else if(fileType == "excel"){
        emit excelLoginStatus(this->response, this->directLogin);
    } else {
        emit csvLoginStatus(this->response, this->directLogin);
    }

    if(errorStatus == true){
        emit importError("File format is not valid UTF-8. Please provide a valid UTF-8 file", fileType);
    }

    this->tables = tables;
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
            this->convertedCsvPath();
        }
    }
}
