/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Data
** Data Sources
**
****************************************************************************/

import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4 as OldControls

import com.grafieks.singleton.constants 1.0

import "../MainSubComponents"
import "./SubComponents"


Page {

    id: datasourcelist_page
    property int menu_width: 60

    Component.onCompleted: {
        DatasourceDS.fetchDatsources(0, true, true)
    }


    LeftMenuBar{
        id: left_menubar
    }


    Rectangle{
        id: submenu
        height: 20
        width: parent.width - menu_width
        x: menu_width
        z: 5


        Button{
            id: next_btn
            text: "Next"
            anchors.right: parent.right
            anchors.top: submenu.top
            anchors.topMargin: 0
            height: 30

            onClicked: {
                stacklayout_home.currentIndex = 5
            }

            background: Rectangle{
                id: next_btn_background
                color: next_btn.pressed? Constants.darkThemeColor: Constants.themeColor
            }


        }

        TabBar{
            id: tabbar_ds
            anchors.right: next_btn.left
            anchors.rightMargin: 1
            anchors.top: submenu.top
            anchors.topMargin: -3
            currentIndex: stacklayout_ds.currentIndex
            z: 5

            Component.onCompleted: {
                grid_btn_background.color = Constants.darkThemeColor
                list_btn_background.color = Constants.themeColor
            }

            TabButton{
                id: grid_btn
                icon.source: "../../Images/icons/Grid.png"
                icon.color: "black"
                height: 30

                background: Rectangle {
                    id: grid_btn_background
                    color:"white"
                }

                onClicked: {
                    grid_btn_background.color = Constants.darkThemeColor
                    list_btn_background.color = Constants.themeColor
                }


            }

            TabButton{
                id: list_btn
                icon.source: "../../Images/icons/List.png"
                icon.color: "black"
                height: 30

                background: Rectangle {
                    id: list_btn_background
                    color:"white"
                }


                onClicked: {
                    grid_btn_background.color = Constants.themeColor
                    list_btn_background.color = Constants.darkThemeColor
                }

            }
        }

    }



    ToolSeparator{
        id: toolsep1
        orientation: Qt.Horizontal
        width: parent.width - menu_width
        anchors.top: submenu.bottom
        anchors.horizontalCenter: submenu.horizontalCenter
        z: 5

        padding: vertical ? 10 : 2
        topPadding: vertical ? 2 : 10
        bottomPadding: vertical ? 2 : 10

        contentItem: Rectangle {
            implicitWidth: parent.vertical ? 1 : 24
            implicitHeight: parent.vertical ? 24 : 1
            color: Constants.themeColor
        }

    }

    Rectangle{
        id: info_rectangle
        height: 70
        width: parent.width - menu_width
        anchors.top: toolsep1.bottom
        anchors.horizontalCenter: toolsep1.horizontalCenter
        x: menu_width
        z: 5

        Row{

            anchors.left: parent.left
            anchors.leftMargin: 20
            width: info_rectangle.width
            anchors.horizontalCenter: parent.horizontalCenter

            Grid{
                id: grid1
                columns: 2
                spacing: 20

                Text{
                    text: "Server Address"
                }
                Text{
                    text: "http://google.com"
                }
                Text{
                    text: "Data Source Name"
                }
                Text{
                    text: "Lorem Ipsum"
                }
            }




            // Search box

            Rectangle{
                id:search_rect
                anchors.right:parent.right
                anchors.verticalCenter: grid1.verticalCenter
                anchors.rightMargin: 350
                border.color: Constants.darkThemeColor
                width: 300
                height: 40
                radius: 10

                TextEdit {
                    id: search_text
                    text: "Search"
                    cursorVisible: true
                    width:250
                    height: 40
                    anchors.left: search_rect.left
                    anchors.leftMargin: 10
                    verticalAlignment:TextEdit.AlignVCenter
                }

                Image{
                    id:search_btn
                    source: "../../Images/icons/Search.png"
                    anchors.left: search_text.right
                    height:30
                    width: height
                    anchors.verticalCenter: search_rect.verticalCenter

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {

                            // Fetch search results
                            DatasourceDS.fetchDatsources(0, true, true, search_text.text)
                        }
                    }

                }
            }


        }
    }

    ToolSeparator{
        id: toolsep2
        orientation: Qt.Horizontal
        width: parent.width - menu_width
        anchors.top: info_rectangle.bottom
        anchors.horizontalCenter: info_rectangle.horizontalCenter
        z: 5

        padding: vertical ? 10 : 2
        topPadding: vertical ? 2 : 10
        bottomPadding: vertical ? 2 : 10

        contentItem: Rectangle {
            implicitWidth: parent.vertical ? 1 : 24
            implicitHeight: parent.vertical ? 24 : 1
            color: Constants.themeColor
        }
    }


    Rectangle{

        id: toolsep11
        width: parent.width - menu_width
        height: parent.height
        anchors.top: toolsep2.bottom
        anchors.left: left_menubar.right


        StackLayout{
            id: stacklayout_ds
            currentIndex: tabbar_ds.currentIndex
            width: toolsep11.width
            height: toolsep11.height

            DataSourcesGrid{
                id: data_source_grid

            }

            DataSourcesList{
                id: data_source_list
            }

        }


    }


}

