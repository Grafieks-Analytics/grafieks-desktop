import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import Qt.labs.qmlmodels 1.0

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"
import "../MiniSubComponents"

Item {
    id: filterCustomizeCategorical
    height: parent.height
    width: parent.width

    Connections{

        target: DashboardParamsModel

        function onCurrentSelectedColumnChanged(currentSelectedColumn){

            if(DashboardParamsModel.currentColumnType === Constants.categoricalTab || DashboardParamsModel.currentColumnType === Constants.dateTab ){
                var currentDashboard = DashboardParamsModel.currentDashboard
                var currentColumn = DashboardParamsModel.currentSelectedColumn
                var columnFilter = DashboardParamsModel.fetchColumnFilterType(currentDashboard, currentColumn)

                // filterCategoricalTypes: ["dataListMulti", "dataListSingle", "dataDropdownSingle", "dataDropdownMulti"]

                switch(columnFilter){
                case Constants.filterCategoricalTypes[0]:
                    control2.checked = true
                    break;

                case Constants.filterCategoricalTypes[1]:
                    control1.checked = true
                    break;

                case Constants.filterCategoricalTypes[2]:
                    control3.checked = true
                    break;

                case Constants.filterCategoricalTypes[3]:
                    control4.checked = true
                    break;

                default:
                    control2.checked = true
                    break;
                }
            }
        }
    }

    function setFilterType(newFilter){
        let currentDashboardId = DashboardParamsModel.currentDashboard
        let currentSelectedCol = DashboardParamsModel.currentSelectedColumn
        DashboardParamsModel.setColumnFilterType(currentDashboardId, currentSelectedCol, newFilter)
    }

    ButtonGroup{
        id:buttonGroupFilterTypeCategorical
    }

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
            ButtonGroup.group: buttonGroupFilterTypeCategorical
            onCheckedChanged: setFilterType(Constants.filterCategoricalTypes[1])
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
            ButtonGroup.group: buttonGroupFilterTypeCategorical
            onCheckedChanged: setFilterType(Constants.filterCategoricalTypes[0])
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
        id: dropDownRadio
        anchors.top: dropDownText.bottom
        x:15
        anchors.margins: 15
        spacing: 15
        RadioButton {
            id: control3
            ButtonGroup.group: buttonGroupFilterTypeCategorical
            onCheckedChanged: setFilterType(Constants.filterCategoricalTypes[2])
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
            ButtonGroup.group: buttonGroupFilterTypeCategorical
            onCheckedChanged: setFilterType(Constants.filterCategoricalTypes[3])
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
