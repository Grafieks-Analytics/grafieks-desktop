#ifndef MYSQLLOGINMODEL_H
#define MYSQLLOGINMODEL_H

#include <QObject>
#include <QtDebug>

#include "../../Connectors/mysqlcon.h"

class ConnectorsLoginModel : public QObject
{
    Q_OBJECT
public:
    explicit ConnectorsLoginModel(QObject *parent = nullptr);
    Q_INVOKABLE void mysqlLogin(QString host, QString db, int port, QString username, QString password);


signals:
    void mysqlLoginStatus(QVariantMap status);

};

#endif // MYSQLLOGINMODEL_H
