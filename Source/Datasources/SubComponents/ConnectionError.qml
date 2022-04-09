/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** DataSources/SubComponents
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents"

Popup {
    id: popup
    width: 600
    height: 200
    modal: true
    visible: false
    x: parent.width / 2 - 300
    y: parent.height / 2 - 100
    padding: 0
    closePolicy: Popup.NoAutoClose


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


    function closePopup(){
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


    // Popup Header starts

    Rectangle{
        id: header_filePopup
        color: Constants.themeColor
        border.color: "transparent"
        height: 40
        width: parent.width - 2
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 1
        anchors.leftMargin: 1

        Text{
            id : text1
            text: "Permission Denied"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left : parent.left
            anchors.leftMargin: 20
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
                onClicked: {
                    closePopup()
                }

            }
        }

    }

    // Popup Header ends

    // Modal Content Starts


    Column{
        id: boxModalContent
        anchors.top: header_filePopup.bottom
        anchors.margins: 20
        anchors.left: parent.left

        // Row  Error Details

        Row{
            id: errorDetails

            Text {
                id: connectedById
                text: qsTr("You do not have permission to connect to this Datasource")
            }
        }

        // Row  Error Details Ends

        // Row  Ok Starts

        Row{
            id: searchFileRow
            anchors.top: errorDetails.bottom
            anchors.topMargin: 20

            Button{
                id: closeBtn
                text: "OK"
                onClicked: closePopup()
            }
        }

        // Row  Ok Ends
    }

    // Modal Content Ends



    // Page Design Ends
    /***********************************************************************************************************************/
}
