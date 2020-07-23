#ifndef SCHEDULERMODEL_H
#define SCHEDULERMODEL_H

#include <QAbstractListModel>
#include <QObject>

#include "schedulerds.h"

class SchedulerModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(SchedulerDS * scheduler READ scheduler WRITE setScheduler)

public:
    explicit SchedulerModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role) const;
    bool setData(const QModelIndex &index, const QVariant &value, int role);
    Qt::ItemFlags flags(const QModelIndex& index) const;
    QHash<int, QByteArray> roleNames() const;

    SchedulerDS * scheduler() const;

    enum SchedulerRoles{
        SchedulerIdRole = Qt::UserRole +1,
        SchedulerNameRole
    };

public slots:

    void setScheduler(SchedulerDS * scheduler);

signals:


private:

    bool signalsConnected {false};
    SchedulerDS * m_scheduler;
};

#endif // SCHEDULERMODEL_H
