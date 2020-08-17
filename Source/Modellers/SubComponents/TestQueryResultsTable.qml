import QtQuick 2.15
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents"

TableView {
    id: dataPreviewResult
    model: QueryStatsModel
    columnWidthProvider: function (column) { return 200; }
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



    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts



    delegate:

        Row{


        Loader{
            active: model.column === 0
            sourceComponent:
                Rectangle{
                id: rect
                width: 30
                height: 30

                Image{
                    source: "../../../Images/icons/tick.png"
                    height: 18
                    width: 18
                }
            }

        }



        Text {
            text: modelData
        }
    }




    Rectangle { // mask the headers
        z: 3
        color: "#222222"
        y: dataPreviewResult.contentY
        x: dataPreviewResult.contentX
        width: dataPreviewResult.leftMargin
        height: dataPreviewResult.topMargin
    }

    // Table Header Starts

    Row {
        id: columnsHeader
        y: testQueryResult.contentY
        z: 3
        width: testQueryResult.width

        Label {
            id: imageStatus
            width: 30
            height: 30
            text: "#"
            color: 'black'
            verticalAlignment: Text.AlignVCenter
            background: Rectangle{
                color: 'white'
            }

        }

        Label {
            id: numberCoulmn
            width: 200
            height: 30
            text: "#"
            color: 'black'
            verticalAlignment: Text.AlignVCenter
            background: Rectangle{
                color: 'white'
            }

        }
        Label {
            id: actionCoulmn
            width: 200
            height: 30
            text: "Duration"
            color: 'black'
            verticalAlignment: Text.AlignVCenter
            background: Rectangle{
                color: Constants.whiteColor
            }

        }
        Label {

            id: messageColumn
            width: 200
            height: 30
            text: "Query"
            color: 'black'
            verticalAlignment: Text.AlignVCenter
            background: Rectangle{
                color: 'white'
            }

        }


    }
    // Table Header Ends

    ScrollIndicator.horizontal: CustomScrollHorizontalIndicator  {}
    ScrollIndicator.vertical: CustomScrollVerticalIndicator {}


    // Page Design Ends
    /***********************************************************************************************************************/


}

