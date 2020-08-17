#include "sheetmodel.h"

/*!
 * \brief Constructor function for SheetModel
 * \param parent
 */
SheetModel::SheetModel(QObject *parent) : QAbstractListModel(parent)
{

}

/*!
 * \brief Override QAbstractListModel::rowCount
 * \details Override method to return the number of results in new model
 * \param parent
 * \return int
 */
int SheetModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_sheet->dataItems().count();
}

/*!
 * \brief Override QAbstractListModel::data
 * \details Override method to return the data of the object for a given index
 * \param index (object index)
 * \param role (object role)
 * \return QVariant
 */
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

/*!
 * \brief Override QAbstractListModel::setData
 * \details Override method to set new data in the object at given index
 * \param index (Object index)
 * \param value (New value for the object at index)
 * \param role (role name)
 * \return bool
 */
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

/*!
 * \brief Override QAbstractListModel::flags
 * \details Override method to tell the model that at given index of the object, data is editable
 * \param index (Object index)
 * \return Qt::ItemFlags
 */
Qt::ItemFlags SheetModel::flags(const QModelIndex &index) const
{
    if(!index.isValid())
        return Qt::NoItemFlags;
    return Qt::ItemIsEditable;
}

/*!
 * \brief Override QAbstractListModel::roleNames
 * \details Override method to tell the view the exact role names with which the value can be accessed from the object
 * \return QHash<int, QByteArray>
 */
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

/*!
 * \brief Getter function for the object
 * \return SheetDS *SheetModel
 */
SheetDS *SheetModel::sheetds() const
{
    return m_sheet;
}

/*!
 * \brief Setter function for the object
 */
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
