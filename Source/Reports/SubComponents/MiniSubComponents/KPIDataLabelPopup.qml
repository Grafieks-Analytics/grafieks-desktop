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
            console.log('KPI Debug',reportId)
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
        dataLabelDialogKpi.color = Constants.defaultDataLabelColor;
        dataLabelKpiColorBox.color = Constants.defaultDataLabelColor;

        fontFamily.currentIndex = fontFamily.find("Arial");
        fontSizescombo.currentIndex = fontSizescombo.find("32");

        boldStatus.checked = false;
        italicStatus.checked = false;
        underlineStatus.checked = false;

    }

    function setOldValues(reportProperties){
        
        var d3PropertiesConfig = JSON.parse(reportProperties.d3PropertiesConfig);
        var { labelFontStylings = {} } = d3PropertiesConfig || {};
        var { bold, underline, italic, fontFamily:fontFamilyValue, fontSize:fontSizeValue, dataLabelColorKpi } = labelFontStylings;
        
        boldStatus.checked = !!bold;
        underlineStatus.checked = !!underline;
        italicStatus.checked = !!italic;
        
        if(dataLabelColorKpi){
            dataLabelDialogKpi.color = dataLabelColorKpi;
            dataLabelKpiColorBox.color = dataLabelColorKpi;
        }

        if(fontFamilyValue){
            fontFamily.currentIndex = fontFamily.find(fontFamilyValue);
        }

        if(fontSizeValue){
            fontSizescombo.currentIndex = fontSizescombo.find(fontSizeValue);
        }

    }


    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    
    function toggleItalic(checkedStatus){
        report_desiner_page.d3PropertyConfig['labelFontStylings'] = report_desiner_page.d3PropertyConfig['labelFontStylings'] || {}
        report_desiner_page.d3PropertyConfig['labelFontStylings'].italic = checkedStatus;
        report_desiner_page.reDrawChart();
    }
    function toggleBold(checkedStatus){
        report_desiner_page.d3PropertyConfig['labelFontStylings'] = report_desiner_page.d3PropertyConfig['labelFontStylings'] || {}
        report_desiner_page.d3PropertyConfig['labelFontStylings'].bold = checkedStatus;
        report_desiner_page.reDrawChart();
    }
    function toggleUnderline(checkedStatus){
        report_desiner_page.d3PropertyConfig['labelFontStylings'] = report_desiner_page.d3PropertyConfig['labelFontStylings'] || {}
        report_desiner_page.d3PropertyConfig['labelFontStylings'].underline = checkedStatus;
        report_desiner_page.reDrawChart();
    }

    
    function updateFontFamily(fontFamily){
        report_desiner_page.d3PropertyConfig['labelFontStylings'] = report_desiner_page.d3PropertyConfig['labelFontStylings'] || {}
        report_desiner_page.d3PropertyConfig['labelFontStylings'].fontFamily = fontFamily;
        report_desiner_page.reDrawChart();
    }
    
    function updateFontSize(fontSize){
        report_desiner_page.d3PropertyConfig['labelFontStylings'] = report_desiner_page.d3PropertyConfig['labelFontStylings'] || {}
        report_desiner_page.d3PropertyConfig['labelFontStylings'].fontSize = fontSize;
        report_desiner_page.reDrawChart();
    }
    function openColorDialog(dialogName){
        switch(dialogName){
        case "dataLabelKpi": dataLabelDialogKpi.open();
            break;
        }
    }
    

    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/

    ColorDialog{
        id: dataLabelDialogKpi

        onColorChanged:{

            if(!d3PropertyConfig.labelFontStylings){
                d3PropertyConfig.labelFontStylings = {}
            }
            d3PropertyConfig.labelFontStylings.dataLabelColorKpi = dataLabelDialogKpi.color+"";
            dataLabelKpiColorBox.color = dataLabelDialogKpi.color;

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
                        text: qsTr("Bold")
                        anchors.left: parent.left
                        anchors.leftMargin: leftMargin
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: Constants.fontCategoryHeaderSmall
                    }

                    CheckBoxTpl{

                        id: boldStatus
                        checked: false
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
                        text: qsTr("Italic")
                        anchors.left: parent.left
                        anchors.leftMargin: leftMargin
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: Constants.fontCategoryHeaderSmall
                    }

                    CheckBoxTpl{

                        id: italicStatus
                        checked: false
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
                        text: qsTr("Underline")
                        anchors.left: parent.left
                        anchors.leftMargin: leftMargin
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: Constants.fontCategoryHeaderSmall
                    }

                    CheckBoxTpl{

                        id: underlineStatus
                        checked: false
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
                    text: qsTr("Font Color: ")
                    width: 118
                    anchors.verticalCenter: parent.verticalCenter
                }
                Rectangle {
                    id: dataLabelKpiColorBox
                    color: Constants.defaultDataLabelColor
                    border.color: Constants.borderBlueColor
                    width: 15
                    height: 15
                    MouseArea{
                        anchors.fill: parent
                        onClicked: openColorDialog("dataLabelKpi");
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
                    text: qsTr("Font Size")
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
