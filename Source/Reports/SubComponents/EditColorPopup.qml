import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2

import com.grafieks.singleton.constants 1.0
import com.grafieks.singleton.messages 1.0

import "../../MainSubComponents";
import "./MiniSubComponents";

Popup {

    id: editPopup
    width: parent.width * 0.4
    height: 600
    anchors.centerIn: parent

    visible: false
    modal: true
    padding: 0
    closePolicy: Popup.NoAutoClose

    property var currentIndex;
    property var sequentialGraphs: [Constants.heatMapChartTitle];

    background: Rectangle{
        color: Constants.whiteColor
    }





//    ListModel{
//        id: dataItemList
////        ListElement{
////            colorValue: "blue"
////            dataItemName: "Total Discount"
////        }
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
            schemeType: "categorical"
        }
        ListElement{
            schemeName: "Accent"
            scheme: '["#7fc97f", "#beaed4", "#fdc086", "#ffff99", "#386cb0", "#f0027f", "#bf5b17", "#666666"]'
            schemeType: "categorical"
        }
        ListElement{
            schemeName: "Dark2"
            scheme: '["#1b9e77", "#d95f02", "#7570b3", "#e7298a", "#66a61e", "#e6ab02", "#a6761d", "#666666"]'
            schemeType: "categorical"
        }
        ListElement{
            schemeName: "Paired"
            scheme: '["#a6cee3", "#1f78b4", "#b2df8a", "#33a02c", "#fb9a99", "#e31a1c", "#fdbf6f", "#ff7f00", "#cab2d6", "#6a3d9a", "#ffff99", "#b15928"]'
            schemeType: "categorical"
        }
        ListElement{
            schemeName: "Pastel1"
            scheme:'["#fbb4ae", "#b3cde3", "#ccebc5", "#decbe4", "#fed9a6", "#ffffcc", "#e5d8bd", "#fddaec", "#f2f2f2"]'
            schemeType: "categorical"
        }
        ListElement{
            schemeName: "Pastel2"
            scheme: '["#b3e2cd", "#fdcdac", "#cbd5e8", "#f4cae4", "#e6f5c9", "#fff2ae", "#f1e2cc", "#cccccc"]'
            schemeType: "categorical"
        }
        ListElement{
            schemeName: "Set1"
            scheme: '["#e41a1c", "#377eb8", "#4daf4a", "#984ea3", "#ff7f00", "#ffff33", "#a65628", "#f781bf", "#999999"]'
            schemeType: "categorical"
        }
        ListElement{
            schemeName: "Set2"
            scheme: '["#66c2a5", "#fc8d62", "#8da0cb", "#e78ac3", "#a6d854", "#ffd92f", "#e5c494", "#b3b3b3"]'
            schemeType: "categorical"
        }
        ListElement{
            schemeName: "Set3"
            scheme: '["#8dd3c7", "#ffffb3", "#bebada", "#fb8072", "#80b1d3", "#fdb462", "#b3de69", "#fccde5", "#d9d9d9", "#bc80bd", "#ccebc5", "#ffed6f"]'
            schemeType: "categorical"
        }
        ListElement{
            schemeName: "Tableau10"
            scheme: '["#4e79a7", "#f28e2c", "#e15759", "#76b7b2", "#59a14f", "#edc949", "#af7aa1", "#ff9da7", "#9c755f", "#bab0ab"]'
            schemeType: "categorical"
        }
    }

    ListModel{
        id: sequentialColorScheme
        ListElement{
            schemeName: "Blues"
            scheme: '["#f7fbff", "#deebf7", "#c6dbef", "#9ecae1", "#6baed6", "#4292c6", "#2171b5", "#08519c", "#08306b"]'
            schemeType: "sequential"
        }
        ListElement{
            schemeName: "Greens"
            scheme: '["#f7fcf5", "#e5f5e0", "#c7e9c0", "#a1d99b", "#74c476", "#41ab5d", "#238b45", "#006d2c", "#00441b"]'
            schemeType: "sequential"
        }
        ListElement{
            schemeName: "Reds"
            scheme: '["#fff5f0", "#fee0d2", "#fcbba1", "#fc9272", "#fb6a4a", "#ef3b2c", "#cb181d", "#a50f15", "#67000d"]'
            schemeType: "sequential"
        }
        ListElement{
            schemeName: "Oranges"
            scheme: '["#fff5eb", "#fee6ce", "#fdd0a2", "#fdae6b", "#fd8d3c", "#f16913", "#d94801", "#a63603", "#7f2704"]'
            schemeType: "sequential"
        }
        ListElement{
            schemeName: "Purples"
            scheme: '["#fcfbfd", "#efedf5", "#dadaeb", "#bcbddc", "#9e9ac8", "#807dba", "#6a51a3", "#54278f", "#3f007d"]'
            schemeType: "sequential"
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
        d3PropertyConfig.tooltipColumn1="tooltest";
        console.log("color"+d3PropertyConfig.d3colorPalette)
        console.log("colorData3",colorData)
        Constants.d3ColorPalette = JSON.parse(colorPallete)
        updateChart();
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

        onColorChanged: {
            console.log("colorChanged",color,currentIndex)
              Constants.d3ColorPalette[currentIndex]=color.toString();
            console.log("constantcolor1",Constants.d3ColorPalette)
//                      d3PropertyConfig.d3colorPalette = JSON.parse(colorPallete);
            d3PropertyConfig.d3colorPalette =  Constants.d3ColorPalette;
            drawChart()

        }
//        on__ValueSetChanged: {
//            console.log("colorChanged1",color,currentIndex)
//            Constants.d3ColorPalette[currentIndex]=color;
//            console.log("constantcolor",Constants.d3ColorPalette)
//            drawChart()

//        }

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
                    text: Messages.re_sub_ecp_selDataItem
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            Rectangle{
                height: parent.height - dataItemListRectangle.height-5
                width: parent.width
                border.color: Constants.borderBlueColor
                border.width: 2

                ListView{
                    id:colorByDataItem
                    anchors.fill: parent
                    model: dataItemList
                    spacing: 10
                    topMargin: 15
                    clip: true
                    ScrollBar.vertical: ScrollBar{}
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
                                width: parent.width-50
                                elide: Text.ElideRight
                            }
                            MouseArea{
                                anchors.fill: parent
                                onClicked: {

                                    console.log("index",index)
                                    currentIndex=index;
                                    colorSchemeDialog.open()

                                }
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
                    text: Messages.re_sub_ecp_selColorScheme
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
                    model: sequentialGraphs.includes(report_desiner_page.chartTitle) ? sequentialColorScheme : colorSchemeList
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
            textValue: Messages.applyBtnTxt
            onClicked: closePopup()
        }

    }

}
