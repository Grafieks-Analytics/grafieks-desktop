#ifndef CSVJSONDATAMODEL_H
#define CSVJSONDATAMODEL_H

#include <QObject>
#include <QFile>
#include <QDebug>

#include "../../statics.h"
#include "../../constants.h"
#include "../Connectors/duckcon.h"

#include "../General/datatype.h"
#include "../General/querysplitter.h"

class CSVJsonDataModel : public QObject
{
    Q_OBJECT
    int headerLength;
    QList<QByteArray> headerDataFinal;

    DataType dataType;

public:
    explicit CSVJsonDataModel(QObject *parent = nullptr);
    Q_INVOKABLE void clearData();
    ~CSVJsonDataModel();

    Q_INVOKABLE void columnData(QString col, QString tableName, QString options);
    Q_INVOKABLE void columnSearchData(QString col, QString tableName, QString searchString, QString options);
    Q_INVOKABLE QStringList getColumnList(QString tableName, char delimiter, QString moduleName);
    Q_INVOKABLE QStringList getTableList();
    Q_INVOKABLE QStringList filterTableList(QString keyword);

private:
    void setHeaders(const QByteArray line, char delimiter);
    QList<QStringList> detectHeaderTypes(const QByteArray line, char delimiter);

signals:
    void columnListObtained(QList<QStringList> allColumns, QString tableName, QString moduleName);
    void columnListModelDataChanged(QStringList colData, char delimiter = ',', QString options = "");

};

#endif // CSVJSONDATAMODEL_H
