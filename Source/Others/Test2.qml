import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3
import Qt.labs.platform 1.1


import "../MainSubComponents"

Page{
    id: x1
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
        id: x
        text: "Click me"
        onClicked: DSParamsModel.saveDatasource()
    }

}
