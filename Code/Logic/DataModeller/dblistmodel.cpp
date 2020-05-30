#include "dblistmodel.h"


DBListModel::DBListModel(QObject *parent):
    QSqlQueryModel(parent)
{

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

    QSqlDatabase dbMysql = QSqlDatabase::addDatabase("QMYSQL");
    dbMysql.setHostName("localhost");
    dbMysql.setPort(3306);
    dbMysql.setDatabaseName("grafieks_my");
    dbMysql.setUserName("root");
    dbMysql.setPassword("123@312QQl");

    dbMysql.open();

    if(queryString != ""){
        this->setQuery("SHOW DATABASES LIKE '%"+queryString+"%'", dbMysql);
    } else{
        this->setQuery("SHOW DATABASES", dbMysql);
    }

}

void DBListModel::callQuery2(QString queryString)
{
//    QSqlDatabase dbMysql = QSqlDatabase::database();

    qDebug() << queryString << "blank";

    if(queryString != ""){
        this->setQuery("SHOW DATABASES LIKE '%"+queryString+"%'");
    } else{
        this->setQuery("SHOW DATABASES");
    }
}

void DBListModel::generateRoleNames()
{
    m_roleNames.clear();
    QString roleName = "dbName";
    m_roleNames.insert(Qt::UserRole + 1, roleName.toUtf8());
}
