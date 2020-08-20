import QtQuick 2.15

Item {

    id: joinBoxItem

    Rectangle{
        id: joinBoxRectangle
        width:20
        height:20
        color: "red"
        radius: 10

        MouseArea{
            anchors.fill: parent
            onClicked: {
                console.log("join")
            }
        }
    }

}
