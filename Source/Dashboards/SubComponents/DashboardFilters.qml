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
import "../../Reports/SubComponents/MiniSubComponents"

Item {


    ListModel{
        id:filterData
        ListElement{
            name:"All"
        }
        ListElement{
            name:"data2"
        }
        ListElement{
            name:"data3"
        }
        ListElement{
            name:"data4"
        }
        ListElement{
            name:"data5"
        }
        ListElement{
            name:"data5"
        }
        ListElement{
            name:"data5"
        }

    }
    Component{
        id:multipleselect
        Row{
            CheckBoxTpl{
                checkbox_text: qsTr(name)
                checkbox_checked: true
                parent_dimension: 14
            }
        }
    }
    Component{
        id:singleselect
        Row{
            CustomRadioButton{
                radio_text: qsTr(name)
                radio_checked: false
                parent_dimension: 16
            }
        }

    }
    //    Component{
    //        id:singleselect
    //        Row{
    //            SelectDropdown{
    //                id: selectOption
    //                textValue:"Equal"
    //                list: filterData
    //                height:  60
    ////                anchors.left: parent.left
    ////                anchors.leftMargin: 20
    //            }
    //        }
    //    }


    id: dashboard_filter
    width:200
    height:parent.height

    anchors.left: parent.left
    anchors.leftMargin: 3
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
                //                color:  filter_apply_btn.pressed? Constants.darkThemeColor: "#F4F4F4"

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



    Rectangle {
        id: rectangle1

        width: parent.width-20
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: apply_btn.bottom
        anchors.topMargin: 10
        height: 200
        color: "white"
        border.color: Constants.themeColor
        Rectangle{
            id:columnName

            width:parent.width
            height:25

            border.color: Constants.themeColor
            Row{

                spacing: 45




                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter


                Text {
                    id: text4
                    text: qsTr("Customer Name")
                    font.pixelSize: 12
                    verticalAlignment: Text.AlignVCenter
                }

                Row{

                    height: parent.height
                    width: 40
                    spacing: 5
                    Image {
                        source: "/Images/icons/iconmonstr-search-thin.svg"
                        width: 14
                        height: 14

                    }
                    Image {
                        source: "/Images/icons/customize.png"
                        width: 16
                        height: 16
                        MouseArea{
                            anchors.fill: parent
                            onClicked: labelShapePopup1.visible = true
                        }

                    }
                }

            }

        }

        TextField{
            id: searchFilter
            anchors.top: columnName.bottom
            width: parent.width-10
            anchors.horizontalCenter: parent.horizontalCenter
            //            visible: false
            placeholderText: qsTr("Search")
            background: Rectangle {
                border.color: Constants.themeColor
                width: parent.width
                border.width: Constants.borderWidth
            }
        }



        ListView{
            anchors.top: searchFilter.bottom
            topMargin: 10
            height:150
            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds
            clip: true
            ScrollBar.vertical: CustomScrollBar {}
            width: parent.width
            model: filterData
            delegate:{
                if(1){
                    return multipleselect
                }
                else if(0){
                    return singleselect
                }

                else{
                    return null
                }

            }
        }

        ComboBox {
            id:control
            y:200
            width: parent.width
            model: filterData
            indicator: Canvas {
                id: canvas
                x: control.width - width - control.rightPadding
                y: control.topPadding + (control.availableHeight - height) / 2
                width: 12
                height: 8
                contextType: "2d"

                Connections {
                    target: control
                    onPressedChanged: canvas.requestPaint()
                }

                onPaint: {
                    context.reset();
                    context.moveTo(0, 0);
                    context.lineTo(width, 0);
                    context.lineTo(width / 2, height);
                    context.closePath();
                    context.fillStyle = control.pressed ? "#black" : "#gray";
                    context.fill();
                }
            }
        }
        ComboBox {
            id: comboBox
            indicator: Canvas {
                id: canvasMultiselect
                x: comboBox.width - width - comboBox.rightPadding
                y: comboBox.topPadding + (comboBox.availableHeight - height) / 2
                width: 12
                height: 8
                contextType: "2d"

                Connections {
                    target: comboBox
                    onPressedChanged: canvas.requestPaint()
                }

                onPaint: {
                    context.reset();
                    context.moveTo(0, 0);
                    context.lineTo(width, 0);
                    context.lineTo(width / 2, height);
                    context.closePath();
                    context.fillStyle = comboBox.pressed ? "#black" : "#gray";
                    context.fill();
                }
            }
            y:260
            //                anchors.centerIn: parent
            width: parent.width

            //                displayText: "Select"

            model: filterData
            // ComboBox closes the popup when its items (anything AbstractButton derivative) are
            //  activated. Wrapping the delegate into a plain Item prevents that.
            delegate: Item {
                width: parent.width
                height: checkDelegate.height

                function toggle() { checkDelegate.toggle() }
                //                    CheckBoxTpl{
                //                        checkbox_text: qsTr(name)
                //                        checkbox_checked: true
                //                        parent_dimension: 14
                //                    }
                CheckDelegate {
                    id: checkDelegate
                    indicator: Rectangle {
                        id: parent_border
                        implicitHeight: 16
                        implicitWidth: 16
                        x: parent.width-20
                        y: parent.height / 2 - height / 2
                        border.color: "black"
//                        border.width: 2

                        Rectangle {
                            id: child_border
                            width: 8
                            height: width
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: checkDelegate.down ?  Constants.darkThemeColor : "black"
                            visible: checkDelegate.checked
                        }
                    }
                    anchors.fill: parent
                    text: model.name
                    highlighted: comboBox.highlightedIndex == index
                    checked: model.selected
                    onCheckedChanged: model.selected = checked
                }
            }
        }
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
            anchors.topMargin: 19
            height: parent.height-settingHead.height-19
            width:150
            border.color: Constants.themeColor

            Column{

//                spacing: 30
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
                    anchors.topMargin: 100
                    //                    spacing: 5
                    TabButton {
                        id: firstBtn
                        width: 150
                        height: 50
                        anchors.horizontalCenter: parent.horizontalCenter
                        background: Rectangle{
                            height: 50
                            width:150
                            color: "white"
                        }
                        Text {
                            text: qsTr("Property")
                            font.pixelSize: 17
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            verticalAlignment: Text.AlignVCenter
                            styleColor : "white"
                        }
                        //                        text: qsTr("Property")
                    }
                    TabButton {
                        id: secondBtn
                        width: 150
                        height: 50
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: firstBtn.bottom
                        anchors.topMargin: parent.spacing
                        background: Rectangle{
                            height: 50
                            width:150
                            color: "white"
                        }
                        Text {

                            text: qsTr("Filter Type")
                            font.pixelSize: 17
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            verticalAlignment: Text.AlignVCenter
                            styleColor : "white"
                        }
                        //                        text: qsTr("Filter Type")
                    }
                    TabButton {
                        id: thirdBtn
                        width: 150
                        height: 50
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: secondBtn.bottom
                        anchors.topMargin: parent.spacing
                        background: Rectangle{
                            id:backgroundColor
                            height: 50
                            width:150
                            color: "white"
                        }
                        Text {

                            text: qsTr("Value")
                            font.pixelSize: 17
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            verticalAlignment: Text.AlignVCenter
                            styleColor : "white"
                        }
//                                                text: qsTr("Value")
                           onPressed:backgroundColor.color="red"

                    }
                    TabButton {
                        id: fourthBtn
                        width: 150
                        height: 50
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: thirdBtn.bottom
                        anchors.topMargin: parent.spacing
                        background: Rectangle{
                            height: 50
                            width:150
                            color: "white"
                        }
                        Text {

                            text: qsTr("Apply")
                            font.pixelSize: 17
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            verticalAlignment: Text.AlignVCenter
                            styleColor : "white"
                        }
//                        text: qsTr("Apply")
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


                    }
                }
                Item {
                    id: filterTypeTab
                    Rectangle{
                        height: settingFilterRight.height-50
                        width: settingFilterRight.width-80
                        y:50
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
                            x:15
                            CustomRadioButton {
                                checked: true
                                 parent_dimension: 16
                                 x:50
//                                text: qsTr("Single Value")
                                 Text {
                                     id: listText23
                                     text: qsTr("List")
                                     font.pixelSize: 17

                                     anchors.horizontalCenter:  parent.horizontalCenter
                                     horizontalAlignment: Text.horizontalAlignment
                                     anchors.left: parent.left
                                     anchors.leftMargin: -50
                                 }
                            }
                            RadioButton {
                                text: qsTr("Multiple Value")
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
                        }
                        ColumnLayout {
                            anchors.top: dropDownText.bottom
                            x:15
                            RadioButton {
                                checked: true
                                text: qsTr("Single Value")
                            }
                            RadioButton {
                                text: qsTr("Multiple Value")
                            }

                        }
                    }
                }
                Item {
                    id: valueTab
                    Rectangle{
                        height: settingFilterRight.height
                        width: settingFilterRight.width
                        color: "blue"
                    }
                }
                Item {
                    id:applyTab
                    Rectangle{
                        height: settingFilterRight.height
                        width: settingFilterRight.width
                        color: "green"
                    }
                }
            }
        }

    }

    //    Rectangle {
    //        id: rectangle2
    //        //            x: 8
    //        y: 210
    //        width: parent.width
    //        height: 80
    //        anchors.left: parent.left
    //        anchors.leftMargin: 5
    //        color: "white"
    //        border.color: Constants.themeColor

    //        ToolSeparator {
    //            id: toolSeparator
    //            x: 8
    //            y: 23
    //            width: 169
    //            height: 13
    //            orientation: Qt.Horizontal
    //        }

    //        Text {
    //            id: text1
    //            x: 15
    //            y: 8
    //            text: qsTr("PO Number")
    //            font.pixelSize: 12
    //        }

    //        ToolSeparator {
    //            id: toolSeparator3
    //            x: 8
    //            y: -123
    //            width: 169
    //            height: 13
    //            orientation: Qt.Horizontal
    //        }
    //    }

    //    Rectangle {
    //        id: rectangle3
    //        //            x: 8
    //        y: 330
    //        width: parent.width
    //        anchors.left: parent.left
    //        anchors.leftMargin: 5
    //        height: 70
    //        color: "white"
    //        border.color: Constants.themeColor

    //        ToolSeparator {
    //            id: toolSeparator1
    //            x: 8
    //            y: 18
    //            width: 169
    //            height: 13
    //            orientation: Qt.Horizontal
    //        }

    //        Text {
    //            id: text2
    //            x: 15
    //            y: 8
    //            text: qsTr("Sales")
    //            font.pixelSize: 12
    //        }



    //        SliderTpl {
    //            id: rangeSlider
    //            x: 15
    //            y: 37
    //            slider_height: 10
    //            slider_width: 150
    //            knob_size: 16

    //        }


    //    }

    //    Rectangle {
    //        id: rectangle4
    //        x: 8
    //        y: 323
    //        width: 185
    //        height: 150
    //        color: "white"
    //        border.color: Constants.themeColor



    //        CustomRadioButton{
    //            id: radioButton
    //            x: 14
    //            y: 32
    //            radio_text: qsTr("Radio Button")
    //            radio_checked: false
    //            parent_dimension: 16
    //        }

    //        CustomRadioButton{
    //            id: radioButton1
    //            x: 14
    //            y: 65
    //            radio_text: qsTr("Radio Button")
    //            radio_checked: false
    //            parent_dimension: 16
    //        }

    //        CustomRadioButton{
    //            id: radioButton2
    //            x: 14
    //            y: 102
    //            radio_text: qsTr("Radio Button")
    //            radio_checked: false
    //            parent_dimension: 16
    //        }


    //        ToolSeparator {
    //            id: toolSeparator2
    //            x: 8
    //            y: 24
    //            width: 169
    //            height: 13
    //            orientation: Qt.Horizontal
    //        }

    //        Text {
    //            id: text3
    //            x: 14
    //            y: 8
    //            text: qsTr("Order Creation Date")
    //            font.pixelSize: 12
    //        }
    //    }

}
