#include "duckquerymodel.h"

DuckQueryModel::DuckQueryModel(QObject *parent) : QAbstractTableModel(parent), setChartDataWorker(nullptr)
{

}

DuckQueryModel::DuckQueryModel(DuckCon *duckCon, QObject *parent)
{
    Q_UNUSED(parent);
    this->duckCon = duckCon;
}

DuckQueryModel::~DuckQueryModel()
{

}


void DuckQueryModel::setQuery(QString query)
{
    // Signal to clear exisitng data in tables (qml)
    emit clearTablePreview();

    this->removeTmpChartData();
    this->query = query;
    querySplitter.setQueryForClasses(this->query);

    this->generateRoleNames();
    this->setQueryResult();

}

void DuckQueryModel::setPreviewQuery(int previewRowCount)
{

    std::vector<duckdb::Value> stdData;

    // Tmp
    QStringList list;
    int tmpRowCount = 0;
    int maxRowCount = 0;

    auto result = duckCon->con.Query(this->query.toStdString());
    if(!result->error.empty()){
        qWarning() << Q_FUNC_INFO << result->error.c_str();
        emit errorSignal(result->error.c_str());
    } else {

        tmpRowCount = result->collection.Count();
        if(previewRowCount > tmpRowCount){
            maxRowCount = tmpRowCount;
        } else{
            maxRowCount = previewRowCount;
        }

        this->previewRowCount = maxRowCount;

        beginResetModel();
        this->resultData.clear();

        for(int i = 0; i < maxRowCount; i++){
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

        emit errorSignal("");
        endResetModel();
    }

    emit duckHeaderDataChanged(this->tableHeaders);
}

int DuckQueryModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return this->previewRowCount;
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

    GenerateRoleNamesDuckWorker *generateRoleNameWorker = new GenerateRoleNamesDuckWorker(duckCon, this->query, &querySplitter);
    connect(generateRoleNameWorker, &GenerateRoleNamesDuckWorker::signalGenerateRoleNames, this, &DuckQueryModel::slotGenerateRoleNames, Qt::QueuedConnection);
    connect(generateRoleNameWorker, &GenerateRoleNamesDuckWorker::finished, generateRoleNameWorker, &QObject::deleteLater, Qt::QueuedConnection);
    generateRoleNameWorker->setObjectName("Grafieks Duck Rolenames");
    generateRoleNameWorker->start();
}

void DuckQueryModel::setChartHeader(int index, QStringList colInfo)
{
    this->duckChartHeader.insert(index, colInfo);
}

void DuckQueryModel::setQueryResult()
{
    this->setChartDataWorker = new SetChartDataDuckWorker(duckCon, this->query);
    connect(setChartDataWorker, &SetChartDataDuckWorker::signalSetChartData, this, &DuckQueryModel::slotSetChartData, Qt::QueuedConnection);
    connect(setChartDataWorker, &SetChartDataDuckWorker::finished, setChartDataWorker, &QObject::deleteLater, Qt::QueuedConnection);
    setChartDataWorker->setObjectName("Grafieks Duck Chart Data");
    setChartDataWorker->start(QThread::HighestPriority);

}


QMap<QString, QString> DuckQueryModel::returnColumnList(QString tableName)
{

    QMap<QString, QString>colTypeMap;

    auto data = duckCon->con.Query("PRAGMA table_info('"+ tableName.toStdString() +"')");

    if(data->error.empty()){
        int rows = data->collection.Count();

        for(int i = 0; i < rows; i++){
            QString fieldName =  data->GetValue(1, i).ToString().c_str();
            fieldName = fieldName.trimmed();
            QString fieldType = data->GetValue(2, i).ToString().c_str();
            colTypeMap.insert(fieldName, fieldType);
        }
    } else{
        qWarning() << Q_FUNC_INFO << data->error.c_str();
    }

    return colTypeMap;
}

void DuckQueryModel::getQueryStats()
{
    auto result = duckCon->con.Query("PRAGMA profiling_output");
    result->Print();
}

void DuckQueryModel::removeTmpChartData()
{
    this->duckChartData.clear();
    this->duckChartHeader.clear();
    this->resultData.clear();
    this->tableHeaders.clear();

    this->internalColCount = 0;
    this->internalRowCount = 0;

    this->tableHeaders.clear();

    emit duckHeaderDataChanged(this->tableHeaders);
    emit chartHeaderChanged(this->duckChartHeader);
    emit duckHasData(false);
    emit chartDataChanged(this->duckChartData);
}

void DuckQueryModel::receiveCsvFilterQuery(QString query)
{

    this->query = query;
    this->setQuery(this->query);
}

void DuckQueryModel::slotGenerateRoleNames(const QStringList &tableHeaders, const QMap<int, QStringList> &duckChartHeader, const QHash<int, QByteArray> roleNames, const int internalColCount)
{
    this->tableHeaders = tableHeaders;
    this->duckChartHeader = duckChartHeader;
    this->m_roleNames = roleNames;
    this->internalColCount = internalColCount;

    emit duckHeaderDataChanged(this->tableHeaders);
    emit chartHeaderChanged(this->duckChartHeader);
}

void DuckQueryModel::slotSetChartData(bool success)
{
    if(success){
        qDebug() << "GOT CHART DATA";
        this->internalColCount = this->setChartDataWorker->getInternalColCount();
        this->internalRowCount = this->setChartDataWorker->getInternalRowCount();
        this->duckChartData = this->setChartDataWorker->getDuckChartData();
        emit chartDataChanged(this->duckChartData);
    }
}

