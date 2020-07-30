#ifndef FILTERLISTMODEL_H
#define FILTERLISTMODEL_H

#include <QAbstractListModel>
#include <QVariant>
#include <QObject>

#include <typeinfo>


#include "filterlist.h"

class FilterListModel : public QAbstractListModel
{
    Q_OBJECT

    int counter;
    QList <FilterList *> mFilter;


public:
    explicit FilterListModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role) const;
    bool setData(const QModelIndex &index, const QVariant &value, int role);
    Qt::ItemFlags flags(const QModelIndex& index) const;
    QHash<int, QByteArray> roleNames() const;

    Q_INVOKABLE void newFilter(QString tableName = "", QString colName = "", QString relation = "", QVariant requiredVal = "", QString category = "" );
    Q_INVOKABLE void deleteFilter(int FilterID);
    Q_INVOKABLE void updateFilter(int FilterId, QString tableName = "", QString colName = "", QString relation = "", QVariant value = "", QString category = "" );

    void addFilterList(FilterList * filter);


    enum Roles{
        FilterListIdRole = Qt::UserRole +1,
        FilterListCategoryRole,
        FilterListTableNameRole,
        FilterListColumnNameRole,
        FilterListRelationRole,
        FilterListValueRole
    };

signals:

};

#endif // FILTERLISTMODEL_H
