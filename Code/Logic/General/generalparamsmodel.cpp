#include "generalparamsmodel.h"

GeneralParamsModel::GeneralParamsModel(QObject *parent) : QObject(parent)
{
    this->setForLiveFile = false;
    this->setForLiveQuery = false;
}

QString GeneralParamsModel::getFileToken()
{
    QSettings settings;
    QString session = settings.value("general/fileToken").toString();

    return session;

}

QString GeneralParamsModel::getTmpPath()
{
    QStringList tmpPaths =  QStandardPaths::standardLocations(QStandardPaths::AppDataLocation);

    QString tmpFilePath = tmpPaths[0] + "/" + "tmp/";
    return tmpFilePath;
}

QString GeneralParamsModel::getDbClassification()
{
    return Statics::currentDbClassification;
}

QString GeneralParamsModel::getCurrentDB()
{
    return Statics::currentDbName;
}

bool GeneralParamsModel::isWorkbookInEditMode()
{
    return Statics::editMode;
}

void GeneralParamsModel::openNewGrafieksInstance()
{
    QString appPath = "\""+QCoreApplication::applicationDirPath() + "/GrafieksDesktop.exe\"";
    QString replacedPath = QDir::toNativeSeparators(appPath);


    QProcess::startDetached(replacedPath);

}

QVariantMap GeneralParamsModel::getAppInfo()
{
    QVariantMap appInfo;

    appInfo.insert("APP_NAME", Constants::appName);
    appInfo.insert("APP_VERSION", Constants::appVersion);
    appInfo.insert("EXTRACT_VERSION", Constants::extractVersion);
    appInfo.insert("LIVE_VERSION", Constants::liveVersion);
    appInfo.insert("WORKBOOK_VERSION", Constants::workbookVersion);
    appInfo.insert("CURRENT_MODE", Constants::currentMode);

    return appInfo;
}

int GeneralParamsModel::getOnlineStorageType()
{
    return Statics::onlineStorageType;
}

QString GeneralParamsModel::returnPlainTextFromHtml(QString s)
{
    QTextDocument td;
    td.setHtml(s);
    return td.toPlainText();
}

void GeneralParamsModel::loadingComplete()
{
    emit hideSplash();
}

int GeneralParamsModel::menuType() const
{
    return m_menuType;
}

int GeneralParamsModel::currentScreen() const
{
    return m_currentScreen;
}

void GeneralParamsModel::setExtractPath(QString extractsPath)
{
    Statics::extractPath = extractsPath;
    if(Statics::modeProcessReader == false)
        emit showSaveExtractWaitPopup();

}

QString GeneralParamsModel::getLivePath()
{
    return Statics::livePath;
}

void GeneralParamsModel::setLivePath(QString livePath)
{
    Statics::livePath = livePath;
    if(Statics::modeProcessReader == false)
        emit showSaveExtractWaitPopup();
}

QString GeneralParamsModel::getExtractPath()
{
    return Statics::extractPath;
}

void GeneralParamsModel::setPath(QString path, QString type)
{
    if (type == Constants::extractType){
        Statics::extractPath = path;
    } else {
        Statics::livePath = path;
    }
}

void GeneralParamsModel::changeColumnTypes(QString columnName, QString tableName, QString newColumnType)
{

    this->changedHeaderTypes.insert(tableName + "." + columnName, newColumnType);

    emit colTypeChanged();
}

QVariantMap GeneralParamsModel::getChangedColumnTypes()
{
    return this->changedHeaderTypes;
}

QString GeneralParamsModel::urlToFilePath(QUrl url)
{
    QString path = url.toLocalFile();
    return path;
}

bool GeneralParamsModel::getFromLiveFile()
{
    return this->setForLiveFile;
}

void GeneralParamsModel::setForAPI(QString dsFileName, QString fileType)
{
    if(fileType == Constants::duckType){
        Statics::currentDbClassification = Constants::duckType;
        Statics::currentDSFile = dsFileName + ".gadse";
    } else {
        Statics::currentDbClassification = Constants::sqlType;
        Statics::currentDSFile = dsFileName + ".gads";
    }
}

void GeneralParamsModel::setJsonFromWorkbook(QJsonDocument jsonDoc)
{
    this->jsonDoc = jsonDoc;
}

QJsonDocument GeneralParamsModel::getJsonFromWorkbook()
{
    return this->jsonDoc;
}

bool GeneralParamsModel::ifJsonFromWorkbookSet()
{
    return this->jsonDoc.isEmpty() ? false: true;
}

void GeneralParamsModel::setFromLiveQuery(bool setForLiveQuery)
{
    this->setForLiveQuery = setForLiveQuery;
}

bool GeneralParamsModel::getFromLiveQuery()
{
    return this->setForLiveQuery;
}

QVariantList GeneralParamsModel::getCredentials()
{
    QString host;
    int port;
    QString database;
    QString username;
    QString password;
    QString realDbName;

    QVariantList output;

    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:
    case Constants::mysqlOdbcIntType:{
        host = Statics::myHost;
        port = Statics::myPort;
        database = Statics::myDb;
        username = Statics::myUsername;
        password = Statics::myPassword;
        realDbName = Statics::myRealDbName;

        break;
    }

    case Constants::postgresIntType:{
        host = Statics::postgresHost;
        port = Statics::postgresPort;
        database = Statics::postgresDb;
        username = Statics::postgresUsername;
        password = Statics::postgresPassword;
        realDbName = Statics::postgresRealDbName;
        break;
    }

    case Constants::mssqlIntType:{

        host = Statics::msHost;
        port = Statics::msPort;
        database = Statics::msDb;
        username = Statics::msUsername;
        password = Statics::msPassword;
        realDbName = Statics::msRealDbName;
        break;
    }

    case Constants::oracleIntType:{

        host = Statics::oracleHost;
        port = Statics::oraclePort;
        database = Statics::oracleDb;
        username = Statics::oracleUsername;
        password = Statics::oraclePassword;
        realDbName = Statics::oracleRealDbName;
        break;
    }

    case Constants::mongoIntType:{

        host = Statics::mongoHost;
        port = Statics::mongoPort;
        database = Statics::mongoDb;
        username = Statics::mongoUsername;
        password = Statics::mongoPassword;
        realDbName = Statics::mongoRealDbName;
        break;
    }

    case Constants::redshiftIntType:{

        host = Statics::redshiftHost;
        port = Statics::redshiftPort;
        database = Statics::redshiftDb;
        username = Statics::redshiftUsername;
        password = Statics::redshiftPassword;
        realDbName = Statics::redshiftRealDbName;
        break;
    }

    case Constants::teradataIntType:{

        host = Statics::teradataHost;
        port = Statics::teradataPort;
        database = Statics::teradataDb;
        username = Statics::teradataUsername;
        password = Statics::teradataPassword;
        realDbName = Statics::teradataRealDbName;
        break;
    }

    case Constants::snowflakeIntType:{

        host = Statics::snowflakeHost;
        port = Statics::snowflakePort;
        database = Statics::snowflakeDb;
        username = Statics::snowflakeUsername;
        password = Statics::snowflakePassword;
        realDbName = Statics::snowflakeRealDbName;
        break;
    }
    }

    output << host << port << database << username << password << realDbName;
    return output;
}

void GeneralParamsModel::setAPISwitch(bool apiSwitch)
{
    Statics::apiSwitch = apiSwitch;
}

bool GeneralParamsModel::getAPISwitch()
{
    return Statics::apiSwitch;
}

void GeneralParamsModel::setFromLiveFile(bool setForLiveFile)
{
    this->setForLiveFile = setForLiveFile;
    Statics::dsType = setForLiveFile == true ? Constants::liveType : Constants::extractType;
}

QString GeneralParamsModel::randomStringGenerator()
{
    const QString possibleCharacters("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789");
    const int randomStringLength = 12; // assuming you want random strings of 12 characters

    QString randomString;
    for(int i=0; i<randomStringLength; ++i)
    {
        QRandomGenerator rand;
        int index = QRandomGenerator::global()->generate() % possibleCharacters.length();
        QChar nextChar = possibleCharacters.at(index);
        randomString.append(nextChar);
    }
    return randomString;
}

bool GeneralParamsModel::ifFreeRelease()
{
    return Constants::appVersion == "Free" ? true : false;
}

void GeneralParamsModel::setCurrentWorkbookName(QString workbookName)
{
    this->currentWorkbookName = workbookName;
    emit savedWorkbookChanged(this->currentWorkbookName);
}


void GeneralParamsModel::resetGeneralParams()
{
    Statics::extractPath = "";
    Statics::livePath = "";

    Statics::modeProcessReader = false;
    Statics::currentDbClassification = "";
    Statics::currentDbName = "";
    Statics::currentDSFile = "";

    Statics::editMode = false;
    Statics::apiSwitch = false;

    this->m_menuType = 0;
    this->m_currentScreen = 0;
    this->changedHeaderTypes.clear();

    this->setForLiveFile = false;
    this->setForLiveQuery = false;
    this->currentWorkbookName = "";

}

QString GeneralParamsModel::getDSNameWithoutExtension(){
    QString fullDSName = Statics::currentDSFile;
    QStringList dsNameParts = fullDSName.split(".");
    return dsNameParts.at(0);
}

void GeneralParamsModel::quitApplication()
{
    QApplication::quit();
}

void GeneralParamsModel::setMenuType(int menuType)
{
    if (m_menuType == menuType)
        return;

    m_menuType = menuType;
    emit menuTypeChanged(m_menuType);
}

void GeneralParamsModel::setCurrentScreen(int currentScreen)
{
    if (m_currentScreen == currentScreen)
        return;

    m_currentScreen = currentScreen;
    emit currentScreenChanged(m_currentScreen);
}

