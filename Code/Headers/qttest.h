#ifndef QTTEST_H
#define QTTEST_H

#include <QSqlDatabase>
#include <QSqlDriver>
#include <QSqlError>
#include <QDebug>
#include <QSqlQuery>

#include <QObject>

class QtTest : public QObject
{
    Q_OBJECT
public:
    explicit QtTest(QObject *parent = nullptr);


signals:
    void firstSignal(QString sig_a);

public slots:
    void firstSlot(QString slot_a);

private:
    int a;
};

#endif // QTTEST_H
