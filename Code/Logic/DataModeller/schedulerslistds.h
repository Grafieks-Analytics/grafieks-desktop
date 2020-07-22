#ifndef SCHEDULERSLISTDS_H
#define SCHEDULERSLISTDS_H

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QSettings>
#include <QObject>

#include "schedulerslist.h"

class SchedulersListDS : public QObject
{
    Q_OBJECT
public:
    explicit SchedulersListDS(QObject *parent = nullptr);

    Q_INVOKABLE void fetchSchedulersList();

    void addScheduler(SchedulersList * schedulersList);
    Q_INVOKABLE void addScheduler(const int & schedulerId,  const QString & schedulerName);

    QList<SchedulersList *> dataItems();
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
    QList<SchedulersList*> m_schedulersList;

};

#endif // SCHEDULERSLISTDS_H
