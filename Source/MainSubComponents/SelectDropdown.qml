import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

Item {
    property alias list: listView.model
    property alias textValue: selectBoxValue.text


    id: selectDropdown
    width: parent.width
    height: (list.count + 1) * 30
    anchors.left: parent.left

    Rectangle{
        id: selectBox
        height: 30
        width: parent.width
        anchors.left: wildcardOptionRow.left
        border.color: Constants.darkThemeColor
        anchors.leftMargin: 40

        Row{
            height: parent.height
            width: parent.width
            anchors.leftMargin: 20

            Text {
                id: selectBoxValue
                color: Constants.grayColor
                anchors.centerIn: parent
                width: parent.width - 10
            }

            Image{
                id: showBtn
                source:"../../../Images/icons/Down_20.png"

                anchors.top: parent.top
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.topMargin: 5
            }

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    selectListViewOptions.open()
                }
            }

        }

    }

    Menu {
        id: selectListViewOptions
        y: selectBox.height
        width: parent.width
        height: list.count * 30

        ListView{
            id:listView

            height: parent.height
            width: parent.width

            model:list

            delegate: MenuItem{
                text: menuItem
                height: 30
                width: parent.width
                onTriggered: {}
                onClicked: {
                    selectBoxValue.text = this.text
                    selectListViewOptions.close()
                }
            }
        }

    }


}
