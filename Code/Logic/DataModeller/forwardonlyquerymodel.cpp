#include "forwardonlyquerymodel.h"

ForwardOnlyQueryModel::ForwardOnlyQueryModel(QObject *parent) : QAbstractTableModel(parent), setChartDataWorker(nullptr)
{
}

ForwardOnlyQueryModel::~ForwardOnlyQueryModel()
{


}

void ForwardOnlyQueryModel::setQuery(QString query)
{

    // Signal to clear exisitng data in tables (qml)
    emit clearTablePreview();

    this->removeTmpChartData();

    this->query = query.simplified();
    querySplitter.setQueryForClasses(this->query);

}

void ForwardOnlyQueryModel::setPreviewQuery(int previewRowCount)
{
    emit clearTablePreview();

    if(this->query.contains(" limit ", Qt::CaseInsensitive)){
        this->finalSql = this->query.split(" limit ", Qt::KeepEmptyParts, Qt::CaseInsensitive).first();
    } else{
        this->finalSql = this->query;
    }

    this->finalSql += " limit " + QString::number(previewRowCount);
    this->generateRoleNames();

}

void ForwardOnlyQueryModel::saveExtractData()
{
    SaveExtractForwardOnlyWorker *saveForwardOnlyWorker = new SaveExtractForwardOnlyWorker(this->query);
    connect(saveForwardOnlyWorker, &SaveExtractForwardOnlyWorker::saveExtractComplete, this, &ForwardOnlyQueryModel::extractSaved, Qt::QueuedConnection);
    connect(saveForwardOnlyWorker, &SaveExtractForwardOnlyWorker::finished, saveForwardOnlyWorker, &SaveExtractForwardOnlyWorker::deleteLater, Qt::QueuedConnection);

    saveForwardOnlyWorker->start();
}

int ForwardOnlyQueryModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return this->previewRowCount;
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
    this->forwardOnlyChartHeader.clear();
    this->forwardOnlyChartData.clear();
    this->tableHeaders.clear();

    emit forwardOnlyHeaderDataChanged(this->tableHeaders);
    emit forwardOnlyHasData(false);
}

void ForwardOnlyQueryModel::extractSaved()
{
    // Delete if the extract size is larger than the permissible limit
    // This goes using QTimer because, syncing files cannot be directly deleted

    FreeTierExtractsManager freeTierExtractsManager;
    QTimer::singleShot(Constants::timeDelayCheckExtractSize, this, &ForwardOnlyQueryModel::extractSizeLimit);
}

void ForwardOnlyQueryModel::generateRoleNames()
{

    QString connectionName = this->returnConnectionName();
    QSqlDatabase dbForward = QSqlDatabase::database(connectionName);
    qDebug() << dbForward.isOpen() << dbForward.isOpenError() << Q_FUNC_INFO;

    GenerateRoleNamesForwardOnlyWorker *generateRoleNameWorker = new GenerateRoleNamesForwardOnlyWorker(this->query, &querySplitter);
    connect(generateRoleNameWorker, &GenerateRoleNamesForwardOnlyWorker::signalGenerateRoleNames, this, &ForwardOnlyQueryModel::slotGenerateRoleNames, Qt::QueuedConnection);
    connect(generateRoleNameWorker, &GenerateRoleNamesForwardOnlyWorker::finished, generateRoleNameWorker, &QObject::deleteLater, Qt::QueuedConnection);
    generateRoleNameWorker->setObjectName("Grafieks ForwardOnly Rolenames");
    generateRoleNameWorker->start();

    // Emit signals for reports
    emit forwardOnlyHeaderDataChanged(this->tableHeaders);

}

void ForwardOnlyQueryModel::setQueryResult()
{
    QString connectionName = this->returnConnectionName();
    QSqlDatabase dbForward = QSqlDatabase::database(connectionName);

    this->setChartDataWorker = new SetChartDataForwardOnlyWorker(&dbForward, this->query, this->internalColCount);
    connect(setChartDataWorker, &SetChartDataForwardOnlyWorker::signalSetChartData, this, &ForwardOnlyQueryModel::slotSetChartData, Qt::QueuedConnection);
    connect(setChartDataWorker, &SetChartDataForwardOnlyWorker::finished, setChartDataWorker, &QObject::deleteLater, Qt::QueuedConnection);
    setChartDataWorker->setObjectName("Grafieks ForwardOnly Chart Data");
    setChartDataWorker->start(QThread::InheritPriority);
}


void ForwardOnlyQueryModel::setChartHeader(int index, QStringList colInfo)
{
    this->forwardOnlyChartHeader.insert(index, colInfo);
}

QString ForwardOnlyQueryModel::returnConnectionName()
{
    QString conType;

    switch(Statics::currentDbIntType){

    case Constants::redshiftIntType:
        conType = Constants::redshiftOdbcStrType;
        break;

    case Constants::snowflakeIntType:
        conType = Constants::snowflakeOdbcStrType;
        break;

    case Constants::teradataIntType:
        conType = Constants::teradataOdbcStrType;
        break;
    }

    return conType;
}

void ForwardOnlyQueryModel::slotGenerateRoleNames(const QStringList &tableHeaders, const QMap<int, QStringList> &forwardOnlyChartHeader, const QHash<int, QByteArray> roleNames, const int internalColCount)
{

    QStringList list;

    this->tableHeaders = tableHeaders;
    this->forwardOnlyChartHeader = forwardOnlyChartHeader;
    this->m_roleNames = roleNames;
    this->internalColCount = internalColCount;

    qDebug() << "TAB 1" << tableHeaders;
    qDebug() << "TAB 2" << forwardOnlyChartHeader;
    qDebug() << "TAB 3" << roleNames;
    qDebug() << "TAB 4" << internalColCount;

    QString connectionName = this->returnConnectionName();
    QSqlDatabase dbForward = QSqlDatabase::database(connectionName);
    QSqlQuery q(this->finalSql, dbForward);

    if(q.lastError().type() != QSqlError::NoError){
        qWarning() << Q_FUNC_INFO << q.lastError();
        emit errorSignal(q.lastError().text());
    } else{

        beginResetModel();
        this->resultData.clear();

        int totalRowCount = 0;
        while(q.next()){

            try{
                for(int i = 0; i < this->internalColCount; i++){
                    list << q.value(i).toString();
                }
                this->resultData.append(list);
            } catch(std::exception &e){
                qWarning() << Q_FUNC_INFO << e.what();
            }

            list.clear();
            totalRowCount++;
        }

        this->previewRowCount = totalRowCount;

        qDebug() << Q_FUNC_INFO<< totalRowCount << this->internalColCount << this->resultData ;

        endResetModel();
    }

    if(this->previewRowCount > 0){
        emit forwardOnlyHasData(true);
    } else{
        emit forwardOnlyHasData(false);
    }

    emit forwardOnlyHeaderDataChanged(this->tableHeaders);
    emit errorSignal("");
}

void ForwardOnlyQueryModel::slotSetChartData(bool success)
{
    if(success){
        this->forwardOnlyChartData = this->setChartDataWorker->getChartData();
        this->internalRowCount = this->setChartDataWorker->getInternalRowCount();

    }
}

void ForwardOnlyQueryModel::extractSizeLimit()
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
        if(!file.remove(extractPath)){
            qDebug() << Q_FUNC_INFO << file.errorString();
        }
        Statics::freeLimitExtractSizeExceeded = true;
        emit extractFileExceededLimit(true);
    } else {
        emit extractFileExceededLimit(false);
    }

    emit showSaveExtractWaitPopup();

    if(Statics::freeLimitExtractSizeExceeded == true){
        Statics::freeLimitExtractSizeExceeded = false;
    } else {
        emit generateReports();
    }
}

