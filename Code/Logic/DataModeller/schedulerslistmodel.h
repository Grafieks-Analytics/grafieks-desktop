#ifndef SCHEDULERSLISTMODEL_H
#define SCHEDULERSLISTMODEL_H

#include <QAbstractListModel>
#include <QObject>

#include "schedulerslistds.h"

class SchedulersListModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(SchedulersListDS * schedulerslistds READ schedulerslistds WRITE setSchedulersListds)

public:
    explicit SchedulersListModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role) const;
    bool setData(const QModelIndex &index, const QVariant &value, int role);
    Qt::ItemFlags flags(const QModelIndex& index) const;
    QHash<int, QByteArray> roleNames() const;

    SchedulersListDS *schedulerslistds() const;
    void setSchedulersListds(SchedulersListDS * schedulerslistds);

    enum DatasourceRoles{
        SchedulerIdRole = Qt::UserRole + 1,
        SchedulerNameRole

    };

signals:

private:
    SchedulersListDS * m_schedulerslistds;
    bool signalsConnected {false};


};

#endif // SCHEDULERSLISTMODEL_H
