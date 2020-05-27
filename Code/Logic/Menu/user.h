#ifndef USER_H
#define USER_H

#include <QObject>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QSettings>
#include <QTimer>
#include <QEventLoop>
#include <QDebug>

#include "../../Api/login.h"
#include "../../Api/logout.h"
#include "../../constants.h"

class User : public QObject
{
    Q_OBJECT

public:
    explicit User(QObject *parent = nullptr);

    Q_INVOKABLE void setHost(const QString &value);
    Q_INVOKABLE void setPassword(const QString &value);
    Q_INVOKABLE void setUsername(const QString &value);
    Q_INVOKABLE void checkLogin();
    Q_INVOKABLE void logout();


signals:
    void loginStatus(QVariantMap status);
    void logoutStatus(QVariantMap status);

private:

    QString username;
    QString password;
    QString host;


};

#endif // USER_H
