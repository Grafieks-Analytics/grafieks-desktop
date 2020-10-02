#ifndef FILTERDATELISTMODEL_H
#define FILTERDATELISTMODEL_H

#include <QAbstractListModel>
#include <QVariant>
#include <QObject>
#include <QDebug>

#include <typeinfo>

#include "filterdatelist.h"
#include "../General/querysplitter.h"

class FilterDateListModel : public QAbstractListModel
{
    Q_OBJECT

    int counter;
    QuerySplitter mQuerySplitter;
    QList <FilterDateList *> mFilter;
    QStringList sqlComparisonOperators;


public:
    explicit FilterDateListModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role) const;
    bool setData(const QModelIndex &index, const QVariant &value, int role);
    Qt::ItemFlags flags(const QModelIndex& index) const;
    QHash<int, QByteArray> roleNames() const;

    void callNewFilter();

    Q_INVOKABLE void newFilter(QString section = "",QString category = "", QString subcategory = "", QString tableName = "", QString colName = "", QString relation = "", QString val = "", bool includeNull = true, bool exclude = false);
    Q_INVOKABLE void deleteFilter(int FilterIndex);
    Q_INVOKABLE void updateFilter(int FilterIndex, QString section = "", QString category = "", QString subcategory = "", QString tableName = "", QString colName = "", QString relation = "", QString value = "", bool includeNull = true, bool exclude = false);
    Q_INVOKABLE void callQueryModel(QString tmpSql);

    void addFilterList(FilterDateList * filter);
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

private:

    QString setRelation(QString tableName, QString columnName, QString relation, QString conditions, bool exclude, bool isNull);


signals:
    void rowCountChanged();
    void sendFilterQuery(QString & filteredQuery);

};


#endif // FILTERDATELISTMODEL_H
