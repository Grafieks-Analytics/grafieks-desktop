#ifndef QUERYSTATSMODEL_H
#define QUERYSTATSMODEL_H

#include <QObject>
#include <QSqlQueryModel>
#include <QSqlRecord>
#include <QSqlField>
#include <QSqlDatabase>
#include <QObject>

#include "../../Connectors/mysqlcon.h"
#include "../../statics.h"

class QueryStatsModel : public QSqlQueryModel
{
    Q_OBJECT
public:
    explicit QueryStatsModel(QObject *parent = nullptr);
    void setQuery(const QString &query, const QSqlDatabase &db = QSqlDatabase());
    void setQuery(const QSqlQuery &query);
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;

    Q_INVOKABLE void callQuery();

private:
    void generateRoleNames();
    QHash<int, QByteArray> m_roleNames;
    QSqlDatabase dbMysql;

signals:

};

#endif // QUERYSTATSMODEL_H
