import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2

import com.grafieks.singleton.constants 1.0

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

    function onApplyClicked(){
        popup.visible = false
        webEngineView.runJavaScript("changeChartAttributes(selector, attributeName, attributeValue)")
    }

    //    bold
    function boldToggleYLabel(){

        d3PropertyConfig.yAxisConfig = d3PropertyConfig.yAxisConfig || {};
        
        if(toggleBoldYLabel == false){
            toggleBoldYLabel = true;
            yAxisLabelBold.color="lightGrey"
            // webEngineView.runJavaScript("changeChartAttributes('.y_label','font-weight','bold')")
            d3PropertyConfig.yAxisConfig.boldLabel = true;
        }
        else if(toggleBoldYLabel == true){
            toggleBoldYLabel = false;
            yAxisLabelBold.color="transparent"
            d3PropertyConfig.yAxisConfig.boldLabel = false;
            // webEngineView.runJavaScript("changeChartAttributes('.y_label','font-weight','normal')")
        }
        console.log("bold"+toggleBoldYLabel)

    }
    function boldToggleXLabel(){

        d3PropertyConfig.xAxisConfig = d3PropertyConfig.xAxisConfig || {};

        if(toggleBoldXLabel == false){
            toggleBoldXLabel = true;
            xAxisLabelBold.color="lightGrey"
            // webEngineView.runJavaScript("changeChartAttributes('.x_label','font-weight','bold')")
            d3PropertyConfig.xAxisConfig.boldLabel = true;
        }

        else if(toggleBoldXLabel == true){
            toggleBoldXLabel = false;
            xAxisLabelBold.color="transparent";
            d3PropertyConfig.xAxisConfig.boldLabel = false;
            // webEngineView.runJavaScript("changeChartAttributes('.x_label','font-weight','normal')")

        }
        console.log("bold"+toggleBoldXLabel)

    }
    function boldToggleXTick(){

        d3PropertyConfig.xAxisConfig = d3PropertyConfig.xAxisConfig || {};

        if(toggleBoldXTick == false){
            toggleBoldXTick = true;
            xAxisTickBold.color="lightGrey"

            d3PropertyConfig.xAxisConfig.boldTick = true;
            // webEngineView.runJavaScript("changeChartAttributes('.x-axis text','font-weight','bold')")


        }
        else if(toggleBoldXTick == true){
            toggleBoldXTick = false;
            xAxisTickBold.color="transparent"
            d3PropertyConfig.xAxisConfig.boldTick = false;
            // webEngineView.runJavaScript("changeChartAttributes('.x-axis text','font-weight','normal')")
        }
        console.log("bold"+toggleBoldXTick)

    }
    function boldToggleYTick(){

        d3PropertyConfig.yAxisConfig = d3PropertyConfig.yAxisConfig || {};

        if(toggleBoldYTick == false){
            toggleBoldYTick = true;
            yAxisTickBold.color="lightGrey"
            d3PropertyConfig.yAxisConfig.boldTick = true;
            // webEngineView.runJavaScript("changeChartAttributes('.y-axis text','font-weight','bold')")

        }
        else if(toggleBoldYTick == true){
            toggleBoldYTick = false;
            yAxisTickBold.color="transparent"
            d3PropertyConfig.yAxisConfig.boldTick = false;
            // webEngineView.runJavaScript("changeChartAttributes('.y-axis text','font-weight','normal')")
        }
        console.log("bold"+toggleBoldYTick)

    }

    //    italic
    function italicToggleXLabel(){

        d3PropertyConfig.xAxisConfig = d3PropertyConfig.xAxisConfig || {};

        if(toggleItalicXLabel == false){
            toggleItalicXLabel = true;
            xAxisLabelItalilc.color="lightGrey"
            // webEngineView.runJavaScript("changeChartAttributes('.x_label','font-style','italic')")
            d3PropertyConfig.xAxisConfig.italicLabel = true;

        }
        else if(toggleItalicXLabel == true){
            toggleItalicXLabel = false;
            xAxisLabelItalilc.color="transparent"
            d3PropertyConfig.xAxisConfig.italicLabel = false;

            // webEngineView.runJavaScript("changeChartAttributes('.x_label','font-style','normal')")
        }
        console.log("bold"+toggleItalicXLabel)

    }
    function italicToggleYLabel(){

        d3PropertyConfig.yAxisConfig = d3PropertyConfig.yAxisConfig || {};

        if(toggleItalicYLabel == false){
            toggleItalicYLabel = true;
            yAxisLabelItalilc.color="lightGrey"
            d3PropertyConfig.yAxisConfig.italicLabel = true;

            // webEngineView.runJavaScript("changeChartAttributes('.y_label','font-style','italic')")


        }
        else if(toggleItalicYLabel == true){
            toggleItalicYLabel = false;
            yAxisLabelItalilc.color="transparent"
            d3PropertyConfig.yAxisConfig.italicLabel = false;
            // webEngineView.runJavaScript("changeChartAttributes('.y_label','font-style','normal')")
        }
        console.log("bold"+toggleItalicYLabel)

    }
    function italicToggleXTick(){

        d3PropertyConfig.xAxisConfig = d3PropertyConfig.xAxisConfig || {};

        if(toggleItalicXTick == false){
            toggleItalicXTick = true;
            xAxisTickItalilc.color="lightGrey"
            // webEngineView.runJavaScript("changeChartAttributes('.x-axis text','font-style','italic')")
            d3PropertyConfig.xAxisConfig.italicTick = true;


        }
        else if(toggleItalicXTick == true){
            toggleItalicXTick = false;
            xAxisTickItalilc.color="transparent"
            d3PropertyConfig.xAxisConfig.italicTick = false;
            // webEngineView.runJavaScript("changeChartAttributes('.x-axis text','font-style','normal')")
        }
        console.log("bold"+toggleItalicYLabel)

    }
    function italicToggleYTick(){

        d3PropertyConfig.yAxisConfig = d3PropertyConfig.yAxisConfig || {};

        if(toggleItalicYTick == false){
            toggleItalicYTick = true;
            yAxisTickItalilc.color="lightGrey"

            d3PropertyConfig.yAxisConfig.italicTick = true;

            // webEngineView.runJavaScript("changeChartAttributes('.y-axis text','font-style','italic')")


        }
        else if(toggleItalicYTick == true){
            toggleItalicYTick = false;
            yAxisTickItalilc.color="transparent"
            d3PropertyConfig.yAxisConfig.italicTick = false;

            // webEngineView.runJavaScript("changeChartAttributes('.y-axis text','font-style','normal')")
        }
        console.log("bold"+toggleItalicYTick)

    }





    Component.onCompleted: {
        let fontFamilies = Qt.fontFamilies();
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
                        checked: true
                        parent_dimension: Constants.defaultCheckBoxDimension
                        anchors.verticalCenter: parent.verticalCenter
                        onCheckStateChanged: {
                            if(xaxisCheckbox.checked){

                                webEngineView.runJavaScript("changeChartAttributes('g .x-axis','style','display: block');changeChartAttributes('.x_label','style','display: block');")


                            }
                            else{
                                webEngineView.runJavaScript("changeChartAttributes('g .x-axis','style','display: none');changeChartAttributes('.x_label','style','display: none');")


                            }
                        }
                    }

                    Text {
                        text: qsTr("X Axis")
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
                            text: qsTr("Label")
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
                                    text: qsTr("Name: ")
                                    width: parent.width/4
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                CustomTextBox {

                                    id:xAxisLabelNameBox
                                    width: parent.width*3/4
                                    //                                    text: qsTr(ReportParamsModel.xAxisColumns[0])
                                    //                                    text: getAxisColumnNames(Constants.yAxisName)
                                    text: qsTr(getAxisColumnNames(Constants.xAxisName)[0])
                                    onTextChanged: {

                                        webEngineView.runJavaScript("setText('.x_label','"+xAxisLabelNameBox.text+"');")

                                    }
                                }
                            }

                            ///Font
                            Row{
                                width: parent.width
                                Text {
                                    text: qsTr("Font: ")
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
                                            reDrawChart();
                                        }
                                    }
                                }

                            }

                            // Font Size

                            Row{
                                height: nameInputRow.height
                                width: parent.width

                                Text {
                                    text: qsTr("Font Size:")
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
                                                reDrawChart();
                                            }
                                        }

                                    }




                                    Button {
                                        height: parent.height
                                        width: parent.width/3 - parent.spacing
                                        Text {
                                            anchors.centerIn: parent
                                            text: qsTr("B")
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
                                            text: qsTr("I")
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
                                    text: qsTr("Font Color: ")
                                    width: parent.width/4
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Rectangle {


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
                            text: qsTr("Tick Mark")
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
                                    text: qsTr("Font: ")
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
                                            reDrawChart();

                                        }
                                    }
                                }

                            }

                            // Font Size

                            Row{
                                height: nameInputRow.height
                                width: parent.width

                                Text {
                                    text: qsTr("Font Size:")
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
                                                reDrawChart();
                                            }
                                        }

                                    }




                                    Button {
                                        height: parent.height
                                        width: parent.width/3 - parent.spacing
                                        Text {
                                            anchors.centerIn: parent
                                            text: qsTr("B")
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
                                            text: qsTr("I")
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
                                    text: qsTr("Font Color: ")
                                    width: parent.width/4
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Rectangle {
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
                        checked: true
                        parent_dimension: Constants.defaultCheckBoxDimension
                        anchors.verticalCenter: parent.verticalCenter
                        onCheckStateChanged: {
                            if(yaxisCheckbox.checked){

                                webEngineView.runJavaScript("changeChartAttributes('g .y-axis','style','display: block');changeChartAttributes('.y_label','style','display: block');")

                            }
                            else{
                                webEngineView.runJavaScript("changeChartAttributes('g .y-axis','style','display: none');changeChartAttributes('.y_label','style','display: none');")


                            }
                        }
                    }

                    Text {
                        text: qsTr("Y Axis")
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
                            text: qsTr("Label")
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
                                    text: qsTr("Name: ")
                                    width: parent.width/4
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                CustomTextBox {
                                    id:yAxisLabelNameBox
                                    width: parent.width*3/4
                                    //                                      text: qsTr(ReportParamsModel.yAxisColumns[0])
                                    text: qsTr(getAxisColumnNames(Constants.yAxisName)[0])
                                    onTextChanged: {

                                        webEngineView.runJavaScript("setText('.y_label','"+yAxisLabelNameBox.text+"');")

                                    }
                                }
                            }

                            ///Font
                            Row{
                                width: parent.width
                                Text {
                                    text: qsTr("Font: ")
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
                                            reDrawChart();
                                        }
                                    }
                                }

                            }

                            // Font Size

                            Row{
                                height: nameInputRow.height
                                width: parent.width

                                Text {
                                    text: qsTr("Font Size:")
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
                                                reDrawChart();
                                            }
                                        }

                                    }




                                    Button {
                                        height: parent.height
                                        width: parent.width/3 - parent.spacing
                                        Text {
                                            anchors.centerIn: parent
                                            text: qsTr("B")
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
                                            text: qsTr("I")
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
                                    text: qsTr("Font Color: ")
                                    width: parent.width/4
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Rectangle {
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
                            text: qsTr("Tick Marks")
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
                                    text: qsTr("Font: ")
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
                                            reDrawChart();
                                        }


                                    }
                                }

                            }

                            // Font Size

                            Row{
                                height: nameInputRow.height
                                width: parent.width

                                Text {
                                    text: qsTr("Font Size:")
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
                                                reDrawChart();
                                            }
                                        }

                                    }




                                    Button {
                                        height: parent.height
                                        width: parent.width/3 - parent.spacing
                                        Text {
                                            anchors.centerIn: parent
                                            text: qsTr("B")
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
                                            text: qsTr("I")
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
                                    text: qsTr("Font Color: ")
                                    width: parent.width/4
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Rectangle {
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
