#include "exceltocsv.h"

ExcelToCsv::ExcelToCsv(QObject *parent) : QObject(parent)
{

    QString excelFileName  = "C:\\Users\\chill\\Downloads\\Book.xlsx";
    QString csvFileName = "C:\\Users\\chill\\Desktop\\asd.csv";

    if (!QFile::exists(excelFileName)){
            qDebug() << "excelFileName  " << excelFileName << "exist";
//            return false;
        }

        /* When pApplication is destructed, all its related child objects will be cleaned up, a kind of scope pointer */
        QScopedPointer<QAxObject> excel(new QAxObject());
             /* Connect Excel control */
        bool ok = excel->setControl("Excel.Application");
        if (!ok){
            qDebug() << "setControl Excel.Application fail!" ;
//            return false;
        }
             /* false means do not display the form */
        excel->dynamicCall("SetVisible(bool)", false);
             /* Do not display any warning messages. If it is true, a prompt similar to "File has been modified, whether to save" will appear when closing */
        excel->setProperty("DisplayAlerts", false);
               /* Get workbook collection (object) */
        QAxObject *workbooks = excel->querySubObject("Workbooks");
        if (workbooks == nullptr){
            qDebug() << "get workbooks fail!" ;
//            return false;
        }
             /* Get the current workbook */
             QAxObject *workbook = workbooks->querySubObject("Open(const QString &)", excelFileName); // Open an Excel file
        if (workbook == nullptr){
            qDebug() << "get workbook fail!" ;
//            return false;
        }
             /* Get the worksheet of the worksheet collection */
        QAxObject *worksheets = workbook->querySubObject("WorkSheets");
        if (worksheets == nullptr){
            qDebug() << "get worksheets fail!" ;
//            return false;
        }
             /* Get worksheet 1 of the worksheet collection, namely sheet1 */
        QAxObject *worksheet = worksheets->querySubObject("Item(int)", 1);
        int count = worksheets->dynamicCall("Count()").toInt();
        qDebug() << "counter" << count;
        if (worksheet == nullptr){
            qDebug() << "get worksheet fail!" ;
//            return false;
        }
             /* Save as file, 3: txt file (space separated) | 6: csv file (comma separated)*/
        worksheet->dynamicCall("SaveAs(const QString&, int)", QDir::toNativeSeparators(csvFileName), 6);
             /* Close the workbook*/
        workbook->dynamicCall("Close()");
        excel->dynamicCall("Quit()");
        qDebug() << "save as success";
}
