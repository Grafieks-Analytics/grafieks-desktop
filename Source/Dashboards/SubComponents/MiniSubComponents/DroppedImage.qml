import QtQuick 2.15
import QtQuick.Controls 2.15

import QtQuick.Dialogs 1.2

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

// This is the Image Widget dynamically called from MainContainer
// when a column is dropped from right side customize


Item{

    id:newItem

    visible: true
    anchors{
        top: mainContainer.top
        left: mainContainer.left
        right: mainContainer.right
        bottom: mainContainer.bottom
    }


    property var hoverStatus: false

    // change this status to false when image is selected
    property var imageChooseStatus: true


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

    Component.onCompleted: selectFile()

    function selectFile(){
        fileDialog.open()
    }

    function destroyElement(){
        mainContainer.destroy()
        this.destroy()

        // Delete from c++
    }

    function showCustomizeReport(){
        customizeReport.visible = true;
    }

    function onItemPressed(){
        DashboardContainerModel.setZIndex(++DashboardContainerModel.zIndex);
        newItem.z = DashboardContainerModel.zIndex;
        mainContainer.z = DashboardContainerModel.zIndex;
    }


    function showMenus(){
        hoverStatus = true
        mainContainer.rulerStatus = true
    }
    function hideMenus(){
        hoverStatus = false
        mainContainer.rulerStatus = false
    }


    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



    FileDialog{
        id: fileDialog
        title: "Select a file (*.jpg *.jpeg *.png  only)"
        selectMultiple: false
        nameFilters: [ "Image files (*.jpg *.jpeg *.png )"]
    }



    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts



    Rectangle {

        color: "white"

        border.width: 1
        border.color: Constants.darkThemeColor

        width: parent.width
        height: parent.height

        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        // Edit Menu Options Starts

        Rectangle{

            color: "transparent"
            anchors.top: parent.top
            height: 40
            width: parent.width
            z:20000

            Rectangle{
                anchors.right: parent.right
                anchors.top: parent.top
                height: parent.height

                Row{
                    id:menuOptions

                    height: parent.height
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.rightMargin: 10

                    spacing: 10
                    z:20001

                    visible: hoverStatus

                    Image{
                        id: editReport
                        height: 20
                        width: 20
                        source: "../../../../Images/icons/Edit.png"
                        anchors.verticalCenter: parent.verticalCenter

                        MouseArea{
                            anchors.fill: parent
                            onClicked:  editOptions.open()
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
                            onClicked:  toggleFullScreen()
                        }
                    }

                }

                Row{

                    anchors.left: parent.right
                    anchors.top: menuOptions.bottom
                    width: parent.width
                    height: 100

                    Item {
                        id: name
                        anchors.left:menuOptions.left

                        x: -editOptions.width

                        Menu{
                            id: editOptions

                            MenuItem {
                                text: qsTr("Edit")
                                onTriggered: selectFile()
                                onHoveredChanged: showMenus()
                            }

                            MenuItem {
                                text: qsTr("Delete")
                                onTriggered: destroyElement()
                                onHoveredChanged: showMenus()
                            }
                        }

                    }

                }

            }


        }

        // Edit Menu Options Ends


        MouseArea{
            anchors.centerIn: parent
            height: parent.height-4
            width: parent.width-4
            hoverEnabled: true
            drag{
                target: mainContainer
                minimumX: Constants.leftMenubarWidth
                minimumY: 29
                maximumX: mainContainer.parent.width - mainContainer.width
                maximumY: mainContainer.parent.height - mainContainer.height - Constants.subMenuWidth
                smoothed: true
            }

            onClicked:  showCustomizeReport()
            onPressed:  onItemPressed()
            onEntered: showMenus()
            onExited: hideMenus()
        }

    }

    CustomButton{
        textValue: "Choose Image"
        anchors.centerIn: parent
        visible: imageChooseStatus
    }

}

