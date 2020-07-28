# Mysql installation

This document is tested with **Mysql 5.7**. Although for higher versions, the steps will be almost similar.

**Note: Sql Driver Compilation error**

During the build process, if you encounter errors, delete the files `config.cache` and `config.log` and try to recompile according to the documentation. If compilation fails or there is an issue, delete `config.cache` as otherwise qmake will not search for the available drivers again

## Windows 10 installation

### Step 1

Download and Install [Mysql Server](https://dev.mysql.com/downloads/installer/) (select **mysql-installer-web-community-8.0.21.0.msi** and select Mysql Server v5.7 during installation). Follow the rest of the instructions on the installer screen.

_NOTE:_ If you already have WAMP/XAMPP, you don't need to follow the above step

### Step 2

Download and install [Mysql C Connector 6.1.11](https://downloads.mysql.com/archives/c-c/). Dont download the latest 8.x version as it doesn't contain the required development headers

### Step 3

Open the command prompt and enter the following commands.

_Note_ :

-   Actual path may vary. Check with your system's path
-   Steps can also be refered from https://doc.qt.io/qt-5/sql-driver.html

```sh
cd QT_INSTALL_DIR/5.15.0/Src/qtbase/src/plugins/sqldrivers

qmake -- MYSQL_INCDIR="C:/Program Files/MySQL/MySQL Connector C 6.1/include" MYSQL_LIBDIR="C:/Program Files/MySQL/MySQL Connector C 6.1/lib"

nmake

nmake-install

nmake-clean
```

### Step 4

Copy `libmysql.dll` from `C:/Program Files/MySQL/MySQL Connector C 6.1/lib/`

## Mac installation
