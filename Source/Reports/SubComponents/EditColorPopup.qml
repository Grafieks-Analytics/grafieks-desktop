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


//    ListModel{
//        id: dataItemList
//        ListElement{
//            colorValue: "blue"
//            dataItemName: colorData
//        }
////        ListElement{
////            colorValue: "green"
////            dataItemName: "Total Discount"
////        }
//    }


    ListModel{
        id: colorSchemeList
        ListElement{
            schemeName: "Category10"
            scheme: '[ "#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9467bd", "#8c564b", "#e377c2", "#7f7f7f", "#bcbd22", "#17becf" ]'
        }
        ListElement{
            schemeName: "Accent"
            scheme: '["#7fc97f", "#beaed4", "#fdc086", "#ffff99", "#386cb0", "#f0027f", "#bf5b17", "#666666"]'
        }
        ListElement{
            schemeName: "Dark2"
            scheme: '["#1b9e77", "#d95f02", "#7570b3", "#e7298a", "#66a61e", "#e6ab02", "#a6761d", "#666666"]'
        }
        ListElement{
            schemeName: "Paired"
            scheme: '["#a6cee3", "#1f78b4", "#b2df8a", "#33a02c", "#fb9a99", "#e31a1c", "#fdbf6f", "#ff7f00", "#cab2d6", "#6a3d9a", "#ffff99", "#b15928"]'
        }
        ListElement{
            schemeName: "Pastel1"
            scheme:'["#fbb4ae", "#b3cde3", "#ccebc5", "#decbe4", "#fed9a6", "#ffffcc", "#e5d8bd", "#fddaec", "#f2f2f2"]'
        }
        ListElement{
            schemeName: "Pastel2"
            scheme: '["#b3e2cd", "#fdcdac", "#cbd5e8", "#f4cae4", "#e6f5c9", "#fff2ae", "#f1e2cc", "#cccccc"]'
        }
        ListElement{
            schemeName: "Set1"
            scheme: '["#e41a1c", "#377eb8", "#4daf4a", "#984ea3", "#ff7f00", "#ffff33", "#a65628", "#f781bf", "#999999"]'
        }
        ListElement{
            schemeName: "Set2"
            scheme: '["#66c2a5", "#fc8d62", "#8da0cb", "#e78ac3", "#a6d854", "#ffd92f", "#e5c494", "#b3b3b3"]'
        }
        ListElement{
            schemeName: "Set3"
            scheme: '["#8dd3c7", "#ffffb3", "#bebada", "#fb8072", "#80b1d3", "#fdb462", "#b3de69", "#fccde5", "#d9d9d9", "#bc80bd", "#ccebc5", "#ffed6f"]'
        }
        ListElement{
            schemeName: "Tableau10"
            scheme: '["#4e79a7", "#f28e2c", "#e15759", "#76b7b2", "#59a14f", "#edc949", "#af7aa1", "#ff9da7", "#9c755f", "#bab0ab"]'
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
        d3PropertyConfig.d3colorPalette = JSON.parse(colorPallete);
        console.log("color"+d3PropertyConfig.d3colorPalette)
//        console.log("colorData",colorData)
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
                    model: colorData
                    spacing: 10
                    topMargin: 15
                    delegate: Row{

                        height: 20
                        width: parent.width
                        leftPadding: 15


                        Rectangle{
                            height: 20
                            width: parent.width - parent.leftPadding - 10

//                            Rectangle{
//                                id: colorBox
//                                anchors.left: parent.left
//                                height: 20
//                                width: 20
//                                color: colorValue
//                            }

                            Text {
                                id: text
                                text: colorData[index]
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
                            onClicked: selectColorPallete(schemeName, scheme)
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
