#include "user.h"

User::User(QObject *parent) : QObject(parent)
{

}

void User::setHost(const QString &value)
{
    host = value;
}

void User::setPassword(const QString &value)
{
    password = value;
}

void User::setUsername(const QString &value)
{
    username = value;
}

void User::checkLogin()
{
    Login *login = new Login(host, username, password, this);

    QVariantMap outputStatus;
    QTimer timer;
    QEventLoop loop;

    timer.setSingleShot(true);

    connect( login, &Login::loginStatus, &loop, &QEventLoop::quit );
    connect( &timer, &QTimer::timeout, &loop, &QEventLoop::quit );

    timer.start(Constants::ApiWaitTime);
    loop.exec();

    if(timer.isActive()){
        outputStatus = login->getOutputStatus();
        emit loginStatus(outputStatus, true);

    } else{
        outputStatus.insert("code", Constants::GeneralErrorCode);
        outputStatus.insert("msg", Constants::GeneralTimeOut);
        emit loginStatus(outputStatus, false);
    }



}

bool User::checkSession()
{
    return false;
}


