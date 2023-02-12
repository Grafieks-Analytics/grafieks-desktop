#ifndef CREDENTIALS_H
#define CREDENTIALS_H

#include <QString>
#include <QVariantMap>

class Statics
{
public:

    static int isFreeTier;
    static QString tmpIconPath;
    static bool editMode;
    static bool apiSwitch;
    static QString currentDSFile;

    static QString currentDbName;
    static int currentDbIntType;
    static QString currentDbStrType;
    static QString currentDbClassification;
    static int onlineStorageType;
    static QString driverName;
    static QString extractPath;
    static QString livePath;
    static QString csvJsonPath;
    static bool freeLimitExtractSizeExceeded;
    static bool modeProcessReader;
    static QString dsType;

    // Mysql
    static QString myHost;
    static QString myDb;
    static int myPort;
    static QString myUsername;
    static QString myPassword;
    static QString myRealDbName;

    // Sqlite
    static QString sqliteFile;
    static QString sqliteUsername;
    static QString sqlitePassword;
    static QString sqliteRealDbName;

    // Mssql
    static QString msHost;
    static QString msDb;
    static int msPort;
    static QString msUsername;
    static QString msPassword;
    static QString msRealDbName;

    // Access
    static QString acDb;
    static QString acUsername;
    static QString acPassword;
    static QString acRealDbName;

    // Postgres
    static QString postgresHost;
    static QString postgresDb;
    static int postgresPort;
    static QString postgresUsername;
    static QString postgresPassword;
    static QString postgresRealDbName;

    // Amazon Redshift
    static QString redshiftHost;
    static QString redshiftDb;
    static int redshiftPort;
    static QString redshiftUsername;
    static QString redshiftPassword;
    static QString redshiftRealDbName;

    // Oracle
    static QString oracleHost;
    static QString oracleDb;
    static int oraclePort;
    static QString oracleUsername;
    static QString oraclePassword;
    static QString oracleRealDbName;

    // Mongo
    static QString mongoHost;
    static QString mongoDb;
    static int mongoPort;
    static QString mongoUsername;
    static QString mongoPassword;
    static QString mongoRealDbName;

    // Impala
    static QString impalaHost;
    static QString impalaDb;
    static int impalaPort;
    static QString impalaUsername;
    static QString impalaPassword;
    static QString impalaRealDbName;

    // Hive
    static QString hiveHost;
    static QString hiveDb;
    static int hivePort;
    static QString hiveUsername;
    static QString hivePassword;
    static QString hiveRealDbName;

    // SnowFlake
    static QString snowflakeHost;
    static QString snowflakeDb;
    static int snowflakePort;
    static QString snowflakeUsername;
    static QString snowflakePassword;
    static QString snowflakeRealDbName;

    // Teradata
    static QString teradataHost;
    static QString teradataDb;
    static int teradataPort;
    static QString teradataUsername;
    static QString teradataPassword;
    static QString teradataRealDbName;

    // CSV
    static QString separator;

    // Excel
    static QString excelDb;

    // Dropbox
};

#endif // CREDENTIALS_H
