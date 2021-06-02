import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

Item{
    id: filterDataSingleItem
    height: control.height + columnName.height
    width: parent.width
    property alias componentName: filterDataSingleItem.objectName

    onComponentNameChanged: {
        control.model = TableColumnsModel.fetchColumnData(componentName)
        componentTitle.text = DashboardParamsModel.fetchColumnAliasName(DashboardParamsModel.currentDashboard, componentName)
    }

    Connections{
        target: DashboardParamsModel

        function onAliasChanged(newAlias, columnName){
            if(columnName === componentName){
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
                text: componentName
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
        id:control
        width: parent.width
        anchors.top : columnName.bottom

        indicator: Canvas {
            id: canvas
            x: control.width - width - control.rightPadding
            y: control.topPadding + (control.availableHeight - height) / 2
            width: 12
            height: 8
            contextType: "2d"

            Connections {
                target: control
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
                context.fillStyle = control.pressed ? "#black" : "#gray";
                context.fill();
            }
        }
    }
}
