import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents"

// Data Preview - Table View From Query Results

TableView {
    id: dataPreviewResult

    columnWidthProvider: function (column) { return 100; }
    rowHeightProvider: function (column) { if(column < DSParamsModel.displayRowsCount) {return 30;} else {return 0;} }
    anchors.fill: parent
    topMargin: columnsHeader1.implicitHeight
    width: parent.width
//    model: QueryModel
//    model: DuckQueryModel
    model: QtTest2
//    model: GeneralParamsModel.getDbClassification() === Constants.sqlType? QueryModel: DuckQueryModel
    ScrollBar.horizontal: ScrollBar{}
    ScrollBar.vertical: ScrollBar{}
    clip: true
    boundsBehavior : Flickable.StopAtBounds


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


    delegate: Rectangle {
        border.color: Constants.darkThemeColor
        border.width: 0.5
        Text {
            text: display
            anchors.fill: parent
            anchors.margins: 10
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            color: Constants.lightGrayTextColor
        }
    }
    Rectangle { // mask the headers
        z: 3
        y: dataPreviewResult.contentY
        x: dataPreviewResult.contentX
        width: dataPreviewResult.leftMargin
        height: dataPreviewResult.topMargin
        border.color: Constants.themeColor
        border.width: 0.2
    }

    // Table Header Starts

    Row {
        id: columnsHeader1
        y: dataPreviewResult.contentY
        z: 2
        width: dataPreviewResult.width

        Repeater {
            model: dataPreviewResult.columns > 0 ? dataPreviewResult.columns : 0
            Rectangle{
                width: dataPreviewResult.columnWidthProvider(modelData)
                height: 30
                border.color: Constants.darkThemeColor
                color: Constants.lightThemeColor
                border.width: 1
                Text {
                    id: name
                    text: QtTest2.headerData(modelData, Qt.Horizontal)
                    width: parent.width
                    height: parent.height
                    anchors.centerIn: parent
                    padding: 10
                    font.bold: false
                    verticalAlignment: Text.AlignVCenter
                }

            }
        }
    }

    Layout.fillWidth: true
    Layout.fillHeight: true


    // Table Header Ends

    ScrollIndicator.horizontal: CustomScrollHorizontalIndicator  {}
    ScrollIndicator.vertical: CustomScrollVerticalIndicator {}


    // Page Design Ends
    /***********************************************************************************************************************/

}
