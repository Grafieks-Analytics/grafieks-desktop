import QtQuick 2.15
import Qt.labs.platform 1.1

import com.grafieks.singleton.constants 1.0

// We are moving this here specially because
// its dependent of Qt.Labs.Platform (the default filename preset)
// Some of the features are not present in the default FileDialog
// Also, Qt.Labs.Platform creates a lot of conflict with default QtQuick.Controls in DataQueryModeller file

FileDialog{
    id: saveFilePrompt
    title: "Save Extract As"
    nameFilters: ["Grafieks Extract (*."+ Constants.extractFileExt+" )"];
    fileMode: FileDialog.SaveFile
    currentFile : "file:///" + DSParamsModel.dsName

    onAccepted: {

        let fileName = ConnectorsLoginModel.urlToFilePath(saveFilePrompt.currentFile)
        console.log("FILEPATH", fileName)
        GeneralParamsModel.setExtractPath(fileName)

        switch(GeneralParamsModel.getDbClassification()){
        case Constants.sqlType:
            console.log("SQL save extract")
            QueryModel.saveExtractData()
            break;

        case Constants.forwardOnlyType:
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

        GeneralParamsModel.setCurrentScreen(Constants.dashboardScreen)
        stacklayout_home.currentIndex = Constants.dashboardDesignerIndex

        let currentDashboard = DashboardParamsModel.currentDashboard
        ChartsThread.setChartSource("dashboard", currentDashboard, DashboardParamsModel.ifFilterApplied(currentDashboard))
    }
    onRejected: {
        console.log("file rejected")
    }
}


