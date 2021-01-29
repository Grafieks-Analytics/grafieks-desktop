#include "mysqlconversions.h"

MysqlConversions::MysqlConversions(QObject *parent) : QObject(parent),
    queryString("")
{

}

QString MysqlConversions::convertDateQuery(QString &columnName, QString &tableName, int &lowerLimit, int &upperLimit, int value)
{

    switch (value) {
    case 1:
        queryString = "SELECT DISTINCT DATE_FORMAT(" + columnName + "," + "'%d/%m/%Y'" + ")" + " FROM "+ tableName + " LIMIT " + QString::number(lowerLimit) + ", "+ QString::number(upperLimit);
        break;
    case 2:
        queryString = "SELECT DISTINCT DATE_FORMAT(" + columnName + "," + "'%d %M %Y'" + ")" + " FROM "+ tableName + " LIMIT " + QString::number(lowerLimit) + ", "+ QString::number(upperLimit);
        break;
    case 3:
        queryString = "SELECT DISTINCT DATE_FORMAT(" + columnName + "," + "'%e %M %Y'" + ")" + " FROM "+ tableName + " LIMIT " + QString::number(lowerLimit) + ", "+ QString::number(upperLimit);
        break;
    case 4:
        queryString = "SELECT DISTINCT DATE_FORMAT(" + columnName + "," + "'%W, %e %M %Y'" + ")" + " FROM "+ tableName + " LIMIT " + QString::number(lowerLimit) + ", "+ QString::number(upperLimit);
        break;
    case 5:
        queryString = "SELECT DISTINCT DATE_FORMAT(" + columnName + "," + "'%W, %d %M %Y'" + ")" + " FROM "+ tableName + " LIMIT " + QString::number(lowerLimit) + ", "+ QString::number(upperLimit);
        break;
    case 6:
        queryString = "SELECT DISTINCT DATE_FORMAT(" + columnName + "," + "'%d/%m/%y'" + ")" + " FROM "+ tableName + " LIMIT " + QString::number(lowerLimit) + ", "+ QString::number(upperLimit);
        break;
    case 7:
        queryString = "SELECT DISTINCT DATE_FORMAT(" + columnName + "," + "'%e/%c/%y'" + ")" + " FROM "+ tableName + " LIMIT " + QString::number(lowerLimit) + ", "+ QString::number(upperLimit);
        break;
    case 8:
        queryString = "SELECT DISTINCT DATE_FORMAT(" + columnName + "," + "'%e.%c.%y'" + ")" + " FROM "+ tableName + " LIMIT " + QString::number(lowerLimit) + ", "+ QString::number(upperLimit);
        break;
    case 9:
        queryString = "SELECT DISTINCT DATE_FORMAT(" + columnName + "," + "'%Y-%m-%d'" + ")" + " FROM "+ tableName + " LIMIT " + QString::number(lowerLimit) + ", "+ QString::number(upperLimit);
        break;
    case 10:
        queryString = "SELECT DISTINCT DATE_FORMAT(" + columnName + "," + "'%M %Y'" + ")" + " FROM "+ tableName + " LIMIT " + QString::number(lowerLimit) + ", "+ QString::number(upperLimit);
        break;
    case 11:
        queryString = "SELECT DISTINCT DATE_FORMAT(" + columnName + "," + "'%e %M'" + ")" + " FROM "+ tableName + " LIMIT " + QString::number(lowerLimit) + ", "+ QString::number(upperLimit);
        break;
    case 12:
        queryString = "SELECT DISTINCT DATE_FORMAT(" + columnName + "," + "'%y'" + ")" + " FROM "+ tableName + " LIMIT " + QString::number(lowerLimit) + ", "+ QString::number(upperLimit);
        break;
    case 13:
        queryString = "SELECT DISTINCT DATE_FORMAT(" + columnName + "," + "'%Y'" + ")" + " FROM "+ tableName + " LIMIT " + QString::number(lowerLimit) + ", "+ QString::number(upperLimit);
        break;
    case 14:
        queryString = "SELECT DISTINCT DATE_FORMAT(" + columnName + "," + "'%d/%m/%Y %H:%i:%s'" + ")" + " FROM "+ tableName + " LIMIT " + QString::number(lowerLimit) + ", "+ QString::number(upperLimit);
        break;
    default:
        queryString = "SELECT DISTINCT " + columnName + " FROM "+ tableName + " LIMIT " + QString::number(lowerLimit) + ", "+ QString::number(upperLimit);
    }

    return queryString;
}
