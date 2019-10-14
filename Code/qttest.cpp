#include "./Headers/qttest.h"

QtTest::QtTest(QObject *parent) : QObject(parent), a(1)
{
}


void QtTest::firstSlot(QString slot_a)
{
    // Testing SQLITE starts

    const QString DRIVER("QSQLITE");
    if(QSqlDatabase::isDriverAvailable(DRIVER)){

        QSqlDatabase db = QSqlDatabase::addDatabase(DRIVER);
        db.setDatabaseName("grafieks.db");

        if(!db.open())
            qWarning() << "ERROR: " << db.lastError();

        QSqlQuery query;
        query.prepare("SELECT name , email FROM user");
        if(!query.exec())
        {
            qDebug() << "Can't Execute Query !";
        }
        else
        {
            qDebug() << "Query Executed Successfully !";
            while(query.next())
            {
                qDebug() << "Employee Name : " << query.value(0).toString();
                qDebug() << "Employee Email : " << query.value(1).toString();
            }
        }
    }

    // Testing SQLITE ends

}

