import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Page {

    id : somepageid

    visible: true
        width: 640
        height: 200
        title: qsTr("Let's disable some items in ComboBox")

        ComboBox {
            id: control
            currentIndex: 0
            anchors.centerIn: parent

            model: [
                { text: "Enabled item.", enabled: true },
                { text: "Supposed to be disabled. Can't click on it.", enabled: false},
                { text: "Last, but enabled item.", enabled: true}
            ]
            width: 500
            textRole: "text"

            delegate: ItemDelegate {
                width: control.width
                text: modelData.text
                font.weight: control.currentIndex === index ? Font.DemiBold : Font.Normal
                highlighted: ListView.isCurrentItem
                enabled: modelData.enabled
                visible: modelData.enabled
            }
        }

}
