#include "generalparamsmodel.h"

GeneralParamsModel::GeneralParamsModel(QObject *parent) : QObject(parent)
{

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

void GeneralParamsModel::changeColumnTypes(QString columnName, QString tableName, QString newColumnType)
{

    this->changedHeaderTypes.insert(tableName + "." + columnName, newColumnType);

    qDebug() << this->changedHeaderTypes;

    Statics::changedHeaderTypes = this->changedHeaderTypes;

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

