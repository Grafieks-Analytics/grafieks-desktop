# MySQL Extension Build

Open terminal/CMD

```
set mysql=C:\\PROGRA~1\\MYSQL\MYSQLS~1.0
cd C:\Qt\5.13.1\Src\qtbase\src\plugins\sqldrivers\mysql
qmake "INCUDEPATH+=%mysql%\\include" "LIBS+=%mysql%\\lib\\libmysql.lib" -o Makefile mysql.pro
nmake
```

Run the following to show the shortcut directory name
`dir /x`. Remember to select sources in maintenance tool

## Share Windows build

```
windeployqt --qmldir <path-to-app-qml-files> <path-to-app-binary>
```

> Remember to add **windeployqt** to Windows path

## To overcome Slow QT download issue

Download the binary from [https://github.com/JKSH/QtSdkRepoChooser/releases](https://github.com/JKSH/QtSdkRepoChooser/releases) and select the fastest mirror. Use the mirror in the Maintenance tool or Qt Online installer settings `user defined repository`

# Application Dependencies

-   Openssl - For calling HTTPS requests. On Linux/Mac, directly install from package repo manager. For Windows use the [link](https://slproweb.com/products/Win32OpenSSL.html)
