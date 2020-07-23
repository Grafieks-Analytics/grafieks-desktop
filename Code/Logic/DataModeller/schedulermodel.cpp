#include "schedulermodel.h"

SchedulerModel::SchedulerModel(QObject *parent) : QAbstractListModel(parent)
{

}

int SchedulerModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_scheduler->dataItems().count();
}

QVariant SchedulerModel::data(const QModelIndex &index, int role) const
{

    if(index.row() < 0 || index.row() >= m_scheduler->dataItems().count()){
        return QVariant();
    }
    Scheduler * scheduler = m_scheduler->dataItems().at(index.row());

    if(role == SchedulerIdRole)
        return scheduler->schedulerId();
    if(role == SchedulerNameRole)
        return scheduler->schedulerName();


    return QVariant();
}

bool SchedulerModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    Scheduler * scheduler = m_scheduler->dataItems().at(index.row());
    bool somethingChanged = false;

    switch(role){
    case SchedulerIdRole:

        if(scheduler->schedulerId() != value.toInt()){
            scheduler->setSchedulerId(value.toInt());
            somethingChanged = true;
        }
        break;
    case SchedulerNameRole:
        if(scheduler->schedulerName() != value.toString()){
            scheduler->setSchedulerName(value.toString());
            somethingChanged = true;
        }
        break;

    }
    if(somethingChanged){
        emit dataChanged(index,index,QVector<int> () << role);
        return true;
    }
    return false;
}

Qt::ItemFlags SchedulerModel::flags(const QModelIndex &index) const
{
    if(!index.isValid())
        return Qt::NoItemFlags;
    return Qt::ItemIsEditable;
}

QHash<int, QByteArray> SchedulerModel::roleNames() const
{
    QHash<int, QByteArray> roles;

    roles[SchedulerIdRole] = "ScheduleID";
    roles[SchedulerNameRole] = "Name";

    return roles;
}

SchedulerDS *SchedulerModel::scheduler() const
{
    return m_scheduler;
}

void SchedulerModel::setScheduler(SchedulerDS *scheduler)
{
    beginResetModel();

    if( m_scheduler && signalsConnected)
        m_scheduler->disconnect(this);

    m_scheduler = scheduler;

    connect(m_scheduler,&SchedulerDS::preItemAdded,this,[=](){
        const int index = m_scheduler->dataItems().count();
        beginInsertRows(QModelIndex(),index,index);
    });

    connect(m_scheduler,&SchedulerDS::postItemAdded,this,[=](){
        endInsertRows();
    });

    endResetModel();
}

