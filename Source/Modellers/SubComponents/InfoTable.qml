import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.3

import com.grafieks.singleton.constants 1.0


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
        dataPreviewBtnBackground.color = dataPreviewBtn.hovered ? Constants.themeColor : Constants.whiteColor

        testQueryResult.visible = true
        dataPreviewResult.visible = false
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
        dataPreviewBtnBackground.color = dataPreviewBtn.hovered ? Constants.themeColor : Constants.whiteColor

        selectLimitOptions.open()
    }


    function onDisplayLimitSelected(value){
        // Change display limit of query results here
        displayLimit.text = "Display limited to top "+ value
        DSParamsModel.setDisplayRowsCount(value)
        selectLimitOptions.close()
    }

    function onRunQueryClicked(){

        testQueryBtn.visible = true


        // If current tab is queryModeller, then process
        // else if current tab is dataModeller, fire a signal to activate a slot in DataModeller.qml

        if(DSParamsModel.currentTab === Constants.queryModellerTab){
            var isSqlSelect = DSParamsModel.tmpSql.toUpperCase().startsWith("SELECT");
            // If query is SELECT query
            // Only SELECT query allowed

            console.log(GeneralParamsModel.getDbClassification(), "DB TYPE")

            if(isSqlSelect){
                if(GeneralParamsModel.getDbClassification() === Constants.sqlType){

                    queryUpdate.visible = true

                    // Set profiling on when clicking the play button
                    // Reset profiling and turn off when clicked on Publish button

                    if(QueryStatsModel.profileStatus === false){
                        QueryStatsModel.setProfiling(true)
                        QueryStatsModel.setProfileStatus(true)
                    }

                    QueryModel.callSql(DSParamsModel.tmpSql)
                    QueryStatsModel.showStats()
                    //TableSchemaModel.showSchema(DSParamsModel.tmpSql)

                } else if(GeneralParamsModel.getDbClassification() === Constants.duckType){
                    DuckQueryModel.setQuery(DSParamsModel.tmpSql)

                    testQueryResult.visible = true
                    dataPreviewResult.visible = false
                } else {
                    console.log("FORWARD ONLY", DSParamsModel.tmpSql)
                    ForwardOnlyQueryModel.setQuery(DSParamsModel.tmpSql)

                    testQueryResult.visible = true
                    dataPreviewResult.visible = false
                }
            } else{
                sqlQueryNotAllowedDialog.visible = true
            }
        } else{

            // Run the signal to activate the slot
            DSParamsModel.processDataModellerQuery()
        }
    }

    function onCollapseInfoTable(){
        if(open){

            collapseBtnImage.source = "/Images/icons/Up.png"
            queryResultsTable.visible = false

            dataQueryModellerStackview.height = Qt.binding(function(){
                return queryModellerPage.height - 95
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

    function onGetErrorMsg(){

        var message = QueryStatsModel.showErrorMessage(DSParamsModel.tmpSql);
        if(message === ""){
            message = "SQL query succesfully executed"
            queryUpdate.icon = StandardIcon.NoIcon
            return message
        }
        queryUpdate.icon = StandardIcon.Critical
        return message;
    }

    //JAVASCRIPT FUNCTIONS ENDS
    /***********************************************************************************************************************/


    /***********************************************************************************************************************/
    // SubComponents Starts



    // IF the sql query is not "SELECT query"
    // Show this popup

    MessageDialog{
        id: sqlQueryNotAllowedDialog
        title: "Warning"
        text: "Only SELECT (without Common Table Expressions) query allowed"
        //icon: StandardIcon.Critical

        onAccepted: {
            sqlQueryNotAllowedDialog.close()
        }
    }


    MessageDialog{
        id: queryUpdate
        visible: false
        title: "Message"
        text: onGetErrorMsg()
        icon: StandardIcon.Critical

        onAccepted: {
            onTestQueryClicked()
        }

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

            width: 100
            anchors.top: infodataTableHeader.top
            anchors.topMargin: 1
            anchors.left: parent.left
            height: parent.height


            Button{
                id: testQueryBtn
                height: 27
                width: 100
                //                leftPadding: 10

                Text{
                    text: "Action Output"
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
                ToolTip.text: qsTr("SQL query performance result")
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
                    text: "Data Preview"
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
                    text: "Display limited to top 100"
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
                ToolTip.text: qsTr("Limit SQL result data preview")

            }


            // "Limit menu" List Model starts

            ListModel{
                id:selectLimitList
                ListElement{
                    value : 100
                    menuItem: "Display Top 100"
                }
                ListElement{
                    value : 200
                    menuItem: "Display Top 200"
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
                ToolTip.text: qsTr("Run SQL")

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

            x: parent.width - 278

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
                ToolTip.text: qsTr("Minimize panel")


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


    ScrollBar {
        id: vbar
        hoverEnabled: true
        active: hovered || pressed
        orientation: Qt.Vertical
        size: parent.height / 2
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }

    ScrollBar {
        id: hbar
        hoverEnabled: true
        active: hovered || pressed
        orientation: Qt.Horizontal
        size: parent.width / 2
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }

    // Result Ends



    // Page Design Ends
    /***********************************************************************************************************************/



}


