# ODBC Documentation

For any connection with **ODBC**, a **DSN (Data source name)** is required. This document will guide you to create a _DSN_ for the required Databases under Mac & Windows Operating systems. ODBC driver ( dll, dyLib) file should be compiled by default. Else follow the documentation on https://doc.qt.io/qt-5/sql-driver.html#qodbc

# ODBC Adminstrator

ODBC Administrator registers and configures the databases ( data sources) available to you either locally or across a network.

## Windows

On Windows, default _ODBC Datasources (64-bit)_ & _ODBC Data sources (32-bit)_ exists which can be used to find the required DSN name for the required connection.

## Mac

On Mac, we need to install **[iODBC](http://www.iodbc.org/dataspace/doc/iodbc/wiki/iodbcWiki/WelcomeVisitors)**. Rest, the functionalities and interface of **iODBC** is similar to that of Windows **Odbc Data sources**

**Note**
1. ANSI ODBC driver is faster than Unicode driver. Try to use ANSI driver if Unicode support is not required
2. ODBC connections can be made from the application interface directly or the right System DSN can be used to connect

# Database ODBC connections

-   **Mysql**

1. Download [Mysql Odbc installer](https://dev.mysql.com/downloads/connector/odbc/5.3.html) for the respective Operating system.

2. Open **iODBC** on Mac or **ODBC Datasources** on Windows. Add a new record under _System DSN_ tab

3. Use the **name/driver** inside the code, e.g "MYSQL ODBC 8.0 Unicode Driver"


- **MS SQL (Works on Windows only)** 

1. Download [Sql server express (free version)](https://www.microsoft.com/en-in/sql-server/sql-server-downloads) and [Sql server management studio (SSMS)](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver15)

2. MS SQL has multiple authentication methods. By default, _Windows Authentication_ is selected. Login using username and password must be selected for remote servers. There you do not need any password. For details on managing users on server, visit this link https://docs.microsoft.com/en-us/sql/ssms/tutorials/ssms-tricks?view=sql-server-ver15

3. To manage Sql server, visit https://docs.microsoft.com/en-us/sql/ssms/tutorials/ssms-tricks?view=sql-server-ver15

- **Postgres SQL**

1. [Download Postgresql](https://www.postgresql.org/download) and [Postgres ODBC](https://www.postgresql.org/ftp/odbc/versions). 

2. After installation open the ODBC manager. Unser _System DSN_, the new Postgres driver names should be visible

3. Postgres server can be managed by **PgAdmin**. Link to management - https://www.enterprisedb.com/postgres-tutorials/how-create-postgresql-database-and-users-using-psql-and-pgadmin & https://www.guru99.com/create-drop-table-postgresql.html

- **MS Excel**

1. For Windows 64-bit, download MS Office 64bit installer else download the 32-bit version
2. For other detailed documentation, read https://wiki.qt.io/Handling_Microsoft_Excel_file_format#:~:text=To%20read%20an%20Excel%20file%20with%20ODBC%20%28tested,%2A.xlsb%29%7D%3BDBQ%3D%22%20%2B%20QString%20%28%22c%3A%5Cpath%5Cto%5Cyour%5Cfile%5Cfile.xlsx%22%29%29%3B%20if%20%28db.open%20%28%29%29%20%7B
3. If at any point, there is an issue while uninstalling MS Office from the system, visit this link https://support.microsoft.com/en-us/office/uninstall-office-from-a-pc-9dd49b83-264a-477a-8fcc-2fdf5dbf61d8

- **MongoDB**

1. Download MongoDB ODBC driver https://github.com/mongodb/mongo-odbc-driver/releases/
2. Download MongoDB BI Connector https://www.mongodb.com/try/download/bi-connector
3. General SQL query will run using the ODBC connector