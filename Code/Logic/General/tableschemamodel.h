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
    void tableSchemaObtained(QList <QStringList> allList, QList <QStringList> allCategorical, QList <QStringList> allNumerical, QList <QStringList> allDates, QList <QStringList> allOthers,QStringList queriedColumnNames);

private:

    QString dataType(QString parameter);
    
    QList<QStringList> allList;
    QList<QStringList> allCategorical;
    QList<QStringList> allNumerical;
    QList<QStringList> allDates;
    QList<QStringList> allOthers;
    QStringList queriedColumnNames;

};

#endif // TABLESCHEMAMODEL_H
