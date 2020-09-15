import QtQuick 2.15
import QtQuick.Controls 2.15

Item{
    id:dragRect

    function clicky() {
        console.log("calling Q3",TableColumnsModel.getColumnsForTable("profiles"))
    }

    function columnListObtained(hello){
        console.log("DATS", hello)
    }

    Button{
        text:"Hello"
    }

    Rectangle {
        id: groot
        width: 400
        height: 400

        MouseArea{
            anchors.fill:parent
            onClicked: clicky()
        }
    }

}
