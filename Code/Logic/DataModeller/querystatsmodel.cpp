#include "querystatsmodel.h"

QueryStatsModel::QueryStatsModel(QObject *parent) : QSqlQueryModel(parent),
    m_profileStatus(false)
{

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
    return {{Qt::DisplayRole, "display"}};
}

void QueryStatsModel::setProfiling(bool status)
{

    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:{
        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlStrQueryType);
        if(status == true){
            this->setQuery("SET profiling = 1", dbMysql);

        } else{
            this->setQuery("SET profiling = 0", dbMysql);
        }

        break;
    }

    }

}

void QueryStatsModel::resetProfiling()
{
    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:{

        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlStrQueryType);
        this->setQuery("SET profiling = 0", dbMysql);
        this->setQuery("SET profiling_history_size = 0", dbMysql);
        this->setQuery("SET profiling_history_size = 100", dbMysql);
        this->setQuery("SET profiling = 1", dbMysql);

        break;
    }

    }
}

void QueryStatsModel::showStats()
{

    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:{

        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlStrQueryType);
        this->setQuery("SHOW profiles", dbMysql);

        break;
    }
    }
}


bool QueryStatsModel::profileStatus() const
{
    return m_profileStatus;
}

void QueryStatsModel::setProfileStatus(bool profileStatus)
{
    if (m_profileStatus == profileStatus)
        return;

    m_profileStatus = profileStatus;
    emit profileStatusChanged(m_profileStatus);
}


void QueryStatsModel::generateRoleNames()
{
    m_roleNames.clear();
    QString roleName = "tableName";
    m_roleNames.insert(Qt::UserRole + 1, roleName.toUtf8());
}
