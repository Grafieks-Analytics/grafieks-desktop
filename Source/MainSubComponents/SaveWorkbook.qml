import QtQuick 2.15
import QtQml 2.15
import Qt.labs.platform 1.1

import com.grafieks.singleton.constants 1.0

// We are moving this here specially because
// its dependent of Qt.Labs.Platform (the default filename preset)
// Some of the features are not present in the default FileDialog
// Also, Qt.Labs.Platform creates a lot of conflict with default QtQuick.Controls in NewDashboard.qml file

FileDialog{
    id: saveWorkbookPromptDialog
    title: "Save Workbook As"
    nameFilters: ["Workbook (*."+ Constants.workbookFileExt+" )"];
    fileMode: FileDialog.SaveFile
    currentFile: "file:///" + DashboardParamsModel.wbName

    onAccepted: {

        // Save Dashboard params
        DashboardParamsModel.saveDashboard()

        // Save report params
        ReportParamsModel.saveReport();

        // Save Table Columns Model params
        TableColumnsModel.saveTableColumns();

        // Save ChartsModel
        ChartsModel.saveChartsModel();

        // Save workbook file
        let fileName = GeneralParamsModel.urlToFilePath(saveWorkbookPromptDialog.currentFile)

        WorkbookProcessor.saveWorkbooks(fileName);

        // Workbook file
        PublishWorkbookModel.workbookFile(fileName)

    }
    onRejected: {
        console.log("file rejected")
    }
}


