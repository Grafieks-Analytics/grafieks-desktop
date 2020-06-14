#include "qttest2.h"


QtTest2::QtTest2(QObject *parent):QAbstractTableModel(parent)
{

}

QVariant QtTest2::headerData(int section, Qt::Orientation orientation, int role) const
{
    if(role == Qt::DisplayRole){
            if(orientation == Qt::Horizontal)
                return  QString("hor-%1").arg(section);
            else
                return QString("ver-%1").arg(section);
        }
        return QVariant();
}

int QtTest2::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
            return 0;
        return 20;
}

int QtTest2::columnCount(const QModelIndex &parent) const
{
    if (parent.isValid())
            return 0;
        return 20;
}

QVariant QtTest2::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
            return QVariant();
        if(role == Qt::DisplayRole
                && index.row() >= 0 && index.row() < rowCount()
                && index.column() >= 0 && index.column() < columnCount())
            return QString("data %1-%2").arg(index.row()).arg(index.column());
        return QVariant();
}
