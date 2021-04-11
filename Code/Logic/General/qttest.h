#ifndef QTTEST_H
#define QTTEST_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlQueryModel>
#include <QString>
#include <QVariant>
#include <QSet>

#include "../../Connectors/allconnectors.h"
#include "../../constants.h"
#include "../../statics.h"

// All Sql test
// Dont use it for anything else please


class QtTest : public QObject
{
    Q_OBJECT
public:
    explicit QtTest(QObject *parent = nullptr);
    void calla();

signals:

};

#endif // QTTEST_H
