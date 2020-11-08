import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents";

Popup {

    id: popup
    width: parent.width * 0.5
    height: 800
    anchors.centerIn: parent

    visible: true
    modal: true
    padding: 0
    closePolicy: Popup.NoAutoClose

    background: Rectangle{
        color: Constants.whiteColor
    }



    /***********************************************************************************************************************/
    // LIST MODEL STARTS

    ListModel{
        id: fonts
        ListElement{
            menuItem:"Default"
        }
        ListElement{
            menuItem:"Bottom"
        }
    }

    // LIST MODEL ENDS
    /***********************************************************************************************************************/


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

    function onCancelClicked(){
        popup.visible = false
    }


    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



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
            text: Constants.axisSettingText
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
                onClicked: onCancelClicked()
            }
        }

    }

    // Popup Header Ends

    Rectangle{
        anchors.top: header.bottom
        height: parent.height - header.height
        width: parent.width

        // Left menu starts
        Rectangle{
            id: leftMenu
            width: 200
            height: parent.height

            Column{
                anchors.top: parent.top
                anchors.topMargin: 10
                width: parent.width
                height: parent.height - 10
                spacing: 5

                Rectangle{
                    id: axisMenubutton
                    height: 40
                    width: parent.width

                    Rectangle{
                        id: axisMenuRectangle
                        height: 38
                        width: parent.width - 40
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        color: Constants.themeColor

                        Text {
                            id: axisMenuText
                            text: qsTr("Axis")
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 30
                            font.pixelSize:  Constants.fontCategoryHeader
                        }

                    }

                    Rectangle{
                        id: borderAxis
                        anchors.bottom: axisMenubutton.bottom
                        height: 2
                        width: parent.width - 40
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        color: Constants.grafieksGreenColor
                    }

                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: axisMenuRectangle.color =  Constants.darkThemeColor
                        onExited: axisMenuRectangle.color =  Constants.themeColor
                        onClicked: {
                            borderMultipleAxis.visible =  false
                            borderAxis.visible =  true
                        }
                    }
                }

                Rectangle{
                    id: multipleAxisMenubutton
                    height: 40
                    width: parent.width

                    Rectangle{
                        id: multipleAxisMenuRectangle
                        height: 38
                        width: parent.width - 40
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        color: Constants.themeColor

                        Text {
                            id: multipleAxisMenuText
                            text: qsTr("Multiple Axis")
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 30
                            font.pixelSize:  Constants.fontCategoryHeader
                        }

                    }

                    Rectangle{
                        id: borderMultipleAxis
                        anchors.bottom: multipleAxisMenubutton.bottom
                        height: 2
                        width: parent.width - 40
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        color: Constants.grafieksGreenColor
                        visible: false
                    }

                    MouseArea{
                        hoverEnabled: true
                        anchors.fill: parent
                        onClicked: {
                            borderMultipleAxis.visible =  true
                            borderAxis.visible =  false
                        }
                        onEntered: multipleAxisMenuRectangle.color =  Constants.darkThemeColor
                        onExited: multipleAxisMenuRectangle.color =  Constants.themeColor
                    }
                }

            }

        }

        // Left menu ends

        ToolSeparator{
            id: menuContentSeparator
            anchors.left: leftMenu.right
            orientation: Qt.Vertical
            height: parent.height
            width: 1
            background: Rectangle{
                color: Constants.darkThemeColor
            }
        }

        // Content Starts

        Rectangle{
            anchors.left: menuContentSeparator.right
            height: parent.height
            width: parent.width - leftMenu.width - menuContentSeparator.width

            Column
            {

                anchors.fill: parent

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
                                            SelectDropdown{
                                                textValue:"Default"
                                                list: Qt.fontFamilies()
                                            }
                                        }

                                    }

                                    // Font Size

                                    Row{
                                        height: nameInputRow.height
                                        width: parent.width

                                        Text {
                                            text: qsTr("Font Size: 2")
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
                                            }

                                            Rectangle{
                                                height: parent.height
                                                width: parent.width/3 - parent.spacing
                                                border.width: 1
                                                border.color: Constants.borderBlueColor
                                            }

                                            Rectangle{
                                                height: parent.height
                                                width: parent.width/3 - parent.spacing
                                                border.width: 1
                                                border.color: Constants.borderBlueColor
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
                                            color: "black"
                                            border.color: Constants.borderBlueColor
                                            width: 50
                                            height: nameInputRow.height
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
                                            SelectDropdown{
                                                textValue:"Default"
                                                list: Qt.fontFamilies()
                                            }
                                        }

                                    }

                                    // Font Size

                                    Row{
                                        height: nameInputRow.height
                                        width: parent.width

                                        Text {
                                            text: qsTr("Font Size: 2")
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
                                            }

                                            Rectangle{
                                                height: parent.height
                                                width: parent.width/3 - parent.spacing
                                                border.width: 1
                                                border.color: Constants.borderBlueColor
                                            }

                                            Rectangle{
                                                height: parent.height
                                                width: parent.width/3 - parent.spacing
                                                border.width: 1
                                                border.color: Constants.borderBlueColor
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
                                            color: "black"
                                            border.color: Constants.borderBlueColor
                                            width: 50
                                            height: nameInputRow.height
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
                                            SelectDropdown{
                                                textValue:"Default"
                                                list: Qt.fontFamilies()
                                            }
                                        }

                                    }

                                    // Font Size

                                    Row{
                                        height: nameInputRow.height
                                        width: parent.width

                                        Text {
                                            text: qsTr("Font Size: 2")
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
                                            }

                                            Rectangle{
                                                height: parent.height
                                                width: parent.width/3 - parent.spacing
                                                border.width: 1
                                                border.color: Constants.borderBlueColor
                                            }

                                            Rectangle{
                                                height: parent.height
                                                width: parent.width/3 - parent.spacing
                                                border.width: 1
                                                border.color: Constants.borderBlueColor
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
                                            color: "black"
                                            border.color: Constants.borderBlueColor
                                            width: 50
                                            height: nameInputRow.height
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
                                            SelectDropdown{
                                                textValue:"Default"
                                                list: Qt.fontFamilies()
                                            }
                                        }

                                    }

                                    // Font Size

                                    Row{
                                        height: nameInputRow.height
                                        width: parent.width

                                        Text {
                                            text: qsTr("Font Size: 2")
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
                                            }

                                            Rectangle{
                                                height: parent.height
                                                width: parent.width/3 - parent.spacing
                                                border.width: 1
                                                border.color: Constants.borderBlueColor
                                            }

                                            Rectangle{
                                                height: parent.height
                                                width: parent.width/3 - parent.spacing
                                                border.width: 1
                                                border.color: Constants.borderBlueColor
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
                                            color: "black"
                                            border.color: Constants.borderBlueColor
                                            width: 50
                                            height: nameInputRow.height
                                        }
                                    }

                                }

                            }

                        }


                    }

                }

            }

        }

        // Content Ends

    }

    // Page Design Ends
    /***********************************************************************************************************************/



}
