#include "filterresultmodel.h"

FilterResultModel::FilterResultModel(QObject *parent) : QSqlQueryModel(parent)
{

}

void FilterResultModel::setQuery(const QString &query, const QSqlDatabase &db)
{
    QSqlQueryModel::setQuery(query, db);
    generateRoleNames();
}

void FilterResultModel::setQuery(const QSqlQuery &query)
{
    QSqlQueryModel::setQuery(query);
    generateRoleNames();
}

QVariant FilterResultModel::data(const QModelIndex &index, int role) const
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

QHash<int, QByteArray> FilterResultModel::roleNames() const
{
    return m_roleNames;
}

void FilterResultModel::callQuery(QString fieldName, QString tableName, QString searchString)
{
    QString queryString;

    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:{

        if (searchString != ""){
            queryString = "SELECT DISTINCT " + fieldName + " FROM "+ tableName + " WHERE " + fieldName + " LIKE '%"+searchString+"%'";
        } else{
            queryString = "SELECT DISTINCT " + fieldName + " FROM "+ tableName;
        }

        qDebug() << queryString << "QueryString";


        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlStrType);
        this->setQuery(queryString, dbMysql);

        break;
    }

    }
}

void FilterResultModel::generateRoleNames()
{
    m_roleNames.clear();
    QString roleName = "tableName";
    m_roleNames.insert(Qt::UserRole + 1, roleName.toUtf8());
}
