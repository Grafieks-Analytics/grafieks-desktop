QT += quick webengine quickcontrols2 sql
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
        Code/Logic/DataModeller/dblist.cpp \
        Code/Logic/DataModeller/dblistmodel.cpp \
        Code/Logic/Datasources/datasource.cpp \
        Code/Logic/Datasources/datasourceds.cpp \
        Code/Logic/Datasources/datasourcefilter.cpp \
        Code/Logic/Datasources/datasourcemodel.cpp \
        Code/Logic/General/qttest2.cpp \
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

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    Code/Api/login.h \
    Code/Api/logout.h \
    Code/Connectors/mysqlcon.h \
    Code/Connectors/sqlitecon.h \
    Code/Logic/Connectors/connector.h \
    Code/Logic/Connectors/connectorfilter.h \
    Code/Logic/Connectors/connectormodel.h \
    Code/Logic/DataModeller/dblist.h \
    Code/Logic/DataModeller/dblistmodel.h \
    Code/Logic/Datasources/datasource.h \
    Code/Logic/Datasources/datasourceds.h \
    Code/Logic/Datasources/datasourcefilter.h \
    Code/Logic/Datasources/datasourcemodel.h \
    Code/Logic/General/qttest2.h \
    Code/Logic/Menu/user.h \ \
    Code/constants.h \
    Code/statics.h

DISTFILES += \
    README.md
