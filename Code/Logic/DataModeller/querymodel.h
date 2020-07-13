#ifndef QUERYMODELLER_H
#define QUERYMODELLER_H

#include <QSqlQueryModel>
#include <QSqlRecord>
#include <QSqlField>
#include <QSqlDatabase>
#include <QObject>

#include "../../Connectors/allconnectors.h"

class QueryModel : public QSqlQueryModel
{
    Q_OBJECT

public:
    explicit QueryModel(QObject *parent = 0);

    void setQuery(const QString &query, const QSqlDatabase &db = QSqlDatabase());
    void setQuery(const QSqlQuery &query);
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;

    Q_INVOKABLE void callSql(QString queryString);

private:
    void generateRoleNames();
    QHash<int, QByteArray> m_roleNames;

};

#endif // QUERYMODELLER_H
