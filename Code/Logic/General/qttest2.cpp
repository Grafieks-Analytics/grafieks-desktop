#include "qttest2.h"

/*!
 * \brief QtTest2::QtTest2
 * \param parent
 * \qmlsignal
 * \
 */
QtTest2::QtTest2(QObject *parent) :QObject(parent)
{

}

void QtTest2::x()
{
    QString tmp = "test";
    int x = 1;
    QByteArray tmpBA = tmp.toUtf8();
    QByteArray xBA = QString::number(x).toUtf8();

    qDebug() << tmp << tmpBA << xBA << "TO BYTEARRAY" << QString(tmpBA);
}


