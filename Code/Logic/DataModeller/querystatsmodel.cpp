#include "querystatsmodel.h"

QueryStatsModel::QueryStatsModel(QObject *parent) : QSqlQueryModel(parent)
{

//    QSqlDatabase dbMysql = QSqlDatabase::addDatabase("QMYSQL");
//    dbMysql.setHostName("localhost");
//    dbMysql.setPort(3306);
//    dbMysql.setDatabaseName("grafieks_my");
//    dbMysql.setUserName("root");
//    dbMysql.setPassword("123@312QQl");

//    dbMysql.open();
//    this->setQuery("SET profiling = 1", dbMysql);
}

void QueryStatsModel::setQuery(const QString &query, const QSqlDatabase &db)
{
    QSqlQueryModel::setQuery(query, db);
    generateRoleNames();
}

void QueryStatsModel::setQuery(const QSqlQuery &query)
{
    QSqlQueryModel::setQuery(query);
    generateRoleNames();
}

QVariant QueryStatsModel::data(const QModelIndex &index, int role) const
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

QHash<int, QByteArray> QueryStatsModel::roleNames() const
{
    return m_roleNames;
}

void QueryStatsModel::callQuery()
{
    QSqlDatabase dbMysql = QSqlDatabase::addDatabase("QMYSQL");
    dbMysql.setHostName("localhost");
    dbMysql.setPort(3306);
    dbMysql.setDatabaseName("grafieks_my");
    dbMysql.setUserName("root");
    dbMysql.setPassword("123@312QQl");

    dbMysql.open();

    this->setQuery("SET profiling = 1", dbMysql);
    this->setQuery("SELECT * FROM users", dbMysql);
    this->setQuery("SHOW PROFILES", dbMysql);

    qDebug() << "In here";

}

void QueryStatsModel::generateRoleNames()
{
    m_roleNames.clear();
    QString roleName = "tableName";
    m_roleNames.insert(Qt::UserRole + 1, roleName.toUtf8());
}
