import QtQuick 2.15
import QtQuick.Controls 2.15
import QtWebEngine 1.7

import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents"
import "../SubComponents"


Column{

    height:parent.height - submenu.height
    width: 200
    anchors.right:parent.right
    anchors.top: submenu.bottom
    anchors.topMargin: 4
    spacing: 40

    visible: false


    ToolSeparator{

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: -8
        height:parent.height

        contentItem: Rectangle {
            implicitWidth: parent.vertical ? 1 : 24
            implicitHeight: parent.vertical ? 24 : 1
            color: Constants.darkThemeColor
        }
    }


    Rectangle{
        id: rectangle_newdashboard_right_col
        color:Constants.themeColor
        width:parent.width
        height:parent.height
        anchors.top: parent.top

        Rectangle{
            id: customizeReportHeading

            height:50
            width: parent.width

            Row{
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                anchors.left: parent.left
                anchors.leftMargin: 10

                Text{
                    text: "Customize Report"
                }

                Image {
                    id: close
                    source: "../../../Images/icons/remove.png"
                    height: 12
                    width: 12
                    anchors.right: parent.right
                    anchors.rightMargin: 20

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            customizeReport.visible = false
                        }
                    }
                }

            }

        }

        // Widget Drawer ends
    }

}
