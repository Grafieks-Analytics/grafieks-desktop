/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** MainSubComponents
** Left Menu Bar
**
****************************************************************************/

import QtQuick 2.11
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4

import com.grafieks.singleton.constants 1.0


Rectangle{
    id: leftMenuBar
    height: parent.height
    width: 49

    Column{

        id: leftMenuContent


        // 1st Menu Item starts

        Rectangle{

            id: dataDesignerRect
            height: leftMenuBar.height/2
            width: leftMenuBar.width - 1
            color: Constants.themeColor

            Column{
                id: menu1
                anchors.left:dataDesignerRect.left
                anchors.leftMargin: 5

                Image{
                    id: dbMenuIcon
                    x: 5
                    y: dataDesignerRect.height/2 - 60
                    source:"../../Images/icons/Db.png"
                    width:25
                    height: 25
                }

                Text{
                    id: dbMenuText
                    anchors.bottom: dbMenuIcon.bottom
                    anchors.bottomMargin: 100
                    horizontalAlignment: dbMenuIcon.horizontalCenter
                    text: Constants.dataDesignerText
                    transform: Rotation { origin.x: 110; origin.y: 100; angle: 270}
                    color:"Gray"

                }
            }


            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    dataDesignerRect.color = Constants.leftDarkColor
                    dashboardDesignerRect.color = Constants.themeColor
                    stacklayout_home.currentIndex = 3
                }
                onPressed: {

                    dataDesignerRect.color = Constants.leftDarkColor
                }

                onEntered: {

                    dataDesignerRect.color = Constants.leftDarkColor
                    dashboardDesignerRect.color = Constants.themeColor

                }
                //                onExited: {
                //                    rect_col_1.color = Constants.themeColor
                //                }


            }


        }

        // 1st Menu Item ends

        // Tool Seperator starts

        Rectangle {
            id: seperator1
            width: leftMenuBar.width - 1
            implicitWidth: parent.vertical ? 1 : 24
            implicitHeight: parent.vertical ? 24 : 1
            color: Constants.darkThemeColor
        }

        // Tool Seperator ends

        // 2nd Menu Item starts

        Rectangle{

            id: dashboardDesignerRect
            height: leftMenuBar.height/2
            width: leftMenuBar.width - 1
            color: Constants.themeColor

            Column{

                id: menu2
                anchors.left:dashboardDesignerRect.left
                anchors.leftMargin: 5

                Image{
                    id: chartMenuIcon
                    x: 5
                    y: dashboardDesignerRect.height/2 - 90
                    source:"../../Images/icons/Charts.png"
                    width:25
                    height: 25
                    anchors.bottomMargin: -150
                }


                Text{
                    anchors.top: chartMenuIcon.bottom
                    anchors.topMargin: -80
                    text: Constants.dashboardDesignerText
                    transform: Rotation { origin.x: 110; origin.y: 100; angle: 270}
                    color:"Gray"

                }
            }

            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    dashboardDesignerRect.color = Constants.leftDarkColor
                    dataDesignerRect.color = Constants.themeColor
                    stacklayout_home.currentIndex = 7
                }
                onPressed: {

                    dashboardDesignerRect.color = Constants.leftDarkColor
                }

                onEntered: {
                    dataDesignerRect.color = Constants.themeColor
                    dashboardDesignerRect.color = Constants.leftDarkColor
                }

            }
        }

        // 2nd Menu Item ends
    }

    ToolSeparator{
        height: leftMenuBar.height
        anchors.left: leftMenuContent.right
        anchors.top: parent.top
        padding: 0
        anchors.topMargin: -5
    }
}


