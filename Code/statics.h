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

    // Dropbox
};

#endif // CREDENTIALS_H
