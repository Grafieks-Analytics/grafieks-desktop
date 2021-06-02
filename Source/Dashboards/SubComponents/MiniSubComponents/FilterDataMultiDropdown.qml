import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

Item {

    id: filterDataMultiItem
    height: control.height + columnName.height
    width: parent.width
    property alias componentName: filterDataMultiItem.objectName

    onComponentNameChanged: {
        comboBox.model = TableColumnsModel.fetchColumnData(componentName)
        componentTitle.text = DashboardParamsModel.fetchColumnAliasName(DashboardParamsModel.currentDashboard, componentName)
    }

    Connections{
        target: DashboardParamsModel

        function onAliasChanged(newAlias, columnName, dashboardId){
            if(columnName === componentName && dashboardId === DashboardParamsModel.currentDashboard){
                componentTitle.text = newAlias
            }
        }
    }

    function filterClicked(){
        DashboardParamsModel.setCurrentSelectedColumn(componentName)
        labelShapePopup1.visible = true
    }

    Rectangle{
        id:columnName
        width:parent.width
        height:25

        border.color: Constants.themeColor
        Row{

            spacing: 55
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter


            Text {
                id: componentTitle
                font.pixelSize: 12
                verticalAlignment: Text.AlignVCenter
            }

            Row{

                height: parent.height
                width: 26
                spacing: 5
                Image {
                    source: "/Images/icons/customize.png"
                    width: 16
                    height: 16
                    MouseArea{
                        anchors.fill: parent
                        onClicked: filterClicked()
                    }
                }
            }
        }
    }

    ComboBox {
        id: comboBox
        width: parent.width

        indicator: Canvas {
            id: canvasMultiselect
            x: comboBox.width - width - comboBox.rightPadding
            y: comboBox.topPadding + (comboBox.availableHeight - height) / 2
            width: 12
            height: 8
            contextType: "2d"

            Connections {
                target: comboBox
                function onPressedChanged(){
                    canvas.requestPaint()
                }
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

        // ComboBox closes the popup when its items (anything AbstractButton derivative) are
        //  activated. Wrapping the delegate into a plain Item prevents that.
        delegate: Item {
            width: parent.width
            height: checkDelegate.height

            function toggle() {
                checkDelegate.toggle()
            }

            CheckDelegate {
                id: checkDelegate
                indicator: Rectangle {
                    id: parent_border
                    implicitHeight: 16
                    implicitWidth: 16
                    x:  checkDelegate.leftPadding
                    y: parent.height / 2 - height / 2
                    border.color: "black"


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
                contentItem: Text {
                    text: modelData
                    elide: Text.ElideLeft
                    leftPadding: checkDelegate.indicator.width + checkDelegate.spacing
                }



                highlighted: comboBox.highlightedIndex == index
                //                checked: model.selected
                //                onCheckedChanged: model.selected = checked
            }
        }
    }
}
