/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Dashboard/Subcomponents
** Dashboard Summary
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0


Rectangle {

    id: dashboardArea

    height: parent.height
    width: parent.width

    property var rectangles: new Map() // rectangle object

    property var dynamicContainer : Qt.createComponent("./MiniSubComponents/MainContainer.qml");

    property var dynamicText : Qt.createComponent("./MiniSubComponents/DroppedText.qml");
    property var dynamicImageBox : Qt.createComponent("./MiniSubComponents/DroppedImage.qml");

    property int counter: 1

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

    function onDropAreaEntered(drag){

        dashboardArea.color = Constants.dropHighlightColor
        var currentPoint = {x: drag.x, y: drag.y};
        console.log("Entered", currentPoint.x, listViewElem.itemName)
    }

    function onDropAreaDropped(drag){
        var currentPoint = {x: drag.x, y: drag.y};

        dashboardArea.color = "transparent"

        console.log(listViewElem.itemName.toLowerCase(),'Dropped Item');
        DashboardParamsModel.setLastContainerType(listViewElem.itemName.toLowerCase());
        DashboardParamsModel.setPositionX(drag.x);
        DashboardParamsModel.setPositionY(drag.y);

        var draggedItem = listViewElem.itemName.toLocaleLowerCase();

        console.log(draggedItem);
        rectangles.set(counter,dynamicContainer.createObject(parent,{x:drag.x, y: drag.y, z: DashboardParamsModel.zIndex,  objectName : counter}))
        counter++;
    }

    function onDropAreaPositionChanged(drag){
//        console.log(drag);
    }
    function onDropAreaExited(){
//        console.log('Exit');
    }


    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts

    Component.onCompleted: {
        DashboardParamsModel.setZIndex(1);
    }

    DropArea {
        id: dropArea
        anchors.fill: parent
        onEntered: onDropAreaEntered(drag)
        onExited: onDropAreaExited()
        onPositionChanged: onDropAreaPositionChanged(drag)
        onDropped: onDropAreaDropped(drag)
    }



    // Page Design Ends
    /***********************************************************************************************************************/

}
