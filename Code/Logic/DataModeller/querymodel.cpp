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

void QueryModel::callSql()
{

    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:{
        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlStrQueryType);
        this->setQuery(this->tmpSql(), dbMysql);

        break;
    }

    }
}

QString QueryModel::tmpSql() const
{
    return m_tmpSql;
}

void QueryModel::setTmpSql(QString tmpSql)
{
    if (m_tmpSql == tmpSql)
        return;

    m_tmpSql = tmpSql;
    emit tmpSqlChanged(m_tmpSql);
}

void QueryModel::generateRoleNames()
{
    m_roleNames.clear();
    for( int i = 0; i < record().count(); i ++) {
        m_roleNames.insert(Qt::UserRole + i + 1, record().fieldName(i).toUtf8());
    }
}
