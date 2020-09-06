/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** MainSubComponents
** Left Menu Bar
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0


Rectangle{
    id: leftMenuBar
    height: parent.height
    width: 49

    // selectedMenu indicates
    // 0 : Data Designer is selected
    // 1 : Dashboard Designer is selected

    property int selectedMenu: 0

    Column{

        id: leftMenuContent

        // 1st Menu Item starts

        Button{

            id: dataDesignerRect
            height: leftMenuBar.height/2
            width: leftMenuBar.width - 1

            background: Rectangle{
                id: dataDesignerBtnBackground
                color: Constants.leftDarkColor
            }

            onClicked: {

                dataDesignerBtnBackground.color = Qt.binding(function() { return  Constants.leftDarkColor })
                dashboardMenuBtnBackground.color = Qt.binding(function() { return dashboardDesignerRect.hovered ? Constants.leftDarkColor : Constants.themeColor })

                stacklayout_home.currentIndex = 3
            }

            Rectangle{
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
                    text: Constants.dataDesignerText
                    transform: Rotation { origin.x: 110; origin.y: 100; angle: 270}
                    color:"Gray"

                }
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

        Button{

            id: dashboardDesignerRect
            height: leftMenuBar.height/2
            width: leftMenuBar.width - 1

            background: Rectangle{
                id: dashboardMenuBtnBackground
                color: dashboardDesignerRect.hovered ? Constants.leftDarkColor : Constants.themeColor
            }

            onClicked: {
                dashboardMenuBtnBackground.color = Qt.binding(function() { return  Constants.leftDarkColor })
                dataDesignerBtnBackground.color = Qt.binding(function() { return dataDesignerRect.hovered ? Constants.leftDarkColor : Constants.themeColor })

                stacklayout_home.currentIndex = 6
            }

            Rectangle{

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


