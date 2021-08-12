#include "excelcon.h"

ExcelCon::ExcelCon(QObject *parent) : QObject(parent)
{

}

QVariantMap ExcelCon::ExcelInstance(const QString &filepath)
{
    QVariantMap outputStatus;
    QFile file(filepath);

    if (!file.open(QIODevice::ReadOnly)) {

            outputStatus.insert("status", false);
            outputStatus.insert("msg", file.errorString());

            file.close();
    }
    else{

        outputStatus.insert("status", true);
        outputStatus.insert("msg", Messages::GeneralSuccessMsg);
    }

    return outputStatus;
}

QVariantMap ExcelCon::ExcelOdbcInstance(const QString &driver, const QString &filepath)
{
    QVariantMap outputStatus;

    if(QSqlDatabase::isDriverAvailable("QODBC")){


        // Sample Connection for Excel
        // dbOdbc.setDatabaseName("DRIVER={Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)};DBQ=C:\\Users\\chill\\Desktop\\all.xls");
        QString dbString = "DRIVER={" + driver + "};DBQ="+ filepath;

        QSqlDatabase dbExcelOdbc = QSqlDatabase::addDatabase("QODBC", Constants::excelOdbcStrType);

        dbExcelOdbc.setDatabaseName(dbString);
        dbExcelOdbc.open();

        if(!dbExcelOdbc.isOpen()){
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

void ExcelCon::closeConnection()
{

    QSqlDatabase dbExcelOdbc = QSqlDatabase::database(Constants::excelOdbcStrType);
    if(dbExcelOdbc.isOpen()) {
        dbExcelOdbc.removeDatabase(Constants::excelOdbcStrType);
        dbExcelOdbc.close();
    }

    Statics::currentDbName = "";
    Statics::currentDbClassification = "";
    Statics::currentDbIntType = -1;
    Statics::currentDbStrType = "";
}


void ExcelCon::convertExcelToCsv()
{
    QString excelPath = Statics::currentDbName;
    QStringList outputList;
    QFileInfo fi(excelPath);

    /* When pApplication is destructed, all its related child objects will be cleaned up, a kind of scope pointer */
    QScopedPointer<QAxObject> excel(new QAxObject());

    /* Connect Excel control */
    excel->setControl("Excel.Application");

    /* false means do not display the form */
    excel->dynamicCall("SetVisible(bool)", false);

    /* Do not display any warning messages. If it is true, a prompt similar to "File has been modified, whether to save" will appear when closing */
    excel->setProperty("DisplayAlerts", false);

    /* Get workbook collection (object) */
    QAxObject *workbooks = excel->querySubObject("Workbooks");

    /* Get the current workbook */
    QAxObject *workbook = workbooks->querySubObject("Open(const QString &)", excelPath); // Open an Excel file

    /* Get the worksheet of the worksheet collection */
    QAxObject *worksheets = workbook->querySubObject("WorkSheets");
    worksheets->dumpObjectTree();

    /* Get worksheet 1 of the worksheet collection, namely sheet1 */
    int count = worksheets->dynamicCall("Count()").toInt();

    for(int i = 1; i <= count; i++){
        QAxObject *worksheet = worksheets->querySubObject("Item(int)", i);
        QString saveCsvName =   worksheet->dynamicCall("Name()").toString();

        /* Save as file, 3: txt file (space separated) | 6: csv file (comma separated)*/
        // For the Save As integer values, visit https://docs.microsoft.com/en-us/office/vba/api/excel.xlfileformat
        worksheet->dynamicCall("SaveAs(const QString&, int)", QDir::toNativeSeparators(QDir::tempPath() +"/"+ saveCsvName), 62);
        outputList << QDir::tempPath() +"/"+ saveCsvName;
    }

    /* Close the workbook*/
    workbook->dynamicCall("Close()");
    excel->dynamicCall("Quit()");

    qDebug() << outputList << "CONV PATHS";

    emit convertedExcelPaths(outputList);
}


ExcelCon::~ExcelCon()
{
}
