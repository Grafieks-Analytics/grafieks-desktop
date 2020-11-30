import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2

import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents";
import "./MiniSubComponents";

Popup {

    id: calculatedFieldPopup
    width: parent.width * 0.5
    height: 600
    anchors.centerIn: parent

    visible: false
    modal: true
    padding: 0
    closePolicy: Popup.NoAutoClose

    background: Rectangle{
        color: Constants.whiteColor
    }



    // Listmodel for combobox
    ListModel{
        id: calculations

        ListElement{
            calculationName:"Number"
        }
        ListElement{
            calculationName:"String"
        }
        ListElement{
            calculationName:"Date"
        }
        ListElement{
            calculationName:"Date Conversion"
        }
        ListElement{
            calculationName:"Logical"
        }
        ListElement{
            calculationName:"Aggregate"
        }
        ListElement{
            calculationName:"User"
        }
        ListElement{
            calculationName:"Table Calculation"
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


    function onCancelClicked(){
        calculatedFieldPopup.visible = false
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
            text: Constants.reportCalculatedFieldPopup
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

    Row{
        id: popupContent
        anchors.top: header.bottom
        width: parent.width - this.padding - this.spacing
        height: parent.height - header.height - footer.height
        padding: 20
        spacing: 20

        Rectangle{
            height: parent.height
            width: parent.width

            Column{
                anchors.fill: parent
                spacing: 10

                Rectangle{
                    id: nameFieldRect
                    height: 30
                    width: parent.width

                    Row{
                        spacing: 15
                        anchors.left: parent.left

                        Rectangle{
                            height: parent.parent.height
                            width: nameLabel.width
                            Text {
                                id: nameLabel
                                text: qsTr("Name")
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        TextField{
                            placeholderText: "Enter Name"
                            width: 200
                            height: parent.parent.height
                        }
                    }
                }

                Rectangle{
                    height: parent.height - nameFieldRect.height
                    width: parent.width

                    Row{
                        anchors.fill: parent
                        spacing: 20

                        Rectangle{
                            height: parent.height
                            width: parent.width - rightPanel.width - parent.spacing
                            Column{
                                anchors.fill: parent
                                spacing: 10

                                Text {
                                    id: calculationLabel
                                    text: qsTr("Calculation")
                                }

                                Rectangle{
                                    height: parent.height - calculationLabel.height - 4*parent.spacing
                                    width: parent.width
                                    border.color: Constants.darkThemeColor
                                }

                            }

                        }
                        Rectangle{
                            id: rightPanel
                            height: parent.height
                            width: 220

                            Column{
                                anchors.fill: parent
                                spacing: 10

                                Text {
                                    id: functionsLabel
                                    text: qsTr("Functions")
                                }

                                Rectangle{
                                    height: parent.height - functionsLabel.height - 4*parent.spacing
                                    width: parent.width

                                    Column{
                                        anchors.fill: parent
                                        spacing: 10

                                        Rectangle{
                                            id: functionField
                                            height: 30
                                            width: parent.width

                                            CustomComboBox{

                                                currentIndex: 0
                                                model: calculations
                                                textRole: "calculationName"
                                                width: parent.width
                                                height: parent.height
                                                font.pixelSize: Constants.fontCategoryHeaderMedium
                                                anchors.centerIn: parent
                                            }

                                        }

                                        Rectangle{
                                            id: syntaxLabel
                                            height: 30
                                            width: parent.width
                                            Text {
                                                text: qsTr("Syntax")
                                                anchors.verticalCenter: parent.verticalCenter
                                            }
                                        }

                                        Rectangle{
                                            height: parent.height - functionField.height - syntaxLabel.height - 2*parent.spacing
                                            width: parent.width

                                            color: Constants.themeColor
                                            border.color: Constants.darkThemeColor

                                        }

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
        id: footer
        anchors.top: popupContent.bottom
        height: 60
        width: parent.width

        Row{
            spacing: 10
            anchors.top: parent.top
            anchors.topMargin: popupContent.padding
            anchors.right: parent.right
            anchors.rightMargin: 20

            CustomButton{
                id: cancelBtn
                textValue: "Cancel"
                height: Constants.defaultElementHeight
                onClicked: onCancelClicked()
            }

            CustomButton{
                id: applyBtn
                height: Constants.defaultElementHeight
                textValue: "Apply"
            }
        }

    }

}
