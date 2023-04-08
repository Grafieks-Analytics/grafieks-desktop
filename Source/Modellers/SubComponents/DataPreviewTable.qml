import QtQuick 
import QtQuick.Window 2.2
import QtQuick.Controls
import QtWebEngine
import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents"

// Data Preview - Table View From Query Results

Rectangle {
    id: win
    width: parent.width
    height: parent.height
    visible: true
    property var roleNames:["a", "b", "c"]
    property var newObject: []
    property var previousModelData: 0
    property var counter : 0
    property var tableData : []
    property var tableHeaderData : []
    color:"red"

    Connections{
        target: QueryModel

        // This one is for table data
        function onSqlHasData(hasData){
            view.model = hasData === true? QueryModel: ""
            view.visible = hasData === true ? true: false

        }

        // This slot is for updating headers
        // This is also returning an array of strings
        function onHeaderDataChanged(tableHeaders){
            if(DSParamsModel.runCalled === true)
                setHeaders(tableHeaders)
        }

        function onQueryDataChanged(jsonData){
            console.log("QUERY RDATA", jsonData)
            tableData = jsonData
          

        }

        // Clear table
        function onClearTablePreview(){
            clearTable()
        }

    }


    Connections{
        target: CSVJsonQueryModel

        // This one is for table data
        function onCsvJsonHasData(hasData){
            view.model = hasData === true? CSVJsonQueryModel: ""
            view.visible = hasData === true ? true: false

        }

        // This slot is for updating headers
        // This is also returning an array of strings
        function onCsvJsonHeaderDataChanged(tableHeaders){
            if(DSParamsModel.runCalled === true)
                setHeaders(tableHeaders)
        }

        function onCsvJsonDataChanged(jsonData){
            console.log("CSV RDATA", jsonData)
            tableData = jsonData
        }


        // Clear table
        function onClearTablePreview(){
            clearTable()
        }

    }

    Connections{
        target: ExcelQueryModel

        // This one is for table data
        function onExcelHasData(hasData){
            //            view.model = hasData === true? ExcelQueryModel: ""
            //            view.visible = hasData === true ? true: false


        }

        // This slot is for updating headers
        // This is also returning an array of strings
        function onExcelHeaderDataChanged(tableHeaders){
            if(DSParamsModel.runCalled === true)
                setHeaders(tableHeaders)
            console.log("TABLE HEADERS", tableHeaders)

            
        }

        function onExcelDataChanged(jsonData){
            console.log("EXCEL RDATA", jsonData)
            tableData = jsonData
           

        }

        // Clear table
        function onClearTablePreview(){
            clearTable()
        }

    }
    Connections{
        target: ForwardOnlyQueryModel

        // This one is for table data
        function onForwardOnlyHasData(hasData){
            view.model = hasData === true? ForwardOnlyQueryModel: ""
            view.visible = hasData === true ? true: false
        }

        // This slot is for updating headers
        // This is also returning an array of strings
        function onForwardOnlyHeaderDataChanged(tableHeaders){
            if(DSParamsModel.runCalled === true)
                setHeaders(tableHeaders)
        }


        function onForwardDataChanged(jsonData){
            console.log("FORWARD RDATA", jsonData)
            tableData = jsonData


        }

        // Clear table
        function onClearTablePreview(){
            clearTable()
        }

    }

    Connections{
        target: DSParamsModel

        function onDestroyLocalObjectsAndMaps(){
            clearTable()
        }
    }

    function setHeaders(tableHeaders){
        // console.log("tableData..",JSON.stringify(tableData))
          webEngineViewTable.runJavaScript("drawTable("+ tableData +
            ","+JSON.stringify(tableHeaders)+")");
    }

    function clearTable(){
        for(var i=0; i<roleNames.length; i++){
            //            view.removeColumn(newObject[i])
            delete newObject[i]

        }
    }


    Rectangle{
        id: view
        anchors.left : parent.left
        anchors.top : calculationName.bottom
        width: parent.width
        height: parent.height
        border.color: Constants.borderBlueColor
        // visible: false

        WebEngineView {
            id: webEngineViewTable
            height:parent.height
            width: parent.width
            // url:"qrc:/Source/Reports/calculatedFieldEditor.html"
            url: Constants.webEngineViewTableURL

            anchors.left: tool_sep_chartFilters.right
            anchors.top: axis.bottom
        }
    }

}
