import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

Item {

    height: parent.height
    width: parent.width

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
        width: parent.width
        model: filterData
        // ComboBox closes the popup when its items (anything AbstractButton derivative) are
        //  activated. Wrapping the delegate into a plain Item prevents that.
        delegate: Item {
            width: parent.width
            height: checkDelegate.height

            function toggle() { checkDelegate.toggle() }
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
                    text: model.name
                    elide: Text.ElideLeft
                    leftPadding: checkDelegate.indicator.width + checkDelegate.spacing
                }



                highlighted: comboBox.highlightedIndex == index
                checked: model.selected
                onCheckedChanged: model.selected = checked
            }
        }
    }
}
