import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Dialogs

import com.grafieks.singleton.constants 1.0
import com.grafieks.singleton.messages 1.0


import "../../MainSubComponents"
import "../SubComponents"

Item{

    id: infodata_table
    anchors.bottom: dataQueryModellerStackview.bottom
    anchors.left: left_menubar.right
    width: parent.width
    visible: true
    height: queryModellerPage.height - submenu.height - dataQueryModellerStackview.height

    property bool profilingStatus: false
    property bool infoTableResizingFixed: true
    property var errorMsg: ""
    property string defaultMsg: Messages.mo_sub_inft_sqlSuccesMsg


    /***********************************************************************************************************************/
    // LIST MODEL STARTS


    // LIST MODEL ENDS
    /***********************************************************************************************************************/


    /***********************************************************************************************************************/
    // SIGNALS STARTS


    // SIGNALS ENDS
    /***********************************************************************************************************************/



    /***********************************************************************************************************************/
    // Connections Starts


    Connections{
        target: QueryModel

        function onErrorSignal(errMsg){
            if(errMsg !== ""){
                errorMsg = errMsg
                queryUpdate.icon = StandardIcon.Critical
            } else{
                errorMsg = defaultMsg
                queryUpdate.icon = StandardIcon.NoIcon
            }
        }
    }

    Connections{
        target: ForwardOnlyQueryModel

        function onErrorSignal(errMsg){
            if(errMsg !== ""){
                errorMsg = errMsg
                queryUpdate.icon = StandardIcon.Critical
            } else{
                errorMsg = defaultMsg
                queryUpdate.icon = StandardIcon.NoIcon
            }
        }
    }

    Connections{
        target: ExcelQueryModel

        function onErrorSignal(errMsg){
            if(errMsg !== ""){
                errorMsg = errMsg
                queryUpdate.icon = StandardIcon.Critical
            } else{
                errorMsg = defaultMsg
//                queryUpdate.icon = StandardIcon.NoIcon
            }
        }
    }

    Connections{
        target: CSVJsonQueryModel

        function onErrorSignal(errMsg){
            if(errMsg !== ""){
                errorMsg = errMsg
                queryUpdate.icon = StandardIcon.Critical
            } else{
                errorMsg = Messages.mo_sub_inft_dataFetchSuccess
                queryUpdate.icon = StandardIcon.NoIcon
            }
        }
    }

    // Connections Ends
    /***********************************************************************************************************************/



    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTIONS START

    Component.onCompleted: {
        // Set default value of displayLimit
        // of query results to 100
        DSParamsModel.setDisplayRowsCount(100)

        // Set default tab
        DSParamsModel.setCurrentTab(Constants.dataModellerTab)
    }

    function onDragInfoTablePanel(mouse){

        if(infoTableResizingFixed){
            if(mouse.y > 0){
                dataQueryModellerStackview.height += mouse.y
                if(dataQueryModellerStackview.height > 200){
                    infoTableResizingFixed = false
                }
            }
        }

        if(dataQueryModellerStackview.height > 200){

            if(dataQueryModellerStackview.height + mouse.y < 200){
                dataQueryModellerStackview.height = 200
            }else{
                dataQueryModellerStackview.height += mouse.y
            }

        }else{
            infoTableResizingFixed = true;
        }

        infodata_table.height = Qt.binding(function(){
            return queryModellerPage.height - submenu.height - dataQueryModellerStackview.height
        })
    }


    function onTestQueryClicked(){
        testQueryBtnBackground.color = Constants.lightThemeColor
        displayLimitBtnBackground.color = displayLimitBtn.hovered ? Constants.themeColor : Constants.whiteColor
        dataPreviewBtnBackground.color = Constants.lightThemeColor

        testQueryResult.visible = false
        dataPreviewResult.visible = true
    }


    function onDataPreviewClicked(){
        testQueryBtnBackground.color = testQueryBtn.hovered ? Constants.themeColor : Constants.whiteColor
        dataPreviewBtnBackground.color = Constants.lightThemeColor
        displayLimitBtnBackground.color = displayLimitBtn.hovered ? Constants.themeColor : Constants.whiteColor

        testQueryResult.visible = false
        dataPreviewResult.visible = true
    }


    function openDisplayLimitMenu(){

        testQueryBtnBackground.color = testQueryBtn.hovered ? Constants.themeColor : Constants.whiteColor
        dataPreviewBtnBackground.color = Constants.lightThemeColor

        selectLimitOptions.open()
    }


    function onDisplayLimitSelected(value){
        // Change display limit of query results here
        displayLimit.text = Messages.mo_sub_inft_displayLimitText + value
        DSParamsModel.setDisplayRowsCount(value)
        selectLimitOptions.close()
    }

    function onRunQueryClicked(){

        //        testQueryBtn.visible = true
        //        queryUpdate.visible = true

        // This is for Data Preview Table (Important. Else while tying query GUI thread is blocked)
        // If set false, header wont generate in Preview
        DSParamsModel.setRunCalled(true);


        var isSqlSelect = GeneralParamsModel.returnPlainTextFromHtml(DSParamsModel.tmpSql).toUpperCase().startsWith("SELECT");
        // If query is SELECT query
        // Only SELECT query allowed

        if(isSqlSelect){
            console.log(GeneralParamsModel.getDbClassification(), "Classification");

            if(GeneralParamsModel.getDbClassification() === Constants.sqlType || GeneralParamsModel.getDbClassification() === Constants.accessType){

                dataPreviewResult.visible = true
                queryUpdate.visible = true

                // Set profiling on when clicking the play button
                // Reset profiling and turn off when clicked on Publish button

                // if(QueryStatsModel.profileStatus === false){
                //     QueryStatsModel.setProfiling(true)
                //     QueryStatsModel.setProfileStatus(true)
                // }

                QueryModel.setPreviewQuery(DSParamsModel.displayRowsCount)
                // QueryStatsModel.showStats()
                // TableSchemaModel.showSchema(DSParamsModel.tmpSql)

            } else if(GeneralParamsModel.getDbClassification() === Constants.csvType || GeneralParamsModel.getDbClassification() === Constants.jsonType ){
                console.log("INSIDE CSV JSON RUN")
                CSVJsonQueryModel.setPreviewQuery(DSParamsModel.displayRowsCount)

                testQueryResult.visible = false
                dataPreviewResult.visible = true
                queryUpdate.visible = true
            } else if(GeneralParamsModel.getDbClassification() === Constants.excelType){
                console.log("INSIDE EXCEL RUN")
                ExcelQueryModel.setPreviewQuery(DSParamsModel.displayRowsCount)

                testQueryResult.visible = false
                dataPreviewResult.visible = true
                queryUpdate.visible = true
            } else {
                ForwardOnlyQueryModel.setPreviewQuery(DSParamsModel.displayRowsCount)

                testQueryResult.visible = false
                dataPreviewResult.visible = true
                queryUpdate.visible = true
            }
        } else{
            sqlQueryNotAllowedDialog.visible = true
        }

    }

    function onCollapseInfoTable(){
        if(open){

            collapseBtnImage.source = "/Images/icons/Up.png"
            queryResultsTable.visible = false

            dataQueryModellerStackview.height = Qt.binding(function(){
                return queryModellerPage.height - 65
            })

            infodata_table.height = Qt.binding(function(){
                return  queryModellerPage.height - submenu.height - dataQueryModellerStackview.height
            })

            open = false
        }else{

            collapseBtnImage.source = "/Images/icons/Down.png"
            queryResultsTable.visible = true

            dataQueryModellerStackview.height = Qt.binding(function(){
                return queryModellerPage.height - 300
            })

            infodata_table.height = Qt.binding(function(){
                return queryModellerPage.height - submenu.height - dataQueryModellerStackview.height
            })

            open = true
        }
    }


    //JAVASCRIPT FUNCTIONS ENDS
    /***********************************************************************************************************************/


    /***********************************************************************************************************************/
    // SubComponents Starts



    // IF the sql query is not "SELECT query"
    // Show this popup

    MessageDialog{
        id: sqlQueryNotAllowedDialog
        title: Messages.warningTitle
        text: Messages.mo_sub_inft_selectQueriesOnly
        //icon: StandardIcon.Critical

        onAccepted: {
            sqlQueryNotAllowedDialog.close()
        }
    }


    MessageDialog{
        id: queryUpdate
        visible: false
        title: Messages.mo_sub_inft_messageHead
        text: errorMsg
//        icon: StandardIcon.NoIcon

    }

    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts



    Rectangle{
        id: infodataTableHeader
        height: 27
        width: parent.width
        visible: true


        HorizontalLineTpl{
            id: linebar1
            line_color: Constants.darkThemeColor
            line_width: parent.width
            anchors.top: parent.top
            width: parent.width
            height: 4

            MouseArea{
                id: infoPanelDragMouseArea
                anchors.fill: parent
                cursorShape: Qt.SizeVerCursor
                width: parent.width

                onPositionChanged: {

                    onDragInfoTablePanel(mouse)

                }

            }

        }

        // "Test Query" Button Starts

        Rectangle{

            id: toolbar_querymodeller

            width: 0
            anchors.top: infodataTableHeader.top
            anchors.topMargin: 1
            anchors.left: parent.left
            height: parent.height
            visible: false


            Button{
                id: testQueryBtn
                height: 27
                width: 0
                visible: false
                //                leftPadding: 10

                Text{
                    text: Messages.mo_sub_inft_actionOut
                    anchors.centerIn: parent
                }

                background: Rectangle{
                    id: testQueryBtnBackground
                    color: testQueryBtn.hovered ? Constants.themeColor : Constants.whiteColor

                }

                onClicked: onTestQueryClicked()

                ToolTip.delay: Constants.tooltipShowTime
                ToolTip.timeout: Constants.tooltipHideTime
                ToolTip.visible: hovered
                ToolTip.text: Messages.mo_sub_inft_queryPerformance
            }


        }

        // "Test Query" Button Ends

        ToolSeparator{
            id: seperator1
            height:30
            anchors.left:toolbar_querymodeller.right
            //            anchors.right: data_preview_btn.left
            anchors.top: infodataTableHeader.top
            anchors.topMargin: -1
            //            anchors.leftMargin: -5
            //            anchors.rightMargin: -5
            padding: 0
        }

        // "Data Preview" Button Starts

        Rectangle{

            id: data_preview_btn
            width: 100
            anchors.top: infodataTableHeader.top
            anchors.topMargin: 1
            anchors.left: seperator1.right
            //             anchors.leftMargin: -5
            height: 22

            Button{
                id: dataPreviewBtn
                height: 27
                width: 100
                leftPadding: 10

                Text{
                    text: Messages.mo_sub_inft_dataPreview
                    anchors.centerIn: parent
                }

                background: Rectangle{
                    id: dataPreviewBtnBackground
                    color: dataPreviewBtn.hovered ? Constants.themeColor : Constants.whiteColor
                }

                onClicked: {

                    onDataPreviewClicked()

                }

                ToolTip.delay: Constants.tooltipShowTime
                ToolTip.timeout: Constants.tooltipHideTime
                ToolTip.visible: hovered
                ToolTip.text: qsTr("SQL result data preview")


            }


        }

        // "Data Preview" Button Ends

        ToolSeparator{
            id: seperator2
            height:30
            anchors.left:data_preview_btn.right
            anchors.top: infodataTableHeader.top
            anchors.topMargin: -1
            padding: 0
        }


        // "Display Limit" Button Starts

        Rectangle{

            id: display_limited_btn
            width: 160

            anchors.top: infodataTableHeader.top
            anchors.topMargin: 1
            anchors.left: seperator2.right
            height: 22

            Button{
                id: displayLimitBtn
                height: 27
                width: parent.width

                Text{
                    id : displayLimit
                    text: Messages.mo_sub_inft_displayLimitText + "100"
                    anchors.centerIn: parent
                }

                background: Rectangle{
                    id: displayLimitBtnBackground
                    color: displayLimitBtn.hovered ? Constants.themeColor : Constants.whiteColor
                }

                onClicked: {
                    openDisplayLimitMenu()
                }

                ToolTip.delay: Constants.tooltipShowTime
                ToolTip.timeout: Constants.tooltipHideTime
                ToolTip.visible: hovered
                ToolTip.text: Messages.mo_sub_inft_queryLimit

            }


            // "Limit menu" List Model starts

            ListModel{
                id:selectLimitList
                ListElement{
                    value : 100
                    menuItem: "Display top 100" // Cannot replace with variable
                }
                ListElement{
                    value : 200
                    menuItem: "Display top 200" // Cannot replace with variable
                }
            }

            // "Limit menu" List Model Ends

            // "Menu Dropdown" Starts

            Menu {
                id:selectLimitOptions
                y: 27
                z:1
                width: parent.width
                height: selectLimitList.count * 30

                ListView{
                    id:listView

                    height: selectLimitList.count * 30
                    width: parent.width
                    z:2

                    model:selectLimitList

                    delegate: MenuItem{
                        text: menuItem
                        height: 30
                        width: parent.width
                        onTriggered: {}
                        onClicked: {
                            onDisplayLimitSelected(value)
                        }
                    }
                }
            }

            // "Menu Dropdown" Ends


        }

        // "Display Limit" Button Ends

        ToolSeparator{
            id: seperator3
            height:30
            anchors.left:display_limited_btn.right
            anchors.top: infodataTableHeader.top
            anchors.topMargin: -1
            anchors.leftMargin: -5
            anchors.rightMargin: -5
        }

        // "Play" Button Starts

        Rectangle{

            id: play_btn_rect
            width: 160
            height: parent.height
            anchors.top: infodataTableHeader.top
            anchors.topMargin: 1
            anchors.left: seperator3.right
            anchors.leftMargin: -6

            Button{
                id: playBtn
                height: 27
                width: 27

                Image {
                    id: playBtnImage
                    height: 24
                    width: 24
                    source: "/Images/icons/play.png"
                    anchors.centerIn: parent
                }

                background: Rectangle{
                    color: Constants.grafieksLightGreenColor
                    opacity: playBtn.hovered ? 0.42 : 1
                }

                onClicked:onRunQueryClicked()

                ToolTip.delay: Constants.tooltipShowTime
                ToolTip.timeout: Constants.tooltipHideTime
                ToolTip.visible: hovered
                ToolTip.text: Messages.mo_sub_inft_runsql

            }

        }

        // "Play" Button Ends

        HorizontalLineTpl{
            id: linebar2
            line_color:Constants.darkThemeColor
            line_width: parent.width
            anchors.top: parent.bottom
        }

        // "Hide-Show-Panel" Button Starts

        Rectangle{
            id:collapseBtnRow
            anchors.top: infodataTableHeader.top
            anchors.topMargin: 1
            height: 26

            x: parent.width - (column_querymodeller.width+100)

            Button{
                id: collapseBtn
                height: parent.height
                width: parent.height

                Image {
                    id: collapseBtnImage
                    height: 12
                    width: 12
                    source: "/Images/icons/Down.png"
                    anchors.centerIn: parent
                }

                background: Rectangle{
                    color: collapseBtn.hovered ? Constants.themeColor : Constants.whiteColor
                }

                onClicked:{
                    onCollapseInfoTable()
                }

                ToolTip.delay: Constants.tooltipShowTime
                ToolTip.timeout: Constants.tooltipHideTime
                ToolTip.visible: hovered
                ToolTip.text: Messages.mo_sub_inft_minimize


            }


        }

        // "Hide-Show-Panel" Button Ends


    }

    // Result starts

    Rectangle{

        id:queryResultsTable
        height: queryModellerPage.height - submenu.height - dataQueryModellerStackview.height  - infodataTableHeader.height - 16
        anchors.top: infodataTableHeader.bottom
        anchors.topMargin: 1
        anchors.rightMargin: column_querymodeller.width + 50
        width: parent.width - column_querymodeller.width - 50




        // "Test Query Results" - Status of query section -> Execution Time starts

        TestQueryResultsTable{
            id: testQueryResult
            anchors.top: top.parent
            anchors.topMargin: 0

        }

        // "Test Query Results" Ends

        // "Data Priview" Table Starts

        DataPreviewTable{
            id: dataPreviewResult
            anchors.top: top.parent
            anchors.topMargin: -1
        }




        // "Data Priview" Table Ends

    }



    // Result Ends



    // Page Design Ends
    /***********************************************************************************************************************/



}


