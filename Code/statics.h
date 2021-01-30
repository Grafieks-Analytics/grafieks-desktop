#ifndef CREDENTIALS_H
#define CREDENTIALS_H

#include <QString>

class Statics
{
public:

    static QString currentDbName;
    static int currentDbIntType;
    static QString currentDbStrType;

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

    // CSV
    static QString separator;

    // Dropbox
};

#endif // CREDENTIALS_H
