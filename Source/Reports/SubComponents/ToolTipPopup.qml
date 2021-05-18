import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2

import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents";
import "./MiniSubComponents";

Popup {

    id: toolTipPopup
    width: parent.width * 0.5
    height: 400
    anchors.centerIn: parent

    visible: false
    modal: true
    padding: 0
    closePolicy: Popup.NoAutoClose

    background: Rectangle{
        color: Constants.whiteColor
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
                id:firstCol
                spacing: 100

                width: parent.width/2

                Text {
                    id: label2
                    text: qsTr("Column")
                }




                Rectangle{
                    id:xAxisToolTip
                    height:30
                    width:parent.width

                    anchors.top: label2.bottom
                    anchors.topMargin: 15



                    ListView{

                        height: parent.height
                        width: parent.width

                        anchors.top: parent.top
                        anchors.topMargin: 3
                        model: xAxisListModel
                        orientation: Qt.Vertical
                        spacing: 5
                        interactive: false
                        delegate:  Text {

                            text: qsTr(itemName)
                        }

                    }
                }
                Rectangle{
                    id:yAxisToolTip
                    height:30
                    width:parent.width

                    anchors.top: xAxisToolTip.bottom
                        anchors.topMargin: 15



                    ListView{

                        height: parent.height
                        width: parent.width

                        anchors.top: parent.top
                        anchors.topMargin: 3
                        model: yAxisListModel
                        orientation: Qt.Vertical
                        spacing: 5
                        interactive: false
                        delegate:  Text {

                            text: qsTr(itemName)
                        }

                    }
                }



            }

        Column{
            spacing: 100
            width: parent.width/2
            anchors.right: parent.right
            Text {
                id: label3
                text: qsTr("Tooltip Label")
            }

            Rectangle{
                id:toolTipEdit1
                height:25
                width:parent.width

                anchors.top: label3.bottom
                    anchors.topMargin: 15

                TextField{
                    width: parent.width-150
                    selectByMouse: true
                    height:25
                    cursorVisible: true
                    anchors.top: parent.top
                    anchors.topMargin: 5
                    placeholderText: "column1"


                    background: Rectangle{
                        border.width: 1

                    }
                }
            }
            Rectangle{
                id:toolTipEdit2
                height:25
                width:parent.width

                anchors.top: toolTipEdit1.bottom
                    anchors.topMargin: 15

                TextField{
                    width: parent.width-150
                    selectByMouse: true
                    height:25
                    cursorVisible: true
                    anchors.top: parent.top
                    anchors.topMargin: 5
                    placeholderText: "column2"
                    background: Rectangle{
                        border.width: 1

                    }
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
            textValue: "Apply"
        }
    }
}
