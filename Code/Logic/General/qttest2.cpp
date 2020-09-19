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

QString QtTest2::a() const
{
    return m_a;
}

void QtTest2::setA(QString a)
{
    if (m_a == a)
        return;

    m_a = a;
    emit aChanged(m_a);
}
