#ifndef MYSQLCONNECT_H
#define MYSQLCONNECT_H

#include <QSql>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QObject>

class MysqlConnect : public QObject
{
    Q_OBJECT
public:
    explicit MysqlConnect(QObject *parent = nullptr);

signals:
    void connectStatus(QString status);

public slots:
    void startConnection(QString host, QString username, QString password, QString db);

private:
    QSqlDatabase db;
};

#endif // MYSQLCONNECT_H
