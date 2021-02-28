#include "exceltocsv.h"

ExcelToCsv::ExcelToCsv(QObject *parent) : QObject(parent)
{
}

QStringList ExcelToCsv::convertExcelToCsv(QString &excelPath)
{

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
        worksheet->dynamicCall("SaveAs(const QString&, int)", QDir::toNativeSeparators(QDir::tempPath() +"/"+ saveCsvName), 6);
        outputList << QDir::tempPath() +"/"+ saveCsvName;
    }

    /* Close the workbook*/
    workbook->dynamicCall("Close()");
    excel->dynamicCall("Quit()");

    return outputList;
}
