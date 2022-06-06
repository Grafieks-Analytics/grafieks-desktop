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
    void closeConnection();

    ~ExcelCon();

public slots:
    //! Deprecated. Will be removed in future version
    //! Convert Excel sheets to csv and save as separate files with existing sheet names.
    void convertExcelToCsv();

signals:
    //! Deprecated. This signal and functionalites will be removed in the future
    void convertedExcelPaths(QStringList paths);

};

#endif // EXCELCON_H
