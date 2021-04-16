#include "accesscon.h"

AccessCon::AccessCon(QObject *parent) : QObject(parent)
{

}

QVariantMap AccessCon::AccessOdbcInstance(const QString &driver, const QString &db, const QString &username, const QString &password)
{
    QVariantMap outputStatus;

    if(QSqlDatabase::isDriverAvailable("QODBC")){

        // Driver={Microsoft Access Driver (*.mdb, *.accdb)};Dbq=C:\mydatabase.accdb;Uid=Admin;Pwd=;

        QString dbString = "DRIVER={" + driver + "}" + ";Dbq=" + db;

        QSqlDatabase dbAccessOdbc = QSqlDatabase::addDatabase("QODBC", Constants::accessOdbcStrType);

        dbAccessOdbc.setDatabaseName(dbString);
        dbAccessOdbc.setUserName(username);
        dbAccessOdbc.setPassword(password);
        dbAccessOdbc.open();

        if(!dbAccessOdbc.isOpen()){
            outputStatus.insert("status", false);
            outputStatus.insert("msg", dbAccessOdbc.lastError().text());

        } else{

            // Save static values to access it later on other objects
            // For automatic connection for other instances
            // If correct credentials inserted once
            qDebug() << dbAccessOdbc.record("Contacts");

            Statics::acDb = QUrl(db).toLocalFile();
            Statics::acUsername = username;
            Statics::acPassword = password;

            outputStatus.insert("status", true);
            outputStatus.insert("msg", Messages::GeneralSuccessMsg);
        }

    } else{
        outputStatus.insert("status", false);
        outputStatus.insert("msg", Messages::GeneralNoDriver);
    }

    return outputStatus;
}

AccessCon::~AccessCon()
{

}
