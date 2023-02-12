#include "osentries.h"

OsEntries::OsEntries(QObject *parent) : QObject(parent)
{

}

void OsEntries::witeToWindowsRegistry()
{
    // Application registry
    // GADS
    QSettings settingsGads("HKEY_CURRENT_USER\\SOFTWARE\\CLASSES\\Grafieks.gads\\shell\\open\\command", QSettings::NativeFormat );
    QString appPathGads = QCoreApplication::applicationDirPath() + "/GrafieksDesktop.exe";
    appPathGads.replace("/", "\\");
    settingsGads.setValue("Default", appPathGads + " \"%1\"");

    QSettings settingsGadsIcon("HKEY_CURRENT_USER\\SOFTWARE\\CLASSES\\Grafieks.gads\\DefaultIcon", QSettings::NativeFormat );
    QString appPathGadsIcon = QCoreApplication::applicationDirPath() + "/rc/gads.ico";
    settingsGadsIcon.setValue("Default", appPathGadsIcon);

    // GAWB
    QSettings settingsGawb("HKEY_CURRENT_USER\\SOFTWARE\\CLASSES\\Grafieks.gawb\\shell\\open\\command", QSettings::NativeFormat );
    QString appPathGawb = QCoreApplication::applicationDirPath() + "/GrafieksDesktop.exe";
    appPathGawb.replace("/", "\\");
    settingsGawb.setValue("Default", appPathGawb + " \"%1\"");

    QSettings settingsGawbIcon("HKEY_CURRENT_USER\\SOFTWARE\\CLASSES\\Grafieks.gawb\\DefaultIcon", QSettings::NativeFormat );
    QString appPathGawbIcon = QCoreApplication::applicationDirPath() + "/rc/gawb.ico";
    settingsGawbIcon.setValue("Default", appPathGawbIcon);

    // GADSE
    QSettings settingsGadse("HKEY_CURRENT_USER\\SOFTWARE\\CLASSES\\Grafieks.gadse\\shell\\open\\command", QSettings::NativeFormat );
    QString appPathGadse = QCoreApplication::applicationDirPath() + "/GrafieksDesktop.exe";
    appPathGadse.replace("/", "\\");
    settingsGadse.setValue("Default", appPathGadse + " \"%1\"");

    QSettings settingsGadseIcon("HKEY_CURRENT_USER\\SOFTWARE\\CLASSES\\Grafieks.gadse\\DefaultIcon", QSettings::NativeFormat );
    QString appPathGadseIcon = QCoreApplication::applicationDirPath() + "/rc/gadse.ico";
    settingsGadseIcon.setValue("Default", appPathGadseIcon);



    // Extensions entry
    // GADSE (Extract)
    QSettings gadse("HKEY_CURRENT_USER\\SOFTWARE\\CLASSES\\.gadse", QSettings::NativeFormat);
    gadse.setValue("Default", "Grafieks.gadse");


    // GADS (Live)
    QSettings gads("HKEY_CURRENT_USER\\SOFTWARE\\CLASSES\\.gads", QSettings::NativeFormat);
    gads.setValue("Default", "Grafieks.gads");

    // GAWB (Workbook)
    QSettings gawb("HKEY_CURRENT_USER\\SOFTWARE\\CLASSES\\.gawb", QSettings::NativeFormat);
    gawb.setValue("Default", "Grafieks.gawb");
}

void OsEntries::writeToMacRegistry()
{

}

void OsEntries::writeToLinuxRegistry()
{

}
