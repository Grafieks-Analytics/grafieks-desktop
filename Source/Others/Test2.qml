import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3
import Qt.labs.platform 1.1


import "../MainSubComponents"

Page{
    id: x
    width: parent.width
    height: parent.height

    FileDialog {
        id: fileDialog
        title: "Save as"
        folder: shortcuts.documents
        fileMode: FileDialog.SaveFile
        defaultSuffix: "bro"
//        Component.onCompleted: visible = true
        onAccepted: {
            console.log(currentFile, file)
            // QtTest2.saveFile(file)
        }
    }

    Button{
        id: x1
        text: "Click me write"
        onClicked: DSParamsModel.saveDatasource("file:///Users/mac/Desktop/lala.dat")
    }

    Button{
        id: x2
        anchors.top: x1.bottom
        text: "Click me read"
        onClicked: DSParamsModel.readDatasource("file:///Users/mac/Desktop/lala.dat")
    }

    Button{
        id: x3
        anchors.top: x2.bottom
        text: "Click me read"
        onClicked: QtTest2.x()
    }

}
