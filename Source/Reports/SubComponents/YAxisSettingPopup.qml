import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0


Popup {

    id: popup
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



    /***********************************************************************************************************************/
    // LIST MODEL STARTS


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

            Rectangle{

                anchors.fill: parent

            }

        }

        // Content Ends

    }

    // Page Design Ends
    /***********************************************************************************************************************/



}
