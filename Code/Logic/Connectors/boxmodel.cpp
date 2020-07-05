#include "boxmodel.h"

BoxModel::BoxModel(QObject *parent) : QAbstractListModel(parent)
{

}

int BoxModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_box->dataItems().count();
}

QVariant BoxModel::data(const QModelIndex &index, int role) const
{
    if(index.row() < 0 || index.row() >= m_box->dataItems().count()){
        return QVariant();
    }
    Box * box = m_box->dataItems().at(index.row());
    if(role == IdRole)
        return box->id();
    if(role == NameRole)
        return box->name();
    if(role == TypeRole)
        return box->type();
    if(role == ModifiedAtRole)
        return box->modifiedAt();
    if(role == ExtensionRole)
        return box->extension();

    return QVariant();
}

bool BoxModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    Box * box = m_box->dataItems().at(index.row());
    bool somethingChanged = false;

    switch(role){
    case IdRole:
        if(box->id() != value.toString()){
            box->setId(value.toString());
            somethingChanged = true;
        }
        break;
    case NameRole:
        if(box->name() != value.toString()){
            box->setName(value.toString());
            somethingChanged = true;
        }
        break;
    case TypeRole:
        if(box->type() != value.toString()){
            box->setType(value.toString());
            somethingChanged = true;
        }
        break;
    case ModifiedAtRole:
        if(box->modifiedAt() != value.toString()){
            box->setModifiedAt(value.toString());
            somethingChanged = true;
        }
        break;
    case ExtensionRole:
        if(box->extension() != value.toString()){
            box->setExtension(value.toString());
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

Qt::ItemFlags BoxModel::flags(const QModelIndex &index) const
{
    if(!index.isValid())
        return Qt::NoItemFlags;
    return Qt::ItemIsEditable;
}

QHash<int, QByteArray> BoxModel::roleNames() const
{
    QHash<int, QByteArray> roles;

    roles[IdRole] = "id";
    roles[NameRole] = "name";
    roles[TypeRole] = "type";
    roles[ModifiedAtRole] = "modifiedAt";
    roles[ExtensionRole] = "extension";

    return roles;
}

BoxDS *BoxModel::boxds() const
{
    return m_box;
}

void BoxModel::setBoxds(BoxDS *box)
{
    beginResetModel();
    if(m_box && signalsConnected)
        m_box->disconnect(this);

    m_box = box;

    connect(m_box,&BoxDS::preItemAdded,this,[=](){
        const int index = m_box->dataItems().count();
        beginInsertRows(QModelIndex(),index,index);
    });

    connect(m_box,&BoxDS::postItemAdded,this,[=](){
        endInsertRows();
    });

    connect(m_box,&BoxDS::preReset,this,[=](){
        beginResetModel();
    });

    connect(m_box,&BoxDS::postReset,this,[=](){
        endResetModel();
    });

    endResetModel();
}
