#ifndef QTTEST2_H
#define QTTEST2_H

#include <QObject>
#include <QTextDocument>
#include <QDebug>


class QtTest2 : public QObject
{
    Q_OBJECT

public:
    explicit QtTest2(QObject *parent = nullptr);
    Q_INVOKABLE QString returnPlainText(QString s);

public slots:

signals:

private:


};

#endif // QTTEST2_H
