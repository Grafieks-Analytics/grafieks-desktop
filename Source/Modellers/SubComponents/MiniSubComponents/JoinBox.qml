import QtQuick 2.15
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0

Item {

    id: joinBoxItem
    property var objectName

    objectName: objectName // refObjectId from parent

    /***********************************************************************************************************************/
    // LIST MODEL STARTS

    // LIST MODEL ENDS
    /***********************************************************************************************************************/


    /***********************************************************************************************************************/
    // SIGNALS STARTS

    signal destroyJoin(int refObjectId, string depth)

    // SIGNALS ENDS
    /***********************************************************************************************************************/



    /***********************************************************************************************************************/
    // Connections Starts


    Connections{
        target: DSParamsModel

        function onJoinIconMapChanged(joinIconData){

            let refObjId = joinIconData[0]
            let newIcon = joinIconData[1]

            changeJoinIcon(refObjId, newIcon);
        }
    }

    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    Component.onCompleted: {
        DSParamsModel.addToJoinIconMap(parseInt(joinBoxItem.objectName), "/Images/icons/inner_join_32.png")
        DSParamsModel.addToJoinTypeMap(parseInt(joinBoxItem.objectName), Constants.innerJoin)
    }

    function onJoinIconClicked(){

        // Set joinId. Required to get value from Map() in the parent component
        DSParamsModel.setJoinId(parseInt(joinBoxItem.objectName))

        joinPopup.visible = true
    }

    function onDeleteIconClicked(){

        destroyJoin(parseInt(joinBoxItem.objectName), "single")
    }


    function changeJoinIcon(refObjId, newIcon){

        if(refObjId === parseInt(objectName))
            joinIconId.source = newIcon
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
            id: joinIconId
            source: "/Images/icons/inner_join_32.png"
        }

        MouseArea{
            anchors.fill: parent
            onClicked: onJoinIconClicked()

        }
    }

    Rectangle{
        id: deleteJoinRectangle
        anchors.verticalCenter: joinBoxRectangle.verticalCenter
        anchors.left: joinBoxRectangle.right
        width:35
        height:35
        color: "transparent"

        Image{
            id: deleteIconId
            source: "/Images/icons/remove.png"
        }

        MouseArea{
            anchors.fill: parent
            onClicked: onDeleteIconClicked()

        }
    }

}
