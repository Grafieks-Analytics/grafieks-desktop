import QtQuick 2.15
import QtQml 2.15
import Qt.labs.platform 1.1

import com.grafieks.singleton.constants 1.0

// We are moving this here specially because
// its dependent of Qt.Labs.Platform (the default filename preset)
// Some of the features are not present in the default FileDialog
// Also, Qt.Labs.Platform creates a lot of conflict with default QtQuick.Controls in DataQueryModeller file

FileDialog{
    id: saveFilePromptDialog
    title: "Save Extract As"
    nameFilters: ["Extract (*."+ Constants.extractFileExt+" )"];
    fileMode: FileDialog.SaveFile
    currentFile : "file:///" + DSParamsModel.dsName

    property var ifPublish: false


    onAccepted: {

        let fileName = GeneralParamsModel.urlToFilePath(saveFilePromptDialog.currentFile)
        GeneralParamsModel.setExtractPath(fileName)

        switch(GeneralParamsModel.getDbClassification()){
        case Constants.sqlType:
        case Constants.accessType:
            console.log("SQL save extract")
            QueryModel.saveExtractData()
            break;

        case Constants.forwardType:
            console.log("FOWARD")
            ForwardOnlyQueryModel.saveExtractData()
            break;

        case Constants.excelType:
            console.log("EXCEL")
            ExcelQueryModel.saveExtractData()
            break;

        case Constants.csvType:
        case Constants.jsonType:
            console.log("CSV")
            CSVJsonQueryModel.saveExtractData()
            break;

        default:
            console.log("DB Classification failed")
            break;
        }

    }
    onRejected: {
        console.log("file rejected")
    }
}


