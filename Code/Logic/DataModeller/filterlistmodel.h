#ifndef FILTERLISTMODEL_H
#define FILTERLISTMODEL_H

#include <QAbstractListModel>
#include <QVariant>
#include <QObject>
#include <QDebug>

#include <typeinfo>

#include "filterlist.h"
#include "../General/querysplitter.h"

class FilterListModel : public QAbstractListModel
{
    Q_OBJECT

    int counter;
    QuerySplitter mQuerySplitter;
    QList <FilterList *> mFilter;

    QString setRelation(QString relation, bool exclude, bool isNull);



public:
    explicit FilterListModel(QObject *parent = nullptr);

    Q_INVOKABLE int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role) const;
    bool setData(const QModelIndex &index, const QVariant &value, int role);
    Qt::ItemFlags flags(const QModelIndex& index) const;
    QHash<int, QByteArray> roleNames() const;

    Q_INVOKABLE void newFilter(QString section = "",QString category = "", QString subcategory = "", QString tableName = "", QString colName = "", QString relation = "", QVariant val = "", bool includeNull = true, bool exclude = false);
    Q_INVOKABLE void deleteFilter(int FilterIndex);
    Q_INVOKABLE void updateFilter(int FilterIndex, QString section = "", QString category = "", QString subcategory = "", QString tableName = "", QString colName = "", QString relation = "", QVariant value = "", bool includeNull = true, bool exclude = false);
    Q_INVOKABLE void callQueryModel(QString tmpSql);

    void addFilterList(FilterList * filter);
    void columnList(QVariantList &columns);


    enum Roles{
        FilterListIdRole = Qt::UserRole +1,
        FilterListSectionRole,
        FilterListCategoryRole,
        FilterListSubCategoryRole,
        FilterListTableNameRole,
        FilterListColumnNameRole,
        FilterListRelationRole,
        FilterListValueRole,
        FilterListIncludeNullRole,
        FilterListExcludeRole
    };

    int rowCountSize;

signals:
    void rowCountChanged();
    void sendFilterQuery(QString & filteredQuery);

};

#endif // FILTERLISTMODEL_H
