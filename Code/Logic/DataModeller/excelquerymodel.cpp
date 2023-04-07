#include "excelquerymodel.h"

ExcelQueryModel::ExcelQueryModel(GeneralParamsModel *gpm, QObject *parent) : QAbstractTableModel(parent)
{
    this->generalParamsModel = gpm;
}

void ExcelQueryModel::setQuery(QString query, bool queriedFromDataModeler)
{
    // Signal to clear exisitng data in tables (qml)
    emit clearTablePreview();
    this->query = query;
    this->queriedFromDataModeler = queriedFromDataModeler;
}

void ExcelQueryModel::setPreviewQuery(int previewRowCount)
{
    QStringList list;
    int tmpRowCount = 0;
    int maxRowCount = 0;
    QString finalSqlInterPart;

    querySplitter.setQueryForClasses(this->query);
    this->selectParams = querySplitter.getSelectParams();
    this->generateRoleNames();

    QSqlDatabase conExcel = QSqlDatabase::database(Constants::excelOdbcStrType);

    finalSqlInterPart = this->query.section(' ', 1);

    QString finalWhereConditions;
    if(this->queriedFromDataModeler && this->newWhereConditions.trimmed().length() > 0)
        finalWhereConditions = " WHERE " + this->newWhereConditions;

    this->finalSql = "SELECT TOP " + QString::number(previewRowCount) + " " + finalSqlInterPart + finalWhereConditions;


    QSqlQuery query(this->finalSql, conExcel);
    QSqlRecord record = query.record();

    this->internalColCount = record.count();

    beginResetModel();
    emit clearTablePreview();
    this->resultData.clear();

    int j = 0;
    tmpRowCount = 0;
    if(query.lastError().type() != QSqlError::NoError){
        qWarning() << Q_FUNC_INFO << query.lastError();
        emit errorSignal(query.lastError().text());
    } else {
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

        emit errorSignal("");
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
    emit excelDataChanged(this->resultData);
    emit excelHeaderDataChanged(this->selectParams);
}

void ExcelQueryModel::saveExtractData()
{
    QString extractQuery;
    QString finalWhereConditions;
    if(this->queriedFromDataModeler && this->newWhereConditions.trimmed().length() > 0)
        finalWhereConditions = " WHERE " + this->newWhereConditions;

    extractQuery = this->query + finalWhereConditions;

    SaveExtractExcelWorker *saveExtractExcelWorker = new SaveExtractExcelWorker(extractQuery, this->generalParamsModel->getChangedColumnTypes());
    connect(saveExtractExcelWorker, &SaveExtractExcelWorker::saveExtractComplete, this, &ExcelQueryModel::extractSaved, Qt::QueuedConnection);
    connect(saveExtractExcelWorker, &SaveExtractExcelWorker::finished, saveExtractExcelWorker, &SaveExtractExcelWorker::deleteLater, Qt::QueuedConnection);

    saveExtractExcelWorker->start();

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

bool ExcelQueryModel::ifPublish() const
{
    return m_ifPublish;
}

void ExcelQueryModel::receiveExcelFilterQuery(QString &existingWhereConditions, QString &newWhereConditions)
{

    emit clearTablePreview();
    this->exisitingWhereConditions = exisitingWhereConditions;
    this->newWhereConditions = newWhereConditions;
}


void ExcelQueryModel::extractSaved(QString errorMsg)
{
    // Delete if the extract size is larger than the permissible limit
    // This goes using QTimer because, syncing files cannot be directly deleted

    if(errorMsg.length() == 0){
        QTimer::singleShot(Constants::timeDelayCheckExtractSize, this, &ExcelQueryModel::extractSizeLimit);
    } else {
        emit extractCreationError(errorMsg);
    }
}

void ExcelQueryModel::setIfPublish(bool ifPublish)
{
    if (m_ifPublish == ifPublish)
        return;

    m_ifPublish = ifPublish;
    emit ifPublishChanged(m_ifPublish);
}

void ExcelQueryModel::extractSizeLimit()
{
    QString extractPath = Statics::extractPath;
    int size = 0;
    int maxFreeExtractSize = Constants::freeTierExtractLimit; // This many bytes in a GB

    QFile fileInfo(extractPath);
    fileInfo.open(QFile::ReadWrite);
    fileInfo.setPermissions(QFileDevice::WriteUser | QFileDevice::ReadUser | QFileDevice::ExeUser);

    size = fileInfo.size();
    fileInfo.close();

    QFile file(extractPath);
    if(size > maxFreeExtractSize){
        if(!file.remove(extractPath))
            qDebug() << Q_FUNC_INFO << file.errorString();

        Statics::freeLimitExtractSizeExceeded = true;
        emit extractFileExceededLimit(true, m_ifPublish);
    } else {
        emit extractFileExceededLimit(false, m_ifPublish);
    }

    emit showSaveExtractWaitPopup();

    if(Statics::freeLimitExtractSizeExceeded == true){
        Statics::freeLimitExtractSizeExceeded = false;
    } else {
        emit generateExtractReports();
    }
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

