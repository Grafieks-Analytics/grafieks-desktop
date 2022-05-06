import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2

import com.grafieks.singleton.constants 1.0
import com.grafieks.singleton.messages 1.0

import "../../../MainSubComponents";


Rectangle{
    anchors.left: menuContentSeparator.right
    height: parent.height
    width: parent.width - leftMenu.width - menuContentSeparator.width

    property bool toggleBoldYLabel: false;
    property bool toggleBoldXLabel: false;
    property bool toggleBoldYTick: false;
    property bool toggleBoldXTick: false;

    property bool toggleItalicYLabel: false;
    property bool toggleItalicXLabel: false;
    property bool toggleItalicYTick: false;
    property bool toggleItalicXTick: false;



    /***********************************************************************************************************************/
    // LIST MODEL STARTS

    ListModel{
        id: fonts
        ListElement{
            fontName:"Default"
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
        //        ListElement{
        //            size: 22
        //        }
        //        ListElement{
        //            size: 24
        //        }
        //        ListElement{
        //            size: 28
        //        }
        //        ListElement{
        //            size: 32
        //        }
        //        ListElement{
        //            size: 48
        //        }
        //        ListElement{
        //            size: 64
        //        }
        //        ListElement{
        //            size: 78
        //        }
    }


    // LIST MODEL ENDS
    /***********************************************************************************************************************/

    //javascript function

    onVisibleChanged:{
        xaxisCheckbox.checked = xAxisLabelStatus;
        yaxisCheckbox.checked = yAxisLabelStatus;

        var { xAxisConfig = {}, yAxisConfig = {} }  = d3PropertyConfig;
        var xLabel =  xAxisConfig.xlabel
        var yLabel =  yAxisConfig.ylabel
        
        var xAxisColumnDetails = getDataPaneAllDetails(Constants.xAxisName);
        var yAxisColumnDetails = getDataPaneAllDetails(Constants.yAxisName);

        xAxisLabelNameBox.text = xLabel || (xAxisColumnDetails[0] && xAxisColumnDetails[0].itemName);
        yAxisLabelNameBox.text = yLabel || (yAxisColumnDetails[0] && yAxisColumnDetails[0].itemName);

    }
    
    function onApplyClicked(){
        popup.visible = false
        updateChart();
    }

    function resetAllValues(){
        toggleBoldYLabel = false; 
        toggleBoldXLabel=false;
        toggleBoldYTick= false;
        toggleBoldXTick= false;
        
        toggleItalicYLabel= false;
        toggleItalicXLabel= false;
        toggleItalicYTick= false;
        toggleItalicXTick= false;

        xAxisLabelStatus =  true;
        yAxisLabelStatus =  true;
                
        xAxisLabelNameBox.text = null
        yAxisLabelNameBox.text = null

        xAxisLegendFonts.currentIndex = xAxisLegendFonts.find("Arial");
        xAxisTickMarkFonts.currentIndex = xAxisTickMarkFonts.find("Arial");
        yAxisLegendFonts.currentIndex = yAxisLegendFonts.find("Arial");
        yAxisTickMarkFonts.currentIndex = yAxisTickMarkFonts.find("Arial");

        xAxisLabelFontSize.currentIndex = xAxisLabelFontSize.find('12');
        xAxisTickMarkFontSize.currentIndex = xAxisTickMarkFontSize.find('12');
        yAxisLabelFontSize.currentIndex = yAxisLabelFontSize.find('12');
        yAxisTickMarkFontSize.currentIndex = yAxisTickMarkFontSize.find('12');

        
        xLabelFontColor.color = Constants.defaultXAxisLabelColor;
        yLabelFontColor.color = Constants.defaultXAxisLabelColor;
        xTickFontColor.color = Constants.defaultXAxisTickColor;
        yTickFontColor.color = Constants.defaultXAxisTickColor;



    }

    function setOldValues(reportProperties){
        
        var chartPropertyConfig = JSON.parse(reportProperties.d3PropertiesConfig);
        var {   
                dataColumns = {}, yAxisConfig = {}, xAxisConfig = {}, xLabelfontSize, xTickfontSize, yLabelfontSize, yTickfontSize,
                xLabelfontFamily, yLabelfontFamily, xTickfontFamily, yTickfontFamily,
                xLabelfontColor, yLabelfontColor, xTickfontColor, yTickfontColor
            } = chartPropertyConfig || {};

        toggleBoldXLabel= !!xAxisConfig.xboldLabel;
        toggleBoldXTick= !!xAxisConfig.xboldTick;        
        toggleItalicXLabel= !!xAxisConfig.xitalicLabel;
        toggleItalicXTick= !!xAxisConfig.xitalicTick;

        toggleBoldYLabel = !!yAxisConfig.yboldLabel; 
        toggleBoldYTick= !!yAxisConfig.yboldTick;
        toggleItalicYLabel= !!yAxisConfig.yitalicLabel;
        toggleItalicYTick= !!yAxisConfig.yitalicTick;

        if(yAxisConfig.yaxisStatus != undefined){
            yAxisLabelStatus = yAxisConfig.yaxisStatus
        }
        
        if(xAxisConfig.xaxisStatus != undefined){
            xAxisLabelStatus = xAxisConfig.xaxisStatus
        }
        console.log('Y Axis',yAxisLabelStatus);
        console.log('X Axis',xAxisLabelStatus);

        xAxisLabelNameBox.text = xAxisConfig.xlabel ? xAxisConfig.xlabel : dataColumns.xAxisColumnDetails[0].itemName;
        yAxisLabelNameBox.text = yAxisConfig.ylabel ? yAxisConfig.ylabel : (dataColumns.yAxisColumnDetails[0] && dataColumns.yAxisColumnDetails[0].itemName);
    
    
        xLabelFontColor.color = xLabelfontColor ? xLabelfontColor : Constants.defaultXAxisLabelColor;
        yLabelFontColor.color = yLabelfontColor ? yLabelfontColor : Constants.defaultXAxisLabelColor;
        xTickFontColor.color = xTickfontColor ? xTickfontColor : Constants.defaultXAxisTickColor;
        yTickFontColor.color = yTickfontColor ? yTickfontColor : Constants.defaultXAxisTickColor;
    
        xAxisLegendFonts.currentIndex = xLabelfontFamily ? xAxisLegendFonts.find(xLabelfontFamily) : xAxisLegendFonts.find("Arial");
        xAxisTickMarkFonts.currentIndex = xTickfontFamily ? xAxisTickMarkFonts.find(xTickfontFamily) : xAxisTickMarkFonts.find("Arial");
        yAxisLegendFonts.currentIndex = yLabelfontFamily ? yAxisLegendFonts.find(yLabelfontFamily) : yAxisLegendFonts.find("Arial");
        yAxisTickMarkFonts.currentIndex = yTickfontFamily ? yAxisTickMarkFonts.find(yTickfontFamily) : yAxisTickMarkFonts.find("Arial");
        
        xAxisLabelFontSize.currentIndex = xLabelfontSize ? xAxisLabelFontSize.find(xLabelfontSize) : xAxisLabelFontSize.find('12');
        xAxisTickMarkFontSize.currentIndex = xTickfontSize ? xAxisTickMarkFontSize.find(xTickfontSize) : xAxisTickMarkFontSize.find('12');
        yAxisLabelFontSize.currentIndex = yLabelfontSize ? yAxisLabelFontSize.find(yLabelfontSize) : yAxisLabelFontSize.find('12');
        yAxisTickMarkFontSize.currentIndex = yTickfontSize ? yAxisTickMarkFontSize.find(yTickfontSize) : xAxisLabelFontSize.find('12');

    }

    onToggleBoldYLabelChanged:{
        if(toggleBoldYLabel){
            yAxisLabelBold.color="lightGrey"
        }else{
            yAxisLabelBold.color="transparent"
        }
    }

    onToggleBoldXLabelChanged:{
        if(toggleBoldXLabel){
            xAxisLabelBold.color="lightGrey"
        }else{
            xAxisLabelBold.color="transparent"
        }
    }

    onToggleItalicYLabelChanged:{
        if(toggleItalicYLabel){
            yAxisLabelItalilc.color="lightGrey"
        }else{
            yAxisLabelItalilc.color="transparent"
        }
    }

    onToggleItalicXLabelChanged:{
        if(toggleItalicXLabel){
            xAxisLabelItalilc.color="lightGrey"
        }else{
            xAxisLabelItalilc.color="transparent"
        }
    }

    onToggleBoldYTickChanged:{
        if(toggleBoldYTick){
            yAxisTickBold.color="lightGrey"
        }else{
            yAxisTickBold.color="transparent"
        }
    }

    onToggleBoldXTickChanged:{
        if(toggleBoldXTick){
            xAxisTickBold.color="lightGrey"
        }else{
            xAxisTickBold.color="transparent"
        }
    }

    onToggleItalicXTickChanged:{
        if(toggleItalicXTick){
            xAxisTickItalilc.color="lightGrey"
        }else{
            xAxisTickItalilc.color="transparent"
        }
    }

    onToggleItalicYTickChanged:{
        if(toggleItalicYTick){
            yAxisTickItalilc.color="lightGrey"
        }else{
            yAxisTickItalilc.color="transparent"
        }
    }
    



    //    bold
    function boldToggleYLabel(){

        d3PropertyConfig.yAxisConfig = d3PropertyConfig.yAxisConfig || {};        
        if(!toggleBoldYLabel){
            toggleBoldYLabel = true;
            yAxisLabelBold.color="lightGrey"
            d3PropertyConfig.yAxisConfig.yboldLabel = true;
        }
        else{
            toggleBoldYLabel = false;
            yAxisLabelBold.color="transparent"
            d3PropertyConfig.yAxisConfig.yboldLabel = false;
        }
    }
    function boldToggleXLabel(){

        d3PropertyConfig.xAxisConfig = d3PropertyConfig.xAxisConfig || {};

        if(toggleBoldXLabel == false){
            toggleBoldXLabel = true;
            d3PropertyConfig.xAxisConfig.xboldLabel = true;
        }

        else if(toggleBoldXLabel == true){
            toggleBoldXLabel = false;
            d3PropertyConfig.xAxisConfig.xboldLabel = false;
        }

    }
    function boldToggleXTick(){

        d3PropertyConfig.xAxisConfig = d3PropertyConfig.xAxisConfig || {};

        if(toggleBoldXTick == false){
            toggleBoldXTick = true;
            d3PropertyConfig.xAxisConfig.xboldTick = true;
        }
        else if(toggleBoldXTick == true){
            toggleBoldXTick = false;
            d3PropertyConfig.xAxisConfig.xboldTick = false;
        }

    }
    function boldToggleYTick(){

        d3PropertyConfig.yAxisConfig = d3PropertyConfig.yAxisConfig || {};

        if(toggleBoldYTick == false){
            toggleBoldYTick = true;
            d3PropertyConfig.yAxisConfig.yboldTick = true;
        }
        else if(toggleBoldYTick == true){
            toggleBoldYTick = false;
            d3PropertyConfig.yAxisConfig.yboldTick = false;
        }

    }

    //    italic
    function italicToggleXLabel(){

        d3PropertyConfig.xAxisConfig = d3PropertyConfig.xAxisConfig || {};

        if(toggleItalicXLabel == false){
            toggleItalicXLabel = true;
            d3PropertyConfig.xAxisConfig.xitalicLabel = true;

        }
        else if(toggleItalicXLabel == true){
            toggleItalicXLabel = false;
            d3PropertyConfig.xAxisConfig.xitalicLabel = false;
        }
    }
    function italicToggleYLabel(){

        d3PropertyConfig.yAxisConfig = d3PropertyConfig.yAxisConfig || {};

        if(toggleItalicYLabel == false){
            toggleItalicYLabel = true;
            d3PropertyConfig.yAxisConfig.yitalicLabel = true;
        }
        else{
            toggleItalicYLabel = false;
            d3PropertyConfig.yAxisConfig.yitalicLabel = false;
        }

    }
    function italicToggleXTick(){

        d3PropertyConfig.xAxisConfig = d3PropertyConfig.xAxisConfig || {};

        if(toggleItalicXTick == false){
            toggleItalicXTick = true;
            d3PropertyConfig.xAxisConfig.xitalicTick = true;
        }
        else{
            toggleItalicXTick = false;
            d3PropertyConfig.xAxisConfig.xitalicTick = false;
        }
    }
    function italicToggleYTick(){

        d3PropertyConfig.yAxisConfig = d3PropertyConfig.yAxisConfig || {};

        if(toggleItalicYTick == false){
            toggleItalicYTick = true;
            d3PropertyConfig.yAxisConfig.yitalicTick = true;
        }
        else{
            toggleItalicYTick = false;
            d3PropertyConfig.yAxisConfig.yitalicTick = false;
        }
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

    ColorDialog{
        id: xAxisLegendColorDialog

        onColorChanged:{
            //            webEngineView.runJavaScript("changeChartAttributes('.x_label','fill', '"+xAxisLegendColorDialog.color+"')")
            d3PropertyConfig.xLabelfontColor=xAxisLegendColorDialog.color+"";
            xLabelFontColor.color = xAxisLegendColorDialog.color;
            updateChart();
        }

    }

    ColorDialog{
        id: xAxisTickMarkColorDialog
        onColorChanged:{

            //   Constants.defaultXAxisTickColor = xAxisTickMarkColorDialog.color;            
            d3PropertyConfig.xTickfontColor=xAxisTickMarkColorDialog.color+"";
            xTickFontColor.color = xAxisTickMarkColorDialog.color;

            updateChart();
        }
    }

    ColorDialog{
        id: yAxisLegendColorDialog
        onColorChanged:{


            //            webEngineView.runJavaScript("changeChartAttributes('.y_label','fill', '"+yAxisLegendColorDialog.color+"')")
            d3PropertyConfig.yLabelfontColor=yAxisLegendColorDialog.color+"";
            yLabelFontColor.color = yAxisLegendColorDialog.color;

            updateChart();
        }
    }

    ColorDialog{
        id: yAxisTickMarkColorDialog
        onColorChanged:{

            d3PropertyConfig.yTickfontColor=yAxisTickMarkColorDialog.color+"";
            yTickFontColor.color = yAxisTickMarkColorDialog.color;

            updateChart();
        }
    }


    Component.onCompleted: {
        let fontFamilies = ["Arial", "Arial Black", "Calibri", "Cambria", "Comic Sans MS", "Courier", "Franklin Gothic", "Georgia", "Impact", "Lucida Console", "Luminari", "Tahoma", "Times New Roman", "Trebuchet MS", "Verdana"];
        for(let i=0; i<fontFamilies.length;i++){
            fonts.append({"fontName": fontFamilies[i]});
        }

        xAxisLegendFonts.model = fonts;
        xAxisLegendFonts.currentIndex = xAxisLegendFonts.find("Arial");
        xAxisTickMarkFonts.model = fonts;
        xAxisTickMarkFonts.currentIndex = xAxisTickMarkFonts.find("Arial");
        yAxisLegendFonts.model = fonts;
        yAxisLegendFonts.currentIndex = yAxisLegendFonts.find("Arial");
        yAxisTickMarkFonts.model = fonts;
        yAxisTickMarkFonts.currentIndex = yAxisTickMarkFonts.find("Arial");

    }

    Column
    {

        id: axisSettingsContent
        width: parent.width-150
        height: parent.height - axisSettingsFooter.height

        Rectangle{
            height: (parent.height - parent.spacing) / 2
            width: parent.width
            anchors.left: parent.left
            anchors.leftMargin: 50

            Column{

                anchors.fill: parent
                anchors.left: parent.left
                spacing: 0

                // X Axis
                Row{

                    height: 50
                    CheckBoxTpl{
                        id: xaxisCheckbox
                        checked: xAxisLabelStatus
                        parent_dimension: Constants.defaultCheckBoxDimension
                        anchors.verticalCenter: parent.verticalCenter
                        onCheckStateChanged: {
                            d3PropertyConfig.xAxisConfig = d3PropertyConfig.xAxisConfig || {};
                            d3PropertyConfig.xAxisConfig.xaxisStatus = checked;
                            xAxisLabelStatus = checked;
                        }
                    }

                    Text {
                        text: Messages.re_mini_common_xAxis
                        anchors.verticalCenter: parent.verticalCenter
                    }

                }

                // Label
                Row{

                    height: (parent.height - 50)/2
                    width: parent.width

                    Rectangle{
                        width: parent.width/4 - 10
                        height: nameInputRow.height

                        Text {
                            text: Messages.re_mini_common_label
                            anchors.left: parent.left
                            anchors.leftMargin: xaxisCheckbox.width
                            anchors.verticalCenter: parent.verticalCenter
                        }

                    }

                    Rectangle{
                        width: (parent.width*3)/4 - 20
                        height: parent.height

                        Column{
                            anchors.fill: parent
                            spacing: 10

                            // Name Input
                            Row{
                                id: nameInputRow
                                width: parent.width
                                Text {
                                    text: Messages.re_mini_common_name
                                    width: parent.width/4
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                CustomTextBox {

                                    id: xAxisLabelNameBox
                                    width: parent.width*3/4
                                    //                                    text: qsTr(ReportParamsModel.xAxisColumns[0])
                                    //                                    text: getAxisColumnNames(Constants.yAxisName)
                                    // text: qsTr(getAxisColumnNames(Constants.xAxisName)[0])
                                    // text: getAxisColumnNames( (d3PropertyConfig.xAxisConfig && d3PropertyConfig.xAxisConfig.label) ||  Constants.xAxisName)[0]
                                    text: qsTr(getAxisColumnNames( (d3PropertyConfig.xAxisConfig && d3PropertyConfig.xAxisConfig.label) ||  Constants.xAxisName)[0])
                                    onTextChanged: {

                                        d3PropertyConfig.xAxisConfig = d3PropertyConfig.xAxisConfig || {};
                                        d3PropertyConfig.xAxisConfig.xlabel = xAxisLabelNameBox.text;
                                        // webEngineView.runJavaScript("setText('.x_label','"+xAxisLabelNameBox.text+"');")

                                    }
                                }
                            }

                            ///Font
                            Row{
                                width: parent.width
                                Text {
                                    text: Messages.re_mini_common_font
                                    width: parent.width/4
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Rectangle{
                                    height: nameInputRow.height
                                    width: parent.width*3/4
                                    CustomComboBox{
                                        id: xAxisLegendFonts
                                        width: parent.width
                                        textRole: "fontName"
                                        currentIndex: 5

                                        onCurrentValueChanged: {
                                            //                                                webEngineView.runJavaScript("changeChartAttributes('.x_label','font-family', '"+xAxisLegendFonts.currentValue+"')")

                                            d3PropertyConfig.xLabelfontFamily=xAxisLegendFonts.currentValue;
                                        }
                                    }
                                }

                            }

                            // Font Size

                            Row{
                                height: nameInputRow.height
                                width: parent.width

                                Text {
                                    text: Messages.re_mini_common_fontsize
                                    width: parent.width/4
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Row{
                                    anchors.right: parent.right
                                    width: parent.width*3/4
                                    height: parent.height
                                    spacing: 5

                                    Rectangle{
                                        height: parent.height
                                        width: parent.width/3 - parent.spacing
                                        border.width: 1
                                        border.color: Constants.borderBlueColor

                                        CustomComboBox{
                                            id:xAxisLabelFontSize
                                            model: fontSizes
                                            currentIndex: 4
                                            textRole: "size"
                                            width: parent.width
                                            onCurrentValueChanged: {

                                                //                                                    webEngineView.runJavaScript("changeChartAttributes('.x_label','font-size', '"+xAxisLabelFontSize.currentValue+"')")
                                                //                                                d3PropertyConfig["xLabelFontSize"]=xAxisLabelFontSize.currentValue;

                                                d3PropertyConfig.xLabelfontSize=xAxisLabelFontSize.currentValue;
                                            }
                                        }

                                    }




                                    Button {
                                        height: parent.height
                                        width: parent.width/3 - parent.spacing
                                        Text {
                                            anchors.centerIn: parent
                                            text: Messages.re_mini_common_B
                                            font.bold: true
                                        }
                                        onClicked: boldToggleXLabel();
                                        background: Rectangle{
                                            id:xAxisLabelBold
                                            border.width: 1
                                            border.color: Constants.borderBlueColor
                                            color: "transparent"
                                            height: parent.height
                                            width:parent.width
                                        }
                                    }







                                    Button {
                                        height: parent.height
                                        width: parent.width/3 - parent.spacing
                                        Text {
                                            anchors.centerIn: parent
                                            text: Messages.re_mini_common_I
                                            font.bold: true
                                            font.italic: true
                                        }

                                        onClicked: italicToggleXLabel();
                                        background: Rectangle{
                                            id:xAxisLabelItalilc
                                            border.width: 1
                                            border.color: Constants.borderBlueColor
                                            color: "transparent"
                                            height: parent.height
                                            width:parent.width
                                        }


                                    }
                                }

                            }

                            // Font Color
                            Row{
                                width: parent.width
                                Text {
                                    text: Messages.re_mini_common_fontColor
                                    width: parent.width/4
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Rectangle {

                                    id: xLabelFontColor
                                    color:  Constants.defaultXAxisLabelColor
                                    border.color: Constants.borderBlueColor
                                    width: 20
                                    height: 20
                                    MouseArea{
                                        anchors.fill: parent
                                        onClicked: openColorDialog("xAxisLegend");
                                    }
                                }
                            }

                        }

                    }

                }

                // Tick Marks

                Row{

                    height: (parent.height - 50)/2
                    width: parent.width

                    Rectangle{
                        width: parent.width/4 - 10
                        height: nameInputRow.height

                        Text {
                            text: Messages.re_mini_common_tickMark
                            anchors.left: parent.left
                            anchors.leftMargin: xaxisCheckbox.width
                            anchors.verticalCenter: parent.verticalCenter
                        }

                    }

                    Rectangle{
                        width: (parent.width*3)/4 - 20
                        height: parent.height

                        Column{
                            anchors.fill: parent
                            spacing: 10



                            ///Font
                            Row{
                                width: parent.width
                                Text {
                                    text: Messages.re_mini_common_font
                                    width: parent.width/4
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Rectangle{
                                    height: nameInputRow.height
                                    width: parent.width*3/4
                                    CustomComboBox{
                                        id: xAxisTickMarkFonts
                                        width: parent.width
                                        textRole: "fontName"

                                        onCurrentValueChanged: {

                                            //                                                webEngineView.runJavaScript("changeChartAttributes('.x-axis text','font-family', '"+xAxisTickMarkFonts.currentValue+"')")

                                            d3PropertyConfig.xTickfontFamily=xAxisTickMarkFonts.currentValue;

                                        }
                                    }
                                }

                            }

                            // Font Size

                            Row{
                                height: nameInputRow.height
                                width: parent.width

                                Text {
                                    text: Messages.re_mini_common_fontsize
                                    width: parent.width/4
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Row{
                                    anchors.right: parent.right
                                    width: parent.width*3/4
                                    height: parent.height
                                    spacing: 5

                                    Rectangle{
                                        height: parent.height
                                        width: parent.width/3 - parent.spacing
                                        border.width: 1
                                        border.color: Constants.borderBlueColor

                                        CustomComboBox{
                                            id:xAxisTickMarkFontSize
                                            model: fontSizes
                                            currentIndex: 4
                                            
                                            textRole: "size"
                                            width: parent.width
                                            onCurrentValueChanged: {
                                                console.log("fontsize"+xAxisTickMarkFontSize.currentValue);
                                                //                                                webEngineView.runJavaScript("changeChartAttributes('.x-axis text','font-size', '"+xAxisTickMarkFontSize.currentValue+"');changeLabelPostionsAttributes('.x-axis .tick text','.x_label','y')")
                                                d3PropertyConfig.xTickfontSize=xAxisTickMarkFontSize.currentValue;
                                            }
                                        }

                                    }




                                    Button {
                                        height: parent.height
                                        width: parent.width/3 - parent.spacing
                                        Text {
                                            anchors.centerIn: parent
                                            text: Messages.re_mini_common_B
                                            font.bold: true
                                        }
                                        onClicked: boldToggleXTick();
                                        background: Rectangle{
                                            id:xAxisTickBold
                                            border.width: 1
                                            border.color: Constants.borderBlueColor
                                            color: "transparent"
                                            height: parent.height
                                            width:parent.width
                                        }
                                    }







                                    Button {
                                        height: parent.height
                                        width: parent.width/3 - parent.spacing
                                        Text {
                                            anchors.centerIn: parent
                                            text: Messages.re_mini_common_I
                                            font.bold: true
                                            font.italic: true
                                        }
                                        onClicked: italicToggleXTick();
                                        background: Rectangle{
                                            id:xAxisTickItalilc
                                            border.width: 1
                                            border.color: Constants.borderBlueColor
                                            color: "transparent"
                                            height: parent.height
                                            width:parent.width
                                        }
                                    }



                                }

                            }

                            // Font Color
                            Row{
                                width: parent.width
                                Text {
                                    text: Messages.re_mini_common_fontColor
                                    width: parent.width/4
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Rectangle {
                                    id: xTickFontColor
                                    color: Constants.defaultXAxisTickColor
                                    //                                    {
                                    //                                        Qt.binding(function() {console.log("testbinding",chartPropertyConfig.axisSettings.xAxisTickMarkColorDialog)
                                    //                                            return Constants.defaultXAxisTickColor })}
                                    //                                    color:Constants.defaultXAxisTickColor
                                    //                                    {
                                    //                                        console.log("chartproperty",chartPropertyConfig.axisSettings && chartPropertyConfig.axisSettings.xAxisTickMarkColorDialog)
                                    //                                         (chartPropertyConfig.axisSettings && chartPropertyConfig.axisSettings.xAxisTickMarkColorDialog || Constants.defaultXAxisTickColor)
                                    //                                    }
                                    border.color: Constants.borderBlueColor
                                    width: 20
                                    height: 20
                                    MouseArea{
                                        anchors.fill: parent
                                        onClicked: openColorDialog("xAxisTickMark");
                                    }
                                }
                            }

                        }

                    }

                }

                // Y Axis

                Row{

                    height: 50

                    CheckBoxTpl{
                        id:yaxisCheckbox
                        checked: yAxisLabelStatus
                        parent_dimension: Constants.defaultCheckBoxDimension
                        anchors.verticalCenter: parent.verticalCenter
                        onCheckStateChanged: {
                            d3PropertyConfig.yAxisConfig = d3PropertyConfig.yAxisConfig || {};
                            d3PropertyConfig.yAxisConfig.yaxisStatus = checked;
                            yAxisLabelStatus = checked;
                        }
                    }

                    Text {
                        text: Messages.re_mini_common_yAxis
                        anchors.verticalCenter: parent.verticalCenter
                    }

                }

                // Label
                Row{

                    height: (parent.height - 50)/2
                    width: parent.width

                    Rectangle{
                        width: parent.width/4 - 10
                        height: nameInputRow.height

                        Text {
                            text: Messages.re_mini_common_label
                            anchors.left: parent.left
                            anchors.leftMargin: xaxisCheckbox.width
                            anchors.verticalCenter: parent.verticalCenter
                        }

                    }

                    Rectangle{
                        width: (parent.width*3)/4 - 20
                        height: parent.height

                        Column{
                            anchors.fill: parent
                            spacing: 10

                            // Name Input
                            Row{
                                width: parent.width
                                Text {
                                    text: Messages.re_mini_common_name
                                    width: parent.width/4
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                CustomTextBox {
                                    id:yAxisLabelNameBox
                                    width: parent.width*3/4
                                    //                                      text: qsTr(ReportParamsModel.yAxisColumns[0])
                                    text: getAxisColumnNames( (d3PropertyConfig.yAxisConfig && d3PropertyConfig.yAxisConfig.label) ||  Constants.yAxisName)[0]
                                    onTextChanged: {


                                        d3PropertyConfig.yAxisConfig = d3PropertyConfig.yAxisConfig || {};
                                        d3PropertyConfig.yAxisConfig.ylabel = yAxisLabelNameBox.text;

                                        // webEngineView.runJavaScript("setText('.y_label','"+yAxisLabelNameBox.text+"');")

                                    }
                                }
                            }

                            ///Font
                            Row{
                                width: parent.width
                                Text {
                                    text: Messages.re_mini_common_font
                                    width: parent.width/4
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Rectangle{
                                    height: nameInputRow.height
                                    width: parent.width*3/4
                                    CustomComboBox{
                                        id: yAxisLegendFonts
                                        width: parent.width
                                        textRole: "fontName"
                                        onCurrentValueChanged: {
                                            //                                                webEngineView.runJavaScript("changeChartAttributes('.y_label','font-family', '"+yAxisLegendFonts.currentValue+"')")

                                            d3PropertyConfig.yLabelfontFamily=yAxisLegendFonts.currentValue;
                                        }
                                    }
                                }

                            }

                            // Font Size

                            Row{
                                height: nameInputRow.height
                                width: parent.width

                                Text {
                                    text: Messages.re_mini_common_fontsize
                                    width: parent.width/4
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Row{
                                    anchors.right: parent.right
                                    width: parent.width*3/4
                                    height: parent.height
                                    spacing: 5

                                    Rectangle{
                                        height: parent.height
                                        width: parent.width/3 - parent.spacing
                                        border.width: 1
                                        border.color: Constants.borderBlueColor

                                        CustomComboBox{
                                            id:yAxisLabelFontSize
                                            model: fontSizes
                                            currentIndex: 4
                                            textRole: "size"
                                            width: parent.width
                                            onCurrentValueChanged: {
                                                console.log("fontsize"+yAxisLabelFontSize.currentValue);
                                                //                                              webEngineView.runJavaScript("changeChartAttributes('.y_label','font-size', '"+yAxisLabelFontSize.currentValue+"')")
                                                d3PropertyConfig.yLabelfontSize=yAxisLabelFontSize.currentValue;
                                            }
                                        }

                                    }




                                    Button {
                                        height: parent.height
                                        width: parent.width/3 - parent.spacing
                                        Text {
                                            anchors.centerIn: parent
                                            text: Messages.re_mini_common_B
                                            font.bold: true
                                        }
                                        onClicked: boldToggleYLabel();
                                        background: Rectangle{
                                            id:yAxisLabelBold
                                            border.width: 1
                                            border.color: Constants.borderBlueColor
                                            color: "transparent"
                                            height: parent.height
                                            width:parent.width
                                        }
                                    }





                                    Button {
                                        height: parent.height
                                        width: parent.width/3 - parent.spacing
                                        Text {
                                            anchors.centerIn: parent
                                            text: Messages.re_mini_common_I
                                            font.bold: true
                                            font.italic: true
                                        }
                                        onClicked: italicToggleYLabel();
                                        background: Rectangle{
                                            id:yAxisLabelItalilc
                                            border.width: 1
                                            border.color: Constants.borderBlueColor
                                            color: "transparent"
                                            height: parent.height
                                            width:parent.width
                                        }
                                    }



                                }

                            }

                            // Font Color
                            Row{
                                width: parent.width
                                Text {
                                    text: Messages.re_mini_common_fontColor
                                    width: parent.width/4
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Rectangle {
                                    id: yLabelFontColor
                                    color: Constants.defaultYAxisLabelColor
                                    border.color: Constants.borderBlueColor
                                    width: 20
                                    height: 20
                                    MouseArea{
                                        anchors.fill: parent
                                        onClicked: openColorDialog("yAxisLegend");
                                    }
                                }
                            }

                        }

                    }

                }

                // Tick Marks
                Row{

                    height: (parent.height - 50)/2
                    width: parent.width

                    Rectangle{
                        width: parent.width/4 - 10
                        height: nameInputRow.height

                        Text {
                            text: Messages.re_mini_common_tickMark
                            anchors.left: parent.left
                            anchors.leftMargin: xaxisCheckbox.width
                            anchors.verticalCenter: parent.verticalCenter
                        }

                    }

                    Rectangle{
                        width: (parent.width*3)/4 - 20
                        height: parent.height

                        Column{
                            anchors.fill: parent
                            spacing: 10



                            ///Font
                            Row{
                                width: parent.width
                                Text {
                                    text: Messages.re_mini_common_font
                                    width: parent.width/4
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Rectangle{
                                    height: nameInputRow.height
                                    width: parent.width*3/4
                                    CustomComboBox{
                                        id: yAxisTickMarkFonts
                                        width: parent.width
                                        textRole: "fontName"
                                        onCurrentValueChanged: {

                                            //                                                      webEngineView.runJavaScript("changeChartAttributes('.y-axis text','font-family', '"+yAxisTickMarkFonts.currentValue+"')")

                                            d3PropertyConfig.yTickfontFamily=yAxisTickMarkFonts.currentValue;
                                        }


                                    }
                                }

                            }

                            // Font Size

                            Row{
                                height: nameInputRow.height
                                width: parent.width

                                Text {
                                    text: Messages.re_mini_common_fontsize
                                    width: parent.width/4
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Row{
                                    anchors.right: parent.right
                                    width: parent.width*3/4
                                    height: parent.height
                                    spacing: 5

                                    Rectangle{
                                        height: parent.height
                                        width: parent.width/3 - parent.spacing
                                        border.width: 1
                                        border.color: Constants.borderBlueColor

                                        CustomComboBox{
                                            id:yAxisTickMarkFontSize
                                            model: fontSizes
                                            textRole: "size"
                                            currentIndex: 4
                                            width: parent.width
                                            onCurrentValueChanged: {
                                                console.log("fontsize"+yAxisTickMarkFontSize.currentValue);
                                                //                                                    webEngineView.runJavaScript("changeChartAttributes('.y-axis text','font-size', '"+yAxisTickMarkFontSize.currentValue+"');changeLabelPostionsAttributes('.y-axis .tick text','.y_label','y')")

                                                d3PropertyConfig.yTickfontSize=yAxisTickMarkFontSize.currentValue;
                                            }
                                        }

                                    }




                                    Button {
                                        height: parent.height
                                        width: parent.width/3 - parent.spacing
                                        Text {
                                            anchors.centerIn: parent
                                            text: Messages.re_mini_common_B
                                            font.bold: true
                                        }
                                        onClicked: boldToggleYTick();
                                        background: Rectangle{
                                            id:yAxisTickBold
                                            border.width: 1
                                            border.color: Constants.borderBlueColor
                                            color: "transparent"
                                            height: parent.height
                                            width:parent.width
                                        }
                                    }





                                    Button {
                                        height: parent.height
                                        width: parent.width/3 - parent.spacing
                                        Text {
                                            anchors.centerIn: parent
                                            text: Messages.re_mini_common_I
                                            font.bold: true
                                            font.italic: true
                                        }
                                        onClicked: italicToggleYTick();
                                        background: Rectangle{
                                            id:yAxisTickItalilc
                                            border.width: 1
                                            border.color: Constants.borderBlueColor
                                            color: "transparent"
                                            height: parent.height
                                            width:parent.width
                                        }
                                    }



                                }

                            }

                            // Font Color
                            Row{
                                width: parent.width
                                Text {
                                    text: Messages.re_mini_common_fontColor
                                    width: parent.width/4
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Rectangle {
                                    id: yTickFontColor
                                    color: Constants.defaultYAxisTickColor
                                    border.color: Constants.borderBlueColor
                                    width: 20
                                    height: 20
                                    MouseArea{
                                        anchors.fill: parent
                                        onClicked: openColorDialog("yAxisTickMark");
                                    }

                                }
                            }

                        }

                    }

                }


            }

        }

    }

    Rectangle{

        id: axisSettingsFooter
        height: 50
        color: "red"
        anchors.top: axisSettingsContent.bottom
        anchors.right: parent.right

        Row{
            anchors.right: parent.right
            anchors.rightMargin: 40
            spacing: 10

            CustomButton{
                textValue: "Cancel"
                anchors.verticalCenter: parent.verticalCenter
                onClicked: onCancelClicked()
            }
            CustomButton{
                textValue: "Apply"
                anchors.verticalCenter: parent.verticalCenter
                onClicked: onApplyClicked()
            }
        }
    }
}
