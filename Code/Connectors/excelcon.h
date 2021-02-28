#ifndef EXCELCON_H
#define EXCELCON_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlQueryModel>
#include <QSqlRecord>
#include <QSqlError>
#include <QtDebug>
#include <QObject>
#include <QFile>

#include "../constants.h"
#include "../Messages.h"
#include "../statics.h"

/*!
 * \brief Handles the connection with Excel database across the application
 * \ingroup Connectors
 */


class ExcelCon : public QObject
{
    Q_OBJECT
    QVariantMap outputStatus;
    const QString ODBCDRIVER = "QODBC";

public:
    explicit ExcelCon(QObject *parent = nullptr);
    QVariantMap ExcelInstance(const QString & filepath);
    QVariantMap ExcelOdbcInstance(const QString & driver, const QString & filepath);

    ~ExcelCon();

signals:

};

#endif // EXCELCON_H
