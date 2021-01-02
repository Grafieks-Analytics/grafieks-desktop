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
            schemeName: "Category10"
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


    function closePopup(){
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

    function selectColorPallete(schemeName,colorPallete){
        const scheme = 'scheme'+schemeName;
        d3PropertyConfig.d3colorPalette = scheme;
        reDrawChart();
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
                onClicked: closePopup()
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
                    spacing: 10
                    topMargin: 15
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
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            MouseArea{
                                anchors.fill: parent
                                onClicked: colorSchemeDialog.open()
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
                id: colorSchemeListRectangle
                height: 30
                width: parent.width
                Text {
                    text: qsTr("Select Color Scheme")
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            Rectangle{
                height: parent.height - colorSchemeListRectangle.height
                width: parent.width
                border.color: Constants.borderBlueColor
                border.width: 2

                ListView{

                    height: parent.height
                    width: parent.width - 2*this.leftMargin
                    model: colorSchemeList
                    spacing: 12
                    topMargin: 15
                    leftMargin: 15

                    delegate: Rectangle{
                        height: 30
                        width: parent.width
                        Image {
                            height: parent.height
                            width: parent.width
                            source: "/Images/icons/reports/"+schemeName
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: selectColorPallete(schemeName)
                        }

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
            onClicked: closePopup()
        }

    }

}
