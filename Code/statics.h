#ifndef CREDENTIALS_H
#define CREDENTIALS_H

#include <QString>
#include <QVariantMap>

class Statics
{
public:

    static QString currentDbName;
    static int currentDbIntType;
    static QString currentDbStrType;
    static QString currentDbClassification;
    static int onlineStorageType;
    static QString driverName;
    static QString extractPath;
    static QString csvJsonPath;
    static QVariantMap changedHeaderTypes;
    static bool freeLimitExtractSizeExceeded;

    // Mysql
    static QString myHost;
    static QString myDb;
    static int myPort;
    static QString myUsername;
    static QString myPassword;

    // Sqlite
    static QString sqliteFile;
    static QString sqliteUsername;
    static QString sqlitePassword;

    // Mssql
    static QString msHost;
    static QString msDb;
    static int msPort;
    static QString msUsername;
    static QString msPassword;

    // Access
    static QString acDb;
    static QString acUsername;
    static QString acPassword;

    // Postgres
    static QString postgresHost;
    static QString postgresDb;
    static int postgresPort;
    static QString postgresUsername;
    static QString postgresPassword;

    // Amazon Redshift
    static QString redshiftHost;
    static QString redshiftDb;
    static int redshiftPort;
    static QString redshiftUsername;
    static QString redshiftPassword;

    // Oracle
    static QString oracleHost;
    static QString oracleDb;
    static int oraclePort;
    static QString oracleUsername;
    static QString oraclePassword;

    // Mongo
    static QString mongoHost;
    static QString mongoDb;
    static int mongoPort;
    static QString mongoUsername;
    static QString mongoPassword;

    // Impala
    static QString impalaHost;
    static QString impalaDb;
    static int impalaPort;
    static QString impalaUsername;
    static QString impalaPassword;

    // Hive
    static QString hiveHost;
    static QString hiveDb;
    static int hivePort;
    static QString hiveUsername;
    static QString hivePassword;

    // SnowFlake
    static QString snowflakeHost;
    static QString snowflakeDb;
    static int snowflakePort;
    static QString snowflakeUsername;
    static QString snowflakePassword;

    // Teradata
    static QString teradataHost;
    static QString teradataDb;
    static int teradataPort;
    static QString teradataUsername;
    static QString teradataPassword;

    // CSV
    static QString separator;

    // Dropbox
};

#endif // CREDENTIALS_H
