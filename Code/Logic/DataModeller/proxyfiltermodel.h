#ifndef PROXYFILTERMODEL_H
#define PROXYFILTERMODEL_H

#include <QVariant>
#include <QObject>
#include <QDebug>

#include <typeinfo>

#include "filtercategoricallistmodel.h"
#include "filterdatelistmodel.h"
#include "filternumericallistmodel.h"

#include "../General/querysplitter.h"
#include "../../statics.h"
#include "../../constants.h"

class ProxyFilterModel : public QObject
{
    Q_OBJECT

    QuerySplitter mQuerySplitter;

public:
    explicit ProxyFilterModel(QObject *parent = nullptr);

    Q_INVOKABLE void callQueryModels(QString tmpSql, FilterCategoricalListModel *categoryModel = nullptr, FilterDateListModel * dateModel = nullptr, FilterNumericalListModel *numericalModel = nullptr);

private:
    QString getQueryJoiner();

signals:
    void sendFilterQuery(QString &existingWhereConditions, QString &newWhereConditions);
    void sendExcelFilterQuery(QString &existingWhereConditions, QString &newWhereConditions);
    void sendModels(FilterCategoricalListModel *categoryModel, FilterNumericalListModel * numericalModel, FilterDateListModel *dateModel);

};

#endif // PROXYFILTERMODEL_H
