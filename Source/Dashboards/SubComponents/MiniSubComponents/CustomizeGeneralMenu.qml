import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import com.grafieks.singleton.constants 1.0

Rectangle{


    Column{

        width: parent.width
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 15
        anchors.rightMargin: 15
        anchors.topMargin: 5

        spacing: 5

        Text {
            text: qsTr("Dashboard Name")
        }

        TextField{
            id: dashboardName
            width: parent.width
            background: Rectangle {
                border.color: Constants.borderBlueColor
                radius: 6
                width: parent.width
                border.width: Constants.borderWidth
            }
        }
    }

}

