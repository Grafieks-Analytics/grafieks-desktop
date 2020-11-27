#include "qttest2.h"

/*!
 * \brief QtTest2::QtTest2
 * \param parent
 * \qmlsignal
 * \
 */
QtTest2::QtTest2(QObject *parent) :QObject(parent)
{
    db.LoadExtension<duckdb::ParquetExtension>();
}

void QtTest2::x()
{
    QString path = "/Users/mac/Desktop/test.csv";
    QFileInfo fifo = path;
    QString fileName = fifo.fileName();
    QString fileNameWithoutExt = fileName.section(".",0,0);


    qDebug() << fileName << fileNameWithoutExt << "FILENAME";
}
