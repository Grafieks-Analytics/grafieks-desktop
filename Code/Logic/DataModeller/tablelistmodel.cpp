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

        QSqlDatabase dbMysqlOdbc = QSqlDatabase::database(Constants::mysqlOdbcStrType);

        if (queryString != ""){

            this->setQuery("SHOW TABLES LIKE '%"+queryString+"%'", dbMysqlOdbc);
        } else{
            this->setQuery("SHOW TABLES", dbMysqlOdbc);
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

            this->setQuery("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_name LIKE '%"+queryString+"%'", dbPostgres);
        } else{
            this->setQuery("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'", dbPostgres);
        }

        break;
    }
    case Constants::redshiftIntType:{

        QSqlDatabase dbRedshift = QSqlDatabase::database(Constants::redshiftOdbcStrType);

        if (queryString != ""){

            this->setQuery("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_name LIKE '%"+queryString+"%'", dbRedshift);
        } else{
            this->setQuery("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'", dbRedshift);
        }

        break;
    }

    case Constants::excelIntType:{

        QSqlDatabase dbExcel = QSqlDatabase::database(Constants::excelStrType);

        if (queryString != ""){

            this->setQuery("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_name LIKE '%"+queryString+"%'", dbExcel);
        } else{
            this->setQuery("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'", dbExcel);
        }

        break;
    }
    case Constants::mssqlIntType:{

        QSqlDatabase dbMssql = QSqlDatabase::database(Constants::mssqlOdbcStrType);

        if (queryString != ""){

            this->setQuery("SELECT name FROM SYSOBJECTS WHERE xtype = 'U' AND name LIKE '%"+queryString+"%'", dbMssql);
        } else{
            this->setQuery("SELECT name FROM SYSOBJECTS WHERE xtype = 'U'", dbMssql);
        }

        break;
    }

    case Constants::oracleIntType:{

        QSqlDatabase dbOracle = QSqlDatabase::database(Constants::oracleOdbcStrType);

        if (queryString != ""){

            this->setQuery("SELECT table_name FROM user_tables WHERE table_name LIKE '%"+queryString+"%'", dbOracle);
        } else{
            this->setQuery("SELECT table_name FROM user_tables", dbOracle);
        }

        break;
    }

    case Constants::mongoIntType:{

        QSqlDatabase dbMongo = QSqlDatabase::database(Constants::mongoOdbcStrType);

        if (queryString != ""){

            this->setQuery("SELECT table_name FROM user_tables WHERE table_name LIKE '%"+queryString+"%'", dbMongo);
        } else{
            this->setQuery("SELECT table_name FROM user_tables", dbMongo);
        }

        break;
    }

    case Constants::impalaIntType:{

        QSqlDatabase dbImpala = QSqlDatabase::database(Constants::impalaOdbcStrType);

        if (queryString != ""){

            this->setQuery("SELECT table_name FROM user_tables WHERE table_name LIKE '%"+queryString+"%'", dbImpala);
        } else{
            this->setQuery("SELECT table_name FROM user_tables", dbImpala);
        }

        break;
    }

    case Constants::hiveIntType:{

        QSqlDatabase dbHive = QSqlDatabase::database(Constants::hiveOdbcStrType);

        if (queryString != ""){

            this->setQuery("SELECT table_name FROM user_tables WHERE table_name LIKE '%"+queryString+"%'", dbHive);
        } else{
            this->setQuery("SELECT table_name FROM user_tables", dbHive);
        }

        break;
    }

    case Constants::snowflakeIntType:{

        QSqlDatabase dbSnowflake = QSqlDatabase::database(Constants::snowflakeOdbcStrType);

        if (queryString != ""){

            this->setQuery("SELECT table_name FROM user_tables WHERE table_name LIKE '%"+queryString+"%'", dbSnowflake);
        } else{
            this->setQuery("SELECT table_name FROM user_tables", dbSnowflake);
        }

        break;
    }

    case Constants::teradataIntType:{

        QSqlDatabase dbTeradata = QSqlDatabase::database(Constants::teradataOdbcStrType);

        if (queryString != ""){

            this->setQuery("SELECT table_name FROM user_tables WHERE table_name LIKE '%"+queryString+"%'", dbTeradata);
        } else{
            this->setQuery("SELECT table_name FROM user_tables", dbTeradata);
        }

        break;
    }

    case Constants::accessIntType:{

        QSqlDatabase dbAccess = QSqlDatabase::database(Constants::accessOdbcStrType);

        if (queryString != ""){

            this->setQuery("SELECT MSysObjects.name FROM MSysObjects WHERE MSysObjects.type IN (1,4,6) AND MSysObjects.name NOT LIKE '~*'  AND MSysObjects.name NOT LIKE 'MSys*' ORDER BY MSysObjects.name LIKE '%"+queryString+"%'", dbAccess);
        } else{
            this->setQuery("SELECT MSysObjects.name FROM MSysObjects WHERE MSysObjects.type IN (1,4,6) AND MSysObjects.name NOT LIKE '~*'  AND MSysObjects.name NOT LIKE 'MSys*' ORDER BY MSysObjects.name", dbAccess);
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
