import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents"

TableView {
    id: testQueryResultTable
//    model: QueryStatsModel
    property var columnWidths: [ 80, 200, (columnsHeader.width -imageStatus.width - numberCoulmn.width - durationColumn.width)/2, (columnsHeader.width -imageStatus.width - numberCoulmn.width - durationColumn.width)/2]
    columnWidthProvider: function (column) {
        console.log("#"+columnWidths[column])
        return columnWidths[column]
    }
    rowHeightProvider: function (column) { return 30; }
    height:parent.height
    width: parent.width
    visible: false
    clip:true
    columnSpacing: 1

    boundsBehavior : Flickable.StopAtBounds
    anchors.fill: parent

    ScrollBar.horizontal: ScrollBar{}
    ScrollBar.vertical: ScrollBar{}

    topMargin: columnsHeader.implicitHeight-4






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
    // JAVASCRIPT FUNCTION STARTS



    function onDragColumnHeadPanel(mouse){


        columnWidths = Qt.binding(function(){
            return ([(80+ parseInt(mouse.x)),200, (columnsHeader.width -imageStatus.width - numberCoulmn.width - durationColumn.width)/2, (columnsHeader.width -imageStatus.width - numberCoulmn.width - durationColumn.width)/2])
        })
        testQueryResultTable.columnWidthProvider= function (column) {
            return columnWidths[column]
        }

    }
    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts



    delegate:Rectangle{

        border.color: Constants.darkThemeColor
        border.width: 0.5

        Text {
            text: modelData
            elide: Text.ElideRight
            color: Constants.lightGrayTextColor
            anchors.left: parent.left
            anchors.leftMargin:  modelData === 1? 40: 10
            anchors.verticalCenter:  parent.verticalCenter
        }
    }


    Rectangle { // mask the headers
        z: 3
        color: "#222222"
        y: testQueryResultTable.contentY
        x: testQueryResultTable.contentX
        width: testQueryResultTable.leftMargin
        height: testQueryResultTable.topMargin
    }

    // Table Header Starts

    Row {
        id: columnsHeader
        y: testQueryResult.contentY
        z: 3
        width: testQueryResult.width



        Label {
            id: imageStatus
            width:  29
            height: 30
            verticalAlignment: Text.AlignVCenter
            background: Rectangle{
                color: Constants.lightThemeColor
            }
            color: Constants.blackColor
            font.bold: false


        }
        ToolSeparator{
            id: seperator1
            height:34
            anchors.top: columnsHeader.top
            anchors.topMargin: -2
            padding: 0

            MouseArea{
                id: infoPanelDragMouseArea
                anchors.fill: parent
                cursorShape: Qt.SizeHorCursor
                width: parent.width
                onPositionChanged: {
                    onDragColumnHeadPanel(mouse)
                }

            }
        }



        Label {
            id: numberCoulmn
            width: columnWidths[0]-30
            height: 30
            text: "#"
            verticalAlignment: Text.AlignVCenter
            background: Rectangle{
                color: Constants.lightThemeColor
            }
            color: Constants.blackColor
            leftPadding: 10
            font.bold: false


        }
        ToolSeparator{
            id: seperator2
            height:34
            anchors.top: columnsHeader.top
            anchors.topMargin: -2
            padding: 0
            MouseArea{
                id: infoPanelDragMouseArea2
                anchors.fill: parent
                cursorShape: Qt.SizeHorCursor
                width: parent.width

                onPositionChanged: {
                    onDragColumnHeadPanel(mouse)
                }
            }
        }


        Label {

            id: durationColumn
            width: columnWidths[1]
            height: 30
            text: "Duration"

            verticalAlignment: Text.AlignVCenter
            background: Rectangle{
                color: Constants.lightThemeColor
            }
            color: Constants.blackColor
            leftPadding: 10
            font.bold: false

        }
        ToolSeparator{
            id: seperator3
            height:34
            anchors.top: columnsHeader.top
            anchors.topMargin: -2
            padding: 0
        }

        Label {
            id: actionCoulmn
            width: columnWidths[2]
            height: 30
            text: "Action"

            verticalAlignment: Text.AlignVCenter
            background: Rectangle{
                color: Constants.lightThemeColor

            }
            color: Constants.blackColor
            leftPadding: 10
            font.bold: false

        }

        ToolSeparator{
            id: seperator4
            height:34
            anchors.top: columnsHeader.top
            anchors.topMargin: -2
            padding: 0
        }

        Label {

            id: messageColumn
            width: columnWidths[3]
            height: 30
            text: "Message"

            verticalAlignment: Text.AlignVCenter
            background: Rectangle{
                color: Constants.lightThemeColor
            }
            color: Constants.blackColor
            leftPadding: 10
            font.bold: false

        }



    }
    // Table Header Ends


    Layout.fillWidth: true
    Layout.fillHeight: true


    ScrollIndicator.vertical: CustomScrollVerticalIndicator {}


    // Page Design Ends
    /***********************************************************************************************************************/


}

