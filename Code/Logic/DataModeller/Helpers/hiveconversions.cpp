#include "hiveconversions.h"

HiveConversions::HiveConversions(QObject *parent) : QObject(parent),
    queryString("")
{

}

QString HiveConversions::convertDateQuery(QString &columnName, QString &tableName, int &lowerLimit, int &upperLimit, int value)
{

    int limit = upperLimit - lowerLimit;
    int offset = lowerLimit;

    switch (value) {
    case 1:
        queryString = "SELECT DISTINCT TO_CHAR(" + columnName + "," + "'DD/MM/YYYY'" + ")" + " FROM "+ tableName + " LIMIT " + QString::number(limit) + " OFFSET "+ QString::number(offset);
        break;
    case 2:
        queryString = "SELECT DISTINCT TO_CHAR(" + columnName + "," + "'DD Month YYYY'" + ")" + " FROM "+ tableName + " LIMIT " + QString::number(limit) + " OFFSET "+ QString::number(offset);
        break;
    case 3:
        queryString = "SELECT DISTINCT REGEXP_REPLACE(TO_CHAR(" + columnName + ", 'DD Month YYYY'), '(^|-)0*', '', 'g')" + " FROM "+ tableName + " LIMIT " + QString::number(limit) + " OFFSET "+ QString::number(offset);
        break;
    case 4:
        queryString = "SELECT DISTINCT TO_CHAR(" + columnName + "," + "'Day, DD Month YYYY'" + ")" + " FROM "+ tableName + " LIMIT " + QString::number(limit) + " OFFSET "+ QString::number(offset);
        break;
    case 5:
        queryString = "SELECT DISTINCT TO_CHAR(" + columnName + "," + "'Day, DD Month YYYY'" + ")" + " FROM "+ tableName + " LIMIT " + QString::number(limit) + " OFFSET "+ QString::number(offset);
        break;
    case 6:
        queryString = "SELECT DISTINCT TO_CHAR(" + columnName + "," + "'DD/MM/YY'" + ")" + " FROM "+ tableName + " LIMIT " + QString::number(limit) + " OFFSET "+ QString::number(offset);
        break;
    case 7:
        queryString = "SELECT DISTINCT TO_CHAR(" + columnName + "," + "'D/MM/YY'" + ")" + " FROM "+ tableName + " LIMIT " + QString::number(limit) + " OFFSET "+ QString::number(offset);
        break;
    case 8:
        queryString = "SELECT DISTINCT TO_CHAR(" + columnName + "," + "'D.MM.YY'" + ")" + " FROM "+ tableName + " LIMIT " + QString::number(limit) + " OFFSET "+ QString::number(offset);
        break;
    case 9:
        queryString = "SELECT DISTINCT TO_CHAR(" + columnName + "," + "'YYYY-MM-DD'" + ")" + " FROM "+ tableName + " LIMIT " + QString::number(limit) + " OFFSET "+ QString::number(offset);
        break;
    case 10:
        queryString = "SELECT DISTINCT TO_CHAR(" + columnName + "," + "'Month YYYY'" + ")" + " FROM "+ tableName + " LIMIT " + QString::number(limit) + " OFFSET "+ QString::number(offset);
        break;
    case 11:
        queryString = "SELECT DISTINCT TO_CHAR(" + columnName + "," + "'DD Month'" + ")" + " FROM "+ tableName + " LIMIT " + QString::number(limit) + " OFFSET "+ QString::number(offset);
        break;
    case 12:
        queryString = "SELECT DISTINCT TO_CHAR(" + columnName + "," + "'YY'" + ")" + " FROM "+ tableName + " LIMIT " + QString::number(limit) + " OFFSET "+ QString::number(offset);
        break;
    case 13:
        queryString = "SELECT DISTINCT TO_CHAR(" + columnName + "," + "'YYYY'" + ")" + " FROM "+ tableName + " LIMIT " + QString::number(limit) + " OFFSET "+ QString::number(offset);
        break;
    case 14:
        queryString = "SELECT DISTINCT TO_CHAR(" + columnName + "," + "'DD/MM/YYYY HH24:MI:SS'" + ")" + " FROM "+ tableName + " LIMIT " + QString::number(limit) + " OFFSET "+ QString::number(offset);
        break;
    default:
        queryString = "SELECT DISTINCT " + columnName + " FROM "+ tableName + " LIMIT " + QString::number(limit) + "OFFSET "+ QString::number(offset);
    }

    return queryString;
}
