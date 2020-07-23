#ifndef SCHEDULERDS_H
#define SCHEDULERDS_H

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QSettings>
#include <QObject>

#include "scheduler.h"

class SchedulerDS : public QObject
{
    Q_OBJECT
public:
    explicit SchedulerDS(QObject *parent = nullptr);

    Q_INVOKABLE void fetchSchedulers();

    void addScheduler(Scheduler * datasource);

    Q_INVOKABLE void addScheduler(const int & schedulerId, const QString & schedulerName);

    QList<Scheduler *> dataItems();

signals:
    void preItemAdded();
    void postItemAdded();

private slots:

    void dataReadyRead();
    void dataReadFinished();


public slots:

private :
    QNetworkAccessManager * m_networkAccessManager;
    QNetworkReply * m_networkReply;
    QByteArray * m_dataBuffer;
    QList<Scheduler*> m_scheduler;

};

#endif // SCHEDULERDS_H
