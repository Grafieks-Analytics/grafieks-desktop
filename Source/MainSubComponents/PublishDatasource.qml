/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Data/SubComponents
** Data Sources Description
** Popup code to publish datasource to Grafieks server
** Prompts Description and Image upload for Datasource
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.2

import com.grafieks.singleton.constants 1.0


Popup {
    id: popup
    width: 600
    height: 520
    modal: true
    visible: false
    x: (parent.width - popup.width) / 2
    y: 100
    padding: 0

    closePolicy: Popup.NoAutoClose

    property int label_col : 150
    property string host_final : ""
    property string database_final : ""
    property string port_final : ""
    property string username_final : ""
    property string password_final : ""
    property string mode_final : ""
    property string datasource_name_final : ""


    /***********************************************************************************************************************/
    // LIST MODEL STARTS


    // LIST MODEL ENDS
    /***********************************************************************************************************************/


    /***********************************************************************************************************************/
    // SIGNALS STARTS

    Connections{
        target : PublishDatasourceModel

        function onPublishDSStatus(outputstatus){

            errorMsg.text = outputstatus.msg
        }

        function onDsUploadPercentage(percentage){
            errorMsg.text = "Uploading Datasource " + percentage + "%"
        }

        function onDsUploadFinished(){
            errorMsg.text = "Datasource is published now. Please close this window"
//            closePopup()

            // If called from modelere screen, then redirect to reports screen
            // Else open publish workbook modal
            if(GeneralParamsModel.currentScreen === Constants.modelerScreen){
                stacklayout_home.currentIndex = 7
            } else {

                // In the parent page
                popupSave.publishWorkbookNow()
            }
        }

    }

    Connections{
        target: QueryModel

        function onExtractFileExceededLimit(freeLimit, ifPublish){
            saveExtractLimit(freeLimit, ifPublish)
        }

        function onLiveFileExceededLimit(freeLimit, ifPublish){
            saveLiveLimit(freeLimit, ifPublish)
        }
    }

    Connections{
        target: ForwardOnlyQueryModel

        function onExtractFileExceededLimit(freeLimit, ifPublish){
            saveExtractLimit(freeLimit, ifPublish)
        }

        function onLiveFileExceededLimit(freeLimit, ifPublish){
            saveLiveLimit(freeLimit, ifPublish)
        }
    }

    Connections{
        target: ExcelQueryModel

        function onExtractFileExceededLimit(freeLimit, ifPublish){
            saveExtractLimit(freeLimit, ifPublish)
        }
    }

    Connections{
        target: CSVJsonQueryModel

        function onExtractFileExceededLimit(freeLimit, ifPublish){
            saveExtractLimit(freeLimit, ifPublish)
        }
    }

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
        errorMsg.text = ""
    }
    function openFileDialog(){
        fileDialog1.open();
    }

    function onPublishDataSourceClicked(){

        // Call Cpp function to process &
        // Upload data to API

        QueryModel.setIfPublish(true)
        ForwardOnlyQueryModel.setIfPublish(true)
        ExcelQueryModel.setIfPublish(true)
        CSVJsonQueryModel.setIfPublish(true)

        // First save the extract file
        // Then publish the data and file
        if(GeneralParamsModel.getExtractPath().length > 0 || GeneralParamsModel.getLivePath().length > 0){
            errorMsg.text = "Processing. Please wait.."
            publishData()
        } else {
            saveFilePrompt.open()
        }
    }

    function publishData(){
        var dsName = datasource_name_field.text
        var description = description_field.text
        var uploadImage = fileDialog1.fileUrl
        var sourceType = DSParamsModel.dsType
        var schedulerId = DSParamsModel.schedulerId
        var isFullExtract = DSParamsModel.isFullExtract
        var extractColumnName = DSParamsModel.extractColName

        var readerFile = GeneralParamsModel.urlToFilePath(uploadImage)

        PublishDatasourceModel.publishDatasource(dsName, description, readerFile, sourceType, schedulerId, isFullExtract, extractColumnName)
    }

    function saveExtractLimit(freeLimit, ifPublish){
        errorMsg.text = "Processing. Please wait.."

        if(GeneralParamsModel.ifFreeRelease() === "Free"){
            if(ifPublish && !freeLimit)
                publishData()
        } else {
            if(ifPublish)
                publishData()
        }
    }

    function saveLiveLimit(freeLimit, ifPublish){
        errorMsg.text = "Processing. Please wait.."

        if(GeneralParamsModel.ifFreeRelease() === "Free"){
            if(ifPublish && !freeLimit)
                publishData()
        } else {
            if(ifPublish)
                publishData()
        }
    }


    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts

    FileDialog{
        id: fileDialog1
        title: "Select a file (*.jpg *.jpeg *.png  only)"
        selectMultiple: false
        nameFilters: [ "Image files (*.jpg *.jpeg *.png )"]
    }


    // This is a component because it uses Qt.labs.Platform
    // and this conflicts with the current file
    SaveExtract{
        id: saveFilePrompt
    }

    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts



    // Popup Header starts

    Rectangle{
        id: header_popup
        color: Constants.themeColor
        border.color: "transparent"
        height: 40
        width: parent.width - 2
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 1
        anchors.leftMargin: 1

        Text{
            text: "Publish Data Source"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left : parent.left
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
                onClicked: closePopup()
            }
        }
    }

    // Popup Header ends

    // Row : Enter Data Source name

    Row{

        id: datasourceName
        anchors.top: header_popup.bottom
        anchors.topMargin: 30
        anchors.left: parent.left
        anchors.leftMargin: 30

        Rectangle{

            id: label1
            width:label_col
            height: 40
            anchors.leftMargin: 30

            Text{
                id : dsNameLabel
                text: "Data Source Name"
                anchors.left: parent.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        CustomTextBox{
            id: datasource_name_field
            anchors.verticalCenter: parent.verticalCenter
            maxLength: 150
            boxWidth: 370
            boxHeight: 40
            text: (DSParamsModel.dsName !== "" || DSParamsModel.dsName !== null) ? DSParamsModel.dsName : ""
        }

    }


    // Row1: Enter Description starts

    Row{

        id: row1
        anchors.top: datasourceName.bottom
        anchors.topMargin: 30
        anchors.left: parent.left
        anchors.leftMargin: 30

        Rectangle{

            id: label2
            width:label_col
            height: 40

            Text{
                text: "Description"
                anchors.left: parent.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        CustomTextArea{
            id: description_field
            boxWidth: 370
            boxHeight: 200
        }

    }

    // Row1: Enter Description ends

    // Row2: Enter FileDialog starts

    Row{

        id: row2
        anchors.top: row1.bottom
        anchors.topMargin: 30
        anchors.left: parent.left
        anchors.leftMargin: 30

        Rectangle{

            id: label3
            width:label_col
            height: 40

            Text{
                text: "Upload Image"
                anchors.left: parent.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        FileUploadBtn{
            id: file
            btnHeight: 40
            btnWidth: 370
            textValue: "Click to upload image (*.jpg *.jpeg *.png  only)"

            MouseArea{
                anchors.fill: parent
                onClicked: openFileDialog()
            }
        }

    }


    // Row2: Enter FileDialog ends

    // Row 3: Action Button starts

    Row{

        id: row3
        anchors.top: row2.bottom
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 50
        spacing: 10

        CustomButton{

            id: btn_signin
            textValue: "Publish"
            onClicked: onPublishDataSourceClicked()
        }

        CustomButton{
            id: btn_cancel
            textValue: "Cancel"
            onClicked: closePopup()
        }
    }
    // Row 3: Action Button ends

    Column{
        id: note
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 30

        Text {
            text: qsTr("For Data Source access permission, contact Project Admin ")
        }

        Text {
            id: errorMsg
            color: "red"
        }

    }


    // Page Design Ends
    /***********************************************************************************************************************/

}
