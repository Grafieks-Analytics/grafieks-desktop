#ifndef STATICS_H
#define STATICS_H


#include <QString>

namespace Statics {

// Mysql
static QString myHost = "localhost";
static QString myDb;
static int myPort = 3306;
static QString myUsername;
static QString myPassword;

// Sqlite
static QString sqliteFile;
static QString sqliteUsername;
static QString sqlitePassword;
}


#endif // STATICS_H
