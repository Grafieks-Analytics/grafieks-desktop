#include "tablecolumnsmodel.h"

TableColumnsModel::TableColumnsModel(QObject *parent) : QObject(parent)
{

}

/*!
 * \brief Accepts a tableName and displays all the columns
 * \code
 * emit void columnListObtained(QList<QStringList> allColumns);
 * \endcode
 *
 */
void TableColumnsModel::getColumnsForTable(QString tableName)
{


    QString describeQueryString, fieldName;

    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:{

        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlStrQueryType);

        describeQueryString = "DESCRIBE " + tableName;

        QSqlQuery describeQuery(describeQueryString, dbMysql);

        while(describeQuery.next()){

            fieldName = describeQuery.value(0).toString();

            // Append all data type to allList as well
            allColumns.append(fieldName);
        }
        break;
    }
    }

    emit columnListObtained(allColumns);
    allColumns.clear();
}
