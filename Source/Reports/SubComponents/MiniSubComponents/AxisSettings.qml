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
        width: parent.width
        height: parent.height - axisSettingsFooter.height

        Rectangle{
            height: (parent.height - parent.spacing) / 2
            width: parent.width

            Column{

                anchors.fill: parent
                anchors.left: parent.left
                spacing: 0

                // X Axis
                Row{

                    height: 50
                    CheckBoxTpl{
                        id: xaxisCheckbox
                        checked: false
                        parent_dimension: Constants.defaultCheckBoxDimension
                        anchors.verticalCenter: parent.verticalCenter
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
                                    width: parent.width*3/4
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
                                    color: Constants.defaultColorDialogColor
                                    border.color: Constants.borderBlueColor
                                    width: 50
                                    height: nameInputRow.height
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

                            // Name Input
                            Row{
                                width: parent.width
                                Text {
                                    text: qsTr("Name: ")
                                    width: parent.width/4
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                CustomTextBox {
                                    width: parent.width*3/4
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
                                        id: xAxisTickMarkFonts
                                        width: parent.width
                                        textRole: "fontName"
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
                                    color: Constants.defaultColorDialogColor
                                    border.color: Constants.borderBlueColor
                                    width: 50
                                    height: nameInputRow.height
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
                        checked: false
                        parent_dimension: Constants.defaultCheckBoxDimension
                        anchors.verticalCenter: parent.verticalCenter
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

                            // Name Input
                            Row{
                                width: parent.width
                                Text {
                                    text: qsTr("Name: ")
                                    width: parent.width/4
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                CustomTextBox {
                                    width: parent.width*3/4
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
                                    color: Constants.defaultColorDialogColor
                                    border.color: Constants.borderBlueColor
                                    width: 50
                                    height: nameInputRow.height
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
                                    width: parent.width*3/4
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
                                        id: yAxisTickMarkFonts
                                        width: parent.width
                                        textRole: "fontName"
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
                                    color: Constants.defaultColorDialogColor
                                    border.color: Constants.borderBlueColor
                                    width: 50
                                    height: nameInputRow.height
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
                onClicked: onCancelClicked()
            }
        }
    }
}
