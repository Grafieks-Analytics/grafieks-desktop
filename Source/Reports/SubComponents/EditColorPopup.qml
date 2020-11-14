import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2

import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents";
import "./MiniSubComponents";

Popup {

    id: editPopup
    width: parent.width * 0.5
    height: 800
    anchors.centerIn: parent

    visible: true
    modal: true
    padding: 0
    closePolicy: Popup.NoAutoClose

    background: Rectangle{
        color: Constants.whiteColor
    }


    ListModel{
        id: dataItemList
        ListElement{
            colorValue: "blue"
            dataItemName: "Total Quality"
        }
        ListElement{
            colorValue: "green"
            dataItemName: "Total Discount"
        }
    }

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
        editPopup.visible = false
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


    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts





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
            text: Constants.reportEditColorPopup
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
        width: parent.width - this.padding * 2 - this.spacing
        height: parent.height - header.height - footer.height
        padding: 20
        spacing: 20

        Column{
            width: parent.width/3
            height: parent.height - parent.padding
            Rectangle{
                id: dataItemListRectangle
                height: 30
                width: parent.width
                Text {
                    text: qsTr("Select Data Item")
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            Rectangle{
                height: parent.height - dataItemListRectangle.height
                width: parent.width
                border.color: Constants.borderBlueColor
                border.width: 2

                ListView{
                    anchors.fill: parent
                    model: dataItemList
                    spacing: 4
                    topMargin: 10
                    delegate: Row{

                        height: 20
                        width: parent.width
                        leftPadding: 15


                        Rectangle{
                            height: 20
                            width: parent.width - parent.leftPadding - 10

                            Rectangle{
                                id: colorBox
                                anchors.left: parent.left
                                height: 20
                                width: 20
                                color: colorValue
                            }

                            Text {
                                id: text
                                text: dataItemName
                                anchors.left: colorBox.right
                                anchors.leftMargin: 10
                            }

                        }


                    }
                }
            }
        }

        Column{
            width: parent.width*2/3
            height: parent.height - parent.padding
            Rectangle{
                id: colorSchemeList
                height: 30
                width: parent.width
                Text {
                    text: qsTr("Select Color Item")
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            Rectangle{
                height: parent.height - colorSchemeList.height
                width: parent.width
                border.color: Constants.borderBlueColor
                border.width: 2
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
            textValue: "Apply"
        }

    }

}
