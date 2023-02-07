QT += core quick httpserver webenginequick  quickcontrols2 sql networkauth webchannel network axcontainer core5compat
CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    Code/Connectors/accesscon.cpp \
    Code/Connectors/csvcon.cpp \
    Code/Connectors/excelcon.cpp \
    Code/Connectors/hivecon.cpp \
    Code/Connectors/impalacon.cpp \
    Code/Connectors/jsoncon.cpp \
    Code/Connectors/jsonnewcon.cpp \
    Code/Connectors/mongocon.cpp \
    Code/Connectors/mssqlcon.cpp \
    Code/Connectors/mysqlcon.cpp \
    Code/Connectors/odbccon.cpp \
    Code/Connectors/oraclecon.cpp \
    Code/Connectors/postgrescon.cpp \
    Code/Connectors/redshiftcon.cpp \
    Code/Connectors/snowflakecon.cpp \
    Code/Connectors/sqlitecon.cpp \
    Code/Connectors/teradatacon.cpp \
    Code/Logic/Connectors/box.cpp \
    Code/Logic/Connectors/boxds.cpp \
    Code/Logic/Connectors/boxmodel.cpp \
    Code/Logic/Connectors/connector.cpp \
    Code/Logic/Connectors/connectorfilter.cpp \
    Code/Logic/Connectors/connectormodel.cpp \
    Code/Logic/Connectors/connectorsloginmodel.cpp \
    Code/Logic/Connectors/drive.cpp \
    Code/Logic/Connectors/driveds.cpp \
    Code/Logic/Connectors/drivemodel.cpp \
    Code/Logic/Connectors/dropbox.cpp \
    Code/Logic/Connectors/dropboxds.cpp \
    Code/Logic/Connectors/dropboxmodel.cpp \
    Code/Logic/Connectors/github.cpp \
    Code/Logic/Connectors/githubds.cpp \
    Code/Logic/Connectors/githubmodel.cpp \
    Code/Logic/Connectors/sheet.cpp \
    Code/Logic/Connectors/sheetds.cpp \
    Code/Logic/Connectors/sheetmodel.cpp \
    Code/Logic/Dashboards/dashboardparamsmodel.cpp \
    Code/Logic/Dashboards/documenthandlermodel.cpp \
    Code/Logic/Dashboards/projectslistmodel.cpp \
    Code/Logic/Dashboards/publishworkbookmodel.cpp \
    Code/Logic/Dashboards/tablecolumnsmodel.cpp \
    Code/Logic/DataModeller/Workers/generaterolenamesforwardonlyworker.cpp \
    Code/Logic/DataModeller/Workers/generaterolenamesqueryworker.cpp \
    Code/Logic/DataModeller/Workers/saveextractcsvjsonworker.cpp \
    Code/Logic/DataModeller/Workers/saveextractexcelworker.cpp \
    Code/Logic/DataModeller/Workers/saveextractforwardonlyworker.cpp \
    Code/Logic/DataModeller/Workers/saveextractqueryworker.cpp \
    Code/Logic/DataModeller/Workers/saveliveforwardonlyworker.cpp \
    Code/Logic/DataModeller/Workers/savelivequeryworker.cpp \
    Code/Logic/DataModeller/Workers/setchartdataqueryworker.cpp \
    Code/Logic/DataModeller/Workers/setchartdataqueryworker.cpp \
    Code/Logic/DataModeller/csvjsondatamodel.cpp \
    Code/Logic/DataModeller/csvjsonquerymodel.cpp \
    Code/Logic/DataModeller/dsparamsmodel.cpp \
    Code/Logic/DataModeller/exceldatamodel.cpp \
    Code/Logic/DataModeller/excelquerymodel.cpp \
    Code/Logic/DataModeller/extractslivequerymodel.cpp \
    Code/Logic/DataModeller/filtercategoricallist.cpp \
    Code/Logic/DataModeller/filtercategoricallistmodel.cpp \
    Code/Logic/DataModeller/filtercsvjson.cpp \
    Code/Logic/DataModeller/filterdatelist.cpp \
    Code/Logic/DataModeller/filterdatelistmodel.cpp \
    Code/Logic/DataModeller/filternumericallist.cpp \
    Code/Logic/DataModeller/filternumericallistmodel.cpp \
    Code/Logic/DataModeller/forwardonlydatamodel.cpp \
    Code/Logic/DataModeller/forwardonlyquerymodel.cpp \
    Code/Logic/DataModeller/newtablelistmodel.cpp \
    Code/Logic/DataModeller/proxyfiltermodel.cpp \
    Code/Logic/DataModeller/publishdatasourcemodel.cpp \
    Code/Logic/DataModeller/querydatamodel.cpp \
    Code/Logic/DataModeller/querymodel.cpp \
    Code/Logic/DataModeller/querystatsmodel.cpp \
    Code/Logic/DataModeller/scheduler.cpp \
    Code/Logic/DataModeller/schedulerds.cpp \
    Code/Logic/DataModeller/schedulermodel.cpp \
    Code/Logic/Datasources/datasource.cpp \
    Code/Logic/Datasources/datasourceds.cpp \
    Code/Logic/Datasources/datasourcemodel.cpp \
    Code/Logic/General/calculatedfields.cpp \
    Code/Logic/General/calculatedfieldsyntax.cpp \
    Code/Logic/General/chartsapithread.cpp \
    Code/Logic/General/chartsmodel.cpp \
    Code/Logic/General/chartsthread.cpp \
    Code/Logic/General/datatype.cpp \
    Code/Logic/General/generalparamsmodel.cpp \
    Code/Logic/General/newtablecolumnsmodel.cpp \
    Code/Logic/General/queryjoiner.cpp \
    Code/Logic/General/querysplitter.cpp \
    Code/Logic/General/tableschemamodel.cpp \
    Code/Logic/General/updateapplicationmodel.cpp \
    Code/Logic/Menu/user.cpp \
    Code/Logic/Readers/extractprocessor.cpp \
    Code/Logic/Readers/liveprocessor.cpp \
    Code/Logic/Readers/workbookprocessor.cpp \
    Code/Logic/Reports/reportparamsmodel.cpp \
    Code/Logic/Reports/reportsdatamodel.cpp \
    Code/OS/odbcdriversmodel.cpp \
    Code/OS/osentries.cpp \
    Code/paths.cpp \
    Code/simplecrypt.cpp \
    main.cpp

RESOURCES += \
    images.qrc \
    qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

RC_ICONS = Images/logos/logo.ico
ICON = Images/logos/GrafieksDesktopMac.icns


# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    Code/Connectors/accesscon.h \
    Code/Connectors/allconnectors.h \
    Code/Connectors/csvcon.h \
    Code/Connectors/excelcon.h \
    Code/Connectors/hivecon.h \
    Code/Connectors/impalacon.h \
    Code/Connectors/jsoncon.h \
    Code/Connectors/jsonnewcon.h \
    Code/Connectors/mongocon.h \
    Code/Connectors/mssqlcon.h \
    Code/Connectors/mysqlcon.h \
    Code/Connectors/odbccon.h \
    Code/Connectors/oraclecon.h \
    Code/Connectors/postgrescon.h \
    Code/Connectors/redshiftcon.h \
    Code/Connectors/snowflakecon.h \
    Code/Connectors/sqlitecon.h \
    Code/Connectors/teradatacon.h \
    Code/Logic/Connectors/box.h \
    Code/Logic/Connectors/boxds.h \
    Code/Logic/Connectors/boxmodel.h \
    Code/Logic/Connectors/connector.h \
    Code/Logic/Connectors/connectorfilter.h \
    Code/Logic/Connectors/connectormodel.h \
    Code/Logic/Connectors/connectorsloginmodel.h \
    Code/Logic/Connectors/drive.h \
    Code/Logic/Connectors/driveds.h \
    Code/Logic/Connectors/drivemodel.h \
    Code/Logic/Connectors/dropbox.h \
    Code/Logic/Connectors/dropboxds.h \
    Code/Logic/Connectors/dropboxmodel.h \
    Code/Logic/Connectors/github.h \
    Code/Logic/Connectors/githubds.h \
    Code/Logic/Connectors/githubmodel.h \
    Code/Logic/Connectors/sheet.h \
    Code/Logic/Connectors/sheetds.h \
    Code/Logic/Connectors/sheetmodel.h \
    Code/Logic/Dashboards/dashboardparamsmodel.h \
    Code/Logic/Dashboards/documenthandlermodel.h \
    Code/Logic/Dashboards/projectslistmodel.h \
    Code/Logic/Dashboards/publishworkbookmodel.h \
    Code/Logic/Dashboards/tablecolumnsmodel.h \
    Code/Logic/DataModeller/Workers/generaterolenamesforwardonlyworker.h \
    Code/Logic/DataModeller/Workers/generaterolenamesqueryworker.h \
    Code/Logic/DataModeller/Workers/saveextractcsvjsonworker.h \
    Code/Logic/DataModeller/Workers/saveextractexcelworker.h \
    Code/Logic/DataModeller/Workers/saveextractforwardonlyworker.h \
    Code/Logic/DataModeller/Workers/saveextractqueryworker.h \
    Code/Logic/DataModeller/Workers/saveliveforwardonlyworker.h \
    Code/Logic/DataModeller/Workers/savelivequeryworker.h \
    Code/Logic/DataModeller/Workers/setchartdataqueryworker.h \
    Code/Logic/DataModeller/Workers/setchartdataqueryworker.h \
    Code/Logic/DataModeller/csvjsondatamodel.h \
    Code/Logic/DataModeller/csvjsonquerymodel.h \
    Code/Logic/DataModeller/dsparamsmodel.h \
    Code/Logic/DataModeller/exceldatamodel.h \
    Code/Logic/DataModeller/excelquerymodel.h \
    Code/Logic/DataModeller/extractslivequerymodel.h \
    Code/Logic/DataModeller/filtercategoricallist.h \
    Code/Logic/DataModeller/filtercategoricallistmodel.h \
    Code/Logic/DataModeller/filtercsvjson.h \
    Code/Logic/DataModeller/filterdatelist.h \
    Code/Logic/DataModeller/filterdatelistmodel.h \
    Code/Logic/DataModeller/filternumericallist.h \
    Code/Logic/DataModeller/filternumericallistmodel.h \
    Code/Logic/DataModeller/forwardonlydatamodel.h \
    Code/Logic/DataModeller/forwardonlyquerymodel.h \
    Code/Logic/DataModeller/newtablelistmodel.h \
    Code/Logic/DataModeller/proxyfiltermodel.h \
    Code/Logic/DataModeller/publishdatasourcemodel.h \
    Code/Logic/DataModeller/querydatamodel.h \
    Code/Logic/DataModeller/querymodel.h \
    Code/Logic/DataModeller/querystatsmodel.h \
    Code/Logic/DataModeller/scheduler.h \
    Code/Logic/DataModeller/schedulerds.h \
    Code/Logic/DataModeller/schedulermodel.h \
    Code/Logic/Datasources/datasource.h \
    Code/Logic/Datasources/datasourceds.h \
    Code/Logic/Datasources/datasourcemodel.h \
    Code/Logic/General/calculatedfields.h \
    Code/Logic/General/calculatedfieldsyntax.h \
    Code/Logic/General/chartsapithread.h \
    Code/Logic/General/chartsmodel.h \
    Code/Logic/General/chartsthread.h \
    Code/Logic/General/datatype.h \
    Code/Logic/General/generalparamsmodel.h \
    Code/Logic/General/newtablecolumnsmodel.h \
    Code/Logic/General/queryjoiner.h \
    Code/Logic/General/querysplitter.h \
    Code/Logic/General/tableschemamodel.h \
    Code/Logic/General/updateapplicationmodel.h \
    Code/Logic/Menu/user.h \
    Code/Logic/Readers/extractprocessor.h \
    Code/Logic/Readers/liveprocessor.h \
    Code/Logic/Readers/workbookprocessor.h \
    Code/Logic/Reports/reportparamsmodel.h \
    Code/Logic/Reports/reportsdatamodel.h \
    Code/OS/odbcdriversmodel.h \
    Code/OS/osentries.h \
    Code/duckdb.hpp \
    Code/json.hpp \
    Code/messages.h \
    Code/constants.h \
    Code/paths.h \
    Code/secrets.h \
    Code/secrets.h \
    Code/secrets.h \
    Code/secrets.h \
    Code/secrets.h \
    Code/secrets.sample.h \
    Code/simplecrypt.h \
    Code/statics.h


INCLUDEPATH += $$PWD/Libraries
INCLUDEPATH += $$PWD/Libraries/jsoncons
INCLUDEPATH += $$PWD/Libraries/jsoncons_ext

DEPENDPATH += $$PWD/Libraries

macx: LIBS += -L$$PWD/Libraries/ -lduckdb
win32: LIBS += $$PWD/Libraries/duckdb.lib


# Crashpad integration
# Create a dSYM file for dump_syms
CONFIG += force_debug_info
CONFIG += separate_debug_info

# Include directories for Crashpad libraries
INCLUDEPATH += $$PWD/Libraries/Crashpad/Include/crashpad
INCLUDEPATH += $$PWD/Libraries/Crashpad/Include/crashpad/third_party/mini_chromium/mini_chromium
INCLUDEPATH += $$PWD/Libraries/Crashpad/Include/crashpad/out/Default/gen

# Crashpad rules for MacOS
macx {
    # Choose either x86_64 or arm64
    #ARCH = x86_64
    ARCH = arm64

    # Crashpad libraries
    LIBS += -L$$PWD/Libraries/Crashpad/Libraries/MacOS/$$ARCH -lcommon
    LIBS += -L$$PWD/Libraries/Crashpad/Libraries/MacOS/$$ARCH -lclient
    LIBS += -L$$PWD/Libraries/Crashpad/Libraries/MacOS/$$ARCH -lbase
    LIBS += -L$$PWD/Libraries/Crashpad/Libraries/MacOS/$$ARCH -lutil
    LIBS += -L$$PWD/Libraries/Crashpad/Libraries/MacOS/$$ARCH -lmig_output

    # System libraries
    LIBS += -L/usr/lib/ -lbsm
    LIBS += -framework AppKit
    LIBS += -framework Security

    # Copy crashpad_handler to build directory and run dump_syms and symupload
    QMAKE_POST_LINK += "mkdir -p $$OUT_PWD/crashpad"
    QMAKE_POST_LINK += "&& cp $$PWD/Libraries/Crashpad/Bin/MacOS/$$ARCH/crashpad_handler $$OUT_PWD/crashpad"
    QMAKE_POST_LINK += "&& bash $$PWD/Libraries/Crashpad/Tools/MacOS/symbols.sh $$PWD $$OUT_PWD support_grafieks_com grafieks.desktop 1.0.4 > $$PWD/Libraries/Crashpad/Tools/MacOS/symbols.out 2>&1"
}

# Crashpad rules for Windows
win32 {
    # Build variables
    CONFIG(debug, debug|release) {
        LIBDIR = $$PWD\Libraries\Crashpad\Libraries\Windows\MDd
        EXEDIR = $$OUT_PWD\debug
    }
    CONFIG(release, debug|release) {
        LIBDIR = $$PWD\Libraries\Crashpad\Libraries\Windows\MD
        EXEDIR = $$OUT_PWD\release
    }

    # Crashpad libraries
    LIBS += -L$$LIBDIR -lbase
    LIBS += -L$$LIBDIR -lcommon
    LIBS += -L$$LIBDIR -lclient
    LIBS += -L$$LIBDIR -lutil

    # System libraries
    LIBS += -lAdvapi32

    # Copy crashpad_handler to output directory and upload symbols
    QMAKE_POST_LINK += "if not exist $$shell_path($$OUT_PWD)\crashpad mkdir $$shell_path($$OUT_PWD)\crashpad"
    QMAKE_POST_LINK += "&& copy /y $$shell_path($$PWD)\Libraries\Crashpad\Bin\Windows\crashpad_handler.exe $$shell_path($$OUT_PWD)\crashpad\crashpad_handler.exe"
    QMAKE_POST_LINK += "&& $$shell_path($$PWD)\Libraries\Crashpad\Tools\Windows\symbols.bat $$shell_path($$PWD) $$shell_path($$EXEDIR) support_grafieks_com grafieks.desktop 1.0.4 > $$shell_path($$PWD)\Libraries\Crashpad\Tools\Windows\symbols.out 2>&1"
    QMAKE_POST_LINK += "&& copy /y $$shell_path($$PWD)\Libraries\Crashpad\attachment.txt $$shell_path($$OUT_PWD)\attachment.txt"
}

# Crashpad rules for Linux
linux {
    # Crashpad libraries
    LIBS += -L$$PWD/Libraries/Crashpad/Libraries/Linux/ -lcommon
    LIBS += -L$$PWD/Libraries/Crashpad/Libraries/Linux/ -lclient
    LIBS += -L$$PWD/Libraries/Crashpad/Libraries/Linux/ -lutil
    LIBS += -L$$PWD/Libraries/Crashpad/Libraries/Linux/ -lbase

    # Copy crashpad_handler to build directory and run dump_syms and symupload
    QMAKE_POST_LINK += "mkdir -p $$OUT_PWD/crashpad && cp $$PWD/Libraries/Crashpad/Bin/Linux/crashpad_handler $$OUT_PWD/crashpad/crashpad_handler"
    QMAKE_POST_LINK += "&& $$PWD/Libraries/Crashpad/Tools/Linux/symbols.sh $$PWD $$OUT_PWD support_grafieks_com grafieks.desktop 1.0.4 > $$PWD/Libraries/Crashpad/Tools/Linux/symbols.out 2>&1"
    QMAKE_POST_LINK += "&& cp $$PWD/Libraries/Crashpad/attachment.txt $$OUT_PWD/attachment.txt"
}

