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
#include "datatype.h"
#include "querysplitter.h"

/*!
 * \class TableSchemaModel
 * \brief Generates schema of a given table(s) in a given query
 * \ingroup General
 */
class TableSchemaModel : public QObject
{
    Q_OBJECT
    DataType dataType;
    QuerySplitter querySplitter;

public:
    explicit TableSchemaModel(QObject *parent = nullptr);

    Q_INVOKABLE void showSchema(QString query = "");

signals:
    void tableSchemaObtained(QList<QStringList> allList, QList<QStringList> allCategorical, QList<QStringList> allNumerical, QList<QStringList> allDates, QList<QStringList> allOthers, QStringList queriedColumnNames);

private:
    QList<QStringList> allList;
    QList<QStringList> allCategorical;
    QList<QStringList> allNumerical;
    QList<QStringList> allDates;
    QList<QStringList> allOthers;
    QStringList queriedColumnNames;
};

#endif // TABLESCHEMAMODEL_H
