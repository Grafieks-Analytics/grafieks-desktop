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



int GeneralParamsModel::menuType() const
{
    return m_menuType;
}

void GeneralParamsModel::setMenuType(int menuType)
{
    if (m_menuType == menuType)
        return;

    m_menuType = menuType;
    emit menuTypeChanged(m_menuType);
}
