/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Dashboard/Subcomponents
** Dashboard Filters
**
****************************************************************************/

import QtQuick 2.11
import QtQuick.Controls 2.4

import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents"

Item {

    id: dashboard_filter
    width:200
    height:parent.height



    Rectangle {
        id: rectangle1
        x: 8
        y: 8
        width: 185
        height: 147
        color: "white"
        border.color: Constants.themeColor


        CheckBoxTpl{
            id: checkBox1
            x: 8
            y: 39
            checkbox_text: qsTr("Checkbox")
            checkbox_checked: true
            parent_dimension: 16
        }

        CheckBoxTpl{
            id: checkBox2
            x: 8
            y: 72
            checkbox_text: qsTr("Checkbox")
            checkbox_checked: true
            parent_dimension: 16
        }


        CheckBoxTpl{
            id: checkBox3
            x: 8
            y: 107
            checkbox_text: qsTr("Checkbox")
            checkbox_checked: true
            parent_dimension: 16
        }

        Text {
            id: text4
            x: 8
            y: 8
            text: qsTr("Customer Name")
            font.pixelSize: 12
        }



    }

    Rectangle {
        id: rectangle2
        x: 8
        y: 161
        width: 185
        height: 80
        color: "white"
        border.color: Constants.themeColor

        ToolSeparator {
            id: toolSeparator
            x: 8
            y: 23
            width: 169
            height: 13
            orientation: Qt.Horizontal
        }

        Text {
            id: text1
            x: 15
            y: 8
            text: qsTr("PO Number")
            font.pixelSize: 12
        }

        ToolSeparator {
            id: toolSeparator3
            x: 8
            y: -123
            width: 169
            height: 13
            orientation: Qt.Horizontal
        }
    }

    Rectangle {
        id: rectangle3
        x: 8
        y: 247
        width: 185
        height: 70
        color: "white"
        border.color: Constants.themeColor

        ToolSeparator {
            id: toolSeparator1
            x: 8
            y: 18
            width: 169
            height: 13
            orientation: Qt.Horizontal
        }

        Text {
            id: text2
            x: 15
            y: 8
            text: qsTr("Sales")
            font.pixelSize: 12
        }



        SliderTpl {
            id: rangeSlider
            x: 15
            y: 37
            slider_height: 10
            slider_width: 150
            knob_size: 16

        }


    }

    Rectangle {
        id: rectangle4
        x: 8
        y: 323
        width: 185
        height: 150
        color: "white"
        border.color: Constants.themeColor



        RadioButtonTpl{
            id: radioButton
            x: 14
            y: 32
            radio_text: qsTr("Radio Button")
            radio_checked: false
            parent_dimension: 16
        }

        RadioButtonTpl{
            id: radioButton1
            x: 14
            y: 65
            radio_text: qsTr("Radio Button")
            radio_checked: false
            parent_dimension: 16
        }

        RadioButtonTpl{
            id: radioButton2
            x: 14
            y: 102
            radio_text: qsTr("Radio Button")
            radio_checked: false
            parent_dimension: 16
        }


        ToolSeparator {
            id: toolSeparator2
            x: 8
            y: 24
            width: 169
            height: 13
            orientation: Qt.Horizontal
        }

        Text {
            id: text3
            x: 14
            y: 8
            text: qsTr("Order Creation Date")
            font.pixelSize: 12
        }
    }


    TabBar{

        id: apply_btn
        anchors.horizontalCenter: rectangle4.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 60
        width: 190
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
            text: "Apply"

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




}
