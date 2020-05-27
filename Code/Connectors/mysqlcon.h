#ifndef MYSQLCON_H
#define MYSQLCON_H

#include <QSql>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlQueryModel>
#include <QSqlRecord>
#include <QSqlError>
#include <QtDebug>
#include <QObject>


#include "../constants.h"
#include "../statics.h"

class MysqlCon : public QObject
{
    Q_OBJECT
    QVariantMap outputStatus;
    QVector<QStringList *> outputData;
    QStringList outputResult;
    QStringList tableList;
    QStringList dbList;
    const QString DRIVER = "QMYSQL";

public:
    explicit MysqlCon(QObject *parent = nullptr);
    QVariantMap MysqlInstance(const QString & host, const QString & db, const int & port, const QString & username, const QString & password);

    ~MysqlCon();

    QVector<QStringList *> MysqlSelect(QString &sqlQuery);
    QStringList MysqlListDbs();
    QStringList MysqlListTables(QString &db);

signals:



};

#endif // MYSQLCON_H
