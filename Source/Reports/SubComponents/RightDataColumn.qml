import QtQuick 2.0

import QtQuick 2.15
import com.grafieks.singleton.constants 1.0

import "./MiniSubComponents";

Column{
    anchors.fill: parent
    anchors.left: parent.left
    anchors.leftMargin: 10
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


    Rectangle{
        height: parent.height/3 - 5
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

    Rectangle{
        height: parent.height/3 - 5
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

    Rectangle{
        height: parent.height/3 - 5
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
