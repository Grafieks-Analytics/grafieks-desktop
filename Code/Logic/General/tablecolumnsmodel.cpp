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
void TableColumnsModel::getColumnsForTable(QString tableName, QString moduleName)
{


    QString describeQueryString, fieldName, fieldType;
    QStringList outputDataList;

    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:{

        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlOdbcStrQueryType);

        describeQueryString = "DESCRIBE `" + tableName + "`";

        QSqlQuery describeQuery(describeQueryString, dbMysql);

        while(describeQuery.next()){

            fieldName = describeQuery.value(0).toString();
            fieldType = describeQuery.value(1).toString();

            // Remove characters after `(` and then trim whitespaces
            QString fieldTypeTrimmed = fieldType.mid(0, fieldType.indexOf("(")).trimmed();

            // Get filter data type for QML
            QString filterDataType = dataType.dataType(fieldTypeTrimmed);


            outputDataList << fieldName << filterDataType;

            // Append all data type to allList as well
            allColumns.append(outputDataList);

            outputDataList.clear();
        }
        break;
    }
    }

    emit columnListObtained(allColumns, tableName, moduleName);
    allColumns.clear();
}
