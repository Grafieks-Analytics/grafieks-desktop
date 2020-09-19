import QtQuick 2.15
import QtQuick.Controls 2.15

import "../MainSubComponents"

Page{
    width: parent.width
    height: parent.height

    Connections{
        target: QtTest2

        function onAChanged(a){
            console.log("SECOND", "TEST2")
            console.log("SIGNAL FIRED", a)
        }
    }


    Component.onCompleted: {
        console.log("FIRST", "TEST2")
        QtTest2.setA("Abhishek")
    }

    Text{
        text: QtTest2.a
    }
}
