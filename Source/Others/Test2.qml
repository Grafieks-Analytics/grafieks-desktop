import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page{
    id: pageid
    width: parent.width
    height: parent.height

    Component.onCompleted: {
        x.visible = true
    }

    Rectangle{
        id: x
        height: 100
        width: 100
        color: "green"
        visible: true
        border.width: 1
        border.color: "yellow"
    }


}
