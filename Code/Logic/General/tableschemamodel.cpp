#include "tableschemamodel.h"

TableSchemaModel::TableSchemaModel(QObject *parent) : QObject(parent)
{

}

QString TableSchemaModel::showSchema(QString query)
{
    QString bingo = "bingo";

    QString explainQuery, describeQuery;
    QStringList tableList;

    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:{

        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlStrType);

        explainQuery = "EXPLAIN FORMAT = JSON "+ query;
        QSqlQuery query(explainQuery, dbMysql);

        query.first();

        QJsonDocument json = QJsonDocument::fromJson(query.value(0).toString().toUtf8());
        QJsonObject obj = json.object(); // since your string is an JSON object

        QJsonObject statusObj = obj["query_block"].toObject();
        QJsonArray tablesListArray = statusObj["nested_loop"].toArray();


        for(int i = 0; i< tablesListArray.size(); i++){
             QJsonObject table = tablesListArray.at(i).toObject();
             QJsonObject tableData = table["table"].toObject();
             qDebug() << tableData["table_name"].toString() << bingo;
        }





        //        for(QString tableName: tableList){
        //            describeQuery = "DESCRIBE " + tableName;
        //            qDebug() <<describeQuery << bingo;
        //        }




        break;
    }

    }


    return bingo;

}
