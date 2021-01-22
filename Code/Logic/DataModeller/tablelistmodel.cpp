#include "tablelistmodel.h"

TableListModel::TableListModel(QObject *parent): QSqlQueryModel(parent)
{

}

void TableListModel::setQuery(const QString &query, const QSqlDatabase &db)
{
    QSqlQueryModel::setQuery(query, db);
    generateRoleNames();
}

void TableListModel::setQuery(const QSqlQuery &query)
{
    QSqlQueryModel::setQuery(query);
    generateRoleNames();
}

QVariant TableListModel::data(const QModelIndex &index, int role) const
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

QHash<int, QByteArray> TableListModel::roleNames() const
{
    return m_roleNames;
}


void TableListModel::callQuery(QString queryString)
{

    switch(Statics::currentDbIntType){


    case Constants::mysqlIntType:{

        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlStrType);

        if (queryString != ""){

            this->setQuery("SHOW TABLES LIKE '%"+queryString+"%'", dbMysql);
        } else{
            this->setQuery("SHOW TABLES", dbMysql);
        }

        break;
    }

    case Constants::mysqlOdbcIntType:{

        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlOdbcStrType);

        if (queryString != ""){

            this->setQuery("SHOW TABLES LIKE '%"+queryString+"%'", dbMysql);
        } else{
            this->setQuery("SHOW TABLES", dbMysql);
        }

        break;
    }

    case Constants::sqliteIntType:{

        QSqlDatabase dbSqlite = QSqlDatabase::database(Constants::sqliteStrType);

        if (queryString != ""){
            this->setQuery("SELECT name FROM sqlite_master WHERE type='table' AND name LIKE '%"+queryString+"%'  AND name != 'sqlite_%'", dbSqlite);
        } else{
            this->setQuery("SELECT name FROM sqlite_master WHERE type='table' AND name != 'sqlite_%'", dbSqlite);
        }

        break;
    }
    case Constants::postgresIntType:{

        QSqlDatabase dbPostgres = QSqlDatabase::database(Constants::postgresOdbcStrType);

        if (queryString != ""){

            this->setQuery("SHOW TABLES LIKE '%"+queryString+"%'", dbPostgres);
        } else{
            this->setQuery("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'", dbPostgres);
        }

        break;
    }

    }
}


void TableListModel::generateRoleNames()
{

    m_roleNames.clear();
    QString roleName = "tableName";
    m_roleNames.insert(Qt::UserRole + 1, roleName.toUtf8());

}
