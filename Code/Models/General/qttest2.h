#ifndef QTTEST2_H
#define QTTEST2_H

#include <QObject>
#include <QDebug>


class QtTest2 : public QObject
{
    Q_OBJECT

public:
    explicit QtTest2(QObject *parent = nullptr);
    Q_INVOKABLE void setStrings(QString n, QString s);
    Q_INVOKABLE void getStrings();

signals:

public slots:
};

#endif // QTTEST2_H
