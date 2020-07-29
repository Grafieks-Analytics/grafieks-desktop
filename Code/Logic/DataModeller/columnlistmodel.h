#ifndef COLUMNLISTMODEL_H
#define COLUMNLISTMODEL_H

#include <QSqlQueryModel>
#include <QSqlRecord>
#include <QSqlField>
#include <QSqlDatabase>
#include <QObject>
#include <QDebug>

#include "../../Connectors/allconnectors.h"
#include "../../statics.h"
#include "../../constants.h"

class ColumnListModel : public QSqlQueryModel
{
    Q_OBJECT
public:
    explicit ColumnListModel(QObject *parent = nullptr);
    void setQuery(const QString &query, const QSqlDatabase &db = QSqlDatabase());
    void setQuery(const QSqlQuery &query);
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;

    Q_INVOKABLE void likeColumnQuery(QString columnName, QString tableName, QString searchString = "");
    Q_INVOKABLE void columnQuery(QString columnName, QString tableName, int pageNo = 0);

private:
    void generateRoleNames();
    QHash<int, QByteArray> m_roleNames;

};

#endif // COLUMNLISTMODEL_H
