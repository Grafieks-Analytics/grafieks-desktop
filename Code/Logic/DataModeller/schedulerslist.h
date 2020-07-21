#ifndef SCHEDULERSLIST_H
#define SCHEDULERSLIST_H

#include <QObject>

class SchedulersList : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int schedulerId READ schedulerId WRITE setSchedulerId NOTIFY schedulerIdChanged)
    Q_PROPERTY(QString schedulerName READ schedulerName WRITE setSchedulerName NOTIFY schedulerNameChanged)

    int m_schedulerId;
    QString m_schedulerName;

public:
    explicit SchedulersList(const int & schedulerId, const QString & schedulerName, QObject *parent = nullptr);
    int schedulerId() const;
    QString schedulerName() const;

public slots:
    void setSchedulerId(int schedulerId);
    void setSchedulerName(QString schedulerName);

signals:

    void schedulerIdChanged(int schedulerId);
    void schedulerNameChanged(QString schedulerName);
};

#endif // SCHEDULERSLIST_H
