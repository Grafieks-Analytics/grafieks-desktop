#ifndef CHARTSMODEL_H
#define CHARTSMODEL_H

#include <QObject>

#include "duckreportsds.h"
#include "sqlreportsds.h"

class ChartsModel : public QObject
{
    Q_OBJECT
public:
    explicit ChartsModel(QObject *parent = nullptr);

signals:

};

#endif // CHARTSMODEL_H
