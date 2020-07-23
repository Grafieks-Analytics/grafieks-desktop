#ifndef SCHEDULER_H
#define SCHEDULER_H

#include <QObject>

class Scheduler : public QObject
{
    Q_OBJECT

    int m_schedulerId;
    QString m_schedulerName;

public:
    explicit Scheduler(const int & schedulerId, const QString & schedulerName, QObject *parent = nullptr);

    Q_PROPERTY(int schedulerId READ schedulerId WRITE setSchedulerId NOTIFY schedulerIdChanged)
    Q_PROPERTY(QString schedulerName READ schedulerName WRITE setSchedulerName NOTIFY schedulerNameChanged)


    int schedulerId() const;
    QString schedulerName() const;

public slots:

    void setSchedulerId(int schedulerId);
    void setSchedulerName(QString schedulerName);

signals:

    void schedulerIdChanged(int schedulerId);
    void schedulerNameChanged(QString schedulerName);
};

#endif // SCHEDULER_H
