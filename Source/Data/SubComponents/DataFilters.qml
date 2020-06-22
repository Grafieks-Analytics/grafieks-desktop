/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Data/SubComponents
** Data Filters
**
****************************************************************************/

import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents"
import "../MiniSubComponents"

Popup {
    id: popupMain
    width: parent.width * 0.5
    height: 500
    x:  parent.width * 0.25
    y: 100
    modal: true
    visible: false
    padding: 0

    background: Rectangle{
        color: Constants.themeColor
    }

    // Popup Header starts

    Rectangle{
        id: headerPopup
        color: Constants.whiteColor
        border.color: "transparent"
        height: 40
        width: parent.width - 2
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 1
        anchors.leftMargin: 1

        Text{
            id : text1
            text: "Data Source Filter"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left : parent.left
            font.pixelSize: 15
            anchors.leftMargin: 10
        }
        Image {
            id: close_icn
            source: "../../../Images/icons/outline_close_black_18dp2x.png"
            anchors.verticalCenter: parent.verticalCenter
            anchors.right:  parent.right
            height: 25
            width: 25
            anchors.rightMargin: 5
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    popupMain.visible = false
                }
            }
        }

    }

    // Popup Header ends

    //    Top header buttons starts

    TabBar{
        id: tabbar1
        anchors.top: headerPopup.bottom
        anchors.left: parent.left
        anchors.topMargin: 1
        anchors.leftMargin: 1

        Component.onCompleted: {
            character_btn_background.color =  Constants.themeColor
        }


        // Characters Tab button starts

        TabButton{
            id: character_btn
            text: "Categorical"
            width:popupMain.width/4 - 1

            background: Rectangle {
                id: character_btn_background
                border.color: Constants.darkThemeColor
                color: character_btn.pressed? Constants.themeColor: Constants.whiteColor
            }

            contentItem: Text{
                id:character_btn_text
                text: character_btn.text
                color:"black"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onClicked: {
                character_btn_background.color =  Constants.themeColor
                date_btn_background.color =  Constants.whiteColor
                numbers_btn_background.color = Constants.whiteColor
                users_btn_background.color = Constants.whiteColor

                allCategoricalFilterContent.visible = true
                allDateFilterContent.visible = false
                allNumericalFilterContent.visible = false
                allGroupFilterContent.visible = false

                addMenuList.model = categoricalMenuList

            }
        }

        // Characters Tab button ends

        // Date Tab button starts

        TabButton{
            id: date_btn
            text: "Date"
            width:popupMain.width/4 - 1

            background: Rectangle {
                id: date_btn_background
                border.color: Constants.darkThemeColor
                color: date_btn.pressed? Constants.themeColor: Constants.whiteColor
            }

            contentItem: Text{
                id:date_btn_text
                text: date_btn.text
                color:"black"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onClicked: {
                character_btn_background.color =  Constants.whiteColor
                date_btn_background.color =  Constants.themeColor
                numbers_btn_background.color = Constants.whiteColor
                users_btn_background.color = Constants.whiteColor


                allCategoricalFilterContent.visible = false
                allDateFilterContent.visible = true
                allNumericalFilterContent.visible = false
                allGroupFilterContent.visible = false

                addMenuList.model = dateMenuList;
            }
        }

        // Date Tab button ends

        // Numbers Tab button starts

        TabButton{
            id: numbers_btn
            text: "Numerical"
            width:popupMain.width/4 - 1

            background: Rectangle {
                id: numbers_btn_background
                border.color: Constants.darkThemeColor
                color: character_btn.pressed? Constants.themeColor: Constants.whiteColor
            }

            contentItem: Text{
                id:numbers_btn_text
                text: numbers_btn.text
                color:"black"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onClicked: {
                character_btn_background.color =  Constants.whiteColor
                date_btn_background.color =  Constants.whiteColor
                numbers_btn_background.color = Constants.themeColor
                users_btn_background.color = Constants.whiteColor


                allCategoricalFilterContent.visible = false
                allDateFilterContent.visible = false
                allNumericalFilterContent.visible = true
                allGroupFilterContent.visible = false

                addMenuList.model = numericalMenuList

            }
        }

        // Numbers Tab button ends

        // Users Tab button starts

        TabButton{
            id: users_btn
            text: "Group"
            width:popupMain.width/4 - 2


            background: Rectangle {
                id: users_btn_background
                border.color: Constants.darkThemeColor
                color: users_btn.pressed? Constants.themeColor: Constants.whiteColor

            }

            contentItem: Text{
                id:users_btn_text
                text: users_btn.text
                color:"black"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onClicked: {
                character_btn_background.color =  Constants.whiteColor
                date_btn_background.color =  Constants.whiteColor
                numbers_btn_background.color = Constants.whiteColor
                users_btn_background.color = Constants.themeColor

                allCategoricalFilterContent.visible = false
                allDateFilterContent.visible = false
                allNumericalFilterContent.visible = false
                allGroupFilterContent.visible = true

                addMenuList.model = groupModelList
            }
        }

        // Users Tab button ends
    }

    // Top header buttons ends

    // Add button starts

    Button{
        id: add_btn_1
        anchors.top: tabbar1.bottom
        anchors.left: parent.left
        anchors.topMargin: 10
        anchors.leftMargin: 20

        text:"Add"
        onClicked: {
            optionsMenu1.open()
        }

        background: Rectangle {
            id: add_btn_1_background
            color: add_btn_1.pressed? Constants.darkThemeColor: Constants.themeColor

        }

        contentItem: Text{
            id:add_btn_1_text
            text: add_btn_1.text
            color:"black"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    // Add button ends

    // Menu options on clicking 'Add button' starts

    ListModel{
        id: categoricalMenuList
        ListElement{
            textValue:"Customer Id"
        }
        ListElement{
            textValue:"Customer Id 2"
        }
        ListElement{
            textValue:"Customer Id 3"
        }
        ListElement{
            textValue:"Customer Id 4"
        }
    }

    ListModel{
        id: dateMenuList
        ListElement{
            textValue:"DOB"
        }
        ListElement{
            textValue:"PO Date"
        }
        ListElement{
            textValue:"GR DATE"
        }
        ListElement{
            textValue:"Customer Id 4"
        }
    }

    ListModel{
        id: numericalMenuList
        ListElement{
            textValue:"DOB"
        }
        ListElement{
            textValue:"PO Date"
        }
        ListElement{
            textValue:"GR DATE"
        }
        ListElement{
            textValue:"Customer Id 4"
        }
    }

    ListModel{
        id:groupModelList
        ListElement{
            textValue:"group1"
        }
        ListElement{
            textValue:"group2"
        }
    }

    Menu {
        id: optionsMenu1

        x: 20
        y: headerPopup.height + tabbar1.height + add_btn_1.height + 22
        width: 150

        ListView{
            id: addMenuList
            anchors.top: parent.top
            model: categoricalMenuList
            height: this.model.count * 40
            width: 150
            delegate:

            MenuItem {
                text: textValue
                onTriggered: {}
                onClicked: {
                    dataFilterInnerPopup.visible = true
                }
            }
        }
    }

    // Menu options on clicking 'Add button' ends

    // Center Panel Starts

    Rectangle{
        id: rect1
        width: popupMain.width - 40
        height: parent.height - headerPopup.height - tabbar1.height - 100;
        border.color: Constants.grayColor
        anchors.top:add_btn_1.bottom
        anchors.left: parent.left
        anchors.topMargin: 10
        anchors.leftMargin: 20


        AllFilters{
            id: allCategoricalFilterContent
        }


        AllDateFilters{
            id: allDateFilterContent
            visible: false
        }


        AllNumericalFilters{
            id: allNumericalFilterContent
            visible: false
        }


        AllGroupFilters{
            id: allGroupFilterContent
            visible: false
        }


    }

    // Center Panel Ends

    // Action button starts

    Row{
        anchors.top:rect1.bottom
        anchors.right: parent.right
        anchors.topMargin: 10
        anchors.rightMargin: 20
        spacing: 5

        Button{
            id: cancel_btn1
            text: "Cancel"
            onClicked: {
                popupMain.visible = false
            }

            background: Rectangle {
                id: cancel_btn1_background
                color: cancel_btn1.pressed? Constants.themeColor: Constants.darkThemeColor

            }

            contentItem: Text{
                id:cancel_btn1_text
                text: cancel_btn1.text
                color:"black"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }


        }


        Button{
            id: apply_btn1
            text: "Apply"

            background: Rectangle {
                id: apply_btn1_background
                color: apply_btn1.pressed? Constants.themeColor: Constants.darkThemeColor

            }

            contentItem: Text{
                id:apply_btn1_text
                text: apply_btn1.text
                color:"black"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: {
                popupMain.visible = false
            }
        }
    }

    // Action button ends


    DataFiltersPopup{
        id:dataFilterInnerPopup
    }
}

