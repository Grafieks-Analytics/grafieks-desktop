import QtQuick 2.15
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents"

Item {

    id: dashboard_filter_add
    width:200
    height:parent.height


    anchors.left: parent.left
    anchors.leftMargin: 3

    Rectangle{
        id: add_filter
        height:28
        width:parent.width-5
        anchors.top: parent.top
        anchors.topMargin: 4
        anchors.left: parent.left
        anchors.leftMargin: 5
        Text{
            text: "Add Filter"

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
        anchors.top: add_filter.bottom
        anchors.topMargin: 4
        anchors.left: parent.left
        anchors.leftMargin: 5
        width: parent.width
        height:23

        TabButton{
            id: filter_cancel_btn
            text: "Cancel"

            background: Rectangle {
                id: filter_cancel_btn_background
                color:  filter_cancel_btn.pressed? Constants.darkThemeColor: Constants.redThemeColor
                //                color:  filter_cancel_btn.pressed? Constants.darkThemeColor: "#F4F4F4"


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

    //search
    Rectangle{
        id: filterSearch
        //        color: "red"

        anchors.top: apply_btn.bottom
        anchors.topMargin: 10
        height:50
        width:parent.width-5
        anchors.left: parent.left
        anchors.leftMargin: 5

        Row{

            id: searchBox
            width: parent.width-20
            anchors.verticalCenter: parent.verticalCenter


            TextField{
                id:searchTextBox
                placeholderText: "Search"
                width: parent.width - search_icon.width
                height:30
                cursorVisible: true
                anchors.top: row_querymodeller_right_col.top
                anchors.topMargin: 5
                font.pointSize: 10

                background: Rectangle{
                    border.width: 0
                }

            }

            Image{
                id:search_icon
                source:"/Images/icons/iconmonstr-search-thin.svg"
                height:18
                width:18
                anchors.rightMargin: 10
                anchors.top: row_querymodeller_right_col.top
                anchors.topMargin: 10
                anchors.verticalCenter: parent.verticalCenter

                ToolTip.delay:Constants.tooltipShowTime
                ToolTip.timeout: Constants.tooltipHideTime
                ToolTip.text: qsTr("Search tables in current database")
                ToolTip.visible:  mouseAreaSearch.containsMouse? true : false

                MouseArea{
                    id: mouseAreaSearch
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: searchTable(searchTextBox.text)
                }
            }
        }

        ToolSeparator{
            id: toolsep3
            orientation: Qt.Horizontal
            width: parent.width - 20
            anchors.top: searchBox.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: -5
        }
    }

    ToolSeparator{
        id: toolsep4
        orientation: Qt.Horizontal
        width: parent.width - 15
        anchors.top: filterSearch.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 5
    }


    Column {
        spacing: 2
        anchors.top: toolsep4.top
        width: parent.width
        anchors.topMargin: 4
        height: parent.height-add_filter.height-filterSearch.height-20

        Rectangle {
            id: rectangle1
            width: parent.width
            anchors.topMargin: 4
            anchors.left: parent.left
            anchors.leftMargin: 5
            height:  parent.height/3-20
            color: "white"
            border.color: Constants.themeColor


            Text {
                id: text4

                anchors.top: parent.top
                anchors.topMargin: 20
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0

                text: qsTr("Categorical")
                font.pixelSize: 15


            }

            CheckBoxTpl{
                id: checkBox1


                x: 8
                y: 52
                checkbox_text: qsTr("Checkbox")
                checkbox_checked: true
                parent_dimension: 16
            }

            CheckBoxTpl{
                id: checkBox2
                x: 8
                y: 82
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
        }
        Rectangle {
            id: rectangle2

            width: parent.width

            anchors.left: parent.left
            anchors.leftMargin: 5
            height:  parent.height/3-20
            color: "white"
            border.color: Constants.themeColor


            Text {
                id: dataTypeDate

                anchors.top: parent.top
                anchors.topMargin: 20
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0

                text: qsTr("Date")
                font.pixelSize: 15


            }

            CheckBoxTpl{
                id: checkBox4


                x: 8
                y: 52
                checkbox_text: qsTr("Checkbox")
                checkbox_checked: true
                parent_dimension: 16
            }

            CheckBoxTpl{
                id: checkBox5
                x: 8
                y: 82
                checkbox_text: qsTr("Checkbox")
                checkbox_checked: true
                parent_dimension: 16
            }


            CheckBoxTpl{
                id: checkBox6
                x: 8
                y: 107
                checkbox_text: qsTr("Checkbox")
                checkbox_checked: true
                parent_dimension: 16
            }





        }
        Rectangle {
            id: rectangle3

            width: parent.width
            anchors.topMargin: 4
            anchors.left: parent.left
            anchors.leftMargin: 5
            height:  parent.height/3-20
            color: "white"
            border.color: Constants.themeColor


            Text {
                id: dataTypeNumerical

                anchors.top: parent.top
                anchors.topMargin: 20
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0

                text: qsTr("Numerical")
                font.pixelSize: 15


            }

            CheckBoxTpl{
                id: checkBox7


                x: 8
                y: 52
                checkbox_text: qsTr("Checkbox")
                checkbox_checked: true
                parent_dimension: 16
            }

            CheckBoxTpl{
                id: checkBox8
                x: 8
                y: 82
                checkbox_text: qsTr("Checkbox")
                checkbox_checked: true
                parent_dimension: 16
            }


            CheckBoxTpl{
                id: checkBox9
                x: 8
                y: 107
                checkbox_text: qsTr("Checkbox")
                checkbox_checked: true
                parent_dimension: 16
            }





        }



    }






}
