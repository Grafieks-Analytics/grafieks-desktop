#ifndef QUERYMODELLER_H
#define QUERYMODELLER_H

#include <QSqlQueryModel>
#include <QSqlRecord>
#include <QSqlField>
#include <QSqlDatabase>
#include <QObject>

#include "../../Connectors/allconnectors.h"
#include "../../constants.h"


class QueryModel : public QSqlQueryModel
{
    Q_OBJECT


public:
    explicit QueryModel(QObject *parent = 0);

    // QSqlQueryModel method override

    void setQuery(const QString &query, const QSqlDatabase &db = QSqlDatabase());
    void setQuery(const QSqlQuery &query);
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;

    Q_INVOKABLE void callSql(QString tmpSql);

public slots:
    void receiveFilterQuery(QString & filteredQuery);

signals:


private:
    void generateRoleNames();
    QHash<int, QByteArray> m_roleNames;

    void executeQuery(QString & query);
};

#endif // QUERYMODELLER_H
