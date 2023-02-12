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
    this->filePath = filePath;
    this->receivedArgument = true;
}

bool LiveProcessor::receivedArgumentStatus()
{
    return this->receivedArgument;
}

void LiveProcessor::processLiveQueries()
{
    this->masterQuery = "SELECT " + this->selectParams + " FROM " + this->masterTable + " " + this->joinParams + " " + this->whereParams;

    // For values refer to Constants.qml
    this->generalParamsModel->setLivePath(this->filePath);
    this->generalParamsModel->setCurrentScreen(4); // Set Dashboard screen
    this->generalParamsModel->setMenuType(1); // Set Dashboard designer menu

    emit generateLiveReports(this->sqlChartHeader);
    emit liveQueryParams(this->selectParams, this->whereParams, this->joinParams,this->masterTable);

    if(this->moveToDashboardScreen){
        emit liveReaderProcessed();
        emit generateLiveSchema(this->masterQuery);
    }
}

void LiveProcessor::setArgumentsFromWorkbook(QString filePath)
{
    this->filePath = filePath;
    this->processLive();
}

void LiveProcessor::processLive()
{

    QString username;
    QString password;
    QString host;
    QString database;
    QString port;
    QString dbType;
    QString realDbName;

    QString colName;
    QString tableName;
    QString colType;
    QString qmlDbName;

    duckdb::DuckDB db(this->filePath.toStdString());
    duckdb::Connection con(db);

    QString queryString = "SELECT * FROM " + Constants::masterLiveTable;
    auto masterDb = con.Query(queryString.toStdString());

    // Parts query table
    QString partsQueryString = "SELECT * FROM " + Constants::masterQueryPartLiveTable;
    auto parts = con.Query(partsQueryString.toStdString());

    selectParams = parts->GetValue(0,0).ToString().c_str();
    whereParams = parts->GetValue(1,0).ToString().c_str();
    joinParams = parts->GetValue(2,0).ToString().c_str();
    masterTable = parts->GetValue(3,0).ToString().c_str();

    // Headers query table
    QString headersQueryString = "SELECT * FROM " + Constants::masterHeadersTable;
    auto headers = con.Query(headersQueryString.toStdString());
    int headersRowCount = headers->collection.Count();

    for(int i = 0; i < headersRowCount; i++){
        QStringList colInfo;
        colName = headers->GetValue(0, i).ToString().c_str();
        colType = headers->GetValue(1, i).ToString().c_str();
        tableName = headers->GetValue(2, i).ToString().c_str();

        colInfo << colName << colType << tableName;
        this->sqlChartHeader.insert(i, colInfo);
    }

    // Credentials table
    QString credentialsQueryString = "SELECT * FROM " + Constants::masterCredentialsTable;
    auto credentials = con.Query(credentialsQueryString.toStdString());

    username = credentials->GetValue(0,0).ToString().c_str();
    password = credentials->GetValue(1,0).ToString().c_str();
    host = credentials->GetValue(2,0).ToString().c_str();
    port = credentials->GetValue(3,0).ToString().c_str();
    database = credentials->GetValue(4,0).ToString().c_str();
    dbType = credentials->GetValue(5,0).ToString().c_str();
    realDbName = credentials->GetValue(6,0).ToString().c_str();

    if(password.trimmed() != ""){
        simpleCrypt.setKey(Secret::simpleCryptHash);
        password = simpleCrypt.decryptToString(password);
    }

    Statics::currentDbIntType = dbType.toInt();


    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:
    case Constants::mysqlOdbcIntType:{
        Statics::myHost = host;
        Statics::myPort = port.toInt();
        Statics::myDb = database;
        Statics::myUsername = username;
        Statics::myPassword = password;
        Statics::myRealDbName = realDbName;
        qmlDbName = Constants::mysqlQml;

        break;
    }

    case Constants::postgresIntType:{
        Statics::postgresHost = host;
        Statics::postgresPort = port.toInt();
        Statics::postgresDb = database;
        Statics::postgresUsername = username;
        Statics::postgresPassword = password;
        Statics::postgresRealDbName = realDbName;
        qmlDbName = Constants::postgresQml;
        break;
    }

    case Constants::mssqlIntType:{

        Statics::msHost = host;
        Statics::msPort = port.toInt();
        Statics::msDb = database;
        Statics::msUsername = username;
        Statics::msPassword = password;
        Statics::msRealDbName = realDbName;
        qmlDbName = Constants::mssqlQml;

        break;
    }

    case Constants::oracleIntType:{

        Statics::oracleHost = host;
        Statics::oraclePort = port.toInt();
        Statics::oracleDb = database;
        Statics::oracleUsername = username;
        Statics::oraclePassword = password;
        Statics::oracleRealDbName = realDbName;
        qmlDbName = Constants::oracleQml;
        break;
    }

    case Constants::mongoIntType:{

        Statics::mongoHost = host;
        Statics::mongoPort = port.toInt();
        Statics::mongoDb = database;
        Statics::mongoUsername = username;
        Statics::mongoPassword = password;
        Statics::mongoRealDbName = realDbName;
        qmlDbName = Constants::mongoQml;
        break;
    }

    case Constants::redshiftIntType:{

        Statics::redshiftHost = host;
        Statics::redshiftPort = port.toInt();
        Statics::redshiftDb = database;
        Statics::redshiftUsername = username;
        Statics::redshiftPassword = password;
        Statics::redshiftRealDbName = realDbName;
        qmlDbName = Constants::redshiftQml;
        break;
    }

    case Constants::snowflakeIntType:{

        Statics::snowflakeHost = host;
        Statics::snowflakePort = port.toInt();
        Statics::snowflakeDb = database;
        Statics::snowflakeUsername = username;
        Statics::snowflakePassword = password;
        Statics::snowflakeRealDbName = realDbName;
        qmlDbName = Constants::snowflakeQml;
        break;
    }

    case Constants::teradataIntType:{

        Statics::teradataHost = host;
        Statics::teradataPort = port.toInt();
        Statics::teradataDb = database;
        Statics::teradataUsername = username;
        Statics::teradataPassword = password;
        Statics::teradataRealDbName = realDbName;
        qmlDbName = Constants::teradataQml;
        break;
    }
    }

    Statics::modeProcessReader = true;
    emit openConnection(qmlDbName);
}
