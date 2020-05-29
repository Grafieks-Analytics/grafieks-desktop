#ifndef DBLISTDS_H
#define DBLISTDS_H

#include <QSqlQueryModel>
#include <QSqlRecord>
#include <QSqlField>
#include <QSqlDatabase>
#include <QObject>

#include "../../Connectors/mysqlcon.h"
#include "../../statics.h"

class DBListModel : public QSqlQueryModel
{
    Q_OBJECT

public:
    explicit DBListModel(QObject *parent = 0);

    void setQuery(const QString &query, const QSqlDatabase &db = QSqlDatabase());
    void setQuery(const QSqlQuery &query);
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;

    Q_INVOKABLE void callQuery(QString queryString);

private:
    void generateRoleNames();
    QHash<int, QByteArray> m_roleNames;

};

#endif // DBLISTDS_H
