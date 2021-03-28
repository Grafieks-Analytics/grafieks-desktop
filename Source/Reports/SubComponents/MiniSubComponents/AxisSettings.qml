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
        ListElement{
            size: 22
        }
        ListElement{
            size: 24
        }
        ListElement{
            size: 28
        }
        ListElement{
            size: 32
        }
        ListElement{
            size: 48
        }
        ListElement{
            size: 64
        }
        ListElement{
            size: 78
        }
    }


    // LIST MODEL ENDS
    /***********************************************************************************************************************/

    //javascript function

    function onApplyClicked(){
        popup.visible = false
        webEngineView.runJavaScript("changeChartAttributes(selector, attributeName, attributeValue)")
    }



    Component.onCompleted: {
        let fontFamilies = Qt.fontFamilies();
        for(let i=0; i<fontFamilies.length;i++){
            fonts.append({"fontName": fontFamilies[i]});
        }
        xAxisLegendFonts.model = fonts;
        xAxisTickMarkFonts.model = fonts;
        yAxisLegendFonts.model = fonts;
        yAxisTickMarkFonts.model = fonts;

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
                                    text: qsTr(ReportParamsModel.xAxisColumns[0])
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

                                        onCurrentValueChanged: {
                                                webEngineView.runJavaScript("changeChartAttributes('.x_label','font-family', '"+xAxisLegendFonts.currentValue+"')")

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
                                            textRole: "size"
                                            width: parent.width
                                            onCurrentValueChanged: {

                                                    webEngineView.runJavaScript("changeChartAttributes('.x_label','font-size', '"+xAxisLabelFontSize.currentValue+"')")

                                            }
                                        }

                                    }

                                    Rectangle{
                                        height: parent.height
                                        width: parent.width/3 - parent.spacing
                                        border.width: 1
                                        border.color: Constants.borderBlueColor
                                        Text {
                                            anchors.centerIn: parent
                                            text: qsTr("B")
                                            font.bold: true
                                        }
                                    }

                                    Rectangle{
                                        height: parent.height
                                        width: parent.width/3 - parent.spacing
                                        border.width: 1
                                        border.color: Constants.borderBlueColor
                                        Text {
                                            anchors.centerIn: parent
                                            text: qsTr("I")
                                            font.bold: true
                                            font.italic: true
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

                                                webEngineView.runJavaScript("changeChartAttributes('.x-axis text','font-family', '"+xAxisTickMarkFonts.currentValue+"')")

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
                                            textRole: "size"
                                            width: parent.width
                                            onCurrentValueChanged: {
                                                console.log("fontsize"+xAxisTickMarkFontSize.currentValue);
                                                    webEngineView.runJavaScript("changeChartAttributes('.x-axis text','font-size', '"+xAxisTickMarkFontSize.currentValue+"')")

                                            }
                                        }

                                    }

                                    Rectangle{
                                        height: parent.height
                                        width: parent.width/3 - parent.spacing
                                        border.width: 1
                                        border.color: Constants.borderBlueColor
                                        Text {
                                            anchors.centerIn: parent
                                            text: qsTr("B")
                                            font.bold: true
                                        }
                                    }

                                    Rectangle{
                                        height: parent.height
                                        width: parent.width/3 - parent.spacing
                                        border.width: 1
                                        border.color: Constants.borderBlueColor
                                        Text {
                                            anchors.centerIn: parent
                                            text: qsTr("I")
                                            font.bold: true
                                            font.italic: true
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
                                      text: qsTr(ReportParamsModel.yAxisColumns[0])
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
                                                webEngineView.runJavaScript("changeChartAttributes('.y_label','font-family', '"+yAxisLegendFonts.currentValue+"')")

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
                                            model: fontSizes
                                            textRole: "size"
                                            width: parent.width
                                        }

                                    }

                                    Rectangle{
                                        height: parent.height
                                        width: parent.width/3 - parent.spacing
                                        border.width: 1
                                        border.color: Constants.borderBlueColor
                                        Text {
                                            anchors.centerIn: parent
                                            text: qsTr("B")
                                            font.bold: true
                                        }
                                    }

                                    Rectangle{
                                        height: parent.height
                                        width: parent.width/3 - parent.spacing
                                        border.width: 1
                                        border.color: Constants.borderBlueColor
                                        Text {
                                            anchors.centerIn: parent
                                            text: qsTr("I")
                                            font.bold: true
                                            font.italic: true
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

                                                      webEngineView.runJavaScript("changeChartAttributes('.y-axis text','font-family', '"+yAxisTickMarkFonts.currentValue+"')")

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
                                            width: parent.width
                                            onCurrentValueChanged: {
                                                console.log("fontsize"+yAxisTickMarkFontSize.currentValue);
                                                    webEngineView.runJavaScript("changeChartAttributes('.y-axis text','font-size', '"+yAxisTickMarkFontSize.currentValue+"')")

                                            }
                                        }

                                    }

                                    Rectangle{
                                        height: parent.height
                                        width: parent.width/3 - parent.spacing
                                        border.width: 1
                                        border.color: Constants.borderBlueColor
                                        Text {
                                            anchors.centerIn: parent
                                            text: qsTr("B")
                                            font.bold: true
                                        }
                                    }

                                    Rectangle{
                                        height: parent.height
                                        width: parent.width/3 - parent.spacing
                                        border.width: 1
                                        border.color: Constants.borderBlueColor
                                        Text {
                                            anchors.centerIn: parent
                                            text: qsTr("I")
                                            font.bold: true
                                            font.italic: true
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
