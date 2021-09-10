#ifndef NEWTABLECOLUMNSMODEL_H
#define NEWTABLECOLUMNSMODEL_H

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

class NewTableColumnsModel : public QObject
{
    Q_OBJECT
    DataType dataType;
    int csvHeaderLength;
    QList<QByteArray> csvHeaderDataFinal;

public:
    explicit NewTableColumnsModel(QObject *parent = nullptr);

    Q_INVOKABLE void getColumnsForTable(QString tableName = "", QString moduleName = "");
    Q_INVOKABLE void clearColumns();

signals:
    void columnListObtained(QList<QStringList> allColumns, QString tableName, QString moduleName);


private:
    QList<QStringList> allColumns;
    void setHeaders(const QByteArray line, QString delimiter);
    QList<QStringList> detectHeaderTypes(const QByteArray line, QString delimiter);

};

#endif // NEWTABLECOLUMNSMODEL_H
