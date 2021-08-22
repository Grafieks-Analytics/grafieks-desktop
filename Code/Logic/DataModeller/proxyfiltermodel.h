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

    Q_INVOKABLE void callQueryModels(QString tmpSql, FilterCategoricalListModel *categoryModel, FilterDateListModel * dateModel, FilterNumericalListModel *numericalModel);

private:
    QString getQueryJoiner();

signals:
    void sendFilterQuery(QString &filteredQuery);
    void sendCsvFilterQuery(QString &filteredQuery);
    void sendExcelFilterQuery(QString &filteredQuery);

};

#endif // PROXYFILTERMODEL_H
