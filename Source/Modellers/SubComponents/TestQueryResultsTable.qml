import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents"

TableView {
    id: testQueryResultTable
    model: QueryStatsModel
    columnWidthProvider: function (column) { return 200; }
    rowHeightProvider: function (column) { return 30; }
    height:parent.height
    width: parent.width
    visible: false
    clip:true
    boundsBehavior : Flickable.StopAtBounds

    anchors.fill: parent

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

        Rectangle{
        border.color: Constants.darkThemeColor
        border.width: 0.5
//        width: 200

        Loader{
            active: model.column === 0
//            width: 30
            sourceComponent:
                Rectangle{
                id: rect
                width: 30
                height: 30

                border.color: Constants.darkThemeColor
                border.width: 0.5

                Image{
                    source: "../../../Images/icons/tick.png"
                    height: 18
                    width: 18
                }
            }

        }

        Text {
            text: modelData
            elide: Text.ElideRight
            color: Constants.lightGrayTextColor
            leftPadding: 10
            anchors.leftMargin: 30
            verticalAlignment: Text.AlignVCenter
            width: model.column === 0 ? columnsHeader.width - (200 * 4) : 200
        }
    }




    Rectangle { // mask the headers
        z: 3
        color: "#222222"
        y: testQueryResultTable.contentY
        x: testQueryResultTable.contentX
        width: testQueryResultTable.leftMargin
        height: testQueryResultTable.topMargin
        border.color: Constants.themeColor
        border.width: 0.2
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
            verticalAlignment: Text.AlignVCenter
            background: Rectangle{
                border.color: Constants.darkThemeColor
            }
            color: Constants.blackColor
            font.bold: true

        }

        Label {
            id: numberCoulmn
            width: 200
            height: 30
            text: "#"
            verticalAlignment: Text.AlignVCenter
            background: Rectangle{
                border.color: Constants.darkThemeColor
            }
            color: Constants.blackColor
            leftPadding: 10
            font.bold: true

        }
        Label {

            id: durationColumn
            width: 200
            height: 30
            text: "Duration"

            verticalAlignment: Text.AlignVCenter
            background: Rectangle{
                border.color: Constants.darkThemeColor
            }
            color: Constants.blackColor
            leftPadding: 10
            font.bold: true

        }

        Label {
            id: actionCoulmn
            width: 200
            height: 30
            text: "Action"

            verticalAlignment: Text.AlignVCenter
            background: Rectangle{
                border.color: Constants.darkThemeColor
            }
            color: Constants.blackColor
            leftPadding: 10
            font.bold: true

        }


        Label {

            id: messageColumn
            width: columnsHeader.width - (200 * 3)
            height: 30
            text: "Message"

            verticalAlignment: Text.AlignVCenter
            background: Rectangle{
                border.color: Constants.darkThemeColor
            }
            color: Constants.blackColor
            leftPadding: 10
            font.bold: true

        }



    }
    // Table Header Ends


    Layout.fillWidth: true
    Layout.fillHeight: true


    ScrollIndicator.horizontal: CustomScrollHorizontalIndicator  {}
    ScrollIndicator.vertical: CustomScrollVerticalIndicator {}


    // Page Design Ends
    /***********************************************************************************************************************/


}

