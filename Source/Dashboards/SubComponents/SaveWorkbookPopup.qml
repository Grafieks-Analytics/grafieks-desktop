/****************************************************************************
**
** Copyright (C) 2019 Grafieks.
** Contact: https://grafieks.com/
**
** MainSubComponents
** Logout
** Popup code to Logout from Grafieks server
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.2

import com.grafieks.singleton.constants 1.0
import com.grafieks.singleton.messages 1.0

import "../../MainSubComponents"

Popup {
    id: popupSave
    width: 600
    height: 400
    modal: true
    visible: false
    x: parent.width / 2 - 300
    y: parent.width / 2 - 700
    padding: 0

    property int label_col : 150

    // JAVASCRIPT FUNCTION STARTS
    /***********************************************************************************************************************/
    function onSaveClicked(){
        if(saveDatasource.checked === true){
            publishDatasourceNow()
        } else {
            publishWorkbookNow()
        }

        popupSave.close()
    }

    function publishDatasourceNow(){

        console.log("Publish datasource")
        publishDs.open()

    }

    function publishWorkbookNow(){

        console.log("Publish workbook")
        publishWb.open()
    }

    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/

    /***********************************************************************************************************************/
    // SubComponents Starts

    PublishDatasource{
        id: publishDs
    }

    PublishWorkbook{
        id: publishWb
    }

    // SubComponents Ends
    /***********************************************************************************************************************/

    // Popup Header starts

    Rectangle{
        id: headerPopup
        color: Constants.themeColor
        border.color: "transparent"
        height: 40
        width: parent.width - 2
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 1
        anchors.leftMargin: 1

        Text{
            text: Messages.da_sub_swp_header
            anchors.verticalCenter: parent.verticalCenter
            anchors.left : parent.left
            font.pixelSize: Constants.fontCategoryHeader
            anchors.leftMargin: 10
        }
        Image {
            id: close_icn
            source: "/Images/icons/outline_close_black_18dp2x.png"
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            height: 25
            width: 25
            anchors.rightMargin: 5

            MouseArea{
                anchors.fill: parent
                onClicked: popupSave.close()
            }
        }
    }

    // Popup Header ends



    // Row 1: Save Datasource Row starts

    Row{

        id: row1
        anchors.top: headerPopup.bottom
        anchors.topMargin: 30
        anchors.left: parent.left
        anchors.leftMargin: 20
        spacing: 10

        CheckBoxTpl{
            id: saveDatasource
            height: 30
            checkbox_checked: true
            checkbox_text: Messages.da_sub_swp_publishDs
            parent_dimension: 16
        }

    }
    // Row 1: Save Datasource Row ends

    // Row 2: Save Workbook Row starts

    Row{

        id: row2
        anchors.top: row1.bottom
        anchors.topMargin: 30
        anchors.left: parent.left
        anchors.leftMargin: 20
        spacing: 10

        CheckBoxTpl{
            id: saveWorkbook
            height: 30
            checkbox_checked: true
            checkbox_text: Messages.da_sub_swp_publishWb
            parent_dimension: 16
            enabled: false
        }

    }
    // Row 2: Save Workbook Row ends

    // Row 3: Button starts

    Row{

        id: row3
        anchors.top: row2.bottom
        anchors.topMargin: 30
        anchors.right: parent.right
        anchors.rightMargin: label_col - 70
        spacing: 10

        Button{
            id: save
            onClicked: onSaveClicked()
            text: Messages.publishBtnTxt
        }

        Button{
            id: cancel
            onClicked: popupSave.close()
            text: Messages.cancelBtnTxt
        }

    }
    // Row 3: Button ends


    // Row 4: Error message starts
    Row{

        id: row4
        anchors.top: row3.bottom
        anchors.topMargin: 30
        anchors.right: parent.right
        anchors.rightMargin: label_col - 70
        spacing: 10

        Text{
            id: error_connection_text
            color: "red"
            text: ""
        }
    }

    // Row 4: Error message ends

}
