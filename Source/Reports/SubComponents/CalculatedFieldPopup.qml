import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2

import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents";
import "./MiniSubComponents";

Popup {

    id: calculatedFieldPopup
    width: parent.width * 0.5
    height: 600
    anchors.centerIn: parent

    visible: false
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

    ListModel{
        id: colorSchemeList
        ListElement{
            schemeName: "category10"
        }
        ListElement{
            schemeName: "Accent"
        }
        ListElement{
            schemeName: "Dark2"
        }
        ListElement{
            schemeName: "Paired"
        }
        ListElement{
            schemeName: "Pastel1"
        }
        ListElement{
            schemeName: "Pastel2"
        }
        ListElement{
            schemeName: "Set1"
        }
        ListElement{
            schemeName: "Set2"
        }
        ListElement{
            schemeName: "Set3"
        }
        ListElement{
            schemeName: "Tableau10"
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
        calculatedFieldPopup.visible = false
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
            text: Constants.reportCalculatedFieldPopup
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
        width: parent.width - this.padding - this.spacing
        height: parent.height - header.height - footer.height
        padding: 20
        spacing: 20

        Rectangle{
            height: parent.height
            width: parent.width
            color: "red"
        }

    }


    Rectangle{
        id: footer
        anchors.top: popupContent.bottom
        height: 60
        width: parent.width

        Row{
            spacing: 10
            anchors.top: parent.top
            anchors.topMargin: popupContent.padding
            anchors.right: parent.right
            anchors.rightMargin: 20

            CustomButton{
                textValue: "Cancel"
                onClicked: onCancelClicked()
            }

            CustomButton{
                textValue: "Apply"
            }
        }

    }

}
