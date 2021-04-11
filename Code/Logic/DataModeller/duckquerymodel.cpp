#include "duckquerymodel.h"

DuckQueryModel::DuckQueryModel(QObject *parent) : QAbstractTableModel(parent)
{

}

DuckQueryModel::DuckQueryModel(DuckCon *duckCon, QObject *parent)
{
    Q_UNUSED(parent);
    this->duckCon = duckCon;
}

DuckQueryModel::~DuckQueryModel()
{
    this->duckChartData.clear();
    this->duckChartHeader.clear();
    this->resultData.clear();
}


void DuckQueryModel::setQuery(QString query)
{
    this->resultData.clear();
    this->query = query;
    querySplitter.setQueryForClasses(this->query);

    this->setQueryResult();
    this->generateRoleNames();
}

int DuckQueryModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return this->internalRowCount;
}

int DuckQueryModel::columnCount(const QModelIndex &) const
{
    return this->internalColCount;
}

QVariant DuckQueryModel::headerData(int section, Qt::Orientation orientation, int role) const
{

    if (role == Qt::DisplayRole && orientation == Qt::Horizontal) {
        return QString(this->m_roleNames[section]);
    }
    emit headerDataChanged(Qt::Horizontal, 1, this->internalColCount);
    return QVariant();
}


QVariant DuckQueryModel::data(const QModelIndex &index, int role) const
{
    switch (role) {
    case Qt::DisplayRole:
        return this->resultData[index.row()][index.column()];
    default:
        break;
    }

    return QVariant();
}


QHash<int, QByteArray> DuckQueryModel::roleNames() const
{
    return {{Qt::DisplayRole, "display"}};
}


void DuckQueryModel::generateRoleNames()
{
    QStringList output;
    m_roleNames.clear();
    this->tableHeaders.clear();

    QRegularExpression selectListRegex(R"(SELECT\s+(.*?)\sFROM\s)", QRegularExpression::CaseInsensitiveOption);
    QRegularExpressionMatch selectIterator = selectListRegex.match(this->query);
    QString containsStar = selectIterator.captured(1);

    if(containsStar.contains("*", Qt::CaseInsensitive) == true){
        QStringList tablesList;
        tablesList << querySplitter.getMainTable();
        tablesList << querySplitter.getJoinTables();

        QString tableName;
        foreach(tableName, tablesList){
            auto data = duckCon->con.Query("PRAGMA table_info('"+ tableName.toStdString() +"')");
            int rows = data->collection.Count();
            QString fieldName;

            for(int i = 0; i < rows; i++){
                fieldName =  data->GetValue(1, i).ToString().c_str();
                fieldName = fieldName.trimmed();
                m_roleNames.insert(i, fieldName.toUtf8());
                this->setChartHeader(i, fieldName);
                this->tableHeaders.append(fieldName);
            }
        }

    } else{
        output = querySplitter.getSelectParams();
        for(int i =0; i < output.length(); i++){
            QString fieldName = output[i].remove("\"").trimmed();
            m_roleNames.insert(i, fieldName.toUtf8());
            this->setChartHeader(i, fieldName);
            this->tableHeaders.append(fieldName);
        }
    }

    emit duckHeaderDataChanged(this->tableHeaders);
}

void DuckQueryModel::setQueryResult()
{
    beginResetModel();
    std::vector<duckdb::Value> stdData;

    // Tmp
    QStringList list;

    auto result = duckCon->con.Query(this->query.toStdString());
    if(!result->error.empty())
        qDebug() << result->error.c_str() << "ERROR IN DUCK";

    // Set the internalRowCount & internalColCount for the QAbstractListModel rowCount method
    this->internalColCount = result->collection.ColumnCount();
    this->internalRowCount = result->collection.Count();

    this->setChartData(result);

    for(int i = 0; i < this->internalRowCount; i++){

        stdData = result->collection.GetRow(i);


        for(auto data: stdData){
            list << data.ToString().c_str();
        }
        this->resultData.append(list);
        list.clear();

    }

    if(this->internalRowCount > 0){
        emit duckHasData(true);
    } else{
        emit duckHasData(false);
    }
    endResetModel();
}

void DuckQueryModel::setChartData(std::unique_ptr<duckdb::MaterializedQueryResult> &totalRows)
{

    int i;
    int j;

    for(j = 0; j < this->internalRowCount; j++){
        for(i = 0; i < this->internalColCount; i++){

            if(j == 0){
                this->duckChartData[i] = new QStringList(totalRows->GetValue(i, j).ToString().c_str());
            } else{
                this->duckChartData.value(i)->append(totalRows->GetValue(i, j).ToString().c_str());
                this->duckChartData[i] = duckChartData.value(i);
            }
        }
    }
    emit chartDataChanged(this->duckChartData);
}

void DuckQueryModel::setChartHeader(int index, QString colName)
{
    this->duckChartHeader.insert(index, colName);
    emit chartHeaderChanged(this->duckChartHeader);
}

void DuckQueryModel::getQueryStats()
{
    auto result = duckCon->con.Query("PRAGMA profiling_output");
    result->Print();
}

void DuckQueryModel::removeTmpChartData()
{
    this->~DuckQueryModel();
}
