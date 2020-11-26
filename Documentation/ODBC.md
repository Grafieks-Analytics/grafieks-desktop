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

3. Use the **name/driver** inside the code, e.g "MYSQL ODBC 8.0 Unicode Driver"


- **MS SQL (Works on Windows only)** 

1. Download [Sql server express (free version)](https://www.microsoft.com/en-in/sql-server/sql-server-downloads) and [Sql server management studio (SSMS)](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver15)

2. MS SQL has multiple authentication methods. By default, _Windows Authentication_ is selected. Login using username and password must be selected for remote servers. There you do not need any password. For details on managing users on server, visit this link https://docs.microsoft.com/en-us/sql/ssms/tutorials/ssms-tricks?view=sql-server-ver15

3. To manage Sql server, visit https://docs.microsoft.com/en-us/sql/ssms/tutorials/ssms-tricks?view=sql-server-ver15

- **Postgres SQL**

1. [Download Postgresql](https://www.postgresql.org/download) and [Postgres ODBC](https://www.postgresql.org/ftp/odbc/versions). 

2. After installation open the ODBC manager. Unser _System DSN_, the new Postgres driver names should be visible

3. Postgres server can be managed by **PgAdmin**. Link to management - https://www.enterprisedb.com/postgres-tutorials/how-create-postgresql-database-and-users-using-psql-and-pgadmin & https://www.guru99.com/create-drop-table-postgresql.html