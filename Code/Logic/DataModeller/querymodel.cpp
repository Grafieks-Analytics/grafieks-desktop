#include "querymodel.h"


QueryModel::QueryModel(QObject *parent): QSqlQueryModel(parent)
{

}

void QueryModel::setQuery(const QString &query, const QSqlDatabase &db)
{
    QSqlQueryModel::setQuery(query, db);
    generateRoleNames();
}

void QueryModel::setQuery(const QSqlQuery &query)
{
    QSqlQueryModel::setQuery(query);
    generateRoleNames();
}

QVariant QueryModel::data(const QModelIndex &index, int role) const
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

QHash<int, QByteArray> QueryModel::roleNames() const
{
    return {{Qt::DisplayRole, "display"}};
}

void QueryModel::callSql(QString tmpSql)
{

    this->executeQuery(tmpSql);
}


void QueryModel::receiveFilterQuery(QString &filteredQuery)
{
    this->executeQuery(filteredQuery);
}

void QueryModel::generateRoleNames()
{
    m_roleNames.clear();
    for( int i = 0; i < record().count(); i ++) {
        m_roleNames.insert(Qt::UserRole + i + 1, record().fieldName(i).toUtf8());
    }
}

void QueryModel::executeQuery(QString &query)
{

    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:{
        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlStrQueryType);
        this->setQuery(query, dbMysql);

        break;
    }
    case Constants::sqliteIntType:{
        qDebug() << query << " Query Model";
        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::sqliteStrQueryType);
        qDebug() << dbMysql;
        this->setQuery(query, dbMysql);

        break;
    }
    case Constants::mysqlOdbcIntType:{
        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlOdbcStrQueryType);
        this->setQuery(query, dbMysql);

        break;
    }
    case Constants::sqliteIntType:{
        QSqlDatabase dbSqlite = QSqlDatabase::database(Constants::sqliteStrQueryType);
        this->setQuery(query, dbSqlite);

        break;
    }
    case Constants::postgresIntType:{
        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::postgresOdbcStrQueryType);
        this->setQuery(query, dbMysql);

        break;
    }

    }
}
