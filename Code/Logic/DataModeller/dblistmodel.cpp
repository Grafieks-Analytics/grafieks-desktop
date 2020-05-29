#include "dblistmodel.h"


DBListModel::DBListModel(QObject *parent):
    QSqlQueryModel(parent)
{
    this->setQuery("SHOW DATABASES");
}

void DBListModel::setQuery(const QString &query, const QSqlDatabase &db)
{
    QSqlQueryModel::setQuery(query, db);
    generateRoleNames();
}

void DBListModel::setQuery(const QSqlQuery &query)
{
    QSqlQueryModel::setQuery(query);
    generateRoleNames();
}

QVariant DBListModel::data(const QModelIndex &index, int role) const
{
    QVariant value;

    if(role < Qt::UserRole) {
        value = QSqlQueryModel::data(index, role);
    }
    else {
        int columnIdx = role - Qt::UserRole - 1;
        QModelIndex modelIndex = this->index(index.row(), columnIdx);
        value = QSqlQueryModel::data(modelIndex, Qt::DisplayRole);
    }


    return value;
}

QHash<int, QByteArray> DBListModel::roleNames() const
{
    return m_roleNames;
}

void DBListModel::callQuery(QString queryString)
{
    this->setQuery("SHOW DATABASES LIKE '%"+queryString+"%'");
}

void DBListModel::generateRoleNames()
{
    m_roleNames.clear();
    for( int i = 0; i < record().count(); i ++) {
        m_roleNames.insert(Qt::UserRole + i + 1, record().fieldName(i).toUtf8());
    }
}
