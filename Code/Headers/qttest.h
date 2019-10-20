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

public slots:

private:

};

#endif // QTTEST_H
