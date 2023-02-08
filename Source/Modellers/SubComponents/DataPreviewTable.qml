import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls
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

        // Clear table
        function onClearTablePreview(){
            clearTable()
        }

    }

    Connections{
        target: ExcelQueryModel

        // This one is for table data
        function onExcelHasData(hasData){
            view.model = hasData === true? ExcelQueryModel: ""
            view.visible = hasData === true ? true: false

        }

        // This slot is for updating headers
        // This is also returning an array of strings
        function onExcelHeaderDataChanged(tableHeaders){
            if(DSParamsModel.runCalled === true)
                setHeaders(tableHeaders)
            console.log("TABLE HEADERS", tableHeaders)
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
        if(tableHeaders.length > 0){
            roleNames = tableHeaders
            newObject = []

            for(var i=0; i<roleNames.length; i++){
                var role  = roleNames[i]
                var columnString = 'import QtQuick 2.3; import QtQuick.Controls 1.2; TableViewColumn {role: "' + role + '"; title: "' + role + '"; }';
                newObject[i] = Qt.createQmlObject(columnString, view)
                view.addColumn(newObject[i])
            }
        }
    }

    function clearTable(){
        for(var i=0; i<roleNames.length; i++){
            view.removeColumn(newObject[i])
            delete newObject[i]

        }
    }


//    TableView {
//        id:view
//        width: parent.width
//        height: parent.height
//        //        anchors.top: clearBtn.bottom
//        alternatingRowColors: false
//        visible: false



//        style: TableViewStyle {
//            headerDelegate: Rectangle {
//                height: textItem.implicitHeight * 1.8
//                width: textItem.implicitWidth
//                color: Constants.themeColor

//                Text {
//                    id: textItem
//                    anchors.fill: parent
//                    verticalAlignment: Text.AlignVCenter
//                    horizontalAlignment: styleData.textAlignment
//                    anchors.leftMargin: 12
//                    text: styleData.value
//                    elide: Text.ElideRight
//                    color: textColor
//                    font.bold: true
//                    renderType: Text.NativeRendering


//                }
//                Rectangle {
//                    anchors.right: parent.right
//                    anchors.top: parent.top
//                    anchors.bottom: parent.bottom
//                    anchors.bottomMargin: 1
//                    anchors.topMargin: 1

//                    width: 1
//                    color: Constants.darkThemeColor
//                    border.color: Constants.darkThemeColor
//                }
//                Rectangle {
//                    anchors.bottom: parent.bottom
//                    width: parent.width
//                    height: 1
//                    color: Constants.darkThemeColor
//                    border.color: Constants.darkThemeColor
//                }
//            }

//            itemDelegate: Rectangle {
//                color: "white"


//                Text {
//                    id: textItem1
//                    anchors.fill: parent
//                    verticalAlignment: Text.AlignVCenter
//                    objectName: styleData.value
//                    horizontalAlignment: styleData.textAlignment
//                    anchors.leftMargin: 12
//                    elide: Text.ElideRight
//                    color: textColor
//                    renderType: Text.NativeRendering
//                    // text: modelData
//                    onObjectNameChanged: {
//                        var colValue;
//                        var newDate;
//                        if(GeneralParamsModel.getDbClassification() === Constants.sqlType || GeneralParamsModel.getDbClassification() === Constants.accessType){
//                            colValue = QueryModel.data(QueryModel.index(styleData.row, styleData.column))
//                            if((new Date(colValue)).getTime() > 0 && typeof colValue === "object"){
//                                newDate = new Date(colValue)
//                                textItem1.text = newDate.getFullYear() + "-" + (newDate.getMonth() + 1) + "-" + newDate.getDate() + " " + newDate.getHours() + ":" + newDate.getMinutes() + ":" + newDate.getSeconds()
//                            } else {
//                                textItem1.text = colValue
//                            }

//                        } else if(GeneralParamsModel.getDbClassification() === Constants.duckType){
//                            colValue = DuckQueryModel.data(DuckQueryModel.index(styleData.row, styleData.column))
//                            if((new Date(colValue)).getTime() > 0 && typeof colValue === "object"){
//                                newDate = new Date(colValue)
//                                textItem1.text = newDate.getFullYear() + "-" + (newDate.getMonth() + 1) + "-" + newDate.getDate() + " " + newDate.getHours() + ":" + newDate.getMinutes() + ":" + newDate.getSeconds()
//                            } else {
//                                textItem1.text = colValue
//                            }
//                        } else if(GeneralParamsModel.getDbClassification() === Constants.forwardType){
//                            colValue = ForwardOnlyQueryModel.data(ForwardOnlyQueryModel.index(styleData.row, styleData.column))
//                            if((new Date(colValue)).getTime() > 0 && typeof colValue === "object"){
//                                newDate = new Date(colValue)
//                                textItem1.text = newDate.getFullYear() + "-" + (newDate.getMonth() + 1) + "-" + newDate.getDate() + " " + newDate.getHours() + ":" + newDate.getMinutes() + ":" + newDate.getSeconds()
//                            } else {
//                                textItem1.text = colValue
//                            }
//                        } else if(GeneralParamsModel.getDbClassification() === Constants.excelType){
//                            colValue = ExcelQueryModel.data(ExcelQueryModel.index(styleData.row, styleData.column))
//                            if((new Date(colValue)).getTime() > 0 && typeof colValue === "object"){
//                                newDate = new Date(colValue)
//                                textItem1.text = newDate.getFullYear() + "-" + (newDate.getMonth() + 1) + "-" + newDate.getDate() + " " + newDate.getHours() + ":" + newDate.getMinutes() + ":" + newDate.getSeconds()
//                            } else {
//                                textItem1.text = colValue
//                            }
//                        } else {
//                            colValue = CSVJsonQueryModel.data(CSVJsonQueryModel.index(styleData.row, styleData.column))
//                            if((new Date(colValue)).getTime() > 0 && typeof colValue === "object"){
//                                newDate = new Date(colValue)
//                                textItem1.text = newDate.getFullYear() + "-" + (newDate.getMonth() + 1) + "-" + newDate.getDate() + " " + newDate.getHours() + ":" + newDate.getMinutes() + ":" + newDate.getSeconds()
//                            } else {
//                                textItem1.text = colValue
//                            }
//                        }
//                    }

//                }
//                Rectangle {
//                    anchors.right: parent.right
//                    anchors.top: parent.top
//                    anchors.bottom: parent.bottom
//                    width: 1
//                    color: Constants.darkThemeColor
//                    border.color: Constants.darkThemeColor
//                }
//                Rectangle {
//                    anchors.bottom: parent.bottom
//                    width: parent.width
//                    height: 1
//                    color: Constants.darkThemeColor
//                    border.color: Constants.darkThemeColor
//                }
//            }
//        }
//    }
}
