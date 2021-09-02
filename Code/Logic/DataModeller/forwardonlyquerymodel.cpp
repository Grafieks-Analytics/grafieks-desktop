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


    this->generateRoleNames();
    this->setQueryResult();

}

void ForwardOnlyQueryModel::setPreviewQuery(int previewRowCount)
{
    // Tmp
    QStringList list;
    int tmpRowCount = 0;
    int maxRowCount = 0;

    QString connectionName = this->returnConnectionName();

    QSqlDatabase dbForward = QSqlDatabase::database(connectionName);
    QSqlQuery q(this->query, dbForward);
    if(q.lastError().type() != QSqlError::NoError){
        qWarning() << Q_FUNC_INFO << q.lastError();
        emit errorSignal(q.lastError().text());
    } else{


        tmpRowCount = this->internalRowCount;
        if(previewRowCount > tmpRowCount){
            maxRowCount = tmpRowCount;
        } else{
            maxRowCount = previewRowCount;
        }
        this->previewRowCount = maxRowCount;

        beginResetModel();
        this->resultData.clear();

        int totalRowCount = 0;
        while(q.next() && totalRowCount < maxRowCount){

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

        if(this->internalRowCount > 0){
            emit forwardOnlyHasData(true);

        } else{
            emit forwardOnlyHasData(false);
        }

        emit errorSignal("");
        endResetModel();
    }

    emit forwardOnlyHeaderDataChanged(this->tableHeaders);
}

void ForwardOnlyQueryModel::saveExtractData()
{
    QString extractPath = Statics::extractPath;
    QString tableName = Statics::currentDbName;
    duckdb::DuckDB db(extractPath.toStdString());
    duckdb::Connection con(db);
    QStringList list;

    QString connectionName = this->returnConnectionName();

    QSqlDatabase dbForward = QSqlDatabase::database(connectionName);
    QSqlQuery q(this->query, dbForward);
    QSqlRecord record = q.record();
    if(q.lastError().type() != QSqlError::NoError){
        qWarning() << Q_FUNC_INFO << q.lastError();
    } else{

        QString createTableQuery = "CREATE TABLE " + tableName + "(";

        for(int i = 0; i < record.count(); i++){
            QVariant fieldType = record.field(i).value();
            QString type = dataType.qVariantType(fieldType.typeName());

            QString checkFieldName = record.field(i).tableName() + "." + record.fieldName(i);
            if(Statics::changedHeaderTypes.value(checkFieldName).toString() != ""){
                type = Statics::changedHeaderTypes.value(checkFieldName).toString();

                if(type == Constants::categoricalType){
                    type = "VARCHAR";
                } else if(type == Constants::numericalType){
                    type = "INTEGER";
                } else {
                    type = "TIMESTAMP";
                }
            }

            createTableQuery += "\"" + record.fieldName(i) + "\" " + type + ",";
            this->columnStringTypes.append(type);
        }

        createTableQuery.chop(1);
        createTableQuery += ")";
        qDebug() << createTableQuery;

        auto createT = con.Query(createTableQuery.toStdString());
        if(!createT->success) qDebug() <<Q_FUNC_INFO << "ERROR CREATE EXTRACT";

        duckdb::Appender appender(con, tableName.toStdString());



        beginResetModel();
        this->resultData.clear();

        while(q.next()){

            appender.BeginRow();
            for(int i = 0; i < this->internalColCount; i++){
                QString columnType = this->columnStringTypes.at(i);

                if(columnType == "INTEGER"){
                    appender.Append(q.value(i).toInt());
                } else if(columnType == "BIGINT"){
                    appender.Append(q.value(i).toLongLong());
                }  else if(columnType == "FLOAT") {
                    appender.Append(q.value(i).toFloat());
                } else if(columnType == "DOUBLE") {
                    appender.Append(q.value(i).toDouble());
                } else if(columnType == "DATE"){
                    QDate date = q.value(i).toDate();
                    int32_t year = date.year();
                    int32_t month = date.month();
                    int32_t day = date.day();
                    appender.Append(duckdb::Date::FromDate(year, month, day));
                    //                appender.Append(duckdb::Date::FromDate(1992, 1, 1));
                } else if(columnType == "TIMESTAMP"){
                    QDate date = q.value(i).toDate();
                    QTime time = q.value(i).toDateTime().time();
                    int32_t year = date.year();
                    int32_t month = date.month();
                    int32_t day = date.day();
                    appender.Append(duckdb::Timestamp::FromDatetime(duckdb::Date::FromDate(year, month, day), duckdb::Time::FromTime(time.hour(), time.minute(), time.second(), 0)));
                    //                appender.Append(duckdb::Timestamp::FromDatetime(duckdb::Value::DATE("1992-11-11"), duckdb::Time::FromTime(1, 1, 1, 0)));
                }else {
                    appender.Append(q.value(i).toString().toUtf8().constData());
                }
            }

            appender.EndRow();
        }

        appender.Close();
    }

    emit generateReports(&con);
    emit showSaveExtractWaitPopup();
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
    emit chartHeaderChanged(this->forwardOnlyChartHeader);
    emit chartDataChanged(this->forwardOnlyChartData);
    emit forwardOnlyHasData(false);
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
    emit chartHeaderChanged(this->forwardOnlyChartHeader);

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
    this->tableHeaders = tableHeaders;
    this->forwardOnlyChartHeader = forwardOnlyChartHeader;
    this->m_roleNames = roleNames;
    this->internalColCount = internalColCount;

    emit forwardOnlyHeaderDataChanged(this->tableHeaders);
    emit chartHeaderChanged(this->forwardOnlyChartHeader);
}

void ForwardOnlyQueryModel::slotSetChartData(bool success)
{
    if(success){
        this->forwardOnlyChartData = this->setChartDataWorker->getChartData();
        this->internalRowCount = this->setChartDataWorker->getInternalRowCount();

        emit chartDataChanged(this->forwardOnlyChartData);
    }
}

