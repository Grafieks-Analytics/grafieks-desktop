#ifndef CSVJSONDATAMODEL_H
#define CSVJSONDATAMODEL_H

#include <QObject>
#include <QAbstractTableModel>
#include <QFile>
#include <QDebug>

#include "../../statics.h"
#include "../../constants.h"

#include "../General/datatype.h"
#include "../General/querysplitter.h"

class CSVJsonDataModel : public QAbstractTableModel
{
    Q_OBJECT
    int headerLength;
    QStringList masterResultData;
    QList<QByteArray> headerDataFinal;

    DataType dataType;
    QString fileName;

    QHash<int, QByteArray> m_roleNames;
    QStringList resultData;
    int totalRowCount;
    int totalColCount;

public:
    explicit CSVJsonDataModel(QObject *parent = nullptr);
    Q_INVOKABLE void clearData();
    ~CSVJsonDataModel();

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex & = QModelIndex()) const override;
    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void columnData(QString col, QString tableName, QString options);
    Q_INVOKABLE void columnSearchData(QString col, QString tableName, QString searchString, QString options);
    Q_INVOKABLE QStringList getTableList();
    Q_INVOKABLE QStringList filterTableList(QString keyword);

private:

signals:
    void columnListObtained(QList<QStringList> allColumns, QString tableName, QString moduleName);
    void columnListModelDataChanged(QString options = "");

};

#endif // CSVJSONDATAMODEL_H
