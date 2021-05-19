#ifndef FILTERDATELISTMODEL_H
#define FILTERDATELISTMODEL_H

#include <QAbstractListModel>
#include <QVariant>
#include <QObject>
#include <QDebug>

#include <typeinfo>

#include "filterdatelist.h"
#include "../General/querysplitter.h"
#include "../../statics.h"
#include "../../constants.h"

class FilterDateListModel : public QAbstractListModel
{
    Q_OBJECT

    QuerySplitter mQuerySplitter;
    QList <FilterDateList *> mFilter;
    QStringList sqlComparisonOperators;
    QVariantMap dateFormatMap;
    QVariantMap timeFrameMap;

public:
    explicit FilterDateListModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role) const;
    bool setData(const QModelIndex &index, const QVariant &value, int role);
    Qt::ItemFlags flags(const QModelIndex& index) const;
    QHash<int, QByteArray> roleNames() const;


    Q_INVOKABLE void newFilter(int counter, int dateFormatId, QString section = "",QString category = "", QString subcategory = "", QString tableName = "", QString colName = "", QString relation = "", QString slug = "", QString val = "", QString actualValue = "", bool includeNull = true, bool exclude = false);
    Q_INVOKABLE void deleteFilter(int FilterIndex);
    Q_INVOKABLE void updateFilter(int FilterIndex, int dateFormatId, QString section = "", QString category = "", QString subcategory = "", QString tableName = "", QString colName = "", QString relation = "", QString slug = "", QString value = "", QString actualValue = "", bool includeNull = true, bool exclude = false);
    Q_INVOKABLE QString callQueryModel();
    Q_INVOKABLE void clearFilters();

    Q_INVOKABLE void setDateFormatMap(QVariantMap dateFormatMap);
    Q_INVOKABLE void setTimeFrameMap(QVariantMap timeFrameMap);

    void addFilterList(FilterDateList * filter);


    enum Roles{
        FilterListIdRole = Qt::UserRole +1,
        FilterListDateFormatIdRole,
        FilterListSectionRole,
        FilterListCategoryRole,
        FilterListSubCategoryRole,
        FilterListTableNameRole,
        FilterListColumnNameRole,
        FilterListRelationRole,
        FilterListSlugRole,
        FilterListValueRole,
        FilterListActualValueRole,
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


