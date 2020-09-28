import QtQuick 2.15
import QtQuick.Controls 2.15

import QtQuick.Dialogs 1.2

import com.grafieks.singleton.constants 1.0

// This is the Image Widget dynamically called from MainContainer
// when a column is dropped from right side customize


Item{

    visible: true
    anchors{
        top: mainContainer.top
        left: mainContainer.left
        right: mainContainer.right
        bottom: mainContainer.bottom
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

    Component.onCompleted: {
        // Add name to report
        // reportName.text = name
    }

    function destroyElement(){
        mainContainer.destroy()
        this.destroy()

        // Delete from c++
    }

    function editSelectedReport(){
        stacklayout_home.currentIndex = 7
    }

    function toggleFullScreen(){
        console.log('Toggle Full Screen')
    }

    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts



    Rectangle {

        color: "white"
        border.width: 1
        border.color: Constants.themeColor

        width: parent.width
        height: parent.height

        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        Rectangle{

            color: "transparent"
            anchors.top: parent.top
            height: 40
            width: parent.width
            border.color: Constants.themeColor
            border.width: 2

            Text {
                id: reportName
                text: qsTr("Report Name")
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
            }


            Rectangle{
                anchors.right: parent.right
                anchors.top: parent.top
                height: parent.height

                Row{

                    height: parent.height
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.rightMargin: 10

                    spacing: 10

                    Image{
                        id: editReport
                        height: 20
                        width: 20
                        source: "../../../../Images/icons/Edit.png"
                        anchors.verticalCenter: parent.verticalCenter

                        MouseArea{
                            anchors.fill: parent
                            onClicked: editOptions.open()
                        }
                    }

                    Image {
                        id: fullScreenReport
                        height: 22
                        width: 22
                        source: "../../../../Images/icons/fullscreen.png"
                        anchors.verticalCenter: parent.verticalCenter

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                toggleFullScreen()
                            }
                        }
                    }

                }

            }

        }

        Menu{
            id: editOptions
            MenuItem {
                text: qsTr("Edit")
                onTriggered: editSelectedReport()
            }

            MenuItem {
                text: qsTr("Delete")
                onTriggered: destroyElement()
            }
        }


    }

}
