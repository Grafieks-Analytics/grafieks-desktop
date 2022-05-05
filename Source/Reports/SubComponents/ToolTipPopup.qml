import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2

import com.grafieks.singleton.constants 1.0
import com.grafieks.singleton.messages 1.0

import "../../MainSubComponents";
import "./MiniSubComponents";

Popup {

    id: toolTipPopup
    width: 600
    height: 400
    anchors.centerIn: parent

    visible: false
    modal: true
    padding: 0
    closePolicy: Popup.NoAutoClose

    background: Rectangle{
        color: Constants.whiteColor
    }
    property int editingFlag:0;

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


    function onCancelClicked(){
        toolTipPopup.visible = false
    }

    function toggleAxisSettings(){
        borderMultipleAxis.visible =  false
        borderAxis.visible =  true
        multipleAxisSettings.visible = false
        axisSettings.visible = true
    }

    function toggleMultipleAxissSettings(){
        borderMultipleAxis.visible =  true
        borderAxis.visible =  false
        multipleAxisSettings.visible = true
        axisSettings.visible = false
    }

    function openColorDialog(dialogName){
        switch(dialogName){
        case "xAxisLegend": xAxisLegendColorDialog.open();
            break;
        case "xAxisTickMark": xAxisTickMarkColorDialog.open();
            break;
        case "yAxisLegend": yAxisLegendColorDialog.open();
            break;
        case "yAxisTickMark": yAxisTickMarkColorDialog.open();
            break;
        }
    }

    function generateLabel(currentIndexTooltip){
        // currentIndexTooltip=currentIndexTooltip+1
        console.log(currentIndexTooltip)
        return "textColumn"+(currentIndexTooltip+1);
    }

    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts

    ColorDialog{
        id: xAxisLegendColorDialog
    }

    ColorDialog{
        id: xAxisTickMarkColorDialog
    }

    ColorDialog{
        id: yAxisLegendColorDialog
    }

    ColorDialog{
        id: yAxisTickMarkColorDialog
    }


    ColorDialog{
        id: colorSchemeDialog
    }


    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts



    function getDataValue(index, model){

        switch(model){
            case 'xAxis':
                return tempXModel.get(index) && tempXModel.get(index).dataValue;
            case 'yAxis':
                return tempYModel.get(index) && tempYModel.get(index).dataValue;
            case 'colorBy':
                return tempColorByModel.get(index) && tempColorByModel.get(index).dataValue;
        }
    }


    // Popup Header Starts

    Rectangle{

        id: header
        color: Constants.themeColor
        height: 40
        width: parent.width - 2

        anchors.top: parent.top
        anchors.left: parent.left

        anchors.topMargin: 1
        anchors.leftMargin: 1

        Text{
            text: Constants.reportToolTipPopupTitle
            anchors.verticalCenter: parent.verticalCenter
            anchors.left : parent.left
            font.pixelSize: Constants.fontCategoryHeader
            anchors.leftMargin: 10
        }
        Image {
            id: close_icn
            source: "/Images/icons/outline_close_black_18dp2x.png"
            anchors.verticalCenter: parent.verticalCenter
            anchors.right:  parent.right
            height: 25
            width: 25
            anchors.rightMargin: 5
            MouseArea{
                anchors.fill: parent
                onClicked: onCancelClicked()
            }
        }

    }

    // Popup Header Ends

    Row{
        id: popupContent
        anchors.top: header.bottom
        anchors.topMargin: 30
        width: parent.width-100
        anchors.horizontalCenter: parent.horizontalCenter
        height: parent.height - header.height - footer.height
        padding: 20
        spacing: 300


        Column{
            
            ListView{
                id:xAxisListModelList
                model:xAxisListModel
                height:xAxisListModel.count*50
                width:parent.width
                delegate:
                    TooltipInputControl{
                    textValue:itemName
                    dataValue:getDataValue(index,'xAxis')||""
                    textLabel:generateLabel( report_desiner_page.isHorizontalGraph ? (yAxisListModel.count + index) : index)
                }
            }
            ListView{
                id:yAxisListModelList
                anchors.top:xAxisListModelList.bottom
                model:yAxisListModel
                height:yAxisListModel.count*50
                width:parent.width
                delegate:
                    TooltipInputControl{
                    textValue:itemName
                    dataValue:getDataValue(index,'yAxis') || ""
                    textLabel:generateLabel(report_desiner_page.isHorizontalGraph ? index : xAxisListModel.count+index)

                }
            }
            ListView{
                anchors.top:yAxisListModelList.bottom

                model:colorListModel
                height:colorListModel.count*50
                width:parent.width
                delegate:
                    TooltipInputControl{
                    textValue:itemName
                    dataValue:getDataValue(index,'colorBy')||""
                    textLabel:"colorData"
                }
            }
        }

    }




    Rectangle{
        id: footer
        anchors.top: popupContent.bottom
        height: 60
        width: parent.width
        CustomButton{
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.right: parent.right
            anchors.rightMargin: 20
            textValue: Messages.applyBtnTxt
            onClicked: {
                
                updateChart();
                toolTipPopup.visible = false
            }
        }
    }
}
