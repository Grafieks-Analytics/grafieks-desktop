#ifndef TABLESCHEMAMODEL_H
#define TABLESCHEMAMODEL_H

#include <QSqlRecord>
#include <QSqlField>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
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
    Q_INVOKABLE void showSchema(QString query = "");

signals:
    void tableSchemaObtained(QList <QStringList> allColumnNames, QStringList queriedColumnNames);

private:
    
    QList<QStringList> allColumnNames;
    QStringList queriedColumnNames;

};

#endif // TABLESCHEMAMODEL_H
