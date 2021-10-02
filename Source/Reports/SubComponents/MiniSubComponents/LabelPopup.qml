import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents";
import "../MiniSubComponents";

Popup {

    property int shapeWidth: 20
    property int shapeHeight: 20

    width: 160
    height: 220
    x: 10
    modal: false
    visible: false

    ListModel{
        id: outlined
        ListElement{
            icon: "Ellipse.png"
        }
        ListElement{
            icon: "Rectangle.png"
        }
        ListElement{
            icon: "Polygon.png"
        }
        ListElement{
            icon: "add.png"
        }
    }

    ListModel{
        id: filled
        ListElement{
            icon: "Ellipse_filled.png"
        }
        ListElement{
            icon: "Rectangle_filled.png"
        }
        ListElement{
            icon: "Polygon_filled.png"
        }
    }


    ListModel{
        id: fonts
        ListElement{
            fontName:"Default"
        }
    }
    ListModel{
        id: fontSizes
        ListElement{
            size: 8
        }
        ListElement{
            size: 9
        }
        ListElement{
            size: 10
        }
        ListElement{
            size: 11
        }
        ListElement{
            size: 12
        }
        ListElement{
            size: 13
        }
        ListElement{
            size: 14
        }
        ListElement{
            size: 16
        }
        ListElement{
            size: 18
        }
        ListElement{
            size: 20
        }
    }


    function showLabel(checked){
        var labelConfig = d3PropertyConfig.labelConfig || {};
        labelConfig.labelStatus = checked;
        labelConfig.labelFormat = "symbol";
        d3PropertyConfig.labelConfig = labelConfig;
        reDrawChart();
    }
      function openColorDialog(dialogName){
        switch(dialogName){
        case "dataLabel": dataLabeleDialog.open();
            break;
        }
    }

      ColorDialog{
        id: dataLabeleDialog

        onColorChanged:{

             Constants.defaultDataLabelColor =  dataLabeleDialog.color;

//            webEngineView.runJavaScript("changeChartAttributes('.x_label','fill', '"+xAxisLegendColorDialog.color+"')")
            d3PropertyConfig.dataLabelColor = dataLabeleDialog.color+"";
            // d3PropertyConfig.dataLabelColor = "";
            reDrawChart();
        }

    }


    background: Rectangle{
        color: Constants.whiteColor
        border.color: Constants.darkThemeColor
    }

    Rectangle{
        anchors.fill: parent

        Column{
            anchors.fill: parent
            spacing: 10


            Rectangle{

                height: 20
                width: parent.width


                Rectangle{
                    anchors.fill: parent

                    Text {
                        text: qsTr("Data Label")
                        anchors.left: parent.left
                        anchors.leftMargin: leftMargin
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: Constants.fontCategoryHeaderSmall
                    }

                    CheckBoxTpl{

                        checked: false
                        parent_dimension: editImageSize - 2
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.rightMargin: -8
                        anchors.top: parent.top

                        onCheckedChanged: showLabel(checked);


                    }

                }

            }
              Row{
                                width: parent.width
                                Text {
                                    text: qsTr("Font Color: ")
                                    width: 118
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Rectangle {
                                    color: Constants.defaultDataLabelColor
                                    border.color: Constants.borderBlueColor
                                    width: 15
                                    height: 15
                                    MouseArea{
                                        anchors.fill: parent
                                        onClicked: openColorDialog("dataLabel");
                                    }

                                }
                            }

            Rectangle{
                height: 20
                width: parent.width
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("Font Family")
                }
            }

            Rectangle{
                height: 30
                width: parent.width

                CustomComboBox{
                    id: fontFamily
                    height: 500


                    Component.onCompleted: {
                        let fontFamilies = Qt.fontFamilies();
                        for(let i=0; i<fontFamilies.length;i++){
                            fonts.append({"fontName": fontFamilies[i]});
                        }
                        fontFamily.model = fonts

                        fontFamily.currentIndex = fontFamily.find("Arial");
                    }
                    onCurrentValueChanged: {
                        console.log("labelfont"+fontFamily.currentValue)
                        d3PropertyConfig.dataLabelfontFamily=fontFamily.currentValue;
                        reDrawChart();
                    }
                    //                    popup: Popup {
                    //                //                            y: control.height - 1
                    //                            implicitWidth:  200

                    //                //                            implicitHeight: contentItem.implicitHeight
                    //                        implicitHeight: 500
                    //                //                            padding: 1


                    //                        contentItem: ListView {
                    //                                     clip: true
                    //                                     implicitHeight: 20
                    //                                     model:  fonts
                    //                                     currentIndex: fontSizes.highlightedIndex

                    //                                     ScrollIndicator.vertical: ScrollIndicator { }
                    //                                 }

                    //                    }







                    model: fonts
                    textRole: "fontName"
                    width: parent.width-2*leftMargin
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: leftMargin
                    anchors.top: parent.top

                }

            }

            Rectangle{
                height: 20
                width: parent.width
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("Font Size")
                }
            }

            Rectangle{
                height: 30
                width: parent.width

                CustomComboBox{
                    id: fontSizescombo
                    height: 500

                    onCurrentValueChanged: {
              
                        d3PropertyConfig.dataLabelfontSize=fontSizescombo.currentValue;
                        reDrawChart();
                    }

                    model: fontSizes
                    currentIndex: 4

                    textRole: "size"
                    width: parent.width-2*leftMargin
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: leftMargin
                    anchors.top: parent.top

                }

            }
             

        }

    }
}
