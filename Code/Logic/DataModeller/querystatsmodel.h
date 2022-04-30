#ifndef QUERYSTATSMODEL_H
#define QUERYSTATSMODEL_H

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
    Q_PROPERTY(bool profileStatus READ profileStatus WRITE setProfileStatus NOTIFY profileStatusChanged)

public:
    explicit QueryStatsModel(QObject *parent = nullptr);
    void setQuery(const QString &query, const QSqlDatabase &db = QSqlDatabase());
    void setQuery(const QSqlQuery &query);
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;

    Q_INVOKABLE void setProfiling(bool status);
    Q_INVOKABLE void showStats();

    bool profileStatus() const;

public slots:

    void setProfileStatus(bool profileStatus);

private:
    void generateRoleNames();
    QHash<int, QByteArray> m_roleNames;
    QSqlDatabase dbMysql;
    bool m_profileStatus;

signals:

void profileStatusChanged(bool profileStatus);
};

#endif // QUERYSTATSMODEL_H
