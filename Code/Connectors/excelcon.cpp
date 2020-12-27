#include "excelcon.h"

ExcelCon::ExcelCon(QObject *parent) : QObject(parent)
{

}

QVariantMap ExcelCon::ExcelOdbcInstance(const QString &driver, const QString &filepath, const QString &password)
{
    QVariantMap outputStatus;

    QSqlDatabase dbOdbc = QSqlDatabase::addDatabase("QODBC", "xlsx_conn");
    dbOdbc.setDatabaseName("DRIVER={Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)};DBQ=C:\\Users\\vishal\\Desktop\\Book1.xlsx");

    if(dbOdbc.open())
    {
        QSqlQuery query("select * from [" + QString("Sheet2") + "$]",dbOdbc);
        // Select range, place A1:B5 after $r
        while (query.next())
        {
            QString column1= query.value(0).toString();
            QString column2= query.value(1).toString();
            QString column3= query.value(2).toString();
            qDebug() << column1 << column2 << column3;
        }
    }
    else {
        qDebug() << dbOdbc.lastError().text();
    }

    return outputStatus;
}

QVariantMap ExcelCon::ExcelInstance(const QString &filepath, const QString &password)
{
    QVariantMap outputStatus;

    return outputStatus;
}

ExcelCon::~ExcelCon()
{

}
