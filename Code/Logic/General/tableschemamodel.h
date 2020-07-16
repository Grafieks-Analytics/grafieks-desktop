#ifndef TABLESCHEMAMODEL_H
#define TABLESCHEMAMODEL_H

#include <QSqlRecord>
#include <QSqlField>
#include <QSqlDatabase>
#include <QObject>
#include <QDebug>

#include "../../Connectors/allconnectors.h"
#include "../../statics.h"
#include "../../constants.h"

class TableSchemaModel : public QObject
{
    Q_OBJECT
public:
    explicit TableSchemaModel(QObject *parent = nullptr);
    Q_INVOKABLE QString showSchema(QString tableName = "");

signals:

private:


};

#endif // TABLESCHEMAMODEL_H
