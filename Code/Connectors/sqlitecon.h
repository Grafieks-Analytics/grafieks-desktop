#ifndef SQLITECON_H
#define SQLITECON_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlDriver>
#include <QSqlError>
#include <QSqlQuery>
#include <QDebug>
#include <QSqlQueryModel>
#include <QSqlRecord>

#include "../Logic/General/constants.h"

class Sqlitecon : public QObject
{
    Q_OBJECT

    QVariantMap outputStatus;
    QVector<QStringList> outputData;
    QStringList outputResult;
    QStringList tableList;

public:
    explicit Sqlitecon(QObject *parent = nullptr);
    QVariantMap SqliteInstance(const QString & filepath, const QString & username, const QString & password);

    QVector<QStringList> SqliteSelect(QString &sqlQuery);
    QStringList SqliteTables();

signals:




};

#endif // SQLITECON_H
