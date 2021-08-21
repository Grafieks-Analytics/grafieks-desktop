#ifndef CSVJSONQUERYMODEL_H
#define CSVJSONQUERYMODEL_H

#include <QObject>
#include <QAbstractTableModel>
#include <QFile>
#include <QDebug>

#include "../../duckdb.hpp"
#include "../../constants.h"
#include "../../statics.h"

class CSVJsonQueryModel : public QAbstractTableModel
{
    Q_OBJECT
    QStringList headerDataFinal;
    QHash<int, QByteArray> m_roleNames;
    QList<QStringList> resultData;
    int previewRowCount;

public:
    explicit CSVJsonQueryModel(QObject *parent = nullptr);

    Q_INVOKABLE void setSelectParams(QString selectParams);
    Q_INVOKABLE void setPreviewQuery(int previewRowCount);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex & = QModelIndex()) const override;
    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

signals:
    void csvJsonHeaderDataChanged(QStringList tableHeaders);
    void csvJsonHasData(bool hasData);

};

#endif // CSVJSONQUERYMODEL_H
