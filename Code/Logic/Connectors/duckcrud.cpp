#include "duckcrud.h"

DuckCRUD::DuckCRUD(QObject *parent) : QObject(parent),
    db(nullptr), con(db)
{

}

void DuckCRUD::createTable(){

    QStringList excelSheetsList;
    QString table = "";
    QString db = Statics::currentDbName;
    std::string csvFile    = db.toStdString();

    QString fileName       = QFileInfo(db).baseName();
    std::string table      = fileName.toStdString();
    std::string csvdb       = "";

    QString fileExtension = QFileInfo(db).completeSuffix();

    if(fileExtension.toLower() == "json"){
        csvFile = jsonToCsv.convertJsonToCsv(Statics::currentDbName).toStdString();

        csvdb      = "'" + csvFile + "'";
        Statics::currentDbName = fileName;

         for(int i = 0; i < fileName.length(); i++){

            if(fileName[i].isLetter() || fileName[i].isDigit()){
                table = table + fileName[i];
            }
        }
        con.Query("CREATE TABLE " + table + " AS SELECT * FROM read_csv_auto(" + csvdb + ")");

    } else if(fileExtension.toLower() == "xls" || fileExtension.toLower() == "xlsx"){
        excelSheetsList = excelToCsv.convertExcelToCsv(Statics::currentDbName);


        for ( const QString& csvFile : excelSheetsList  ) {

            csvdb      = "'" + csvFile.toStdString() + "'";
            Statics::currentDbName = fileName;

            for(int i = 0; i < fileName.length(); i++){

                if(fileName[i].isLetter() || fileName[i].isDigit()){
                    table = table + fileName[i];
                }
            }

            con.Query("CREATE TABLE " + table + " AS SELECT * FROM read_csv_auto(" + csvdb + ")");
        }

    } else{
        csvdb      = "'" + csvFile + "'";
        Statics::currentDbName = fileName;

        for(int i = 0; i < fileName.length(); i++){

            if(fileName[i].isLetter() || fileName[i].isDigit()){
                table = table + fileName[i];
            }
        }
        con.Query("CREATE TABLE " + table + " AS SELECT * FROM read_csv_auto(" + csvdb + ")");
    }
}

void DuckCRUD::columnData(QString colName, QString index)
{
    Q_UNUSED(colName);

    QString db = Statics::currentDbName;
    qDebug() << "LISTING" << db;

    auto data = con.Query("SELECT * FROM " + db.toStdString());
    int rows = data->collection.count;
    int colidx = index.toInt();

    for(int i = 0; i < rows; i++){

        duckdb::Value colData = data->GetValue(colidx, i);
        QString newColData = QString::fromStdString(colData.ToString());

        this->colData.append(newColData);
    }

    emit csvColData(this->colData);
    this->colData.clear();
}

void DuckCRUD::receiveCsvFilterQuery(QString query)
{
    QString db = Statics::currentDbName;

    std::string newQuery = query.toStdString();
    std::string csvQuery = "SELECT * FROM " + db.toStdString() + newQuery;

    auto data = con.Query(csvQuery);
    data->Print();

}

