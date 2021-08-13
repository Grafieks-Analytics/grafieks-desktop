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

    this->generateRoleNames();
    this->setQueryResult();

}

void ExcelQueryModel::setPreviewQuery(int previewRowCount)
{
    QStringList list;
    int tmpRowCount = 0;
    int maxRowCount = 0;

    QSqlDatabase conExcel = QSqlDatabase::database(Constants::excelOdbcStrType);
    QString newLimitQuery = this->query + " LIMIT " + previewRowCount;
    QSqlQuery query(newLimitQuery, conExcel);
    QSqlRecord record = query.record();

    this->internalColCount = record.count();

    tmpRowCount = query.size();
    if(previewRowCount > tmpRowCount){
        maxRowCount = tmpRowCount;
    } else{
        maxRowCount = previewRowCount;
    }

    this->previewRowCount = maxRowCount;

    beginResetModel();
    while(query.next()){
        for(int i = 0; i < this->internalColCount; i++){
            list << query.value(i).toString();
        }
        this->resultData.append(list);
        list.clear();
    }
    endResetModel();

    qDebug() << this->resultData;
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

void ExcelQueryModel::receiveCsvFilterQuery(QString query)
{

}

void ExcelQueryModel::slotGenerateRoleNames(const QStringList &tableHeaders, const QMap<int, QStringList> &duckChartHeader, const QHash<int, QByteArray> roleNames, const int internalColCount)
{

}

void ExcelQueryModel::slotSetChartData(bool success)
{

}

void ExcelQueryModel::generateRoleNames()
{

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
