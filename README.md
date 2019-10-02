#MySQL Extension Build

Open terminal/CMD


`
set mysql=C:\\PROGRA~1\\MYSQL\MYSQLS~1.0
cd C:\Qt\5.13.1\Src\qtbase\src\plugins\sqldrivers\mysql
qmake "INCUDEPATH+=%mysql%\\include" "LIBS+=%mysql%\\lib\\libmysql.lib" -o Makefile mysql.pro
nmake
`

Run the following to show the shortcut directory name
`dir /x`
