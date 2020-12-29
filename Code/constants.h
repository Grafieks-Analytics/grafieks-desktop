#ifndef CONSTANTS_H
#define CONSTANTS_H

#include <QString>

namespace Constants
{

    // Application level constants
    const QString defaultAPIEndpoint = "http://localhost:5476";
    const int ApiWaitTime = 5000; // in ms
    const int GeneralErrorCode = 403;
    const QString DefaultBackgroundColor = "#FFFFFF";


    // Datasource type int
    const int mysqlIntType = 0;
    const int sqliteIntType = 1;

    // Datasource type Strings
    const QString mysqlStrType = "mysql";
    const QString mysqlStrQueryType = "mysql_query";
    const QString mysqlOdbcStrType = "mysql_odbc";
    const QString mysqlOdbcStrQueryType = "mysql_odbc_query";
    const QString sqliteStrType = "sqlite";
    const QString sqliteStrQueryType = "sqlite_query";
    const QString sqliteOdbcStrType = "sqlite_odbc";
    const QString sqliteOdbcStrQueryType = "sqlite_odbc_query";

    const QString mssqlOdbcStrType = "mssql_odbc";
    const QString mssqlOdbcStrQueryType = "mssql_odbc_query";

    const QString excelOdbcStrType = "excel_odbc";
    const QString excelOdbcStrQueryType = "excel_odbc_query";

    const QString postgresOdbcStrType = "postgres_odbc";
    const QString postgresOdbcStrQueryType = "postgres_odbc_query";

    const QString mongoOdbcStrType = "mongo_odbc";
    const QString mongoOdbcStrQueryType = "mongo_odbc_query";

    // Filter type Strings
    const QString categoricalType = "categorical";
    const QString numericalType = "numerical";
    const QString dateType = "date";
    const QString otherType = "other";

    // Main Category
    const QString categoryMainListType = "categorical.list";
    const QString categoryMainWildCardType = "categorical.wildcard";
    const QString categoryMainTopType = "categorical.top";

    // DSParams Settings
    const QString defaultTabSection = categoricalType;
    const QString defaultCategory = categoryMainListType;
    const QString defaultSubCategory = "multiple";
    const QString defaultMode = "create";
    const bool defaultExclude = false;
    const bool defaultIncludeNull = true;
    const bool defaultSelectAll = true;

    // DashboardParams
    const int defaultCanvasWidth = 1280;
    const int defaultCanvasHeight = 800;

    // Menu User

} // namespace Constants
#endif // CONSTANTS_H
