#ifndef FILTERCSVJSON_H
#define FILTERCSVJSON_H

#include <QObject>
#include <QDebug>

#include "../../constants.h"

class FilterCsvJson : public QObject
{
    Q_OBJECT
public:
    explicit FilterCsvJson(QObject *parent = nullptr);
    bool filteredValue(QVariant currentValue, QString valueList, const QString slug);

signals:

};

#endif // FILTERCSVJSON_H
