#ifndef SCHEDULERSLISTMODEL_H
#define SCHEDULERSLISTMODEL_H

#include <QAbstractListModel>
#include <QObject>

#include "schedulerslistds.h"

class SchedulersListModel : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit SchedulersListModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role) const;
    bool setData(const QModelIndex &index, const QVariant &value, int role);
    Qt::ItemFlags flags(const QModelIndex& index) const;
    QHash<int, QByteArray> roleNames() const; //Allows to expose our custom roles( names,favoritecolor,age) to a qml ListView

    SchedulersListDS *schedulerlistds() const;
    void setDatasourceds(SchedulersListDS * schedulerlistds);

    enum DatasourceRoles{
        SchedulerIdRole = Qt::UserRole + 1,
        SchedulerNameRole

    };

signals:

private:
    SchedulersListDS * m_scheduler;
    bool signalsConnected {false};

};

#endif // SCHEDULERSLISTMODEL_H
