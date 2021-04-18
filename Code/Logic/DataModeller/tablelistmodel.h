#ifndef TABLELISTMODEL_H
#define TABLELISTMODEL_H

#include <QSqlQueryModel>
#include <QSqlRecord>
#include <QSqlField>
#include <QSqlDatabase>
#include <QObject>
#include <QDebug>

#include "../../Connectors/allconnectors.h"
#include "../../statics.h"
#include "../../constants.h"

class TableListModel : public QSqlQueryModel
{
    Q_OBJECT

public:
    explicit TableListModel(QObject *parent = 0);

    void setQuery(const QString &query, const QSqlDatabase &db = QSqlDatabase());
    void setQuery(const QSqlQuery &query);
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;

    Q_INVOKABLE void callQuery(QString queryString = "");

private:
    void generateRoleNames();
    QHash<int, QByteArray> m_roleNames;

};

#endif // TABLELISTMODEL_H