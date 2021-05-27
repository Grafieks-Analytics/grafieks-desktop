import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

Item{
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
}
