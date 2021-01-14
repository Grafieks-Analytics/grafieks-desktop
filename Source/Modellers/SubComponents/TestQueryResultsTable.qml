import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents"

TableView {
    id: testQueryResultTable
    model: QueryStatsModel
    property var columnWidths: [ 80, 200, (columnsHeader.width -imageStatus.width - numberCoulmn.width - durationColumn.width)/2, (columnsHeader.width -imageStatus.width - numberCoulmn.width - durationColumn.width)/2]
    columnWidthProvider: function (column) {
        console.log("#"+columnWidths[column])
        return columnWidths[column] }
    rowHeightProvider: function (column) { return 30; }
    height:parent.height
    width: parent.width
    visible: false
    clip:true
    columnSpacing: 1
//    rowSpacing: 1

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


        console.log("mouse x"+ parseInt(mouse.x)) ;
        columnWidths = Qt.binding(function(){
            return ([(80+ parseInt(mouse.x))]) })
        console.log("column width"+  columnWidths[0] ) ;
        testQueryResultTable.columnWidthProvider= function (column) {
            console.log("#"+columnWidths[column])
            return columnWidths[column] }

    }
    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts



    delegate:

        Rectangle{
        border.color: Constants.darkThemeColor
        border.width: 0.5
//        Loader{
//            active: model.column === 0
//            //            width: 30
//            anchors.right: parent.right
//            anchors.rightMargin: 50
//            sourceComponent:
//                Rectangle{
//                id: rect
//                width: 30
//                height: 30
//                border.color: Constants.darkThemeColor
//                border.width: 0.5
//                Image{
//                    source: "/Images/icons/checkmark.png"
//                    height: 18
//                    width: 18
//                    anchors.horizontalCenter: parent.horizontalCenter
//                    anchors.verticalCenter:  parent.verticalCenter
//                }
//            }

//        }

        Text {
            text: modelData
            elide: Text.ElideRight
            color: Constants.lightGrayTextColor
            //            leftPadding: 30


            anchors.left: parent.left
            anchors.leftMargin:  if (modelData===1) {
                                     40
                                 }
                                 else{
                                     10
                                 }

            //            verticalAlignment: Text.AlignVCenter
            //            anchors.horizontalCenter: parent.horizontalCenter
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
        //        border.color: Constants.themeColor
        //        border.width: 0.2
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
                //                border.color: Constants.darkThemeColor
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
                //                border.color: Constants.darkThemeColor
                color: Constants.lightThemeColor

            }
            color: Constants.blackColor
            leftPadding: 10
            font.bold: false


        }
//        ToolSeparator{
//            id: seperator2
//            height:34
//            anchors.top: columnsHeader.top
//            anchors.topMargin: -2
////            width: 20
//            padding: 0
//            MouseArea{
//                id: infoPanelDragMouseArea2
//                anchors.fill: parent
//                cursorShape: Qt.SizeHorCursor
//                width: parent.width

//                onPositionChanged: {

//                    onDragColumnHeadPanel(mouse)

//                }

//            }
//        }
        Rectangle{
            id: seperator2
            height:34
            anchors.top: columnsHeader.top
            anchors.topMargin: -2
            color: "red"
            width: 20

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
                //                border.color: Constants.darkThemeColor
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
//            MouseArea{
//                id: infoPanelDragMouseArea3
//                anchors.fill: parent
//                cursorShape: Qt.SizeHorCursor
//                width: parent.width

//                onPositionChanged: {

//                    onDragColumnHeadPanel(mouse)

//                }

//            }
        }

        Label {
            id: actionCoulmn
            width: columnWidths[2]
            height: 30
            text: "Action"

            verticalAlignment: Text.AlignVCenter
            background: Rectangle{
                //                border.color: Constants.darkThemeColor
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
//            MouseArea{
//                id: infoPanelDragMouseArea4
//                anchors.fill: parent
//                cursorShape: Qt.SizeHorCursor
//                width: parent.width

//                onPositionChanged: {

//                    onDragColumnHeadPanel(mouse)

//                }

//            }
        }

        Label {

            id: messageColumn
            width: columnWidths[3]
            height: 30
            text: "Message"

            verticalAlignment: Text.AlignVCenter
            background: Rectangle{
                //                border.color: Constants.darkThemeColor
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


    //    ScrollIndicator.horizontal: CustomScrollHorizontalIndicator  {}
    ScrollIndicator.vertical: CustomScrollVerticalIndicator {}


    // Page Design Ends
    /***********************************************************************************************************************/


}

