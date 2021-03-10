#include "qttest2.h"

/*!
 * \brief QtTest2::QtTest2
 * \param parent
 * \qmlsignal
 * \
 */

QtTest2::QtTest2(QObject *parent) : QAbstractTableModel(parent)
{
    contactNames << "a" << "b" << "c";
    contactPhoneNums << "1"<< "2" << "3";
}

int QtTest2::rowCount(const QModelIndex &) const
{
    return 2;
}

int QtTest2::columnCount(const QModelIndex &) const
{
    return 2;
}

QVariant QtTest2::data(const QModelIndex &index, int role) const
{
    switch (role) {
    case Qt::DisplayRole:
        return QString("%1, %2").arg(index.column()).arg(index.row());
    default:
        break;
    }

    return QVariant();
}

QVariant QtTest2::headerData(int section, Qt::Orientation orientation, int role) const
{
    if (role == Qt::DisplayRole && orientation == Qt::Horizontal) {
       return QString("Name" + QString::number(section));
    }
    return QVariant();

}

QHash<int, QByteArray> QtTest2::roleNames() const
{
    return { {Qt::DisplayRole, "display"} };
}


