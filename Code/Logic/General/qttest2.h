#ifndef QTTEST2_H
#define QTTEST2_H

#include <QObject>
#include <QDebug>
#include <QFile>
#include <QString>
#include <QDataStream>
#include <QMap>

class QtTest2 : public QObject
{
    Q_OBJECT
    QVariantMap mapVar;
    QMap<int, QString>mapVar1;
    QMap<int, QStringList> mapVar2;

public:
    explicit QtTest2(QObject *parent = nullptr);
    Q_INVOKABLE void x();
    Q_INVOKABLE void write();
    Q_INVOKABLE void read();

public slots:

signals:
};

#endif // QTTEST2_H
