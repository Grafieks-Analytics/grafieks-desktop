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
        reportName.text = name
    }

    function destroyElement(){
        mainContainer.destroy()
        this.destroy()

        // Delete from c++
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
            height: 30
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

            Image{
                id: editReport
                height: 12
                width: 12
                source: "../../../../Images/icons/Edit.png"
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 25
            }

            Image {
                id: fullScreenReport
                height: 12
                width: 12
                source: "../../../../Images/icons/remove.png"
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 5

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        destroyElement()
                    }
                }
            }



        }

    }

}

