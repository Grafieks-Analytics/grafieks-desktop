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

    Row{
        id: infodataTableHeader
        height: 27
        anchors.top: data_query_modeller_stackview.bottom
        anchors.left: left_menubar.right
        width: parent.width
        visible: true

        HorizontalLineTpl{
            id: linebar1
            line_color: Constants.darkThemeColor
            line_width: parent.width
            anchors.top: infodata_table.top
        }

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
                    displayResult.visible = false

                }
            }


        }

        ToolSeparator{
            id: seperator1
            height:30
            anchors.left:toolbar_querymodeller.right
            anchors.top: linebar1.top
            padding: 0
        }

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
                    displayResult.visible = false

                    QtTest2.callSql()

                }


            }


        }

        ToolSeparator{
            id: seperator2
            height:30
            anchors.left:data_preview_btn.right
            anchors.top: linebar1.top
            padding: 0
        }

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
                    displayLimitBtnBackground.color = Constants.themeColor

                    testQueryResult.visible = false
                    dataPreviewResult.visible = false
                    displayResult.visible = true

                }

            }

        }

        ToolSeparator{
            id: seperator3
            height:30
            anchors.left:display_limited_btn.right
            anchors.top: linebar1.top
            padding: 0
        }

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
//                        QueryModel.callQuery()
                    QtTest2.callSql()
                }

            }

        }

        HorizontalLineTpl{
            id: linebar2
            line_color:Constants.darkThemeColor
            line_width: parent.width
            anchors.top: parent.bottom
        }

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


    }

    // Result starts

    Row{

        id:queryResultsTable
        height: 208
        anchors.top: infodataTableHeader.bottom
        anchors.topMargin: 2
        anchors.rightMargin: column_querymodeller.width + 50
        width: parent.width - column_querymodeller.width - 50

        TableView {
            id: testQueryResult
            model: testQueryModel
            rowHeightProvider: function (column) { return 30; }
            width: parent.width
            visible: false
            columnSpacing: 1
            rowSpacing: 1
            height:parent.height
            boundsBehavior : Flickable.StopAtBounds
            clip:true
            ScrollBar.horizontal: ScrollBar{}
            ScrollBar.vertical: ScrollBar{}
            topMargin: columnsHeader.implicitHeight

            delegate: Row{
                id: resultQueryRow
                height:30
                width: parent.width

                Column{
                    width: 50
                    height: parent.height
                    topPadding: 5

                    Row{
                        height: parent.height
                        width: parent.width
                        anchors.top: parent
                        anchors.topMargin: 3
                        anchors.left: parent.left
                        leftPadding: 20

                        Image {
                            id: statusImg
                            height: 18
                            width: 18
                            source: "../../../Images/icons/tick.png"
                        }

                    }

                }

                Column{
                    width: 50
                    height: parent.height

                    Row{
                        height: parent.height
                        width: parent.width
                        anchors.left: parent
                        anchors.leftMargin: 2

                        Text {
                            text: qsTr(queryNumber)
                            padding: 5
                            leftPadding: 20
                        }
                    }

                }


                Column{
                    width: parent.width * 0.4
                    height: 30

                    Row{
                        height: parent.height
                        width: parent.width
                        anchors.left: parent

                        Text {
                            text: qsTr(action)
                            padding: 5
                            leftPadding: 20
                        }
                    }

                }

                Column{
                    width: parent.width * 0.4
                    height: 30

                    Row{
                        height: parent.height
                        width: parent.width
                        anchors.left: parent

                        Text {
                            text: qsTr(message)
                            padding: 5
                            leftPadding: 20
                        }
                    }
                }

                Column{
                    width: parent.width * 0.1
                    height: 30

                    Row{
                        height: parent.height
                        width: parent.width

                        Text {
                            text: qsTr(duration)
                            padding: 5
                            leftPadding: 20
                        }
                    }
                }

            }

            Rectangle { // mask the headers
                z: 3
                color: "#222222"
                y: testQueryResult.contentY
                x: testQueryResult.contentX
                width: testQueryResult.leftMargin
                height: testQueryResult.topMargin
            }
            Row {
                id: columnsHeader
                y: testQueryResult.contentY
                z: 3
                width: parent.width

                Label {
                    id: statusColumn
                    width: 50
                    height: 30
                    text: ""
                    color: 'black'
                    padding: 10
                    leftPadding: 20
                    verticalAlignment: Text.AlignVCenter
                    background: Rectangle{
                        color: 'white'
                    }
                }
                Label {
                    id: numberCoulmn
                    width: 50
                    height: 30
                    text: "#"
                    color: 'black'
                    padding: 10
                    leftPadding: 20
                    verticalAlignment: Text.AlignVCenter
                    background: Rectangle{
                        color: 'white'
                    }

                }
                Label {
                    id: actionCoulmn
                    width: parent.width * 0.4
                    height: 30
                    text: "Action"
                    color: 'black'
                    padding: 10
                    leftPadding: 20
                    verticalAlignment: Text.AlignVCenter
                    background: Rectangle{
                        color: 'white'
                    }

                }
                Label {

                    id: messageColumn
                    width: parent.width * 0.4
                    height: 30
                    text: "Message"
                    color: 'black'
                    padding: 10
                    leftPadding: 20
                    verticalAlignment: Text.AlignVCenter
                    background: Rectangle{
                        color: 'white'
                    }

                }
                Label {
                    id: durationColumn
                    width: parent.width  - ( statusColumn.width + numberCoulmn.width + actionCoulmn.width + messageColumn.width)
                    height: 30
                    text: "Duration"
                    color: 'black'
                    padding: 10
                    leftPadding: 20
                    verticalAlignment: Text.AlignVCenter
                    background: Rectangle{
                        color: 'white'
                    }

                }

            }

            ScrollIndicator.horizontal: ScrollIndicator { }
            ScrollIndicator.vertical: ScrollIndicator { }

        }

        DataPreviewTable{
            id: dataPreviewResult
        }


        Row{
            id:displayResult
        }

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

    // Result starts

}
