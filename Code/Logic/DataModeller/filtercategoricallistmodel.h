#ifndef FILTERCATEGORICALLISTMODEL_H
#define FILTERCATEGORICALLISTMODEL_H

#include <QAbstractListModel>
#include <QVariant>
#include <QObject>
#include <QDebug>

#include <typeinfo>

#include "filtercategoricallist.h"
#include "../General/querysplitter.h"
#include "../../statics.h"
#include "../../constants.h"

class FilterCategoricalListModel : public QAbstractListModel
{
    Q_OBJECT

    int counter;
    QuerySplitter mQuerySplitter;
    QList <FilterCategoricalList *> mFilter;
    QStringList sqlComparisonOperators;


public:
    explicit FilterCategoricalListModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role) const;
    bool setData(const QModelIndex &index, const QVariant &value, int role);
    Qt::ItemFlags flags(const QModelIndex& index) const;
    QHash<int, QByteArray> roleNames() const;


    Q_INVOKABLE void newFilter(QString section = "",QString category = "", QString subcategory = "", QString tableName = "", QString colName = "", QString relation = "", QString slug = "", QString val = "", bool includeNull = true, bool exclude = false);
    Q_INVOKABLE void deleteFilter(int FilterIndex);
    Q_INVOKABLE void updateFilter(int FilterIndex, QString section = "", QString category = "", QString subcategory = "", QString tableName = "", QString colName = "", QString relation = "", QString slug = "", QString value = "", bool includeNull = true, bool exclude = false);
    Q_INVOKABLE QString callQueryModel();

    void addFilterList(FilterCategoricalList * filter);


    enum Roles{
        FilterListIdRole = Qt::UserRole +1,
        FilterListSectionRole,
        FilterListCategoryRole,
        FilterListSubCategoryRole,
        FilterListTableNameRole,
        FilterListColumnNameRole,
        FilterListRelationRole,
        FilterListSlugRole,
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

#endif // FILTERCATEGORICALLISTMODEL_H
