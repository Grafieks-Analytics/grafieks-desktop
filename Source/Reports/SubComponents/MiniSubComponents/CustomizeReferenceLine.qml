import QtQuick 2.15
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents"

Column{

    property int leftMargin: 15

    property int spacingColorList: 5
    property int colorBoxHeight: 20
    property int colorListTopMargin: 5
    property int editImageSize: 16

    spacing: 4

    /***********************************************************************************************************************/
    // LIST MODEL STARTS


    ListModel{
        id: colorListModel
        ListElement{
            textValue: "Quantity"
        }
        ListElement{
            textValue: "Quantity 1"
        }
        ListElement{
            textValue: "Quantity 2"
        }
    }

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


    Rectangle {
        id: colorByComponent
        height: allParameter.height
        width: 150

        Rectangle{

            id: allParameter

            height: 20
            width: parent.width

            Rectangle{
                anchors.fill: parent

                Text {
                    text: qsTr("Add Reference Line")
                    anchors.left: parent.left
                    anchors.leftMargin: leftMargin
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: Constants.fontCategoryHeaderSmall
                }


            }

        }

    }


}
