#ifndef MYSQLLOGINMODEL_H
#define MYSQLLOGINMODEL_H

#include <QObject>
#include <QtDebug>

#include "../../Connectors/allconnectors.h"
#include "../../statics.h"

class ConnectorsLoginModel : public QObject
{
    Q_OBJECT


    Q_PROPERTY(QString currentDbName READ currentDbName WRITE setCurrentDbName NOTIFY currentDbNameChanged)
    Q_PROPERTY(QString currentDbType READ currentDbType WRITE setCurrentDbType NOTIFY currentDbTypeChanged)

    QString m_currentDbName;
    QString m_currentDbType;

public:
    explicit ConnectorsLoginModel(QObject *parent = nullptr);
    Q_INVOKABLE void mysqlLogin(QString host, QString db, int port, QString username, QString password);
    Q_INVOKABLE void sqliteLogin(QString filename, QString username = "", QString password = "");

    QString currentDbName() const;
    QString currentDbType() const;

public slots:
    void setCurrentDbName(QString currentDbName);
    void setCurrentDbType(QString currentDbType);

signals:
    void mysqlLoginStatus(QVariantMap status);
    void sqliteLoginStatus(QVariantMap status);
    void currentDbNameChanged(QString currentDbName);
    void currentDbTypeChanged(QString currentDbType);
};

#endif // MYSQLLOGINMODEL_H
