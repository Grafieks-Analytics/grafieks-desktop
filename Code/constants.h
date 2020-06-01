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
const QString sqliteStrType = "sqlite";


// Layout level constants

// Menu User


}
#endif // CONSTANTS_H
