import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents";
import "../MiniSubComponents";

Popup {

    property int menuItemheight: 30

    width: 100
    height: colorOptionsList.height
    x: parent.width - 20
    modal: false
    visible: false
    margins: 0
    padding: 1

    background: Rectangle{
        color: Constants.whiteColor
        border.color: Constants.darkThemeColor
    }


    /***********************************************************************************************************************/
    // LIST MODEL STARTS

    ListModel{
        id: colorByMenuListModel
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



    function deleteColorByChild(){
        var deleteName = colorByTextItem.text;
        for(var i=0; i<colorListModel.count;i++){
            var elementName = colorListModel.get(i).textValue;
            if(elementName===deleteName){
                colorListModel.remove(i);
                ReportParamsModel.setItemType(null);
                ReportParamsModel.setLastDropped(null);
                ReportParamsModel.setChartType(Constants.barChartTitle);
                report_desiner_page.colorByData = [];
                break;
            }
        }
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
            id: colorOptionsList
            model: colorByMenuListModel
            height: (menuItemheight+this.spacing)*colorByMenuListModel.count
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
                            deleteColorByChild()
                        }
                    }
                }

            }
        }


    }
}
