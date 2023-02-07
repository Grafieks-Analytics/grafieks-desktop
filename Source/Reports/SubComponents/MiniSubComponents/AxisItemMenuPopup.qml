import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Dialogs

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents";
import "../MiniSubComponents";

Popup {

    id: axisItemMenuPopup
    property int menuItemheight: 30
    property int currentIndexValue: 0

    width: 100
    height: menuList.height
    x: parent.width - 20
    modal: false
    visible: false
    margins: 0
    padding: 1

    property alias rectIndex: axisItemMenuPopup.currentIndexValue;

    background: Rectangle{
        color: Constants.whiteColor
        border.color: Constants.darkThemeColor
    }


    /***********************************************************************************************************************/
    // LIST MODEL STARTS

    ListModel{
        id: menuListModal
        ListElement{
            menuName: "Remove"
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


    function removeElement(index){
        // [Tag: Refactor]
        // Remove these parent -> parent -> parent 
        // Possible to get model via id or some other reference?
        
       var axisModel = axisItemMenuPopup.parent.parent.parent.model;
           var modelData = axisModel.get(index);
       if(modelData.droppedItemType == "Date"){
           console.log(modelData);
           delete d3PropertyConfig['dateFormat']
       }

        axisModel.remove(index);

        tempXModel.clear();
        tempYModel.clear();
        tempColorByModel.clear();
       reDrawChart();
       
    }


    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts



    Rectangle{
        height: parent.height
        width: parent.width


        ListView{
            id: menuList
            model: menuListModal
            height: (menuItemheight+this.spacing)*menuListModal.count
            width: parent.width
            interactive: false
            spacing: 2
            delegate: Rectangle{
                id: menuElement
                height: menuItemheight
                width: parent.width
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    x: 10
                    text: qsTr(menuName)
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        switch(menuName){
                        case "Remove":
                            removeElement(currentIndexValue)
                        }
                    }
                }

            }
        }


    }
}
