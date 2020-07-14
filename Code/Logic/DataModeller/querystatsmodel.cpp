#include "querystatsmodel.h"

QueryStatsModel::QueryStatsModel(QObject *parent) : QSqlQueryModel(parent)
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
    if(status == true){
        this->setQuery("SET profiling = 1");
    } else{
        this->setQuery("SET profiling = 0");
    }

    //    this->setQuery("SHOW PROFILES");
}

void QueryStatsModel::resetProfiling()
{
    this->setQuery("SET profiling = 0");
    this->setQuery("SET profiling_history_size = 0");
    this->setQuery("SET profiling_history_size = 100");
    this->setQuery("SET profiling = 1");
}

void QueryStatsModel::showStats()
{
    this->setQuery("SHOW profiles");
}

void QueryStatsModel::generateRoleNames()
{
    m_roleNames.clear();
    QString roleName = "tableName";
    m_roleNames.insert(Qt::UserRole + 1, roleName.toUtf8());
}
