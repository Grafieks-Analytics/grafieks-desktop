#include "forwardonlydatamodel.h"

ForwardOnlyDataModel::ForwardOnlyDataModel(QObject *parent) : QAbstractListModel(parent)
{
    this->totalColCount = 1;
}

void ForwardOnlyDataModel::clearData()
{
    this->allColumns.clear();
    this->resultData.clear();
    this->tables.clear();
}

ForwardOnlyDataModel::~ForwardOnlyDataModel()
{

}

int ForwardOnlyDataModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return this->totalRowCount;
}

int ForwardOnlyDataModel::columnCount(const QModelIndex &) const
{
    return this->totalColCount;
}

QVariant ForwardOnlyDataModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    if (role == Qt::DisplayRole && orientation == Qt::Horizontal) {
        return QString(this->m_roleNames[section]);
    }
    return QVariant();
}

QVariant ForwardOnlyDataModel::data(const QModelIndex &index, int role) const
{
    switch (role) {
    case Qt::DisplayRole:
        return this->resultData[index.row()];
    default:
        break;
    }

    return QVariant();
}

QHash<int, QByteArray> ForwardOnlyDataModel::roleNames() const
{
    return {{Qt::DisplayRole, "display"}};
}

void ForwardOnlyDataModel::columnData(QString col, QString tableName, QString options)
{
    emit fetchingColumnListModel();
    QString joiner = this->getQueryJoiner();

//    output = this->getData("SELECT DISTINCT " + col + " FROM "+ tableName);
    this->modelOutput = this->getData("SELECT DISTINCT " + joiner + col + joiner + " FROM "+ joiner + tableName + joiner);

    this->m_roleNames.insert(0, col.toUtf8());
    emit columnListModelDataChanged(options);
}

void ForwardOnlyDataModel::columnSearchData(QString col, QString tableName, QString searchString, QString options)
{
    emit fetchingColumnListModel();
    QString joiner = this->getQueryJoiner();

//    output = this->getData("SELECT DISTINCT " + col + " FROM "+ tableName + " WHERE UPPER(" + col + ") LIKE UPPER('%"+searchString+"%')");
    this->modelOutput = this->getData("SELECT DISTINCT " + joiner + col + joiner + " FROM "+ joiner + tableName + joiner + " WHERE UPPER(" + joiner + col + joiner + ") LIKE UPPER('%"+searchString+"%')");
    emit columnListModelDataChanged(options);
}

QStringList ForwardOnlyDataModel::getTableList()
{
    QStringList output;

    QString conType;
    QString queryString;

    QString joiner = this->getQueryJoiner();

    switch (Statics::currentDbIntType) {

    case Constants::redshiftIntType:
        conType = Constants::redshiftOdbcStrType;
        queryString = "SELECT DISTINCT tablename FROM pg_table_def WHERE schemaname = 'public'";
//        queryString = "SELECT DISTINCT tablename FROM pg_table_def WHERE schemaname = " + joiner + "public" + joiner;
        break;

    case Constants::snowflakeIntType:
        conType = Constants::snowflakeOdbcStrType;
        queryString = "SHOW TABLES";
        break;

    case Constants::teradataIntType:
        conType = Constants::teradataOdbcStrType;
        queryString = "SELECT TableName FROM DBC.TablesV WHERE TableKind = 'T' and DatabaseName = '" + Statics::currentDbName + "'";
//        queryString = "SELECT TableName FROM DBC.TablesV WHERE TableKind = " + joiner + "T" + joiner + " and DatabaseName = " + joiner + Statics::currentDbName + joiner;
        break;

    }
    QSqlDatabase forwardOnlyDb = QSqlDatabase::database(conType);
    QSqlQuery tableQuery(queryString, forwardOnlyDb);

    if(tableQuery.lastError().type() == QSqlError::NoError){

        while(tableQuery.next()){
            if(Statics::currentDbIntType == Constants::snowflakeIntType){
                output << tableQuery.value(1).toString();
            } else{
                output << tableQuery.value(0).toString();
            }

        }
    } else{
        qWarning() << Q_FUNC_INFO << tableQuery.lastError();
    }

    this->tables = output;
    return this->tables;
}

QStringList ForwardOnlyDataModel::filterTableList(QString keyword)
{
    return this->tables.filter(keyword);
}

QStringList ForwardOnlyDataModel::getDbList()
{
    QStringList output;
    QString conType;
    QString queryString;

    switch (Statics::currentDbIntType) {

    case Constants::redshiftIntType:
        conType = Constants::redshiftOdbcStrType;
        queryString = "SELECT * FROM pg_database";
        break;

    case Constants::snowflakeIntType:
        conType = Constants::snowflakeOdbcStrType;
        queryString = "SHOW DATABASES";
        break;

    case Constants::teradataIntType:
        conType = Constants::teradataOdbcStrType;
        queryString = "SELECT  DatabaseName FROM DBC.TablesV WHERE TableKind = 'T' AND DatabaseName NOT IN ('All', 'DBC', 'Crashdumps', 'dbcmngr', 'Default', 'External_AP', 'EXTUSER', 'LockLogShredder', 'PUBLIC', 'SQLJ', 'Sys_Calendar', 'SysAdmin', 'SYSBAR', 'SYSJDBC', 'SYSLIB', 'SYSSPATIAL', 'SystemFe', 'SYSUDTLIB', 'SYSUIF', 'TD_SERVER_DB', 'TD_SYSFNLIB', 'TD_SYSGPL', 'TD_SYSXML', 'TDMaps', 'TDPUSER', 'TDQCD', 'TDStats', 'tdwm')";
        break;

    }
    QSqlDatabase forwardOnlyDb = QSqlDatabase::database(conType);
    QSqlQuery tableQuery(queryString, forwardOnlyDb);

    if(tableQuery.lastError().type() == QSqlError::NoError){
        while(tableQuery.next()){
            output << tableQuery.value(0).toString();
        }
    } else{
        qWarning() << Q_FUNC_INFO << tableQuery.lastError();
    }

    return output;
}

QStringList ForwardOnlyDataModel::getDateColumnData()
{
    return this->modelOutput;
}

QString ForwardOnlyDataModel::getQueryJoiner()
{
    QString joiner;

    switch(Statics::currentDbIntType){
    case Constants::redshiftIntType:
        joiner = "\"";
        break;

    case Constants::snowflakeIntType:
        joiner = "\"";
        break;

    case Constants::teradataIntType:
        joiner = "\"";
        break;
    }

    return joiner;
}

QStringList ForwardOnlyDataModel::getData(QString queryString)
{

    QString conType;
    QStringList out;
    switch (Statics::currentDbIntType) {

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

    QSqlDatabase forwardOnlyDb = QSqlDatabase::database(conType);
    QSqlQuery query(queryString, forwardOnlyDb);


    this->resultData.clear();
    if(query.lastError().type() == QSqlError::NoError){
        while(query.next()){
            this->resultData.append(query.value(0).toString());
        }
    } else{
        qWarning() << Q_FUNC_INFO << query.lastError();
    }

    out = this->resultData;
    this->totalRowCount = this->resultData.count();
    return out;
}
