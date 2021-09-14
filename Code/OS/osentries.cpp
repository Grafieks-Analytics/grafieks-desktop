#include "osentries.h"

OsEntries::OsEntries(QObject *parent) : QObject(parent)
{

}

void OsEntries::witeToWindowsRegistry()
{
    // Application registry
    QSettings settings("HKEY_CURRENT_USER\\SOFTWARE\\CLASSES\\Grafieks\\shell\\open\\command", QSettings::NativeFormat );
    QString appPath = QCoreApplication::applicationDirPath() + "/GrafieksDesktop.exe";
    appPath.replace("/", "\\");
    settings.setValue("Default", appPath + " \"%1\"");

    // GADSE registry (Extract)
    QSettings gadse("HKEY_CURRENT_USER\\SOFTWARE\\CLASSES\\.gadse", QSettings::NativeFormat);
    gadse.setValue("Default", "Grafieks");
    gadse.setValue("DefaultIcon", Statics::tmpIconPath);

    // GADS registry (Live)
    QSettings gads("HKEY_CURRENT_USER\\SOFTWARE\\CLASSES\\.gads", QSettings::NativeFormat);
    gads.setValue("Default", "Grafieks");
    gads.setValue("DefaultIcon",  Statics::tmpIconPath);

    // GAWB registry (Workbook)
    QSettings gawb("HKEY_CURRENT_USER\\SOFTWARE\\CLASSES\\.gawb", QSettings::NativeFormat);
    gawb.setValue("Default", "Grafieks");
    gawb.setValue("DefaultIcon",  Statics::tmpIconPath);
}

void OsEntries::writeToMacRegistry()
{

}

void OsEntries::writeToLinuxRegistry()
{

}
