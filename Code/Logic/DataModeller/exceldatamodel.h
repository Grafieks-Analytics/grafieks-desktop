#ifndef EXCELDATAMODEL_H
#define EXCELDATAMODEL_H

#include <QObject>
#include <QSqlDatabase>
#include <QAbstractTableModel>
#include <QSqlQuery>
#include <QDebug>

#include <QFile>
#include <QAxObject>
#include <QDir>

#include "../../constants.h"
#include "../../Messages.h"
#include "../../statics.h"


class ExcelDataModel : public QAbstractTableModel
{
    Q_OBJECT
    QMap<int, QString> sheetNamesMap;

    QHash<int, QByteArray> m_roleNames;
    QStringList resultData;
    int totalRowCount;
    int totalColCount;

public:
    explicit ExcelDataModel(QObject *parent = nullptr);
    Q_INVOKABLE void clearData();
    ~ExcelDataModel();

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
    QString getQueryJoiner();
    QStringList getTableListQAXObject();

signals:
    void columnListModelDataChanged(QString options);
};

#endif // EXCELDATAMODEL_H