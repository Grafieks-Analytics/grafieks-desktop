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

    connect( login, &Login::loginStatus, &loop, &QEventLoop::quit, Qt::UniqueConnection );
    connect( &timer, &QTimer::timeout, &loop, &QEventLoop::quit, Qt::UniqueConnection );

    timer.start(Constants::ApiWaitTime);
    loop.exec();

    if(timer.isActive()){
        outputStatus = login->getOutputStatus();

    } else{
        outputStatus.insert("code", Constants::GeneralErrorCode);
        outputStatus.insert("msg", Constants::GeneralTimeOut);
    }

    emit loginStatus(outputStatus);


}

void User::logout()
{
    Logout *logout = new Logout(this);

    QVariantMap outputStatus;
    QTimer timer;
    QEventLoop loop;

    timer.setSingleShot(true);

    connect( logout, &Logout::logoutStatus, &loop, &QEventLoop::quit, Qt::UniqueConnection );
    connect( &timer, &QTimer::timeout, &loop, &QEventLoop::quit, Qt::UniqueConnection );

    timer.start(Constants::ApiWaitTime);
    loop.exec();

    if(timer.isActive()){
        outputStatus = logout->getOutputStatus();

    } else{
        outputStatus.insert("code", Constants::GeneralErrorCode);
        outputStatus.insert("msg", Constants::GeneralTimeOut);
    }

    emit logoutStatus(outputStatus);
}


