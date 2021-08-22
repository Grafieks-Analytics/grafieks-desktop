#include "excelquerymodel.h"

ExcelQueryModel::ExcelQueryModel(QObject *parent) : QAbstractTableModel(parent)
{

}

void ExcelQueryModel::setQuery(QString query)
{
    // Signal to clear exisitng data in tables (qml)
    emit clearTablePreview();
    this->removeTmpChartData();
    this->query = query;
    querySplitter.setQueryForClasses(this->query);

    this->selectParams = querySplitter.getSelectParams();

    this->generateRoleNames();
    this->setQueryResult();

}

void ExcelQueryModel::setPreviewQuery(int previewRowCount)
{
    QStringList list;
    int tmpRowCount = 0;
    int maxRowCount = 0;
    QString finalSqlInterPart;

    QSqlDatabase conExcel = QSqlDatabase::database(Constants::excelOdbcStrType);

    finalSqlInterPart = this->query.section(' ', 1);
    QString newLimitQuery = "SELECT TOP " + QString::number(previewRowCount) + " " + finalSqlInterPart;
    QSqlQuery query(newLimitQuery, conExcel);
    QSqlRecord record = query.record();

    this->internalColCount = record.count();

    beginResetModel();
    this->resultData.clear();

    int j = 0;
    tmpRowCount = 0;
    while(query.next()){
        for(int i = 0; i < this->internalColCount; i++){
            list << query.value(i).toString();
        }
        this->resultData.append(list);
        list.clear();

        tmpRowCount++;
        j++;
    }

    if(previewRowCount > tmpRowCount){
        maxRowCount = tmpRowCount;
    } else{
        maxRowCount = previewRowCount;
    }

    this->previewRowCount = maxRowCount;

    if(j > 0){
        emit errorSignal(query.lastError().text());
        emit excelHasData(true);
    } else{
        emit errorSignal("");
        emit excelHasData(false);
    }

    endResetModel();
    emit excelHeaderDataChanged(this->selectParams);
}

int ExcelQueryModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return this->previewRowCount;
}

int ExcelQueryModel::columnCount(const QModelIndex &) const
{
    return this->internalColCount;
}

QVariant ExcelQueryModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    if (role == Qt::DisplayRole && orientation == Qt::Horizontal) {
        return QString(this->m_roleNames[section]);
    }
    return QVariant();
}

QVariant ExcelQueryModel::data(const QModelIndex &index, int role) const
{
    switch (role) {
    case Qt::DisplayRole:
        return this->resultData[index.row()][index.column()];
    default:
        break;
    }

    return QVariant();
}

QHash<int, QByteArray> ExcelQueryModel::roleNames() const
{
    return {{Qt::DisplayRole, "display"}};
}

void ExcelQueryModel::getQueryStats()
{

}

void ExcelQueryModel::removeTmpChartData()
{

}

void ExcelQueryModel::receiveExcelFilterQuery(QString query)
{
    this->query = query;
}

void ExcelQueryModel::slotGenerateRoleNames(const QStringList &tableHeaders, const QMap<int, QStringList> &duckChartHeader, const QHash<int, QByteArray> roleNames, const int internalColCount)
{

}

void ExcelQueryModel::slotSetChartData(bool success)
{

}

void ExcelQueryModel::generateRoleNames()
{
    QStringList colInfo;
    QVariant fieldType;
    DataType dataType;

    QStringList tableHeaders;
    QMap<int, QStringList> sqlChartHeader;
    QHash<int, QByteArray> roleNames;

    QSqlDatabase conExcel = QSqlDatabase::database(Constants::excelOdbcStrType);

    QSqlQuery query(this->query, conExcel);
    QSqlRecord record = query.record();

    for( int i = 0; i < record.count(); i ++) {

        roleNames.insert(Qt::UserRole + i + 1, record.fieldName(i).toUtf8());
        fieldType = record.field(i).value();
        colInfo << record.fieldName(i) << dataType.dataType(fieldType.typeName())  << record.field(i).tableName();

        sqlChartHeader.insert(i, colInfo);
        tableHeaders.append(record.fieldName(i));
        colInfo.clear();
    }
    emit signalGenerateRoleNames(tableHeaders, sqlChartHeader);
}


void ExcelQueryModel::setQueryResult()
{

}

QMap<QString, QString> ExcelQueryModel::returnColumnList(QString tableName)
{
    QMap<QString, QString> output;
    return output;
}

void ExcelQueryModel::setChartHeader(int index, QStringList colInfo)
{

}
