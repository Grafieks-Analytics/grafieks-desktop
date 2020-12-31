#include "qttest2.h"

/*!
 * \brief QtTest2::QtTest2
 * \param parent
 * \qmlsignal
 * \
 */
//QtTest2::QtTest2(QObject *parent) :QObject(parent)
//     db(nullptr), con(db)
QtTest2::QtTest2(QObject *parent) :QObject(parent)
{
    //    db.LoadExtension<duckdb::ParquetExtension>();

}

void QtTest2::x()
{
    QString path = "/Users/mac/Desktop/test.csv";
    QFileInfo fifo = path;
    QString fileName = fifo.fileName();
    QString fileNameWithoutExt = fileName.section(".",0,0);


    qDebug() << fileName << fileNameWithoutExt << "FILENAME";
}

void QtTest2::osTest()
{
#ifdef Q_OS_WIN
    qDebug() << "On Windows";
    QStringList winODBCDrivers = fetchWindowsODBCDrivers();
#endif

#ifdef Q_OS_MACOS
    qDebug() << "On Mac";
    QStringList macODBCDrivers = fetchMacODBCDrivers();
#endif
}

QStringList QtTest2::fetchWindowsODBCDrivers()
{
    QSettings registry("HKEY_LOCAL_MACHINE\\SOFTWARE\\ODBC\\ODBCINST.INI", QSettings::NativeFormat);
    QStringList installedDrivers = registry.childGroups();

    return installedDrivers;
}

QStringList QtTest2::fetchMacODBCDrivers()
{
    QStringList out;
    return out;
}
