# MySQL Extension Build
 
Open terminal/CMD


```
set mysql=C:\\PROGRA~1\\MYSQL\MYSQLS~1.0
cd C:\Qt\5.13.1\Src\qtbase\src\plugins\sqldrivers\mysql
qmake "INCUDEPATH+=%mysql%\\include" "LIBS+=%mysql%\\lib\\libmysql.lib" -o Makefile mysql.pro
nmake
```

Run the following to show the shortcut directory name
`dir /x`

## To overcome Slow QT install issue
Download the binary from [https://github.com/JKSH/QtSdkRepoChooser/releases](https://github.com/JKSH/QtSdkRepoChooser/releases) and select the fastest mirror. Use the mirror in the Maintenance tool or Qt Online installer settings `user defined repository`