#include "schedulerslistmodel.h"

SchedulersListModel::SchedulersListModel(QObject *parent) : QAbstractListModel(parent)
{

}

int SchedulersListModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_scheduler->dataItems().count();
}

QVariant SchedulersListModel::data(const QModelIndex &index, int role) const
{

    if( index.row() < 0 || index.row() >= m_scheduler->dataItems().count()){
        return QVariant();
    }
    SchedulersList * schedulerslist = m_scheduler->dataItems().at(index.row());
    if( role == SchedulerIdRole)
        return schedulerslist->schedulerId();
    if( role == SchedulerNameRole)
        return schedulerslist->schedulerName();

    return QVariant();
}

bool SchedulersListModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    SchedulersList * schedulerslist = m_scheduler->dataItems().at(index.row());
    bool somethingChanged = false;

    switch (role) {
    case  SchedulerIdRole :
        if ( schedulerslist->schedulerId() != value.toString()){
            schedulerslist->setSchedulerId(value.toInt());
            somethingChanged = true;
        }
        break;

    case SchedulerNameRole:
        if ( schedulerslist->schedulerName() != value.toString()){
            schedulerslist->setSchedulerName(value.toString());
            somethingChanged = true;
        }
        break;

    }

    if ( somethingChanged){
        emit dataChanged(index,index,QVector<int> () << role);
        return true;
    }
    return false;
}

Qt::ItemFlags SchedulersListModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;
    return Qt::ItemIsEditable;
}

QHash<int, QByteArray> SchedulersListModel::roleNames() const
{
    QHash<int, QByteArray> roles;

    roles[SchedulerIdRole] = "ScheduleID";
    roles[SchedulerNameRole] = "Name";

    return roles;
}

SchedulersListDS *SchedulersListModel::schedulerlistds() const
{
    return m_scheduler;
}

void SchedulersListModel::setDatasourceds(SchedulersListDS *schedulerlistds)
{
    beginResetModel();

    if( m_scheduler && signalsConnected)
        m_scheduler->disconnect(this);

    m_scheduler = schedulerlistds;

    connect(m_scheduler,&SchedulersListDS::preItemAdded,this,[=](){
        const int index = m_scheduler->dataItems().count();
        beginInsertRows(QModelIndex(),index,index);
    });

    connect(m_scheduler,&SchedulersListDS::postItemAdded,this,[=](){
        endInsertRows();
    });

    endResetModel();
}
