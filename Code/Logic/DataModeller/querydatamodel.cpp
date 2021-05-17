#include "querydatamodel.h"

QueryDataModel::QueryDataModel(QObject *parent) : QObject(parent)
{

}

void QueryDataModel::columnData(QString col, QString tableName, QString options)
{
    QStringList output;
    output = this->getData("SELECT DISTINCT " + col + " FROM "+ tableName);
    emit columnListModelDataChanged(output, options);
}

void QueryDataModel::columnSearchData(QString col, QString tableName, QString searchString, QString options)
{

    QStringList output;
    output = this->getData("SELECT DISTINCT " + col + " FROM "+ tableName + " WHERE " + col + " LIKE '%"+searchString+"%'");
    emit columnListModelDataChanged(output, options);
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


    if(query.lastError().type() == QSqlError::NoError){
        while(query.next()){
            this->colData.append(query.value(0).toString());
        }
    } else{
        qWarning() << Q_FUNC_INFO << query.lastError();
    }

    qDebug() << "RESULTS" << this->colData;
    output = this->colData;
    this->colData.clear();
    return output;

}
