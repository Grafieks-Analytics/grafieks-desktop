#include "./Headers/qttest.h"

QtTest::QtTest(QObject *parent) : QObject(parent), a(1)
{
    emit firstSignal("Direct Call from C++. Value is " + QString::number(a));
}

QString QtTest::pubFunc1(QString pub_a)
{
    return pub_a;
}

void QtTest::firstSlot(QString slot_a)
{
    emit firstSignal("Called from QML. Keyword is " + slot_a);
}

void QtTest::secondSlot(int slot_b)
{
    emit firstSignal("Called from QML. Keyword is " + QString::number(slot_b));
}
