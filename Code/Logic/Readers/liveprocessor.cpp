#include "liveprocessor.h"

LiveProcessor::LiveProcessor(GeneralParamsModel *gpm, DSParamsModel *dsp, QObject *parent) : QObject(parent),
    receivedArgument(false), moveToDashboardScreen(true)
{
    this->generalParamsModel = gpm;
    this->dsParamsModel = dsp;
}

void LiveProcessor::setArgumentsFromMenu(QString filePath)
{
    this->filePath = filePath;
    this->processLive();
}

void LiveProcessor::setArgumentsByFile(QString filePath)
{

}

bool LiveProcessor::receivedArgumentStatus()
{
    return true;
}

void LiveProcessor::processLive()
{
    qDebug() << "LIVE FILE READING";
    duckdb::DuckDB db(this->filePath.toStdString());
    duckdb::Connection con(db);

    QString queryString = "SELECT * FROM " + Constants::masterLiveTable;
    auto masterDb = con.Query(queryString.toStdString());

    QString credentialsQueryString = "SELECT * FROM " + Constants::masterCredentialsTable;
    auto credentials = con.Query(credentialsQueryString.toStdString());

    QString partsQueryString = "SELECT * FROM " + Constants::masterQueryPartLiveTable;
    auto parts = con.Query(partsQueryString.toStdString());
//    QString tableName = masterDb->GetValue(0,0).ToString().c_str();

//    Statics::currentDbName = tableName;
//    Statics::modeProcessReader = true;

//    // Set datasource name
//    this->dsParamsModel->setDsName(Statics::currentDbName);

//    // For values refer to Constants.qml
//    this->generalParamsModel->setExtractPath(this->filePath);
//    this->generalParamsModel->setCurrentScreen(4); // Set Dashboard screen
//    this->generalParamsModel->setMenuType(1); // Set Dashboard designer menu

//    emit generateReports(&con);
//    if(this->moveToDashboardScreen)
//        emit liveReaderProcessed();

    masterDb->Print();
    credentials->Print();
    parts->Print();
}
