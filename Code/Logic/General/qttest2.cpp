#include "qttest2.h"

/*!
 * \brief QtTest2::QtTest2
 * \param parent
 * \qmlsignal
 * \
 */

QtTest2::QtTest2(QObject *parent) : QObject(parent)
{

}

QString QtTest2::returnPlainText(QString s)
{
    QTextDocument td;
    td.setHtml(s);
    return td.toPlainText();

}


