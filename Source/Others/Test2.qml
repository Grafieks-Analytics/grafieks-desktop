import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3
import QtWebChannel 1.0

Page{
    id:dragRect


    Component.onCompleted: {
        QtTest2.x()
    }

    function saveExport(){
        DSParamsModel.exportExtractData("/Users/mac/Desktop/l.parquet")
    }

//    FileDialog {
//        id: fileDialog
//        title: "Please choose a file"
//        folder: shortcuts.documents
//        onAccepted: {
//            console.log("You chose: " + fileUrl)
////            DSParamsModel.parseCsv(fileUrl)
//            DSParamsModel.parseParquet(fileUrl)
//        }
//        onRejected: {
//            console.log("Canceled")
////            Qt.quit()
//        }
//        Component.onCompleted: visible = true
//    }

    Button{
        text: "Click to export data"
        onClicked: saveExport()
    }

}
