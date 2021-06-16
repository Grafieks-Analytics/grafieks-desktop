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
    QString colListQuery, conType, fieldName, fieldType, tmpTableName, tmpFieldName;
    DataType dataType;
    QStringList colInfo, tablesList, output;
    QMap<QString, QString> colTypeMap;

    m_roleNames.clear();
    this->tableHeaders.clear();

    QRegularExpression selectListRegex(R"(SELECT\s+(.*?)\sFROM\s)", QRegularExpression::CaseInsensitiveOption);
    QRegularExpressionMatch selectIterator = selectListRegex.match(this->query);
    QString containsStar = selectIterator.captured(1);

    if(containsStar.contains("*", Qt::CaseInsensitive) == true){
        tablesList << querySplitter.getMainTable();
        tablesList << querySplitter.getJoinTables();

        foreach(QString tableName, tablesList){
            auto data = duckCon->con.Query("PRAGMA table_info('"+ tableName.toStdString() +"')");
            if(data->error.empty()){
                int rows = data->collection.Count();

                for(int i = 0; i < rows; i++){
                    fieldName =  data->GetValue(1, i).ToString().c_str();
                    fieldName = fieldName.trimmed();
                    fieldType = data->GetValue(2, i).ToString().c_str();
                    colInfo << fieldName << dataType.dataType(fieldType) << tableName;

                    m_roleNames.insert(i, fieldName.toUtf8());
                    this->setChartHeader(i, colInfo);
                    this->tableHeaders.append(fieldName);
                    colInfo.clear();
                }
            } else{
                qWarning() << Q_FUNC_INFO << data->error.c_str();
            }

        }

    } else{
        output = querySplitter.getSelectParams();
        tablesList << querySplitter.getMainTable();
        tablesList << querySplitter.getJoinTables();


        this->internalColCount = output.length();

        for(int i =0; i < output.length(); i++){
            fieldName = output[i].remove(QRegularExpression("[\"`']+")).trimmed();

            // If fieldname contains a dot(.), then probably it might have joins
            // Else for sure it doesnt contain a join
            if(fieldName.contains(".")){
                int j=0;
                foreach(QString tableName, tablesList){

                    tableName = tableName.remove(QRegularExpression("[\"`']+")).trimmed();

                    if(tmpTableName != tableName){
                        colTypeMap = this->returnColumnList(tableName);
                    }

                    if(fieldName.contains(tableName)){

                        tmpFieldName = fieldName;
                        fieldName.remove(tableName + ".");
                        fieldType = colTypeMap.value(fieldName);

                        colInfo << fieldName << dataType.dataType(fieldType) << tablesList.at(j);
                    }
                    tmpTableName = tableName;
                    j++;

                }
            } else{

                if(tmpTableName != tablesList.at(0)){
                    colTypeMap = this->returnColumnList(tablesList.at(0));
                }
                tmpTableName = tablesList.at(0);

                fieldType = colTypeMap.value(fieldName);
                colInfo << fieldName << dataType.dataType(fieldType) << tablesList.at(0);
            }

            m_roleNames.insert(i, fieldName.toUtf8());
            this->setChartHeader(i, colInfo);
            this->tableHeaders.append(fieldName);

            colInfo.clear();
        }
    }

    emit duckHeaderDataChanged(this->tableHeaders);
    emit chartHeaderChanged(this->duckChartHeader);
}

void DuckQueryModel::setQueryResult()
{
    auto result = duckCon->con.Query(this->query.toStdString());
    if(!result->error.empty()) {
        qWarning() << Q_FUNC_INFO << result->error.c_str();
    } else{

        // Set the internalRowCount & internalColCount for the QAbstractListModel rowCount method
        this->internalColCount = result->collection.ColumnCount();
        this->internalRowCount = result->collection.Count();

        this->setChartData(result);
    }
}

void DuckQueryModel::setChartData(std::unique_ptr<duckdb::MaterializedQueryResult> &totalRows)
{

    int i, j;

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

void DuckQueryModel::setChartHeader(int index, QStringList colInfo)
{
    this->duckChartHeader.insert(index, colInfo);
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
