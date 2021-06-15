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

int GeneralParamsModel::menuType() const
{
    return m_menuType;
}

int GeneralParamsModel::currentScreen() const
{
    return m_currentScreen;
}


void GeneralParamsModel::setMenuType(int menuType)
{
    if (m_menuType == menuType)
        return;

    m_menuType = menuType;
    emit menuTypeChanged(m_menuType);
}

void GeneralParamsModel::setcurrentScreen(int currentScreen)
{
    if (m_currentScreen == currentScreen)
        return;

    m_currentScreen = currentScreen;
    emit currentScreenChanged(m_currentScreen);
}

