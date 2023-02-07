import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Dialogs

import com.grafieks.singleton.constants 1.0
import com.grafieks.singleton.messages 1.0

import "../../../MainSubComponents";
import "../MiniSubComponents";

Popup {

    property int shapeWidth: 20
    property int shapeHeight: 20

    width: 160
    height: 280
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
        
        ListElement{
            size: 24
        }
        ListElement{
            size: 32
        }
        ListElement{
            size: 48
        }
        ListElement{
            size: 60
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
        dataValueDialogKpi.color = Constants.defaultDataValueColor;
        dataValueKpiColorBox.color = Constants.defaultDataValueColor;

        fontFamily.currentIndex = fontFamily.find("Arial");
        fontSizescombo.currentIndex = fontSizescombo.find("32");


        boldCheckKPIValueStatus = false;
        italicCheckKPIValueStatus = false;
        underlineCheckKPIValueStatus = false;

    }

    function setOldValues(reportProperties){
        

    }

    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    
    function toggleItalic(checkedStatus){
        report_desiner_page.d3PropertyConfig['valueFontStylings'] = report_desiner_page.d3PropertyConfig['valueFontStylings'] || {}
        report_desiner_page.d3PropertyConfig['valueFontStylings'].italic = checkedStatus;
        report_desiner_page.updateChart();
    }
    function toggleBold(checkedStatus){
        report_desiner_page.d3PropertyConfig['valueFontStylings'] = report_desiner_page.d3PropertyConfig['valueFontStylings'] || {}
        report_desiner_page.d3PropertyConfig['valueFontStylings'].bold = checkedStatus;
        report_desiner_page.updateChart();
    }
    function toggleUnderline(checkedStatus){
        report_desiner_page.d3PropertyConfig['valueFontStylings'] = report_desiner_page.d3PropertyConfig['valueFontStylings'] || {}
        report_desiner_page.d3PropertyConfig['valueFontStylings'].underline = checkedStatus;
        report_desiner_page.updateChart();
    }
    
    function updateFontFamily(fontFamily){
        report_desiner_page.d3PropertyConfig['valueFontStylings'] = report_desiner_page.d3PropertyConfig['valueFontStylings'] || {}
        report_desiner_page.d3PropertyConfig['valueFontStylings'].fontFamily = fontFamily;
        report_desiner_page.updateChart();
    }
    
    function updateFontSize(fontSize){
        report_desiner_page.d3PropertyConfig['valueFontStylings'] = report_desiner_page.d3PropertyConfig['valueFontStylings'] || {}
        report_desiner_page.d3PropertyConfig['valueFontStylings'].fontSize = fontSize;
        report_desiner_page.updateChart();
    }
    function openColorDialog(dialogName){
        switch(dialogName){
        case "dataValueKpi": dataValueDialogKpi.open();
            break;
        }
    }

    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/

    ColorDialog{
        id: dataValueDialogKpi

        onColorChanged:{

            if(!d3PropertyConfig.valueFontStylings){
                d3PropertyConfig.valueFontStylings = {}
            }

            d3PropertyConfig.valueFontStylings.dataValueColorKpi = color+"";
            dataValueKpiColorBox.color = color;

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
                        text: Messages.re_mini_common_Bold
                        anchors.left: parent.left
                        anchors.leftMargin: leftMargin
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: Constants.fontCategoryHeaderSmall
                    }

                    CheckBoxTpl{
                        id: boldStatus
                        checked: boldCheckKPIValueStatus
                        parent_dimension: editImageSize - 2
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.rightMargin: -8
                        anchors.top: parent.top

                        onCheckedChanged: toggleBold(checked);


                    }

                }

            }

            Rectangle{

                height: 20
                width: parent.width


                Rectangle{
                    anchors.fill: parent

                    Text {
                        text: Messages.re_mini_common_Italic
                        anchors.left: parent.left
                        anchors.leftMargin: leftMargin
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: Constants.fontCategoryHeaderSmall
                    }

                    CheckBoxTpl{
                        id: italicStatus
                        checked: italicCheckKPIValueStatus
                        parent_dimension: editImageSize - 2
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.rightMargin: -8
                        anchors.top: parent.top

                        onCheckedChanged: toggleItalic(checked);


                    }

                }

            }

            Rectangle{

                height: 20
                width: parent.width


                Rectangle{
                    anchors.fill: parent

                    Text {
                        text: Messages.re_mini_common_Underline
                        anchors.left: parent.left
                        anchors.leftMargin: leftMargin
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: Constants.fontCategoryHeaderSmall
                    }

                    CheckBoxTpl{

                        id: underlineStatus
                        checked: underlineCheckKPIValueStatus
                        parent_dimension: editImageSize - 2
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.rightMargin: -8
                        anchors.top: parent.top

                        onCheckedChanged: toggleUnderline(checked);


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
                    id: dataValueKpiColorBox
                    color: Constants.defaultDataValueColor
                    border.color: Constants.borderBlueColor
                    width: 15
                    height: 15
                    MouseArea{
                        anchors.fill: parent
                        onClicked: openColorDialog("dataValueKpi");
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
                        for(let i=0; i<fontFamilies.length;i++){
                            fonts.append({"fontName": fontFamilies[i]});
                        }
                        fontFamily.model = fonts

                        fontFamily.currentIndex = fontFamily.find("Arial");
                    }
                    onCurrentValueChanged: updateFontFamily(currentValue)
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
                    onCurrentValueChanged: updateFontSize(currentValue)
                    model: fontSizes
                    currentIndex: 11

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
