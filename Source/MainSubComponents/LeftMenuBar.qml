/****************************************************************************
**
** Copyright (C) 2019 Grafieks.
** Contact: https://grafieks.com/
**
** Master Left Menubar
**
****************************************************************************/

import QtQuick 2.11
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4

import "../../Constants.js" as Constants


Rectangle{
    id: rectangle_left
    height: parent.height
    width: 49

    Column{

        id: leftmenu_col


        // 1st Menu Item starts

        Rectangle{

            id: rect_col_1
            height: rectangle_left.height/2
            width: rectangle_left.width - 1
            color: Constants.themeColor


            Column{
                id: row_left1
                anchors.left:rect_col_1.left
                anchors.leftMargin: 5

                Image{
                    id: db_menu_icon
                    x: 5
                    y: rect_col_1.height/2 - 60
                    source:"../../Images/icons/Db.png"
                    width:25
                    height: 25
                }

                Text{
                    id: db_menu_text
                    anchors.bottom: db_menu_icon.bottom
                    anchors.bottomMargin: 100
                    horizontalAlignment: db_menu_icon.horizontalCenter
                    text: "Data Designer"
                    transform: Rotation { origin.x: 110; origin.y: 100; angle: 270}
                    color:"Gray"

                }
            }


            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    stacklayout_home.currentIndex = 3
                }
                onPressed: {
                    rect_col_1.color = "white"
                }
                onReleased:  {
                    rect_col_1.color = Constants.themeColor
                }
                onEntered: {
                    rect_col_1.color = Constants.hoverThemeColor
                }
                onExited: {
                    rect_col_1.color = Constants.themeColor
                }

            }


        }

        // 1st Menu Item ends

        // Tool Seperator starts

        Rectangle {
            id: seperator1
            width: rectangle_left.width - 1
            implicitWidth: parent.vertical ? 1 : 24
            implicitHeight: parent.vertical ? 24 : 1
            color: Constants.darkThemeColor
        }

        // Tool Seperator ends

        // 2nd Menu Item starts

        Rectangle{

            id: rect_col_2
            height: rectangle_left.height/2
            width: rectangle_left.width - 1
            color: Constants.themeColor

            Column{

                id: row_left2
                anchors.left:rect_col_2.left
                anchors.leftMargin: 5

                Image{
                    id: chart_menu_icon
                    x: 5
                    y: rect_col_2.height/2 - 90
                    source:"../../Images/icons/Charts.png"
                    width:25
                    height: 25
                    anchors.bottomMargin: -150
                }


                Text{
                    id: chart_menu_text
//                    x: 0
//                    y: chart_menu_icon.y - 145
                    anchors.top: chart_menu_icon.bottom
                    anchors.topMargin: -80
                    text: "Dashboard Designer"
                    transform: Rotation { origin.x: 110; origin.y: 100; angle: 270}
                    color:"Gray"

                }
            }

            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    stacklayout_home.currentIndex = 7
                }
                onPressed: {
                    rect_col_2.color = "white"
                }
                onReleased:  {
                    rect_col_2.color = Constants.themeColor
                }
                onEntered: {
                    rect_col_2.color = Constants.hoverThemeColor
                }
                onExited: {
                    rect_col_2.color = Constants.themeColor
                }
            }
        }

        // 2nd Menu Item ends
    }

    ToolSeparator{
        height: rectangle_left.height
        anchors.left: leftmenu_col.right
        anchors.top: parent.top
        padding: 0
        anchors.topMargin: -5
    }
}


