#include "columnlistmodel.h"

ColumnListModel::ColumnListModel(QObject *parent) : QSqlQueryModel(parent)
{

}

void ColumnListModel::setQuery(const QString &query, const QSqlDatabase &db)
{
    QSqlQueryModel::setQuery(query, db);
    generateRoleNames();
}

void ColumnListModel::setQuery(const QSqlQuery &query)
{
    QSqlQueryModel::setQuery(query);
    generateRoleNames();
}

QVariant ColumnListModel::data(const QModelIndex &index, int role) const
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

QHash<int, QByteArray> ColumnListModel::roleNames() const
{
    return {{Qt::DisplayRole, "display"}};
}

void ColumnListModel::columnQuery(QString columnName, QString tableName, int pageNo)
{

    QString queryString;
    int lowerLimit = 0;
    int upperLimit = 0;
    int pageLimit = 1000;

    // Set the page limit
    // for the query

    if(pageNo == 0){
        lowerLimit = 0;
    } else{
        lowerLimit = pageNo * pageLimit;
    }

    upperLimit = lowerLimit + pageLimit;


    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:{


        queryString = "SELECT DISTINCT " + columnName + " FROM "+ tableName + " LIMIT " + QString::number(lowerLimit) + ", "+ QString::number(upperLimit);

        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlStrType);
        this->setQuery(queryString, dbMysql);

        break;
    }

    }
}



void ColumnListModel::likeColumnQuery(QString columnName, QString tableName, QString searchString)
{
    QString queryString;

    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:{

        if (searchString != ""){
            queryString = "SELECT DISTINCT " + columnName + " FROM "+ tableName + " WHERE " + columnName + " LIKE '%"+searchString+"%'";
        } else{
            queryString = "SELECT DISTINCT " + columnName + " FROM "+ tableName;
        }


        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlStrType);
        this->setQuery(queryString, dbMysql);

        break;
    }

    }
}

void ColumnListModel::generateRoleNames()
{
    m_roleNames.clear();
    QString roleName = "tableName";
    m_roleNames.insert(Qt::UserRole + 1, roleName.toUtf8());
}
