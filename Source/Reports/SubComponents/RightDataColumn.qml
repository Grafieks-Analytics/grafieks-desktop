import QtQuick 2.15
import QtQuick.Controls 2.15
import com.grafieks.singleton.constants 1.0

import "./MiniSubComponents";

Column{

    property int leftMargin: 10

    anchors.fill: parent
    anchors.left: parent.left
    anchors.leftMargin: leftMargin
    spacing: 15

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

    Component.onCompleted: {

    }

    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/


    Rectangle{
        height: parent.height/5 - 5
        width: parent.width

        Text {
            id: categoricalHeading
            text: qsTr("Categorical")
            font.pixelSize: Constants.fontCategoryHeader
        }

        CategoricalList{
            id: categoricalList
        }

    }

    ToolSeparator{

        orientation: Qt.Horizontal;
        width: parent.width + leftMargin
        height: 1
        x:-leftMargin
        background: Rectangle{
            color: Constants.darkThemeColor
        }
    }

    Rectangle{
        height: parent.height/3 - 6
        width: parent.width

        Text {
            id: dateHeading
            text: qsTr("Date")
            font.pixelSize: Constants.fontCategoryHeader
        }

        DateList{
            id: dateList
        }

    }


    ToolSeparator{
        orientation: Qt.Horizontal;
        width: parent.width + leftMargin
        height: 1
        x:-leftMargin
        background: Rectangle{
            color: Constants.darkThemeColor
        }
    }


    Rectangle{
        height: parent.height/3 - 6
        width: parent.width

        Text {
            id: numericalHeading
            text: qsTr("Numerical")
            font.pixelSize: Constants.fontCategoryHeader
        }

        NumericalList{
            id: numericalList
        }

    }
}
