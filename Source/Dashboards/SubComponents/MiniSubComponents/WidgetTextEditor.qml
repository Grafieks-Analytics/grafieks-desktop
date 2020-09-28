/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Dashboard/SubComponent/MiniSubComponent
** Text WidgetTextEditor
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.2

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

Popup {
    id: editorPopup
    width: 800
    height: 300
    modal: true

    visible: true

    anchors.centerIn: parent



    padding: 0

    background: Rectangle{
        color: Constants.themeColor
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


    function hidePopup(){
        editorPopup.visible = false;
    }
    function openPopup(){
        editorPopup.visible = true;
    }


    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts


    Rectangle{
        id: headerPopup
        color: Constants.whiteColor
        border.color: "transparent"
        height: 40
        width: parent.width - 2
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 1
        anchors.leftMargin: 1


        Text{
            id : text1
            text: "Edit Text"
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
                onClicked: hidePopup()
            }
        }

    }


    Rectangle{
        id: textEditorDocument
        anchors.top: headerPopup.bottom
        anchors.topMargin: 10
        height: editorPopup.height - (headerPopup.height + 30)

        width: parent.width - 20

        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.rightMargin: 10

        color: "transparent"

        Rectangle{

            height: parent.height
            width: parent.width
            border.color: Constants.leftDarkColor
            color: Constants.whiteColor

            TextEditor{
                id: textEditor
            }

        }

    }

    Rectangle{
        id: footer
        anchors.top: textEditorDocument.bottom
        anchors.topMargin: 10

        anchors.right: parent.right

    }

}
