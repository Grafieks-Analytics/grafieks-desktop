#ifndef DUCKQUERYMODEL_H
#define DUCKQUERYMODEL_H

#include<QAbstractListModel>
#include <QObject>

#include "../../duckdb.hpp"
#include "../../statics.h"
#include "../../constants.h"
#include "../Connectors/duckcon.h"

#include "../General/datatype.h"
#include "../General/querysplitter.h"

class DuckQueryModel : public QAbstractListModel
{
    Q_OBJECT

public:
    explicit DuckQueryModel(QObject *parent = nullptr);
    explicit DuckQueryModel(DuckCon *duckCon, QObject *parent = nullptr);

    Q_INVOKABLE void setQuery(QString query);
    int rowCount(const QModelIndex &parent = QModelIndex()) const;
//    bool setData(const QModelIndex &index, const QVariant &value, int role);
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;

    Q_INVOKABLE void getQueryStats();

private:
    void generateRoleNames();
    void setQueryResult();

    QHash<int, QByteArray> m_roleNames;
    QList<QStringList> resultData;
    int internalRowCount;

    DuckCon *duckCon;
    QString query;
    QuerySplitter querySplitter;

signals:

};

#endif // DUCKQUERYMODEL_H
