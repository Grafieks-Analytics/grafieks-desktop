#ifndef LIVEPROCESSOR_H
#define LIVEPROCESSOR_H

#include <QObject>
#include <QDebug>

#include "../General/generalparamsmodel.h"
#include "../DataModeller/dsparamsmodel.h"

#include "../../statics.h"
#include "../../constants.h"
#include "../../duckdb.hpp"

class LiveProcessor : public QObject
{
    Q_OBJECT
    QString filePath;
    GeneralParamsModel *generalParamsModel;
    DSParamsModel *dsParamsModel;

public:
    explicit LiveProcessor(GeneralParamsModel *gpm = nullptr, DSParamsModel *dsp = nullptr, QObject *parent = nullptr);

    Q_INVOKABLE void setArguments(QString filePath);

signals:

};

#endif // LIVEPROCESSOR_H
