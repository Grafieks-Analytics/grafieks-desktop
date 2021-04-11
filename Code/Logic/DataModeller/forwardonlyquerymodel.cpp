#include "forwardonlyquerymodel.h"

ForwardOnlyQueryModel::ForwardOnlyQueryModel(QObject *parent) : QAbstractTableModel(parent)
{

}

ForwardOnlyQueryModel::~ForwardOnlyQueryModel()
{

}

void ForwardOnlyQueryModel::setQuery(QString query)
{

    this->resultData.clear();
    this->query = query;
    querySplitter.setQueryForClasses(this->query);

    this->generateRoleNames();
    this->setQueryResult();

}

int ForwardOnlyQueryModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return this->internalRowCount;
}

int ForwardOnlyQueryModel::columnCount(const QModelIndex &) const
{
    return this->internalColCount;
}

QVariant ForwardOnlyQueryModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    if (role == Qt::DisplayRole && orientation == Qt::Horizontal) {
        return QString(this->m_roleNames[section]);
    }
    emit headerDataChanged(Qt::Horizontal, 1, this->internalColCount);
    return QVariant();
}

QVariant ForwardOnlyQueryModel::data(const QModelIndex &index, int role) const
{
    switch (role) {
    case Qt::DisplayRole:
        return this->resultData[index.row()][index.column()];
    default:
        break;
    }

    return QVariant();
}

QHash<int, QByteArray> ForwardOnlyQueryModel::roleNames() const
{
    return {{Qt::DisplayRole, "display"}};
}

void ForwardOnlyQueryModel::getQueryStats()
{
    // TBD
}

void ForwardOnlyQueryModel::removeTmpChartData()
{
    this->~ForwardOnlyQueryModel();
}

void ForwardOnlyQueryModel::generateRoleNames()
{
    QStringList output;
    QString colListQuery;
    QString conType;

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

            switch(Statics::currentDbIntType){
                case Constants::redshiftIntType:
                colListQuery = "select \"column\" from pg_table_def where tablename = '" + tableName  + "'";
                conType = Constants::redshiftOdbcStrType;
                break;

            case Constants::snowflakeIntType:
                colListQuery = "select \"column\" from pg_table_def where tablename = '" + tableName  + "'";
                conType = Constants::redshiftOdbcStrType;
                break;

            }

            QSqlDatabase dbForward = QSqlDatabase::database(conType);
            QSqlQuery q(colListQuery, dbForward);
            int i = 0;

            while(q.next()){
                QString fieldName;
                fieldName = q.value(0).toString().trimmed();

                m_roleNames.insert(i, fieldName.toUtf8());
                this->setChartHeader(i, fieldName);
                this->tableHeaders.append(fieldName);
                this->internalColCount++;
            }

        }

    } else{
        output = querySplitter.getSelectParams();
        this->internalColCount = output.length();

        for(int i =0; i < output.length(); i++){
            QString fieldName = output[i].remove("\"").trimmed();
            m_roleNames.insert(i, fieldName.toUtf8());
            this->setChartHeader(i, fieldName);
            this->tableHeaders.append(fieldName);
        }
    }

    emit forwardOnlyHeaderDataChanged(this->tableHeaders);

}

void ForwardOnlyQueryModel::setQueryResult()
{

    beginResetModel();

    // Tmp
    QStringList list;
    QString conType;

    switch(Statics::currentDbIntType){
        case Constants::redshiftIntType:
        conType = Constants::redshiftOdbcStrType;
        break;

    case Constants::snowflakeIntType:
        conType = Constants::redshiftOdbcStrType;
        break;

    }

    QSqlDatabase dbForward = QSqlDatabase::database(conType);
    QSqlQuery q(this->query, dbForward);
    if(q.lastError().type() != QSqlError::NoError)
        qDebug() << Q_FUNC_INFO << q.lastError();


    // this->setChartData(result);

    int totalRowCount = 0;
    while(q.next()){
        for(int i = 0; i < this->internalColCount; i++){
            list << q.value(i).toString();

            // Add to chart data
            if(totalRowCount == 0){
                this->forwardOnlyChartData[i] = new QStringList(q.value(i).toString());
            } else{
                this->forwardOnlyChartData.value(i)->append(q.value(i).toString());
                this->forwardOnlyChartData[i] = forwardOnlyChartData.value(i);
            }
        }
        this->resultData.append(list);
        list.clear();

        totalRowCount++;
    }
    // Set the internalRowCount for the QAbstractListModel rowCount method
    this->internalRowCount = totalRowCount;

    if(this->internalRowCount > 0){
        emit forwardOnlyHasData(true);

    } else{
        emit forwardOnlyHasData(false);
    }
    emit chartDataChanged(this->forwardOnlyChartData);
    endResetModel();
}

//void ForwardOnlyQueryModel::setChartData(std::unique_ptr<duckdb::MaterializedQueryResult> &totalRows)
//{

//}

void ForwardOnlyQueryModel::setChartHeader(int index, QString colName)
{
    this->forwardOnlyChartHeader.insert(index, colName);
    emit chartHeaderChanged(this->forwardOnlyChartHeader);
}
