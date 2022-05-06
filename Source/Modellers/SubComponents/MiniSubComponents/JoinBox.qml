import QtQuick 2.15
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0
import com.grafieks.singleton.messages 1.0

Item {

    id: joinBoxItem
    property var objectName
    property var hoverCrossIcon: false

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
        joinPopup.visible = false
    }


    function changeJoinIcon(refObjId, newIcon){

        if(refObjId === parseInt(objectName))
            joinIconId.source = newIcon
    }


    function showCrossIcon(){

        hoverCrossIcon = true


    }
    function hideCrossIcon(){

        hoverCrossIcon = false

    }

    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts

    // SubComponents Ends
    /***********************************************************************************************************************/
    Rectangle{
        height: Constants.joinBoxHeight * 2
        width: Constants.joinBoxWidth * 2
        color: "transparent"
        radius: Constants.joinBoxRadius * 2
        scale: Constants.scaleTable

        MouseArea{
            id: mouseAreaBox1
            anchors.fill: parent
            onClicked: onJoinIconClicked()
            hoverEnabled: true
            onEntered: showCrossIcon();
            onExited: hideCrossIcon();
            //            onDoubleClicked: showCrossIcon();


        }

        ToolTip.delay: Constants.tooltipShowTime
        ToolTip.timeout: Constants.tooltipHideTime
        ToolTip.text: Messages.mo_mini_jbox_joinType
        ToolTip.visible: mouseAreaBox1.containsMouse ? true: false



        Rectangle{
            id: joinBoxRectangle
            width:33
            height:33
            color: "white"
            radius: 50
            border.color: Constants.buttonBorderColor
            border.width: 0.5
            smooth: true
            antialiasing: true
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter




            Image{
                id: joinIconId
                source: "/Images/icons/inner_join_32.png"
                anchors.fill: parent
                anchors.top:top.parent
                anchors.topMargin: 3
                anchors.bottom: bottom.parent
                anchors.bottomMargin: 3
                anchors.left: left.parent
                anchors.leftMargin: 3
                anchors.right: right.parent
                anchors.rightMargin: 3


            }

            //        MouseArea{
            //            id: mouseAreaBox
            //            anchors.fill: parent
            //            onClicked: onJoinIconClicked()
            //            hoverEnabled: true
            ////            onEntered: showCrossIcon();
            ////            onExited: hideCrossIcon();
            ////            onDoubleClicked: showCrossIcon();


            //        }




        }

    }
    Rectangle{
        id: deleteJoinRectangle
        anchors.left: joinBoxRectangle.right
        x:35
        width:5
        height:5
        visible: hoverCrossIcon


        Image{
            id: deleteIconId
            source: "/Images/icons/remove.png"
            MouseArea{
                id: mouseAreaDelete
                anchors.fill: parent
                onClicked: onDeleteIconClicked()
                hoverEnabled: true
                onEntered: showCrossIcon();
                //                onExited: hideCrossIcon();

            }

        }


        ToolTip.delay: Constants.tooltipShowTime
        ToolTip.timeout: Constants.tooltipHideTime
        ToolTip.text: Messages.mo_mini_jbox_deleteJoin
        ToolTip.visible: mouseAreaDelete.containsMouse ? true: false

    }

}
