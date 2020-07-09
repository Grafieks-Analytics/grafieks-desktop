#include "qttest2.h"


QtTest2::QtTest2(QObject *parent) :
    QSqlQueryModel(parent)
{
}


void QtTest2::setQuery(const QString &query, const QSqlDatabase &db)
{
    QSqlQueryModel::setQuery(query, db);
    generateRoleNames();
}

void QtTest2::setQuery(const QSqlQuery & query)
{
    QSqlQueryModel::setQuery(query);
    generateRoleNames();
}

void QtTest2::generateRoleNames()
{
    m_roleNames.clear();
    for( int i = 0; i < record().count(); i ++) {
        m_roleNames.insert(Qt::UserRole + i + 1, record().fieldName(i).toUtf8());
    }
}

QVariant QtTest2::data(const QModelIndex &index, int role) const
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

void QtTest2::callSql()
{
//    MysqlCon mysqlcon;
//    QVariantMap response = mysqlcon.MysqlInstance("localhost", "grafieks_my", 3306, "root", "123@312QQl");

//    qDebug() << response << "Testing CPP";

//    Statics::currentDbName = "grafieks_my";
//    Statics::currentDbIntType = Constants::mysqlIntType;
//    Statics::currentDbStrType = Constants::mysqlStrType;

    QSqlDatabase dbMysql = QSqlDatabase::addDatabase("QMYSQL");
    dbMysql.setHostName("localhost");
    dbMysql.setPort(3306);
    dbMysql.setDatabaseName("grafieks_my");
    dbMysql.setUserName("root");
    dbMysql.setPassword("123@312QQl");

    dbMysql.open();


    this->setQuery("SELECT * FROM users");
}
