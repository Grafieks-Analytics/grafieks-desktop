#include "qttest2.h"
#include <QFile>
#include <QDataStream>

QtTest2::QtTest2(QObject *parent) : QObject(parent)
{

}

void QtTest2::setStrings(QString n, QString s)
{


    //    qDebug() << Q_FUNC_INFO << QtTest::name << QtTest::surname;

    QFile file("/Users/chilaraimushahary/Desktop/file.dat");
    file.open(QIODevice::WriteOnly);
    QDataStream out(&file);
    out << (quint32)0xA0B0C0D0;
    out << (qint32)123;

    out.setVersion(QDataStream::Qt_4_0);
    out << QString("name is " + n) << QString("surname is " + s);
    file.close();

}

void QtTest2::getStrings(){
    QFile file("/Users/chilaraimushahary/Desktop/file.dat");
    file.open(QIODevice::ReadOnly);
    QDataStream in(&file);
    QString str, str2;
    // Read and check the header
    quint32 magic;
    qint32 version;
    in >> magic;
    in >> version;

    qDebug() << magic << version << "meta";

    in >> str >> str2;
    qDebug() << str << str2 << "called";
    file.close();
}
