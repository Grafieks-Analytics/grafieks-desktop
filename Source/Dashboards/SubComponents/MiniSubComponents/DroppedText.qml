import QtQuick 2.15
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0

// This is the Text Widget dynamically called from MainContainer
// when a column is dropped from right side customize

Item{

    id: newItem
    visible: true

    anchors{
        top: mainContainer.top
        left: mainContainer.left
        right: mainContainer.right
        bottom: mainContainer.bottom
    }



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



    function showCustomizeReport(){
        customizeReport.visible = true;
    }

    function onItemPressed(){
        DashboardContainerModel.setZIndex(++DashboardContainerModel.zIndex);
        newItem.z = DashboardContainerModel.zIndex;
        mainContainer.z = DashboardContainerModel.zIndex;
    }

    Component.onCompleted: {
        var globalCordinates = this.mapToGlobal(0,0)
        console.log('global x',globalCordinates.x)
        console.log('global y',globalCordinates.y)
    }


    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts


    Rectangle {

        id: droppedRectangle
        color: "white"
        border.width: 1
        border.color: Constants.darkThemeColor
        height: parent.height
        width: parent.width

        MouseArea{
            height: parent.height-4
            width: parent.width-4
            anchors.centerIn: parent
            onDoubleClicked: {
                console.log('double clicked')
            }
            drag{
                target: mainContainer
                minimumX: Constants.leftMenubarWidth
                minimumY: 29
                maximumX: mainContainer.parent.width - mainContainer.width
                maximumY: mainContainer.parent.height - mainContainer.height - Constants.subMenuWidth
                smoothed: true
            }
            onClicked:  showCustomizeReport()
            onPressed:  onItemPressed()
        }

    }

    WidgetTextEditor{
        id: textEditor

    }


}

