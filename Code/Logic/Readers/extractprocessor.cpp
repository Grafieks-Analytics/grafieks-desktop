#include "extractprocessor.h"

ExtractProcessor::ExtractProcessor(GeneralParamsModel *gpm, DSParamsModel *dsp, QObject *parent) : QObject(parent),
    receivedArgument(false), moveToDashboardScreen(true)
{
    this->generalParamsModel = gpm;
    this->dsParamsModel = dsp;
}

void ExtractProcessor::setArgumentsFromMenu(QString filePath)
{
    this->filePath = filePath;
    this->processExtract();
}

void ExtractProcessor::setArgumentsByFile(QString filePath)
{
    this->filePath = filePath;
    this->receivedArgument = true;
}

bool ExtractProcessor::receivedArgumentStatus()
{
    return this->receivedArgument;
}


void ExtractProcessor::processExtract()
{
    duckdb::DuckDB db(this->filePath.toStdString());
    duckdb::Connection con(db);

    QString queryString = "SELECT * from " + Constants::masterExtractTable;
    auto masterDb = con.Query(queryString.toStdString());
    QString tableName = masterDb->GetValue(0,0).ToString().c_str();

    Statics::currentDbName = tableName;
    Statics::modeProcessReader = true;

    // Set datasource name
    this->dsParamsModel->setDsName(Statics::currentDbName);

    // For values refer to Constants.qml
    this->generalParamsModel->setExtractPath(this->filePath);
    this->generalParamsModel->setCurrentScreen(4); // Set Dashboard screen
    this->generalParamsModel->setMenuType(1); // Set Dashboard designer menu

    emit generateExtractReports(&con);
    if(this->moveToDashboardScreen)
        emit extractReaderProcessed();
}

void ExtractProcessor::setArgumentsFromWorkbook(QString filePath)
{
    this->moveToDashboardScreen = false;
    this->filePath = filePath;
    this->processExtract();
}
