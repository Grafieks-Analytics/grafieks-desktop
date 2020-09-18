import QtQuick 2.15
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0

Item {

    id: joinBoxItem
    property var objectName

    objectName: objectName

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
        DSParamsModel.setJoinIcon("/Images/icons/inner_join_32.png")
    }

    function onIconClicked(){

        // Set joinId. Required to get value from Map() in the parent component
        DSParamsModel.setJoinId(parseInt(objectName))

        joinPopup.visible = true
    }

    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts

    // SubComponents Ends
    /***********************************************************************************************************************/


    Rectangle{
        id: joinBoxRectangle
        width:35
        height:35
        color: "transparent"

        Image{
            id: iconId
            source: DSParamsModel.joinIcon
        }

        MouseArea{
            anchors.fill: parent
            onClicked: onIconClicked()

        }
    }

}
