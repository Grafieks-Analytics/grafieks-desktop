#include "excelcon.h"

ExcelCon::ExcelCon(QObject *parent) : QObject(parent)
{

}

QVariantMap ExcelCon::ExcelOdbcInstance(const QString &driver, const QString &filepath)
{
    QVariantMap outputStatus;

    if(QSqlDatabase::isDriverAvailable(ODBCDRIVER)){

        // Sample Connection for Excel
        // dbOdbc.setDatabaseName("DRIVER={Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)};DBQ=C:\\Users\\vishal\\Desktop\\Book1.xlsx");

        QString dbString = "DRIVER={" + driver + "};DBQ="+ filepath;

        QSqlDatabase dbExcelOdbc = QSqlDatabase::addDatabase(ODBCDRIVER, Constants::excelOdbcStrType);

        dbExcelOdbc.setDatabaseName(dbString);

        if(!dbExcelOdbc.open()){
            outputStatus.insert("status", false);
            outputStatus.insert("msg", dbExcelOdbc.lastError().text());

        } else{

            outputStatus.insert("status", true);
            outputStatus.insert("msg", Messages::GeneralSuccessMsg);
        }

    } else{
        outputStatus.insert("status", false);
        outputStatus.insert("msg", Messages::GeneralNoDriver);
    }

    return outputStatus;
}


ExcelCon::~ExcelCon()
{

    QSqlDatabase dbExcelOdbc = QSqlDatabase::database(Constants::excelOdbcStrType);
    if(dbExcelOdbc.isOpen()) dbExcelOdbc.close();
}
