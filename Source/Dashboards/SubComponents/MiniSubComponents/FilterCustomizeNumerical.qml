import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import Qt.labs.qmlmodels 1.0

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"
import "../MiniSubComponents"

Item {

    id: filterCustomizeNumerical
    height: parent.height
//    width: parent.width

    ButtonGroup{
        id:buttonGroupFilterTypeNumerical
    }


    Connections{

        target: DashboardParamsModel

        function onCurrentSelectedColumnChanged(currentSelectedColumn){

            if(DashboardParamsModel.currentColumnType === Constants.numericalTab){
                var currentDashboard = DashboardParamsModel.currentDashboard
                var currentColumn = DashboardParamsModel.currentSelectedColumn
                var columnFilter = DashboardParamsModel.fetchColumnFilterType(currentDashboard, currentColumn)

                // filterNumericalTypes: ["dataRange","dataEqual","datanotEqual","dataSmaller","dataGreater","dataEqualOrSmaller","dataEqualOrGreater","dataBetween"]

                switch(columnFilter){
                case Constants.filterNumericalTypes[0]:
                    rangeText.checked = true
                    break;

                case Constants.filterNumericalTypes[1]:
                    control5.checked = true
                    break;

                case Constants.filterNumericalTypes[2]:
                    control6.checked = true
                    break;

                case Constants.filterNumericalTypes[3]:
                    control7.checked = true
                    break;

                case Constants.filterNumericalTypes[4]:
                    control8.checked = true
                    break;

                case Constants.filterNumericalTypes[5]:
                    control9.checked = true
                    break;

                case Constants.filterNumericalTypes[6]:
                    control10.checked = true
                    break;
                case Constants.filterNumericalTypes[7]:
                    control11.checked = true
                    break;

                default:
                    rangeText.checked = true
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


    //                    Range Filter
    RadioButton {
        id: rangeText
        ButtonGroup.group: buttonGroupFilterTypeNumerical
        x:5

        anchors.margins: 10
        onCheckedChanged: setFilterType(Constants.filterTypes[4])
        indicator: Rectangle {
            implicitWidth: 16
            implicitHeight: 16
            x: 208
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
                visible: rangeText.checked
            }

        }

        contentItem: Text {
            rightPadding: rangeText.indicator.width + rangeText.spacing+100
            text: qsTr("Range")

            elide: Text.ElideRight
            font.pixelSize: 17
            verticalAlignment: Text.AlignVCenter
        }



    }

    Text {
        id: conditionText
        text: qsTr("Condition")
        font.pixelSize: 17
        anchors.top: rangeText.bottom
        anchors.margins: 15
        anchors.horizontalCenter:  parent.horizontalCenter
        horizontalAlignment: Text.horizontalAlignment
        anchors.left: parent.left
        anchors.leftMargin: 10
    }
    ColumnLayout {
        id: rangeRadio
        anchors.top: conditionText.bottom
        x:15
        anchors.margins: 15
        spacing: 15
        RadioButton {
            id: control5
            ButtonGroup.group: buttonGroupFilterTypeNumerical
            onCheckedChanged: setFilterType(Constants.filterTypes[5])
            indicator: Rectangle {
                implicitWidth: 16
                implicitHeight: 16
                x: 200
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
                    visible: control5.checked
                }

            }

            contentItem: Text {
                rightPadding: control5.indicator.width + control5.spacing+60
                text: qsTr("Equal To")
                elide: Text.ElideRight
                font.pixelSize: 15
                verticalAlignment: Text.AlignVCenter
            }



        }
        RadioButton {
            id: control6
            ButtonGroup.group: buttonGroupFilterTypeNumerical
            onCheckedChanged: setFilterType(Constants.filterTypes[6])
            indicator: Rectangle {
                implicitWidth: 16
                implicitHeight: 16
                x: 200
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
                    visible: control6.checked
                }
            }

            contentItem: Text {
                rightPadding: control6.indicator.width + control6.spacing+49
                text: qsTr("Not Equal To")
                elide: Text.ElideRight
                font.pixelSize: 15
                verticalAlignment: Text.AlignVCenter
            }
        }
        RadioButton {
            id: control7
            ButtonGroup.group: buttonGroupFilterTypeNumerical
            onCheckedChanged: setFilterType(Constants.filterTypes[7])
            indicator: Rectangle {
                implicitWidth: 16
                implicitHeight: 16
                x: 200
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
                    visible: control7.checked
                }
            }

            contentItem: Text {
                rightPadding: control7.indicator.width + control7.spacing+49
                text: qsTr("Smaller Than")
                elide: Text.ElideRight
                font.pixelSize: 15
                verticalAlignment: Text.AlignVCenter
            }
        }
        RadioButton {
            id: control8
            ButtonGroup.group: buttonGroupFilterTypeNumerical
            onCheckedChanged: setFilterType(Constants.filterTypes[8])
            indicator: Rectangle {
                implicitWidth: 16
                implicitHeight: 16
                x: 200
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
                    visible: control8.checked
                }
            }

            contentItem: Text {
                rightPadding: control8.indicator.width + control8.spacing+49
                text: qsTr("Greater Than")
                elide: Text.ElideRight
                font.pixelSize: 15
                verticalAlignment: Text.AlignVCenter
            }
        }
        RadioButton {
            id: control9
            ButtonGroup.group: buttonGroupFilterTypeNumerical
            onCheckedChanged: setFilterType(Constants.filterTypes[9])
            indicator: Rectangle {
                implicitWidth: 16
                implicitHeight: 16
                x: 200
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
                    visible: control9.checked
                }
            }

            contentItem: Text {
                rightPadding: control9.indicator.width + control9.spacing+49
                text: qsTr("Equal or Smaller Than")
                elide: Text.ElideRight
                font.pixelSize: 15
                verticalAlignment: Text.AlignVCenter
            }
        }
        RadioButton {
            id: control10
            ButtonGroup.group: buttonGroupFilterTypeNumerical
            onCheckedChanged: setFilterType(Constants.filterTypes[10])
            indicator: Rectangle {
                implicitWidth: 16
                implicitHeight: 16
                x: 200
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
                    visible: control10.checked
                }
            }

            contentItem: Text {
                rightPadding: control10.indicator.width + control10.spacing+49
                text: qsTr("Equal or Greater Than")
                elide: Text.ElideRight
                font.pixelSize: 15
                verticalAlignment: Text.AlignVCenter
            }
        }
        RadioButton {
            id: control11
            ButtonGroup.group: buttonGroupFilterTypeNumerical
            onCheckedChanged: setFilterType(Constants.filterTypes[11])
            indicator: Rectangle {
                implicitWidth: 16
                implicitHeight: 16
                x: 200
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
                    visible: control11.checked
                }
            }

            contentItem: Text {
                rightPadding: control11.indicator.width + control11.spacing+49
                text: qsTr("Between")
                elide: Text.ElideRight
                font.pixelSize: 15
                verticalAlignment: Text.AlignVCenter
            }
        }

    }

}
