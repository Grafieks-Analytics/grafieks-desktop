#ifndef LIVEPROCESSOR_H
#define LIVEPROCESSOR_H

#include <QObject>
#include <QDebug>

#include "../General/generalparamsmodel.h"

#include "../../statics.h"
#include "../../constants.h"
#include "../../duckdb.hpp"

class LiveProcessor : public QObject
{
    Q_OBJECT
    QString filePath;
    GeneralParamsModel *generalParamsModel;

public:
    explicit LiveProcessor(GeneralParamsModel *gpm = nullptr, QObject *parent = nullptr);

    Q_INVOKABLE void setArguments(QString filePath);

signals:

};

#endif // LIVEPROCESSOR_H
