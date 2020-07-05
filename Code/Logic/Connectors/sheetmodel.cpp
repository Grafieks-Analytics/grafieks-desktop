#include "sheetmodel.h"

SheetModel::SheetModel(QObject *parent) : QAbstractListModel(parent)
{

}

int SheetModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_sheet->dataItems().count();
}

QVariant SheetModel::data(const QModelIndex &index, int role) const
{
    if(index.row() < 0 || index.row() >= m_sheet->dataItems().count()){
        return QVariant();
    }
    Sheet * sheet = m_sheet->dataItems().at(index.row());
    if(role == IdRole)
        return sheet->id();
    if(role == NameRole)
        return sheet->name();
    if(role == KindRole)
        return sheet->kind();
    if(role == ModifiedTimeRole)
        return sheet->modifiedTime();
    if(role == ExtensionRole)
        return sheet->extension();

    return QVariant();
}

bool SheetModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    Sheet * sheet = m_sheet->dataItems().at(index.row());
    bool somethingChanged = false;
    switch(role){
        case IdRole:
        if(sheet->id() != value.toString()){
            sheet->setId(value.toString());
            somethingChanged = true;
        }
        break;
    case NameRole:
        if(sheet->name() != value.toString()){
            sheet->setName(value.toString());
            somethingChanged = true;
        }
        break;
    case KindRole:
        if(sheet->kind() != value.toString()){
            sheet->setKind(value.toString());
            somethingChanged = true;
        }
    case ModifiedTimeRole:
        if(sheet->modifiedTime() != value.toString()){
            sheet->setModifiedTime(value.toString());
            somethingChanged = true;
        }
        break;
    case ExtensionRole:
        if(sheet->extension() != value.toString()){
            sheet->setExtension(value.toString());
            somethingChanged= true;
        }
        break;


    }
    if(somethingChanged){
        emit dataChanged(index,index,QVector<int> () << role);
        return true;
    }
    return false;
}

Qt::ItemFlags SheetModel::flags(const QModelIndex &index) const
{
    if(!index.isValid())
        return Qt::NoItemFlags;
    return Qt::ItemIsEditable;
}

QHash<int, QByteArray> SheetModel::roleNames() const
{
    QHash<int, QByteArray> roles;

    roles[IdRole] = "id";
    roles[NameRole] = "name";
    roles[KindRole] = "kind";
    roles[ModifiedTimeRole] = "modifiedTime";
    roles[ExtensionRole] = "extension";

    return roles;
}

SheetDS *SheetModel::sheetds() const
{
    return m_sheet;
}

void SheetModel::setSheetds(SheetDS *sheet)
{
    beginResetModel();
    if(m_sheet && signalsConnected)
        m_sheet->disconnect(this);

    m_sheet = sheet;

    connect(m_sheet,&SheetDS::preItemAdded,this,[=](){
        const int index = m_sheet->dataItems().count();
        beginInsertRows(QModelIndex(),index,index);
    });

    connect(m_sheet,&SheetDS::postItemAdded,this,[=](){
        endInsertRows();
    });

    connect(m_sheet,&SheetDS::preReset,this,[=](){
        beginResetModel();
    });

    connect(m_sheet,&SheetDS::postReset,this,[=](){
        endResetModel();
    });

    endResetModel();


}
