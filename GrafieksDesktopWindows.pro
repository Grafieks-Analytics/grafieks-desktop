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
        Code/Api/login.cpp \
        Code/Api/logout.cpp \
        Code/Connectors/mysqlcon.cpp \
        Code/Connectors/sqlitecon.cpp \
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
        Code/Logic/DataModeller/dblistmodel.cpp \
        Code/Logic/DataModeller/querymodel.cpp \
        Code/Logic/DataModeller/tablelistmodel.cpp \
        Code/Logic/Datasources/datasource.cpp \
        Code/Logic/Datasources/datasourceds.cpp \
        Code/Logic/Datasources/datasourcefilter.cpp \
        Code/Logic/Datasources/datasourcemodel.cpp \
        Code/Logic/General/qttest2.cpp \
#        Code/Logic/General/testing.cpp \
        Code/Logic/Menu/user.cpp \
        main.cpp

RESOURCES += \
    assets.qrc \
    assets.qrc \
    assets.qrc \
    assets.qrc \
    assets.qrc \
    assets.qrc \
    images.qrc \
    images.qrc \
    images.qrc \
    images.qrc \
    images.qrc \
    images.qrc \
    qml.qrc \
    qml.qrc \
    qml.qrc \
    qml.qrc \
    qml.qrc \
    qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

RC_ICONS = Images/logos/logo.ico

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    Code/Api/login.h \
    Code/Api/logout.h \
    Code/Connectors/allconnectors.h \
    Code/Connectors/mysqlcon.h \
    Code/Connectors/sqlitecon.h \
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
    Code/Logic/DataModeller/dblistmodel.h \
    Code/Logic/DataModeller/querymodel.h \
    Code/Logic/DataModeller/tablelistmodel.h \
    Code/Logic/Datasources/datasource.h \
    Code/Logic/Datasources/datasourceds.h \
    Code/Logic/Datasources/datasourcefilter.h \
    Code/Logic/Datasources/datasourcemodel.h \
    Code/Logic/General/qttest2.h \
#    Code/Logic/General/testing.h \
    Code/Logic/Menu/user.h \ \
    Code/constants.h \
    Code/statics.h

DISTFILES += \
    .gitignore \
    Assets/.DS_Store \
    Assets/css/.DS_Store \
    Assets/css/custom.css \
    Assets/js/custom.js \
    Assets/vendors/MARKDOWN-LICENSE.txt \
    Assets/vendors/MARKED-LICENSE.txt \
    Assets/vendors/markdown.css \
    Assets/vendors/marked.js \
    Assets/vendors/qt_attribution.json \
    Assets/vendors/vega-embed.js \
    Assets/vendors/vega5.min.js \
    Constants.qml \
    Documentation/.DS_Store \
    Documentation/Configuration Windows QT.pdf \
    Documentation/Configuration Windows QT.pdf \
    Documentation/Configuration Windows QT.pdf \
    Documentation/Configuration Windows QT.pdf \
    Documentation/Configuration Windows QT.pdf \
    Documentation/Configuration Windows QT.pptx \
    Documentation/Configuration Windows QT.pptx \
    Documentation/Configuration Windows QT.pptx \
    Documentation/Configuration Windows QT.pptx \
    Documentation/Configuration Windows QT.pptx \
    Documentation/ConfigurationMac.md \
    Documentation/Layouts.md \
    Images/.DS_Store \
    Images/icons/.DS_Store \
    Images/icons/16_csv.png \
    Images/icons/16_google-sheets_1b1915a4b0.png \
    Images/icons/20_snowflake-icon_a4ed1ae266.png \
    Images/icons/74_sqlite-icon_a6ac860586.png \
    Images/icons/Charts.png \
    Images/icons/Db - 60.png \
    Images/icons/Db - 60.png \
    Images/icons/Db - 60.png \
    Images/icons/Db - 60.png \
    Images/icons/Db - 60.png \
    Images/icons/Db.png \
    Images/icons/Down.png \
    Images/icons/Down_20.png \
    Images/icons/Edit.png \
    Images/icons/Edit_20.png \
    Images/icons/Enlarge.png \
    Images/icons/GRS.png \
    Images/icons/Grid.png \
    Images/icons/List.png \
    Images/icons/Plus.png \
    Images/icons/Plus_32.png \
    Images/icons/Refresh.png \
    Images/icons/Refresh_30.png \
    Images/icons/Search.png \
    Images/icons/Server.png \
    Images/icons/Up.png \
    Images/icons/Up_20.png \
    Images/icons/align-2.png \
    Images/icons/align.png \
    Images/icons/aws-redshift-logo.png \
    Images/icons/box.png \
    Images/icons/charts/.DS_Store \
    Images/icons/charts/Area.png \
    Images/icons/charts/Area_30.png \
    Images/icons/charts/Bar.png \
    Images/icons/charts/Bar_30.png \
    Images/icons/charts/CandleStick.png \
    Images/icons/charts/CandleStick_30.png \
    Images/icons/charts/Chord.png \
    Images/icons/charts/Chord_30.png \
    Images/icons/charts/Doughnut_30.png \
    Images/icons/charts/ForceDirected_30.png \
    Images/icons/charts/Funnel.png \
    Images/icons/charts/Funnel_30.png \
    Images/icons/charts/Gauge.png \
    Images/icons/charts/Gauge_30.png \
    Images/icons/charts/HeatMap.png \
    Images/icons/charts/HeatMap_30.png \
    Images/icons/charts/Line.png \
    Images/icons/charts/Line_30.png \
    Images/icons/charts/Map.png \
    Images/icons/charts/Map2.png \
    Images/icons/charts/Map2_30.png \
    Images/icons/charts/Map_30.png \
    Images/icons/charts/NightingaleRose_30.png \
    Images/icons/charts/Pie.png \
    Images/icons/charts/Pie_30.png \
    Images/icons/charts/Radar.png \
    Images/icons/charts/Radar_30.png \
    Images/icons/charts/Sankey.png \
    Images/icons/charts/Sankey_30.png \
    Images/icons/charts/ScatterPlot.png \
    Images/icons/charts/ScatterPlot_30.png \
    Images/icons/charts/Sunburst_30.png \
    Images/icons/charts/Table.png \
    Images/icons/charts/Table_30.png \
    Images/icons/charts/Tree.png \
    Images/icons/charts/TreeMap.png \
    Images/icons/charts/TreeMap_30.png \
    Images/icons/charts/Tree_30.png \
    Images/icons/charts/doughnut.png \
    Images/icons/charts/force_directed.png \
    Images/icons/charts/nightingale_rose.png \
    Images/icons/charts/susburst.png \
    Images/icons/cross.png \
    Images/icons/cross_32.png \
    Images/icons/drive.png \
    Images/icons/dropbox-2.png \
    Images/icons/file-icon.png \
    Images/icons/folder-invoices.png \
    Images/icons/folder.png \
    Images/icons/github-1.png \
    Images/icons/google-analytics-4.png \
    Images/icons/hadoop.png \
    Images/icons/json-file.png \
    Images/icons/json-icon.png \
    Images/icons/microsoft-access-1.png \
    Images/icons/microsoft-excel-2013.png \
    Images/icons/microsoft-sql-server.png \
    Images/icons/mysql-6.png \
    Images/icons/oracle-icon.png \
    Images/icons/outline_close_black_18dp1x.png \
    Images/icons/outline_close_black_18dp2x.png \
    Images/icons/outline_play_arrow_black_48dp.png \
    Images/icons/play.png \
    Images/icons/sample_graph.png \
    Images/icons/text.png \
    Images/icons/tick.png \
    Images/icons/tick_32.png \
    Images/icons/zoom out.png \
    Images/icons/zoom out.png \
    Images/icons/zoom out.png \
    Images/icons/zoom out.png \
    Images/icons/zoom out.png \
    Images/logos/.DS_Store \
    Images/logos/logo.ico \
    Images/logos/logo.png \
    Images/logos/logo_full_small.png \
    README.md \
    Source/.DS_Store \
    Source/Charts/area.html \
    Source/Charts/bar.html \
    Source/Charts/box.html \
    Source/Charts/horizontal-bar.html \
    Source/Charts/line.html \
    Source/Charts/pie.html \
    Source/Charts/radar.html \
    Source/Charts/scatter.html \
    Source/Charts/sunburst.html \
    Source/Charts/tree-map.html \
    Source/Charts/tree.html \
    Source/Dashboard/.DS_Store \
    Source/Dashboard/NewDashboard.qml \
    Source/Dashboard/NewReport.qml \
    Source/Dashboard/SubComponents/.DS_Store \
    Source/Dashboard/SubComponents/DashboardCustomize.qml \
    Source/Dashboard/SubComponents/DashboardFilters.qml \
    Source/Dashboard/SubComponents/DashboardSubFilters.qml \
    Source/Dashboard/SubComponents/DashboardSummary.qml \
    Source/Dashboard/SubComponents/ReportCustomizations.qml \
    Source/Data/.DS_Store \
    Source/Data/DataQueryModeller.qml \
    Source/Data/DataSources.qml \
    Source/Data/SelectConnection.qml \
    Source/Data/SubComponents/.DS_Store \
    Source/Data/SubComponents/DataFilterTestPopup.qml \
    Source/Data/SubComponents/DataFilters.qml \
    Source/Data/SubComponents/DataFiltersPopup.qml \
    Source/Data/SubComponents/DataModeller.qml \
    Source/Data/SubComponents/DataSourceDescription.qml \
    Source/Data/SubComponents/DataSourcesGrid.qml \
    Source/Data/SubComponents/DataSourcesList.qml \
    Source/Data/SubComponents/DriveConnection.qml \
    Source/Data/SubComponents/DriveConnectionFiles.qml \
    Source/Data/SubComponents/DropboxConnection.qml \
    Source/Data/SubComponents/DropboxConnectionFiles.qml \
    Source/Data/SubComponents/InMemory.qml \
    Source/Data/SubComponents/MainMenuDelegate.qml \
    Source/Data/SubComponents/MenuSeparatorComponent.qml \
    Source/Data/SubComponents/MysqlConnection.qml \
    Source/Data/SubComponents/QueryModeller.qml \
    Source/Data/SubComponents/SqliteConnection.qml \
    Source/Data/SubComponents/TabBackgroundComponent.qml \
    Source/Data/SubComponents/TabTextComponent.qml \
    Source/Data/SubComponents/TestQueryResultsTable.qml \
    Source/MainSubComponents/.DS_Store \
    Source/MainSubComponents/CheckBoxTpl.qml \
    Source/MainSubComponents/HorizontalLineTpl.qml \
    Source/MainSubComponents/LeftMenuBar.qml \
    Source/MainSubComponents/LeftMenuBarReports.qml \
    Source/MainSubComponents/LoginCredentials.qml \
    Source/MainSubComponents/LoginServer.qml \
    Source/MainSubComponents/Logout.qml \
    Source/MainSubComponents/MainMenuDelegate.qml \
    Source/MainSubComponents/MenuItemDelegate.qml \
    Source/MainSubComponents/MenuSeparatorComponent.qml \
    Source/MainSubComponents/RadioButtonTpl.qml \
    Source/MainSubComponents/RangeSliderTpl.qml \
    Source/MainSubComponents/SearchBar.qml \
    Source/MainSubComponents/SliderTpl.qml \
    Source/Others/.DS_Store \
    Source/Others/Home.qml \
    Source/Others/SubComponents/.DS_Store \
    Source/Others/Test.qml \
    Source/Others/Test2.qml \
    Source/Others/Test3.qml \
    main.qml
