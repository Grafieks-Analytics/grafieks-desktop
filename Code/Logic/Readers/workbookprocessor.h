#ifndef WORKBOOKPROCESSOR_H
#define WORKBOOKPROCESSOR_H

#include <QObject>
#include <QDebug>

#include "../General/generalparamsmodel.h"

#include "../../statics.h"
#include "../../constants.h"
#include "../../duckdb.hpp"

class WorkbookProcessor : public QObject
{
    Q_OBJECT
    QString filePath;
    GeneralParamsModel *generalParamsModel;

public:
    explicit WorkbookProcessor(GeneralParamsModel *gpm = nullptr, QObject *parent = nullptr);

    Q_INVOKABLE void setArguments(QString filePath);

signals:

};

#endif // WORKBOOKPROCESSOR_H
