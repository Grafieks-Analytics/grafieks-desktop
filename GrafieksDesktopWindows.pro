QT += quick webengine quickcontrols2 sql networkauth
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
    Code/Connectors/mysqlcon.cpp \
    Code/Connectors/sqlitecon.cpp \
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
    Code/Logic/Connectors/sheet.cpp \
    Code/Logic/Connectors/sheetds.cpp \
    Code/Logic/Connectors/sheetmodel.cpp \
    Code/Logic/DataModeller/columnlistmodel.cpp \
    Code/Logic/DataModeller/dblistmodel.cpp \
    Code/Logic/DataModeller/dsparamsmodel.cpp \
    Code/Logic/DataModeller/filterfunctionsmodel.cpp \
    Code/Logic/DataModeller/filterlist.cpp \
    Code/Logic/DataModeller/filterlistcategoricalfilter.cpp \
    Code/Logic/DataModeller/filterlistmodel.cpp \
    Code/Logic/DataModeller/publishdatasourcemodel.cpp \
    Code/Logic/DataModeller/querymodel.cpp \
    Code/Logic/DataModeller/querystatsmodel.cpp \
    Code/Logic/DataModeller/scheduler.cpp \
    Code/Logic/DataModeller/schedulerds.cpp \
    Code/Logic/DataModeller/schedulermodel.cpp \
    Code/Logic/DataModeller/tablelistmodel.cpp \
    Code/Logic/Datasources/datasource.cpp \
    Code/Logic/Datasources/datasourceds.cpp \
    Code/Logic/Datasources/datasourcefilter.cpp \
    Code/Logic/Datasources/datasourcemodel.cpp \
    Code/Logic/General/generalparamsmodel.cpp \
    Code/Logic/General/qttest2.cpp \
    Code/Logic/General/querysplitter.cpp \
    Code/Logic/General/tableschemamodel.cpp \
    Code/Logic/Menu/user.cpp \
    main.cpp

RESOURCES += \
    assets.qrc \
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
    Code/Connectors/allconnectors.h \
    Code/Connectors/mysqlcon.h \
    Code/Connectors/sqlitecon.h \
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
    Code/Logic/Connectors/sheet.h \
    Code/Logic/Connectors/sheetds.h \
    Code/Logic/Connectors/sheetmodel.h \
    Code/Logic/DataModeller/columnlistmodel.h \
    Code/Logic/DataModeller/dblistmodel.h \
    Code/Logic/DataModeller/dsparamsmodel.h \
    Code/Logic/DataModeller/filterfunctionsmodel.h \
    Code/Logic/DataModeller/filterlist.h \
    Code/Logic/DataModeller/filterlistcategoricalfilter.h \
    Code/Logic/DataModeller/filterlistmodel.h \
    Code/Logic/DataModeller/publishdatasourcemodel.h \
    Code/Logic/DataModeller/querymodel.h \
    Code/Logic/DataModeller/querystatsmodel.h \
    Code/Logic/DataModeller/scheduler.h \
    Code/Logic/DataModeller/schedulerds.h \
    Code/Logic/DataModeller/schedulermodel.h \
    Code/Logic/DataModeller/tablelistmodel.h \
    Code/Logic/Datasources/datasource.h \
    Code/Logic/Datasources/datasourceds.h \
    Code/Logic/Datasources/datasourcefilter.h \
    Code/Logic/Datasources/datasourcemodel.h \
    Code/Logic/General/generalparamsmodel.h \
    Code/Logic/General/qttest2.h \
    Code/Logic/General/querysplitter.h \
    Code/Logic/General/tableschemamodel.h \
    Code/Logic/Menu/user.h \
    Code/messages.h \
    Code/constants.h \
    Code/statics.h

DISTFILES += \
    Source/Dashboard/NewDashboard.qml \
    Source/Dashboard/NewReport.qml \
    Source/Dashboard/SubComponents/DashboardCustomize.qml \
    Source/Dashboard/SubComponents/DashboardFilters.qml \
    Source/Dashboard/SubComponents/DashboardSubFilters.qml \
    Source/Dashboard/SubComponents/DashboardSummary.qml \
    Source/Dashboard/SubComponents/ReportCustomizations.qml \
    Source/Data/DataQueryModeller.qml \
    Source/Data/DataSources.qml \
    Source/Data/MiniSubComponents/AllDateFilters.qml \
    Source/Data/MiniSubComponents/AllFilters.qml \
    Source/Data/MiniSubComponents/AllGroupFilters.qml \
    Source/Data/MiniSubComponents/AllNumericalFilters.qml \
    Source/Data/MiniSubComponents/DateFilterCalenderContent.qml \
    Source/Data/MiniSubComponents/DateFilterListContent.qml \
    Source/Data/MiniSubComponents/DateTimeFrameContent.qml \
    Source/Data/MiniSubComponents/DateTimeFrameDayContent.qml \
    Source/Data/MiniSubComponents/DateTimeFrameMonthContent.qml \
    Source/Data/MiniSubComponents/DateTimeFrameQuarterContent.qml \
    Source/Data/MiniSubComponents/DateTimeFrameYearContent.qml \
    Source/Data/MiniSubComponents/FilterListContent.qml \
    Source/Data/MiniSubComponents/FilterTopContent.qml \
    Source/Data/MiniSubComponents/FilterWildcardContent.qml \
    Source/Data/MiniSubComponents/GroupFilterInnerPopup.qml \
    Source/Data/MiniSubComponents/NumericalFilterInnerPopup.qml \
    Source/Data/SelectConnection.qml \
    Source/Data/SubComponents/CategoricalFilterPopup.qml \
    Source/Data/SubComponents/BoxConnection.qml \
    Source/Data/SubComponents/BoxConnectionFiles.qml \
    Source/Data/SubComponents/DataFilterTestPopup.qml \
    Source/Data/SubComponents/DataFilters.qml \
    Source/Data/SubComponents/DataFiltersPopup.qml \
    Source/Data/SubComponents/DataModeller.qml \
    Source/Data/SubComponents/DataPreviewTable.qml \
    Source/Data/SubComponents/DataSourceDescription.qml \
    Source/Data/SubComponents/DataSourcesGrid.qml \
    Source/Data/SubComponents/DataSourcesList.qml \
    Source/Data/SubComponents/DateFilter.qml \
    Source/Data/SubComponents/DriveConnection.qml \
    Source/Data/SubComponents/DriveConnectionFiles.qml \
    Source/Data/SubComponents/DropboxConnection.qml \
    Source/Data/SubComponents/DropboxConnectionFiles.qml \
    Source/Data/SubComponents/GroupFilter.qml \
    Source/Data/SubComponents/InMemory.qml \
    Source/Data/SubComponents/InfoTable.qml \
    Source/Data/SubComponents/MainMenuDelegate.qml \
    Source/Data/SubComponents/MenuSeparatorComponent.qml \
    Source/Data/SubComponents/MysqlConnection.qml \
    Source/Data/SubComponents/NumericalFilter.qml \
    Source/Data/SubComponents/QueryModeller.qml \
    Source/Data/SubComponents/SheetConnection.qml \
    Source/Data/SubComponents/SheetConnectionFiles.qml \
    Source/Data/SubComponents/SqliteConnection.qml \
    Source/Data/SubComponents/TabBackgroundComponent.qml \
    Source/Data/SubComponents/TabTextComponent.qml \
    Source/Data/SubComponents/TestQueryResultsTable.qml
