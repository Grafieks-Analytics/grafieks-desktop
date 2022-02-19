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
    QString tmpFilePath = QCoreApplication::applicationDirPath() + "/" + "tmp/";
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
    QString appPath = QCoreApplication::applicationDirPath() + "/GrafieksDesktop.exe";
    appPath.replace("/", "\\");

    QProcess::startDetached(appPath);
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

void GeneralParamsModel::setFromLiveQuery(bool setForLiveQuery)
{
    this->setForLiveQuery = setForLiveQuery;
}

bool GeneralParamsModel::getFromLiveQuery()
{
    return this->setForLiveQuery;
}

QStringList GeneralParamsModel::getCredentials()
{
    QString host;
    QString port;
    QString database;
    QString username;
    QString password;

    QStringList output;

    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:
    case Constants::mysqlOdbcIntType:{
        host = Statics::myHost;
        port = Statics::myPort;
        database = Statics::myDb;
        username = Statics::myUsername;
        password = Statics::myPassword;

        break;
    }

    case Constants::postgresIntType:{
        host = Statics::postgresHost;
        port = Statics::postgresPort;
        database = Statics::postgresDb;
        username = Statics::postgresUsername;
        password = Statics::postgresPassword;
        break;
    }

    case Constants::mssqlIntType:{

        host = Statics::msHost;
        port = Statics::msPort;
        database = Statics::msDb;
        username = Statics::msUsername;
        password = Statics::msPassword;
        break;
    }

    case Constants::oracleIntType:{

        host = Statics::oracleHost;
        port = Statics::oraclePort;
        database = Statics::oracleDb;
        username = Statics::oracleUsername;
        password = Statics::oraclePassword;
        break;
    }

    case Constants::mongoIntType:{

        host = Statics::mongoHost;
        port = Statics::mongoPort;
        database = Statics::mongoDb;
        username = Statics::mongoUsername;
        password = Statics::mongoPassword;
        break;
    }

    case Constants::redshiftIntType:{

        host = Statics::redshiftHost;
        port = Statics::redshiftPort;
        database = Statics::redshiftDb;
        username = Statics::redshiftUsername;
        password = Statics::redshiftPassword;
        break;
    }

    case Constants::teradataIntType:{

        host = Statics::teradataHost;
        port = Statics::teradataPort;
        database = Statics::teradataDb;
        username = Statics::teradataUsername;
        password = Statics::teradataPassword;
        break;
    }

    case Constants::snowflakeIntType:{

        host = Statics::snowflakeHost;
        port = Statics::snowflakePort;
        database = Statics::snowflakeDb;
        username = Statics::snowflakeUsername;
        password = Statics::snowflakePassword;
        break;
    }
    }

    output << host << port << database << username << password;
    return output;
}

void GeneralParamsModel::setFromLiveFile(bool setForLiveFile)
{
    this->setForLiveFile = setForLiveFile;
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

