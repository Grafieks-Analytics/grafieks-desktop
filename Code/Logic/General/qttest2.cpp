#include "qttest2.h"

/*!
 * \brief QtTest2::QtTest2
 * \param parent
 * \qmlsignal
 * \
 */
QtTest2::QtTest2(QObject *parent) :QObject(parent)
{
    mapVar.insert("first", "1");
    mapVar.insert("second", "2");
    mapVar.insert("third", "3");

    mapVar1.insert(1, "One");
    mapVar1.insert(2, "Two");
    mapVar1.insert(3, "Three");

    QStringList x;
    x << "Hello" << "world" << "dist";

    mapVar2.insert(1, x);
    mapVar2.insert(2, x);
    mapVar2.insert(3, x);

}

void QtTest2::x()
{
    QString tmp = "test";
    int x = 1;
    QByteArray tmpBA = tmp.toUtf8();
    QByteArray xBA = QString::number(x).toUtf8();

    qDebug() << tmp << tmpBA << xBA << "TO BYTEARRAY" << QString(tmpBA);


}

void QtTest2::write()
{

    QString filename = "/Users/mac/Desktop/snippets.ds";
    QFile myFile (filename);

    if (!myFile.open(QIODevice::WriteOnly))
    {
        qDebug() << "Could not write " << filename;
        return;
    }


    QDataStream out (&myFile);
    out.setVersion(QDataStream::Qt_5_15);

    QString fire = "fire";

    out << QString("stackoverflow");
    out << this->mapVar;
    out << this->mapVar1;
    out << this->mapVar2;
    out << fire;

    myFile.flush();
    myFile.close();
}

void QtTest2::read()
{

    QString filename = "/Users/mac/Desktop/snippets.ds";
    QFile myFile(filename);

    QVariantMap map;
    QMap<int, QString> mapVar1;
    QMap<int, QStringList> mapVar2;
    QString a = "", b = "";

    QDataStream in(&myFile);
    in.setVersion(QDataStream::Qt_5_15);

    if (!myFile.open(QIODevice::ReadOnly))
    {
        qDebug() << "Could not read the file:" << filename << "Error string:" << myFile.errorString();
        return;
    }

    in >> a;
    in >> map;
    in >> mapVar1;
    in >> mapVar2;
    in >> b;

    qDebug() << map << mapVar1 << mapVar2<< a << b;
//    qDebug() << a << map;
}


