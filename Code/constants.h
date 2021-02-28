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
    const int mysqlOdbcIntType = 1;
    const int sqliteIntType = 2;
    const int mssqlIntType = 3;
    const int postgresIntType = 4;
    const int excelIntType = 5;
    const int mongoIntType = 6;
    const int redshiftIntType = 7;
    const int hiveIntType = 8;
    const int csvIntType = 9;
    const int githubIntType = 10;
    const int impalaIntType = 11;
    const int jsonIntType = 12;
    const int accessIntType = 13;
    const int oracleIntType = 14;
    const int snowflakeIntType = 15;
    const int teradataIntType = 16;
    const int dropboxIntType = 17;
    const int driveIntType = 18;
    const int boxIntType = 19;
    const int sheetIntType = 20;

    // Datasource type Strings
    const QString mysqlStrType = "mysql";
    const QString mysqlStrQueryType = "mysql_query";
    const QString mysqlOdbcStrType = "mysql_odbc";
    const QString mysqlOdbcStrQueryType = "mysql_odbc_query";

    const QString sqliteStrType = "sqlite";
    const QString sqliteStrQueryType = "sqlite_query";

    const QString mssqlOdbcStrType = "mssql_odbc";
    const QString mssqlOdbcStrQueryType = "mssql_odbc_query";

    const QString excelStrType = "excel";
    const QString excelStrQueryType = "excel_query";
    const QString excelOdbcStrType = "excel_odbc";
    const QString excelOdbcStrQueryType = "excel_odbc_query";

    const QString postgresOdbcStrType = "postgres_odbc";
    const QString postgresOdbcStrQueryType = "postgres_odbc_query";

    const QString oracleOdbcStrType = "oracle_odbc";
    const QString oracleOdbcStrQueryType = "oracle_odbc_query";

    const QString mongoOdbcStrType = "mongo_odbc";
    const QString mongoOdbcStrQueryType = "mongo_odbc_query";

    const QString redshiftOdbcStrType = "redshift_odbc";
    const QString redshiftOdbcStrQueryType = "redshift_odbc_query";

    const QString impalaOdbcStrType = "impala_odbc";
    const QString impalaOdbcStrQueryType = "impala_odbc_query";

    const QString hiveOdbcStrType = "hive_odbc";
    const QString hiveOdbcStrQueryType = "hive_odbc_query";

    const QString snowflakeOdbcStrType = "snowflake_odbc";
    const QString snowflakeOdbcStrQueryType = "snowflake_odbc_query";

    const QString teradataOdbcStrType = "teradata_odbc";
    const QString teradataOdbcStrQueryType = "teradata_odbc_query";

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
