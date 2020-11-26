# ODBC Documentation

For any connection with **ODBC**, a **DSN (Data source name)** is required. This document will guide you to create a _DSN_ for the required Databases under Mac & Windows Operating systems. ODBC driver ( dll, dyLib) file should be compiled by default. Else follow the documentation on https://doc.qt.io/qt-5/sql-driver.html#qodbc

# ODBC Adminstrator

ODBC Administrator registers and configures the databases ( data sources) available to you either locally or across a network.

## Windows

On Windows, default _ODBC Datasources (64-bit)_ & _ODBC Data sources (32-bit)_ exists which can be used to find the required DSN name for the required connection.

## Mac

On Mac, we need to install **[iODBC](http://www.iodbc.org/dataspace/doc/iodbc/wiki/iodbcWiki/WelcomeVisitors)**. Rest, the functionalities and interface of **iODBC** is similar to that of Windows **Odbc Data sources**

# Database ODBC connections

-   **Mysql**

1. Download [Mysql Odbc installer](https://dev.mysql.com/downloads/connector/odbc/5.3.html) for the respective Operating system.

2. Open **iODBC** on Mac or **ODBC Datasources** on Windows. Add a new record under _System DSN_ tab

3. Select any of the available MySql driver available and add a new name. Use the **name/driver** inside the code, e.g "MYSQL ODBC 8.0 Unicode Driver"


- **MS SQL**

- **Postgres SQL**