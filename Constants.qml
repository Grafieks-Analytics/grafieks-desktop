/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Global Constants file
**
****************************************************************************/

pragma Singleton
import QtQuick 2.15

QtObject {

    // General Strings

    property string applicationName : qsTr("Grafieks")
    property string signInText : qsTr("Sign In")
    property string signOutText : qsTr("Sign Out")
    property string dataDesignerText : qsTr("Data Designer")
    property string dashboardDesignerText : qsTr("Dashboard Designer")


    // Theme Colors

    property color themeColor : "#F3F3F4"
    property color hoverThemeColor : "#E4E4E7"
    property color darkThemeColor : "#CCCCCC"
    property color greenThemeColor : "#A1D99B"
    property color redThemeColor : "#FB8072"
    property color borderBlueColor : "#BCE0FD"
    property color lightThemeColor : "#F5F5F5"
    property color leftDarkColor: "#E2E2E4"
    property color buttonBorderColor : "#009B8F"
    property color buttonHoverColor : "#009B8F"
    property color whiteColor : "#FFFFFF"
    property color grayColor : "#707070"
    property color blackColor : "#000000"
    property color grafieksGreen: "#009B8F"
    property color grafieksGreenColor: "#009B8F"


    // Standard Font Sizes

    property font fontDefault : Qt.font({family : "verdana"})
    property int fontHeader : 20
    property int fontSubHeader : 18
    property int fontCategoryHeader : 16
    property int fontCategoryHeaderSmall : 12
    property int fontReading: 10

    //font.pointSize: Constants.fontReading = font.pixelSize: Constants.fontCategoryHeader
    //font.pointSize: Constants.fontCategoryHeader = font.pixelSize: Constants.fontHeader

    // Radio Size
    property int defaultRadioDimension: 16

    // SQL Relations
    property string likeRelation: "LIKE"
    property string notLikeRelation: "NOT LIKE"
    property string inRelation: "IN"
    property string equalRelation: "="
    property string notEqualRelation: "!="


    // FILTERS starts
    // Tab Bar Open Constants- Section

    property string categoricalTab: "categorical"
    property string dateTab: "date"
    property string numericalTab: "numerical"
    property string groupTab: "group"

    property double borderWidth: 1.3

    // Main Category
    property string categoryMainListType: "categorical.list"
    property string categoryMainWildCardType: "categorical.wildcard"
    property string categoryMainTopType: "categorical.top"

    // Sub Categories
    property string categorySubMulti: "multiple"
    property string categorySubSingle: "single"

    // Mode
    property string modeCreate: "create"
    property string modeEdit: "edit"

    // FILTERS ends


}
