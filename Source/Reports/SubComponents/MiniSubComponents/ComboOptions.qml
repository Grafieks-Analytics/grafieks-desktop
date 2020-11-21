import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

Rectangle{
    height: boxHeight
    width: parent.width


    ListModel{
        id: multiCharts
        ListElement{
            itemName: "Bar"
            icon: "bar_chart.png"
        }
        ListElement{
            itemName: "Line"
            icon: "line_chart.png"
        }
        ListElement{
            itemName: "Area"
            icon: "area.png"
        }
        ListElement{
            itemName: "Bubble"
            icon: "bar_chart.png"
        }
        ListElement{
            itemName: "Scatter"
            icon: "scatter_plot.png"
        }
    }


    ListView{
        orientation: Qt.Horizontal
        model: multiCharts
        anchors.fill: parent
        interactive: false

        spacing: 2
        delegate: Rectangle{
            width: 100
            height: parent.height
            color: Constants.themeColor
            border.color: Constants.darkThemeColor
            Image {
                source: "/Images/icons/charts/"+icon
                height: 20
                width: 20
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                text: qsTr(itemName)
                anchors.centerIn: parent
            }
        }
    }

}
