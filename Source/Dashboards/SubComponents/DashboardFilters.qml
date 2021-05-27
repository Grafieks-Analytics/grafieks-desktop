/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Dashboard/Subcomponents
** Dashboard Filters
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3


import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents"
import "./MiniSubComponents"

Item {

    id: dashboard_filter
    width:200
    height:parent.height
    anchors.left: parent.left
    anchors.leftMargin: 3

    //    js funct
    function toggleSearch(){

        if(searchFilter.visible){
            searchFilter.visible=false
            searchFilter.height=0
            return
        }
        searchFilter.visible=true
        searchFilter.height=30
    }


    function propertyPressed(){
        firstLine.visible=true
        secondLine.visible=false
        thirdLine.visible=false

    }
    function filterTypePressed(){
        secondLine.visible=true
        firstLine.visible=false
        thirdLine.visible=false
    }
    function valuePressed(){
        thirdLine.visible=true
        firstLine.visible=false
        secondLine.visible=false
    }

    ButtonGroup{
        id:buttonGroupSingle
    }
    ButtonGroup{
        id:buttonGroupFilterType
    }

    Rectangle{
        id: show_filter
        height:28
        width:parent.width-5
        anchors.top: parent.top
        anchors.topMargin: 4
        anchors.left: parent.left
        anchors.leftMargin: 5
        Text{
            text: "Select Filter"

            anchors.topMargin: 5
            id:selectFilter
            font.pointSize: 9


            anchors.top: parent.top
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

        }
    }
    TabBar{

        id: apply_btn
        anchors.horizontalCenter: rectangle4.horizontalCenter
        anchors.top: show_filter.bottom
        anchors.topMargin: 4
        anchors.left: parent.left
        anchors.leftMargin: 5
        width: parent.width-10
        height:23

        TabButton{
            id: filter_cancel_btn
            text: "Cancel"

            background: Rectangle {
                id: filter_cancel_btn_background
                color:  filter_cancel_btn.pressed? Constants.darkThemeColor: Constants.redThemeColor



            }
            contentItem: Text{
                id: filter_cancel_btn_text
                text: filter_cancel_btn.text
                color:  "black"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        TabButton{
            id: filter_apply_btn
            text: "Add"

            background: Rectangle {
                id: filter_apply_btn_background
                color:  filter_apply_btn.pressed? Constants.darkThemeColor: Constants.greenThemeColor

            }
            contentItem: Text{
                id: filter_apply_btn_text
                text: filter_apply_btn.text
                color:  "black"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

    }



    ColumnDataList{
        id: columnDataListComponent
    }


    Popup {
        id: labelShapePopup1


        width: 460
        height: 520

        x: -parent.width-labelShapePopup1.width+200
        y:70
        modal: false
        visible: false
        padding: 0


        Rectangle{
            id:settingHead
            width:parent.width
            height: 40
            color: Constants.lightThemeColor

            Text {
                id: text8
                text: qsTr("Filter")
                font.pixelSize: 17
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
            }
            Image {
                source: "/Images/icons/close gray.png"
                width: 14
                height: 14
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin:10

            }
        }


        Rectangle{
            id:settingFilterLeft
            anchors.top: settingHead.bottom
            height: parent.height-settingHead.height
            width:150
            border.color: Constants.themeColor

            Column{

                padding: 0
                anchors.left: parent.left
                anchors.leftMargin: 20
                TabBar {
                    id: bar
                    width: firstBtn.width
                    height: 100
                    anchors.left: parent.left
                    anchors.leftMargin: -20
                    anchors.top: settingFilterLeft.bottom

                    TabButton {
                        id: firstBtn
                        width: 150
                        height: 70
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        background: Rectangle{
                            height: 50
                            width:150
                            color: "white"
                            anchors.verticalCenter: parent.verticalCenter
                            Rectangle {
                                id:firstLine
                                width: parent.width-50
                                height: 3
                                visible: true
                                color: "#009B8F"
                                anchors.bottom: parent.bottom
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                        Text {
                            text: qsTr("Property")
                            font.pixelSize: 17
                            anchors.verticalCenter: parent.verticalCenter
                            x:30
                            verticalAlignment: Text.AlignVCenter
                            styleColor : "white"
                        }
                        onPressed:propertyPressed()
                    }
                    TabButton {
                        id: secondBtn
                        width: 150
                        height: 70
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: firstBtn.bottom
                        anchors.topMargin: parent.spacing
                        background: Rectangle{
                            height: 50
                            width:150
                            color: "white"
                            anchors.verticalCenter: parent.verticalCenter
                            Rectangle {
                                id:secondLine
                                visible: false
                                width: parent.width-50
                                height: 3
                                color: "#009B8F"
                                anchors.bottom: parent.bottom
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                        Text {

                            text: qsTr("Filter Type")
                            font.pixelSize: 17
                            anchors.verticalCenter: parent.verticalCenter
                            x:30
                            verticalAlignment: Text.AlignVCenter
                            styleColor : "white"
                        }

                        onPressed:filterTypePressed()
                    }
                    TabButton {
                        id: thirdBtn
                        width: 150
                        height: 70
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: secondBtn.bottom
                        anchors.topMargin: parent.spacing
                        background: Rectangle{
                            id:backgroundColor
                            height: 50
                            width:150
                            color: "white"
                            anchors.verticalCenter: parent.verticalCenter
                            Rectangle {
                                id:thirdLine
                                visible: false
                                width: parent.width-50
                                height: 3
                                color: "#009B8F"
                                anchors.bottom: parent.bottom
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                        Text {

                            text: qsTr("Value")
                            font.pixelSize: 17
                            anchors.verticalCenter: parent.verticalCenter
                            x:30
                            verticalAlignment: Text.AlignVCenter
                            styleColor : "white"
                        }
                        onPressed:valuePressed()

                    }

                }

            }
        }
        Rectangle{
            id:settingFilterRight
            anchors.top: settingHead.bottom
            anchors.left: settingFilterLeft.right
            height: parent.height-settingHead.height
            width:parent.width - settingFilterLeft.width
            border.color: Constants.themeColor
            StackLayout {
                width: parent.width
                currentIndex: bar.currentIndex
                anchors.top: settingHead.bottom
                Item {
                    id: propertyTab
                    Rectangle{
                        height: settingFilterRight.height
                        width: settingFilterRight.width
                        color: "white"
                        border.color: Constants.themeColor
                        anchors.horizontalCenter: parent.horizontalCenter

                        Row{
                            id: renameEdit
                            y:40
                            spacing:1
                            height: 50
                            width: parent.width/1.5
                            anchors.horizontalCenter:  parent.horizontalCenter

                            Text {
                                id: rename
                                text: qsTr("Rename")
                                font.pixelSize: 17
                            }


                            TextField{
                                width: 130
                                selectByMouse: true
                                anchors.left: rename.right
                                anchors.leftMargin: 50
                                placeholderText: qsTr("Rename")
                                background: Rectangle {

                                    border.color: Constants.themeColor
                                    width: 130
                                    border.width: Constants.borderWidth
                                }
                            }
                        }
                    }
                }
                Item {
                    id: filterTypeTab
                    Rectangle{
                        height: settingFilterRight.height-50
                        width: settingFilterRight.width-80
                        y:40
                        anchors.horizontalCenter: parent.horizontalCenter
                        //                        color: "yellow"

                        Text {
                            id: listText
                            text: qsTr("List")
                            font.pixelSize: 17

                            anchors.horizontalCenter:  parent.horizontalCenter
                            horizontalAlignment: Text.horizontalAlignment
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                        }
                        ColumnLayout {
                            id: radioGroup1
                            anchors.top: listText.bottom
                            anchors.topMargin: 15
                            x:15

                            spacing: 15
                            RadioButton {
                                id: control1
                                ButtonGroup.group: buttonGroupFilterType
                                indicator: Rectangle {
                                    implicitWidth: 16
                                    implicitHeight: 16
                                    x: control1.width - width - control1.rightPadding
                                    y: parent.height / 2 - height / 2
                                    radius: 13
                                    color: "transparent"
                                    border.color: "black"

                                    Rectangle {
                                        width: 16/2
                                        height: width
                                        radius: width/2
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        color: "black"
                                        visible: control1.checked
                                    }
                                }

                                contentItem: Text {
                                    rightPadding: control1.indicator.width + control1.spacing+60
                                    text: qsTr("Single Value")
                                    elide: Text.ElideRight
                                    font.pixelSize: 15
                                    verticalAlignment: Text.AlignVCenter
                                }



                            }

                            RadioButton {
                                id: control2
                                ButtonGroup.group: buttonGroupFilterType
                                indicator: Rectangle {
                                    implicitWidth: 16
                                    implicitHeight: 16
                                    x: control2.width - width - control2.rightPadding
                                    y: parent.height / 2 - height / 2
                                    radius: 13
                                    color: "transparent"
                                    border.color: "black"

                                    Rectangle {
                                        width: 16/2
                                        height: width
                                        radius: width/2
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        color: "black"
                                        visible: control2.checked
                                    }
                                }

                                contentItem: Text {
                                    rightPadding: control2.indicator.width + control2.spacing+49
                                    text: qsTr("Multiple Value")
                                    elide: Text.ElideRight
                                    font.pixelSize: 15
                                    verticalAlignment: Text.AlignVCenter
                                }



                            }

                        }
                        Text {
                            id: dropDownText
                            text: qsTr("Drop Down")
                            font.pixelSize: 17
                            anchors.top: radioGroup1.bottom

                            anchors.horizontalCenter:  parent.horizontalCenter
                            horizontalAlignment: Text.horizontalAlignment
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            anchors.margins: 15

                        }
                        ColumnLayout {
                            anchors.top: dropDownText.bottom
                            x:15
                            anchors.margins: 15
                            spacing: 15
                            RadioButton {
                                id: control3
                                ButtonGroup.group: buttonGroupFilterType
                                indicator: Rectangle {
                                    implicitWidth: 16
                                    implicitHeight: 16
                                    x: control3.width - width - control3.rightPadding
                                    y: parent.height / 2 - height / 2
                                    radius: 13
                                    color: "transparent"
                                    border.color: "black"

                                    Rectangle {
                                        width: 16/2
                                        height: width
                                        radius: width/2
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        color: "black"
                                        visible: control3.checked
                                    }
                                }

                                contentItem: Text {
                                    rightPadding: control3.indicator.width + control3.spacing+60
                                    text: qsTr("Single Value")
                                    elide: Text.ElideRight
                                    font.pixelSize: 15
                                    verticalAlignment: Text.AlignVCenter
                                }



                            }
                            RadioButton {
                                id: control4
                                ButtonGroup.group: buttonGroupFilterType
                                indicator: Rectangle {
                                    implicitWidth: 16
                                    implicitHeight: 16
                                    x: control4.width - width - control4.rightPadding
                                    y: parent.height / 2 - height / 2
                                    radius: 13
                                    color: "transparent"
                                    border.color: "black"

                                    Rectangle {
                                        width: 16/2
                                        height: width
                                        radius: width/2
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        color: "black"
                                        visible: control4.checked
                                    }
                                }

                                contentItem: Text {
                                    rightPadding: control4.indicator.width + control4.spacing+49
                                    text: qsTr("Multiple Value")
                                    elide: Text.ElideRight
                                    font.pixelSize: 15
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }


                        }
                    }
                }
                Item {
                    id: valueTab
                    Rectangle{
                        height: settingFilterRight.height
                        width: settingFilterRight.width
                        ColumnLayout {
                            id: radioGroup6
                            anchors.top: propertyList.bottom
                            y:40
                            anchors.topMargin: 15
                            anchors.horizontalCenter:  parent.horizontalCenter



                            spacing: 15
                            RadioButton {
                                id: control13
                                ButtonGroup.group: buttonGroupFilterType
                                indicator: Rectangle {
                                    implicitWidth: 16
                                    implicitHeight: 16
                                    x: control13.width - width - control13.rightPadding
                                    y: parent.height / 2 - height / 2
                                    radius: 13
                                    color: "transparent"
                                    border.color: "black"

                                    Rectangle {
                                        width: 16/2
                                        height: width
                                        radius: width/2
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        color: "black"
                                        visible: control13.checked
                                    }
                                }

                                contentItem: Text {
                                    rightPadding: control13.indicator.width + control13.spacing+60
                                    text: qsTr("Include")
                                    elide: Text.ElideRight
                                    font.pixelSize: 15
                                    verticalAlignment: Text.AlignVCenter
                                }

                            }

                            RadioButton {
                                id: control14
                                ButtonGroup.group: buttonGroupFilterType
                                indicator: Rectangle {
                                    implicitWidth: 16
                                    implicitHeight: 16
                                    x: control14.width - width - control14.rightPadding
                                    y: parent.height / 2 - height / 2
                                    radius: 13
                                    color: "transparent"
                                    border.color: "black"

                                    Rectangle {
                                        width: 16/2
                                        height: width
                                        radius: width/2
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        color: "black"
                                        visible: control14.checked
                                    }
                                }

                                contentItem: Text {
                                    rightPadding: control14.indicator.width + control14.spacing+60
                                    text: qsTr("Exclude")
                                    elide: Text.ElideRight
                                    font.pixelSize: 15
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }

                        }

                    }
                }

            }
        }

        Rectangle{
            id:bottomButtons
            anchors.top: settingFilterLeft.bottom
            height: 35
            width: parent.width
            border.color: Constants.themeColor


            TabBar{

                id: apply_btn1
                anchors.top: bottomButtons.top
                anchors.topMargin: 3

                anchors.right: parent.right
                anchors.rightMargin: 5
                width: parent.width/3
                height:24


                TabButton{
                    id: filter_cancel_btn1
                    text: "Cancel"

                    background: Rectangle {
                        id: filter_cancel_btn_background1
                        color:  filter_cancel_btn1.pressed? Constants.darkThemeColor: Constants.redThemeColor



                    }
                    contentItem: Text{
                        id: filter_cancel_btn_text1
                        text: filter_cancel_btn1.text
                        color:  "black"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                TabButton{
                    id: filter_apply_btn1
                    text: "Ok"

                    background: Rectangle {
                        id: filter_apply_btn_background1
                        color:  filter_apply_btn1.pressed? Constants.darkThemeColor: Constants.greenThemeColor

                    }
                    contentItem: Text{
                        id: filter_apply_btn_text1
                        text: filter_apply_btn1.text
                        color:  "black"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

            }

        }
    }
}
