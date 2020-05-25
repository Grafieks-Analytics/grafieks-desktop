#ifndef QTTEST2_H
#define QTTEST2_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QSettings>
#include <QDebug>


#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QQmlApplicationEngine>

class QtTest2 : public QObject
{
    Q_OBJECT
public:
    explicit QtTest2(QObject *parent = nullptr);

    Q_INVOKABLE void fetchPosts();

//    Q_INVOKABLE void removeLast();


//    QStringList jokes() const;

    bool initialize();

private slots:

    void dataReadyRead();
    void dataReadFinished();

signals:

private:

    void resetModel();

    QNetworkAccessManager *mNetManager;
    QNetworkReply *mNetReply;
    QByteArray * mDataBuffer;
    QString mBuffer;
    QStringList mJokes;
    QQmlApplicationEngine mEngine;

};

#endif // QTTEST2_H
