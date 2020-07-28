#ifndef CONSTANTS_H
#define CONSTANTS_H

#include <QString>

namespace Constants {

// Application level constants
const QString defaultAPIEndpoint = "http://localhost:5476";
const int ApiWaitTime = 5000; // in ms
const int GeneralErrorCode = 403;
const QString GeneralSuccessMsg = "Success";
const QString GeneralFailureMsg = "Failure";
const QString GeneralNoDriver = "No driver available";
const QString GeneralTimeOut = "Request Time Out";

// Datasource type int
const int mysqlIntType = 0;
const int sqliteIntType = 1;

// Datasource type Strings
const QString mysqlStrType = "mysql";
const QString mysqlStrQueryType = "mysql_query";
const QString sqliteStrType = "sqlite";
const QString sqliteStrQueryType = "sqlite_query";

// Filter type Strings
const QString categoricalType = "categorical";
const QString numericalType = "numerical";
const QString dateType = "date";
const QString otherType = "other";

// Layout level constants

// Menu User


}
#endif // CONSTANTS_H
