#include "exceldatamodel.h"

ExcelDataModel::ExcelDataModel(QObject *parent) : QAbstractTableModel(parent)
{
    this->totalColCount = 1;
}


ExcelDataModel::~ExcelDataModel()
{

}

int ExcelDataModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return this->totalRowCount;
}

int ExcelDataModel::columnCount(const QModelIndex &) const
{
    return this->totalColCount;
}

QVariant ExcelDataModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    if (role == Qt::DisplayRole && orientation == Qt::Horizontal) {
        return QString(this->m_roleNames[section]);
    }
    return QVariant();
}

QVariant ExcelDataModel::data(const QModelIndex &index, int role) const
{
    switch (role) {
    case Qt::DisplayRole:
        return this->modelOutput[index.row()];
    default:
        break;
    }

    return QVariant();
}

QHash<int, QByteArray> ExcelDataModel::roleNames() const
{
    return {{Qt::DisplayRole, "display"}};
}

void ExcelDataModel::columnData(QString col, QString tableName, QString options)
{
    this->modelOutput.clear();
    QSqlDatabase dbExcel = QSqlDatabase::database(Constants::excelOdbcStrType);
    QString dbQueryString = "SELECT DISTINCT ["+col+"] FROM "+tableName;

    QSqlQuery query(dbQueryString, dbExcel);

    while(query.next()){
        this->modelOutput.append(query.value(0).toString());
    }

    this->totalRowCount = this->modelOutput.length();
    this->m_roleNames.insert(0, col.toUtf8());

    emit columnListModelDataChanged(options);
}

void ExcelDataModel::columnSearchData(QString col, QString tableName, QString searchString, QString options)
{

    this->modelOutput.clear();
    QSqlDatabase dbExcel = QSqlDatabase::database(Constants::excelOdbcStrType);
    QString dbQueryString = "SELECT DISTINCT ["+col+"] FROM "+ tableName + " WHERE [" + col + "] LIKE '%" + searchString + "%'";

    QSqlQuery query(dbQueryString, dbExcel);

    while(query.next()){
        this->modelOutput.append(query.value(0).toString());
    }

    this->totalRowCount = this->modelOutput.length();
    this->m_roleNames.insert(0, col.toUtf8());

    emit columnListModelDataChanged(options);
}

QStringList ExcelDataModel::getTableList()
{
    this->getTableListQAXObject();
    return this->output;
}

QStringList ExcelDataModel::filterTableList(QString keyword)
{
    return this->output.filter(keyword, Qt::CaseInsensitive);
}

QStringList ExcelDataModel::getDateColumnData()
{
    return this->modelOutput;
}


QStringList ExcelDataModel::getTableListQAXObject()
{
    QString excelPath = Statics::currentDbName;
    this->sheetNamesMap.clear();
    this->output.clear();

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
    //    worksheets->dumpObjectTree();

    /* Get worksheet 1 of the worksheet collection, namely sheet1 */
    int count = worksheets->dynamicCall("Count()").toInt();

    for(int i = 1; i <= count; i++){
        QAxObject *worksheet = worksheets->querySubObject("Item(int)", i);
        this->output.append(worksheet->dynamicCall("Name()").toString());
        this->sheetNamesMap.insert(i, worksheet->dynamicCall("Name()").toString());
    }

    /* Close the workbook*/
    workbook->dynamicCall("Close()");
    excel->dynamicCall("Quit()");

    qDebug() << Q_FUNC_INFO <<  this->output;
    return output;
}
