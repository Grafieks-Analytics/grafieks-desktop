#include "sqliteconversions.h"

SqliteConversions::SqliteConversions(QObject *parent) : QObject(parent),
    queryString("")
{
    // The dashes are intentionally kept to make substring equal

    monthNameShort = "--JanFebMarAprMayJunJulAugSepOctNovDec";
    monthNameLong = "January--February-March----April----May------June-----July-----August---SeptemberOctober--November-December";
}

QString SqliteConversions::convertDateQuery(QString &columnName, QString &tableName, int &lowerLimit, int &upperLimit, int value)
{

    switch (value) {
    case 1:
        queryString = "SELECT DISTINCT STRFTIME('%d/%m/%Y',"  + columnName +")" + " FROM "+ tableName.toLower() + " LIMIT " + QString::number(lowerLimit) + ", "+ QString::number(upperLimit);
        break;
    case 2:

        queryString = "SELECT DISTINCT STRFTIME('%d %M %Y'," + columnName+ ")" + " FROM "+ tableName.toLower() + " LIMIT " + QString::number(lowerLimit) + ", "+ QString::number(upperLimit);
        break;
    case 3:
        queryString = "SELECT DISTINCT STRFTIME('%e %M %Y'," + columnName+ ")" + " FROM "+ tableName.toLower() + " LIMIT " + QString::number(lowerLimit) + ", "+ QString::number(upperLimit);
        break;
    case 4:
        queryString = "SELECT DISTINCT STRFTIME('%W, %e %M %Y'," + columnName+ ")" + " FROM "+ tableName.toLower() + " LIMIT " + QString::number(lowerLimit) + ", "+ QString::number(upperLimit);
        break;
    case 5:
        queryString = "SELECT DISTINCT STRFTIME('%W, %d %M %Y'," + columnName+ ")" + " FROM "+ tableName.toLower() + " LIMIT " + QString::number(lowerLimit) + ", "+ QString::number(upperLimit);
        break;
    case 6:
        queryString = "SELECT DISTINCT STRFTIME('%d/%m/%y'," + columnName+ ")" + " FROM "+ tableName.toLower() + " LIMIT " + QString::number(lowerLimit) + ", "+ QString::number(upperLimit);
        break;
    case 7:
        queryString = "SELECT DISTINCT STRFTIME('%e/%c/%y'," + columnName+ ")" + " FROM "+ tableName.toLower() + " LIMIT " + QString::number(lowerLimit) + ", "+ QString::number(upperLimit);
        break;
    case 8:
        queryString = "SELECT DISTINCT STRFTIME('%e.%c.%y'," + columnName+ ")" + " FROM "+ tableName.toLower() + " LIMIT " + QString::number(lowerLimit) + ", "+ QString::number(upperLimit);
        break;
    case 9:
        queryString = "SELECT DISTINCT STRFTIME('%Y-%m-%d'," + columnName+ ")" + " FROM "+ tableName.toLower() + " LIMIT " + QString::number(lowerLimit) + ", "+ QString::number(upperLimit);
        break;
    case 10:
        queryString = "SELECT DISTINCT STRFTIME('%M %Y'," + columnName+ ")" + " FROM "+ tableName.toLower() + " LIMIT " + QString::number(lowerLimit) + ", "+ QString::number(upperLimit);
        break;
    case 11:
        queryString = "SELECT DISTINCT STRFTIME('%e %M'," + columnName+ ")" + " FROM "+ tableName.toLower() + " LIMIT " + QString::number(lowerLimit) + ", "+ QString::number(upperLimit);
        break;
    case 12:
        queryString = "SELECT DISTINCT STRFTIME('%y'," + columnName+ ")" + " FROM "+ tableName.toLower() + " LIMIT " + QString::number(lowerLimit) + ", "+ QString::number(upperLimit);
        break;
    case 13:
        queryString = "SELECT DISTINCT STRFTIME('%Y'," + columnName+ ")" + " FROM "+ tableName.toLower() + " LIMIT " + QString::number(lowerLimit) + ", "+ QString::number(upperLimit);
        break;
    case 14:
        queryString = "SELECT DISTINCT STRFTIME('%d/%m/%Y %H:%i:%s'," + columnName+ ")" + " FROM "+ tableName.toLower() + " LIMIT " + QString::number(lowerLimit) + ", "+ QString::number(upperLimit);
        break;
    default:
        queryString = "SELECT DISTINCT " + columnName + " FROM "+ tableName + " LIMIT " + QString::number(lowerLimit) + ", "+ QString::number(upperLimit);
    }

    return queryString;
}
