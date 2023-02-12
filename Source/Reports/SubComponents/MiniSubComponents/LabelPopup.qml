import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Dialogs
import Qt.labs.platform

import com.grafieks.singleton.constants 1.0
import com.grafieks.singleton.messages 1.0

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


    
    Connections{
        target: ReportParamsModel

        function onEditReportToggleChanged(reportId){
            if(reportId=="-1"){
                return;
            }
            if(reportId != "false"){
                var reportProperties = ReportParamsModel.getReport(reportIdMain);
                setOldValues(reportProperties)
            }
            else{
                resetAllValues();
            }
        }
    }
    
    function resetAllValues(){
        dataLabeleDialog.color = Constants.defaultDataLabelColor;
        dataLabelFontColorBox.color = Constants.defaultDataLabelColor;

        fontFamily.currentIndex = fontFamily.find("Arial");
        fontSizescombo.currentIndex = fontSizescombo.find("12");

        dataLabelStatus.checked = false;

    }

    function setOldValues(reportProperties){
        
        var d3PropertiesConfig = JSON.parse(reportProperties.d3PropertiesConfig);
        var { dataLabelColor, labelConfig = {}, dataLabelfontFamily, dataLabelfontSize  } = d3PropertiesConfig || {};
        var { labelStatus, labelFormat } = labelConfig;

        dataLabelStatus.checked = !!labelStatus;
        
        if(dataLabelColor){
            dataLabeleDialog.color = dataLabelColor;
            dataLabelFontColorBox.color = dataLabelColor;
        }

        if(dataLabelfontFamily){
            fontFamily.currentIndex = fontFamily.find(dataLabelfontFamily);
        }

        if(dataLabelfontSize){
            fontSizescombo.currentIndex = fontSizescombo.find(dataLabelfontSize);
        }

    }


    function showLabel(checked){
        var labelConfig = d3PropertyConfig.labelConfig || {};
        labelConfig.labelStatus = checked;
        labelConfig.labelFormat = "symbol";
        d3PropertyConfig.labelConfig = labelConfig;
        updateChart();
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

            d3PropertyConfig.dataLabelColor = dataLabeleDialog.color+"";
            dataLabelFontColorBox.color = dataLabeleDialog.color;

            updateChart();
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
                        text: Messages.re_mini_lp_dataLabel
                        anchors.left: parent.left
                        anchors.leftMargin: leftMargin
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: Constants.fontCategoryHeaderSmall
                    }

                    CheckBoxTpl{

                        id: dataLabelStatus
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
                    text: Messages.re_mini_common_fontColor
                    width: 118
                    anchors.verticalCenter: parent.verticalCenter
                }
                Rectangle {
                    id: dataLabelFontColorBox
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
                    text: Messages.re_mini_common_fontFamily
                }
            }

            Rectangle{
                height: 30
                width: parent.width

                CustomComboBox{
                    id: fontFamily
                    height: 500


                    Component.onCompleted: {
                        let fontFamilies = ["Arial", "Arial Black", "Calibri", "Cambria", "Comic Sans MS", "Courier", "Franklin Gothic", "Georgia", "Impact", "Lucida Console", "Luminari", "Tahoma", "Times New Roman", "Trebuchet MS", "Verdana"];
                        // let fontFamilies =["Arial","Arial Black",""];
                        for(let i=0; i<fontFamilies.length;i++){
                            fonts.append({"fontName": fontFamilies[i]});
                        }
                        fontFamily.model = fonts

                        fontFamily.currentIndex = fontFamily.find("Arial");
                    }
                    onCurrentValueChanged: {
                        console.log("labelfont"+fontFamily.currentValue)
                        d3PropertyConfig.dataLabelfontFamily=fontFamily.currentValue;
                        updateChart();
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
                    text: Messages.re_mini_common_fontsize
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
                        updateChart();
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
