#ifndef EXCELCON_H
#define EXCELCON_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlQueryModel>
#include <QSqlRecord>
#include <QSqlError>
#include <QtDebug>
#include <QFile>
#include <QAxObject>
#include <QDir>

#include <jsoncons/json.hpp>
#include <jsoncons_ext/csv/csv.hpp>

#include "../constants.h"
#include "../Messages.h"
#include "../statics.h"

using namespace jsoncons;
using namespace jsoncons::csv;

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
    void closeConnection();

//    QStringList convertExcelToCsv(QString &excelPath);
    ~ExcelCon();

public slots:
    void convertExcelToCsv();

signals:
    void convertedExcelPaths(QStringList paths);

};

#endif // EXCELCON_H
