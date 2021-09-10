#include "querydatamodel.h"

QueryDataModel::QueryDataModel(QObject *parent) : QAbstractTableModel(parent)
{
    this->totalColCount = 1;
}

int QueryDataModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return this->totalRowCount;
}

int QueryDataModel::columnCount(const QModelIndex &) const
{
    return this->totalColCount;
}

QVariant QueryDataModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    if (role == Qt::DisplayRole && orientation == Qt::Horizontal) {
        return QString(this->m_roleNames[section]);
    }
    return QVariant();
}

QVariant QueryDataModel::data(const QModelIndex &index, int role) const
{
    switch (role) {
    case Qt::DisplayRole:
        return this->resultData[index.row()];
    default:
        break;
    }

    return QVariant();
}

QHash<int, QByteArray> QueryDataModel::roleNames() const
{
    return {{Qt::DisplayRole, "display"}};
}

void QueryDataModel::columnData(QString col, QString tableName, QString options)
{
    QStringList output;
    QString joiner = this->getQueryJoiner();

//    output = this->getData("SELECT DISTINCT '" + col + "' FROM "+ tableName);
    output = this->getData("SELECT DISTINCT " + joiner + col + joiner + " FROM "+ joiner + tableName + joiner);

    this->m_roleNames.insert(0, col.toUtf8());
    emit columnListModelDataChanged(options, false);
}

void QueryDataModel::columnSearchData(QString col, QString tableName, QString searchString, QString options)
{

    QStringList output;
    QString joiner = this->getQueryJoiner();

//    output = this->getData("SELECT DISTINCT '" + col + "' FROM "+ tableName + " WHERE '" + col + "' LIKE '%"+searchString+"%'");
    output = this->getData("SELECT DISTINCT " + joiner + col + joiner + " FROM "+ joiner + tableName + joiner + " WHERE " + joiner + col + joiner + " LIKE '%"+searchString+"%'");
    emit columnListModelDataChanged(options, true);
}

QString QueryDataModel::getQueryJoiner()
{
    QString joiner;

    switch(Statics::currentDbIntType){
    case Constants::mysqlIntType:
        joiner = "`";
        break;

    case Constants::mongoIntType:
        joiner = "\"";
        break;

    case Constants::postgresIntType:
        joiner = "`";
        break;

    case Constants::oracleIntType:
        joiner = "'";
        break;

    case Constants::mssqlIntType:
        joiner = "\"";
        break;

    case Constants::accessIntType:
        joiner = "\"";
        break;
    case Constants::sqliteIntType:
        joiner = "`";
        break;
    }

    return joiner;
}

QStringList QueryDataModel::getData(QString queryString)
{

    QStringList output;
    QString conType;

    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:{
        conType = Constants::mysqlStrType;
        break;
    }
    case Constants::mysqlOdbcIntType:{
        conType = Constants::mysqlOdbcStrType;
        break;
    }

    case Constants::sqliteIntType:{
        conType = Constants::sqliteStrType;
        break;
    }

    case Constants::postgresIntType:{
        conType = Constants::postgresOdbcStrType;
        break;
    }

    case Constants::mssqlIntType:{
        conType = Constants::mssqlOdbcStrType;
        break;
    }

    case Constants::oracleIntType:{
        conType = Constants::oracleOdbcStrType;
        break;
    }
    case Constants::mongoIntType:{
        conType = Constants::mongoOdbcStrType;
        break;
    }

    case Constants::impalaIntType:{
        conType = Constants::impalaOdbcStrType;
        break;
    }

    case Constants::hiveIntType:{
        conType = Constants::hiveOdbcStrType;
        break;
    }

    case Constants::accessIntType:{
        conType = Constants::accessOdbcStrType;
        break;
    }
    }

    QSqlDatabase queryDataDb = QSqlDatabase::database(conType);
    QSqlQuery query(queryString, queryDataDb);

    this->resultData.clear();
    if(query.lastError().type() == QSqlError::NoError){
        while(query.next()){
            this->resultData.append(query.value(0).toString());
        }
    } else{
        qWarning() << Q_FUNC_INFO << query.lastError();
    }

    output = this->resultData;
    this->totalRowCount = this->resultData.count();
    return output;

}
