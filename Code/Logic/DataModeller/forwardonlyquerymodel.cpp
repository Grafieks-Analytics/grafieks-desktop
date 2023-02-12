#include "forwardonlyquerymodel.h"

ForwardOnlyQueryModel::ForwardOnlyQueryModel(GeneralParamsModel *gpm, QObject *parent) : QAbstractTableModel(parent)
{
    this->generalParamsModel  = gpm;
}

ForwardOnlyQueryModel::~ForwardOnlyQueryModel()
{


}

void ForwardOnlyQueryModel::setQuery(QString query, bool queriedFromDataModeler)
{

    // Signal to clear exisitng data in tables (qml)
    emit clearTablePreview();

    this->query = query.simplified();
    this->queriedFromDataModeler = queriedFromDataModeler;
    querySplitter.setQueryForClasses(this->query);
//    this->generateRoleNames();

}

void ForwardOnlyQueryModel::setPreviewQuery(int previewRowCount)
{
    emit clearTablePreview();

    if(this->query.contains(" limit ", Qt::CaseInsensitive)){
        this->finalSql = this->query.split(" limit ", Qt::KeepEmptyParts, Qt::CaseInsensitive).first();
    } else{
        this->finalSql = this->query;
    }

    if(this->queriedFromDataModeler && this->newWhereConditions.trimmed().length() > 0)
        this->finalSql += " WHERE " + this->newWhereConditions;

//    if(Statics::currentDbIntType != Constants::teradataIntType ){
//        this->finalSql += " limit " + QString::number(previewRowCount);
//    }
    this->generateRoleNames();

}

void ForwardOnlyQueryModel::saveExtractData()
{
    QString extractQuery;
    QString finalWhereConditions;
    if(this->queriedFromDataModeler && this->newWhereConditions.trimmed().length() > 0)
        finalWhereConditions = " WHERE " + this->newWhereConditions;

    extractQuery = this->query + finalWhereConditions;


    SaveExtractForwardOnlyWorker *saveForwardOnlyWorker = new SaveExtractForwardOnlyWorker(extractQuery, this->generalParamsModel->getChangedColumnTypes());
    connect(saveForwardOnlyWorker, &SaveExtractForwardOnlyWorker::saveExtractComplete, this, &ForwardOnlyQueryModel::extractSaved, Qt::QueuedConnection);
    connect(saveForwardOnlyWorker, &SaveExtractForwardOnlyWorker::finished, saveForwardOnlyWorker, &SaveExtractForwardOnlyWorker::deleteLater, Qt::QueuedConnection);

    saveForwardOnlyWorker->start();
}

void ForwardOnlyQueryModel::saveLiveData()
{
    if(this->queriedFromDataModeler && this->newWhereConditions.trimmed().length() > 0){
        this->liveQuery = this->query +  " WHERE " + this->newWhereConditions;
    } else {
        this->liveQuery = this->query;
    }

    // For .gads, we need to save headers
    this->ifLive = true;


    SaveLiveForwardOnlyWorker *saveLiveQueryWorker = new SaveLiveForwardOnlyWorker(this->liveQuery, this->generalParamsModel->getChangedColumnTypes());
    connect(saveLiveQueryWorker, &SaveLiveForwardOnlyWorker::saveLiveComplete, this, &ForwardOnlyQueryModel::liveSaved, Qt::QueuedConnection);
    connect(saveLiveQueryWorker, &SaveLiveForwardOnlyWorker::finished, saveLiveQueryWorker, &SaveLiveForwardOnlyWorker::deleteLater, Qt::QueuedConnection);

    saveLiveQueryWorker->start();
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

bool ForwardOnlyQueryModel::ifPublish() const
{
    return m_ifPublish;
}


void ForwardOnlyQueryModel::receiveFilterQuery(QString &existingWhereConditions, QString &newWhereConditions)
{
    // Signal to clear exisitng data in tables (qml)
    emit clearTablePreview();
    this->existingWhereConditions = existingWhereConditions;
    this->newWhereConditions = newWhereConditions;

}

void ForwardOnlyQueryModel::extractSaved(QString errorMsg)
{
    // Delete if the extract size is larger than the permissible limit
    // This goes using QTimer because, syncing files cannot be directly deleted

    if(errorMsg.length() == 0){
        QTimer::singleShot(Constants::timeDelayCheckExtractSize, this, &ForwardOnlyQueryModel::extractSizeLimit);
    } else {
        emit extractCreationError(errorMsg);
    }
}

void ForwardOnlyQueryModel::liveSaved(QString errorMessage, QString selectParams, QString whereConditions, QString joinConditions, QString masterTable)
{

    // Delete if the extract size is larger than the permissible limit
    // This goes using QTimer because, syncing files cannot be directly deleted

    if(errorMessage.length() == 0){
        liveSizeLimit(selectParams, whereConditions, joinConditions, masterTable);
    } else {
        emit liveCreationError(errorMessage);
    }
}

void ForwardOnlyQueryModel::setIfPublish(bool ifPublish)
{
    if (m_ifPublish == ifPublish)
        return;

    m_ifPublish = ifPublish;
    emit ifPublishChanged(m_ifPublish);
}

void ForwardOnlyQueryModel::generateRoleNames()
{
    QString connectionName = this->returnConnectionName();
    QSqlDatabase dbForward = QSqlDatabase::database(connectionName);

    GenerateRoleNamesForwardOnlyWorker *generateRoleNameWorker = new GenerateRoleNamesForwardOnlyWorker(this->query, &querySplitter);
    connect(generateRoleNameWorker, &GenerateRoleNamesForwardOnlyWorker::signalGenerateRoleNames, this, &ForwardOnlyQueryModel::slotGenerateRoleNames, Qt::QueuedConnection);
    connect(generateRoleNameWorker, &GenerateRoleNamesForwardOnlyWorker::finished, generateRoleNameWorker, &QObject::deleteLater, Qt::QueuedConnection);
    generateRoleNameWorker->setObjectName("Grafieks ForwardOnly Rolenames");
    generateRoleNameWorker->start();

    // Emit signals for reports
    emit forwardOnlyHeaderDataChanged(this->tableHeaders);

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
                    qDebug() << Q_FUNC_INFO << q.value(i);
                }
                this->resultData.append(list);
            } catch(std::exception &e){
                qWarning() << Q_FUNC_INFO << e.what();
            }

            list.clear();
            totalRowCount++;
        }

        this->previewRowCount = totalRowCount;

        endResetModel();
    }


    // For .gads file, we need to save headers and data types
    if(this->ifLive){

        QString livePath = Statics::livePath;
        duckdb::DuckDB db(livePath.toStdString());
        duckdb::Connection con(db);

        QString headersCreateQuery = "CREATE TABLE " + Constants::masterHeadersTable + "(column_name VARCHAR, data_type VARCHAR, table_name VARCHAR)";
        QString headersInsertQuery = "INSERT INTO " + Constants::masterHeadersTable + " VALUES ";


        foreach(QStringList values, this->forwardOnlyChartHeader){
            headersInsertQuery += "('"+ values.at(0) +"', '"+ values.at(1) +"', '"+ values.at(2) +"'),";
        }
        headersInsertQuery.chop(1);

        auto queryHeadersCreate = con.Query(headersCreateQuery.toStdString());
        if(!queryHeadersCreate->success) qDebug() << queryHeadersCreate->error.c_str() << headersCreateQuery;
        auto queryHeaderInsert = con.Query(headersInsertQuery.toStdString());
        if(!queryHeaderInsert->success) qDebug() << queryHeaderInsert->error.c_str() << headersInsertQuery;

        if(queryHeadersCreate->success && queryHeaderInsert->success){
            emit showSaveExtractWaitPopup();
            emit liveHeaderGenerated(this->forwardOnlyChartHeader);
        } else {
            qWarning() << Q_FUNC_INFO << "HEADER WRITING FAILED";
        }
    }

    if(this->previewRowCount > 0){
        emit forwardOnlyHasData(true);
    } else{
        emit forwardOnlyHasData(false);
    }

    emit forwardOnlyHeaderDataChanged(this->tableHeaders);
    emit errorSignal("");
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

void ForwardOnlyQueryModel::liveSizeLimit(QString selectParams, QString whereConditions, QString joinConditions, QString masterTable)
{

    QString livePath = Statics::livePath;
    int size = 0;

    QFile fileInfo(livePath);
    fileInfo.open(QFile::ReadWrite);
    fileInfo.setPermissions(QFileDevice::WriteUser | QFileDevice::ReadUser | QFileDevice::ExeUser);

    size = fileInfo.size();
    fileInfo.close();

    // Generate headers to be saved for .gads file
    this->setPreviewQuery(0);

    emit showSaveExtractWaitPopup();
    emit liveFileSaved(m_ifPublish);
    emit liveFileExceededLimit(true, m_ifPublish);
    emit generateLiveReports(this->query);
    emit liveQueryParams(selectParams, whereConditions, joinConditions, masterTable);
}

