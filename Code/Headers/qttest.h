#ifndef QTTEST_H
#define QTTEST_H

#include <QObject>

class QtTest : public QObject
{
    Q_OBJECT
public:
    explicit QtTest(QObject *parent = nullptr);

    Q_INVOKABLE QString pubFunc1(QString pub_a);

signals:
    void firstSignal(QString sig_a);

public slots:
    void firstSlot(QString slot_a);
    void secondSlot(int slot_b);

private:
    int a;
};

#endif // QTTEST_H
