import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0


import "../../MainSubComponents"
import "../SubComponents"

Item{

    id: infodata_table
    anchors.top: data_query_modeller_stackview.bottom
    anchors.left: left_menubar.right
    width: parent.width
    visible: true
    height: infodataTableHeader.height + queryResultsTable.height

    property bool profilingStatus: false

    Component.onCompleted: {
        // Set default value of displayLimit
        // of query results to 100
        DSParamsModel.setDisplayRowsCount(100)
    }



    Rectangle{
        id: infodataTableHeader
        height: 27
        width: parent.width
        visible: true

        HorizontalLineTpl{
            id: linebar1
            line_color: Constants.darkThemeColor
            line_width: parent.width
            anchors.top: infodataTableHeader.top
        }

        // "Test Query" Button Starts

        Rectangle{

            id: toolbar_querymodeller

            width: 100
            anchors.top: linebar1.bottom
            anchors.left: parent.left
            height: 22

            Button{
                id: testQueryBtn
                height: 27
                width: 100
                leftPadding: 10
                topPadding: 8

                Text{
                    text: "Test Query"
                    anchors.centerIn: parent
                }

                background: Rectangle{
                    id: testQueryBtnBackground
                    color: testQueryBtn.hovered ? Constants.themeColor : Constants.whiteColor
                }

                onClicked: {

                    testQueryBtnBackground.color = Constants.themeColor
                    displayLimitBtnBackground.color = displayLimitBtn.hovered ? Constants.themeColor : Constants.whiteColor
                    dataPreviewBtnBackground.color = dataPreviewBtn.hovered ? Constants.themeColor : Constants.whiteColor

                    testQueryResult.visible = true
                    dataPreviewResult.visible = false


                }
            }


        }

        // "Test Query" Button Ends

        ToolSeparator{
            id: seperator1
            height:30
            anchors.left:toolbar_querymodeller.right
            anchors.top: linebar1.top
            padding: 0
        }

        // "Data Preview" Button Starts

        Rectangle{

            id: data_preview_btn
            width: 100
            anchors.top: linebar1.bottom
            anchors.left: seperator1.right
            height: 22

            Button{
                id: dataPreviewBtn
                height: 27
                width: 100
                leftPadding: 10
                topPadding: 8

                Text{
                    text: "Data Preview"
                    anchors.centerIn: parent
                }

                background: Rectangle{
                    id: dataPreviewBtnBackground
                    color: dataPreviewBtn.hovered ? Constants.themeColor : Constants.whiteColor
                }

                onClicked: {

                    testQueryBtnBackground.color = testQueryBtn.hovered ? Constants.themeColor : Constants.whiteColor
                    dataPreviewBtnBackground.color = Constants.themeColor
                    displayLimitBtnBackground.color = displayLimitBtn.hovered ? Constants.themeColor : Constants.whiteColor

                    testQueryResult.visible = false
                    dataPreviewResult.visible = true

                }


            }


        }

        // "Data Preview" Button Ends

        ToolSeparator{
            id: seperator2
            height:30
            anchors.left:data_preview_btn.right
            anchors.top: linebar1.top
            padding: 0
        }


        // "Display Limit" Button Starts

        Rectangle{

            id: display_limited_btn
            width: 160
            anchors.top: linebar1.bottom
            anchors.left: seperator2.right
            height: 22

            Button{
                id: displayLimitBtn
                height: 27
                width: 160
                leftPadding: 10
                topPadding: 8

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

                    testQueryBtnBackground.color = testQueryBtn.hovered ? Constants.themeColor : Constants.whiteColor
                    dataPreviewBtnBackground.color = dataPreviewBtn.hovered ? Constants.themeColor : Constants.whiteColor

                    selectLimitOptions.open()
                }

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

                            // Change display limit of query results here

                            displayLimit.text = "Display limited to top "+ value
                            DSParamsModel.setDisplayRowsCount(value)
                            selectLimitOptions.close()
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
            anchors.top: linebar1.top
            padding: 0
        }

        // "Play" Button Starts

        Rectangle{

            id: play_btn_rect
            width: 160
            anchors.top: linebar1.bottom
            anchors.left: seperator3.right
            height: 22

            Button{
                id: playBtn
                height: 27
                width: 27
                topPadding: 8

                Image {
                    id: playBtnImage
                    height: 24
                    width: 24
                    source: "../../../Images/icons/play.png"
                    anchors.centerIn: parent
                }

                background: Rectangle{
                    color: playBtn.hovered ? "#009B8F" : "#0dd1c2"
                    opacity: 0.42
                }

                onClicked:{
                    testQueryBtn.visible = true

                    // Set profiling on when clicking the play button
                    // Reset profiling and turn off when clicked on Publish button

                    if(QueryStatsModel.profileStatus === false){
                        QueryStatsModel.setProfiling(true)
                        QueryStatsModel.setProfileStatus(true)
                    }

                    QueryModel.callSql()
                    QueryStatsModel.showStats()
                    TableSchemaModel.showSchema(QueryModel.tmpSql)
                }

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
            anchors.top: linebar1.bottom
            height: 26

            x: parent.width - 278

            Button{
                id: collapseBtn
                height: parent.height
                width: parent.height
                topPadding: 8

                Image {
                    id: collapseBtnImage
                    height: 12
                    width: 12
                    source: "../../../Images/icons/Down.png"
                    anchors.centerIn: parent
                }

                background: Rectangle{
                    color: collapseBtn.hovered ? Constants.themeColor : Constants.whiteColor
                }

                onClicked:{
                    if(open){

                        collapseBtnImage.source = "../../../Images/icons/Up.png"

                        queryResultsTable.height = 0
                        queryResultsTable.visible = false

                        infodata_table.height = Qt.binding(function(){
                            return infodataTableHeader.height + queryResultsTable.height
                        })
                        data_query_modeller_stackview.height = Qt.binding(function(){

                            return query_modeller_page.height - infodata_table.height - 66
                        })

                        open = false
                    }else{

                        collapseBtnImage.source = "../../../Images/icons/Down.png"

                        queryResultsTable.visible = true
                        queryResultsTable.height = 270

                        infodata_table.height = Qt.binding(function(){
                            return infodataTableHeader.height + queryResultsTable.height
                        })
                        data_query_modeller_stackview.height = Qt.binding(function(){

                            return query_modeller_page.height - infodata_table.height
                        })
                        open = true
                    }
                }


            }


        }

        // "Hide-Show-Panel" Button Ends


    }

    // Result starts

    Rectangle{

        id:queryResultsTable
        height: 208
        anchors.top: infodataTableHeader.bottom
        anchors.topMargin: 2
        anchors.rightMargin: column_querymodeller.width + 50
        width: parent.width - column_querymodeller.width - 50

        // "Test Query Results" - Status of query section -> Execution Time starts

        TestQueryResultsTable{
            id: testQueryResult
        }

        // "Test Query Results" Ends

        // "Data Priview" Table Starts

        DataPreviewTable{
            id: dataPreviewResult
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

}
