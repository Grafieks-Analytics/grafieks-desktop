#include "odbcdriversmodel.h"

ODBCDriversModel::ODBCDriversModel(QObject *parent) : QObject(parent)
{

}

QStringList ODBCDriversModel::fetchOdbcDrivers(const QString &db)
{

#ifdef Q_OS_WIN
    QStringList ODBCDrivers = fetchWindowsODBCDrivers();
#endif

#ifdef Q_OS_MACOS
    QStringList ODBCDrivers = fetchMacODBCDrivers();
#endif

    QStringList filteredDrivers = ODBCDrivers.filter(db, Qt::CaseInsensitive);

    emit availableDrivers(filteredDrivers, db);
    return filteredDrivers;
}

QStringList ODBCDriversModel::fetchWindowsODBCDrivers()
{

    QSettings registry("HKEY_LOCAL_MACHINE\\SOFTWARE\\ODBC\\ODBCINST.INI", QSettings::NativeFormat);
    QStringList installedDrivers = registry.childGroups();

    return installedDrivers;
}

QStringList ODBCDriversModel::fetchMacODBCDrivers()
{

    QSettings registry("/Library/ODBC/odbcinst.ini", QSettings::IniFormat);
    QStringList installedDrivers = registry.childGroups();

    return installedDrivers;
}
