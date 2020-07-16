#include "tableschemamodel.h"

TableSchemaModel::TableSchemaModel(QObject *parent) : QObject(parent)
{

}

QString TableSchemaModel::showSchema(QString tableName)
{
    QString bingo = "bingo";
    QString queryString;

    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:{

        queryString = "DESCRIBE " + tableName;

        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlStrType);

        break;
    }

    }


    return bingo;

}
