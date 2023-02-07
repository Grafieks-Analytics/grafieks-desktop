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
import QtQuick.Dialogs

import com.grafieks.singleton.constants 1.0
import com.grafieks.singleton.messages 1.0


Popup {
    id: popup
    width: 600
    height: 590
    modal: true
    visible: false
    x: (parent.width - popup.width) / 2
    y: parent.y
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

    property bool showSaveWbPrompt: true


    /***********************************************************************************************************************/
    // LIST MODEL STARTS

    ListModel{
        id: projectsModel
    }

    // LIST MODEL ENDS
    /***********************************************************************************************************************/


    /***********************************************************************************************************************/
    // SIGNALS STARTS

    Connections{
        target : PublishWorkbookModel

        function onPublishWbStatus(outputstatus){

            errorMsg.text = outputstatus.msg
        }

        function onWbUploadPercentage(percentage){
            errorMsg.text = Messages.msc_pwb_uploading + percentage + "%"
        }

        function onWbUploadFinished(){
            errorMsg.text = Messages.msc_pwb_uploadSuccess
//            closePopup()
        }

    }

    Connections {
        target: GeneralParamsModel

        function onSavedWorkbookChanged(workbookName){
            popup.showSaveWbPrompt = false
            wbNamefield.text = workbookName
        }
    }


    Connections{
        target: ProjectsListModel

        function onSignalProjectList(projects){
            projectsModel.clear()
            Object.keys(projects).forEach((projectName) => {
                                              projectsModel.append({projectName: projectName, projectId: projects[projectName]})
                                          })

        }
    }

    Connections{
        target: DashboardParamsModel

        function onWbNameChanged(wbName){
            popup.showSaveWbPrompt = true
        }
    }

    Connections {
        target: WorkbookProcessor

        function onWorkbookSaved(){
            uploadWorkbook()
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

    Component.onCompleted:  {
       errorMsg.text = ""
       fileDialog1.nameFilters = Messages.msc_pwb_selectImageNamedFiltersTxt
    }

    function closePopup(){
        popup.visible = false
        errorMsg.text = ""
    }
    function openFileDialog(){
        fileDialog1.open();
    }

    function onPublishWorkbookClicked(){

        errorMsg.text = ""
        if(popup.showSaveWbPrompt === true){

            popup.showSaveWbPrompt = false
            fileDialog2.open()

        } else {
            uploadWorkbook()
        }
    }

    function uploadWorkbook(){
        var projectId = projectNameCombo.currentValue
        var wbName = wbNamefield.text
        var description = description_field.text
        var uploadImage = fileDialog1.fileUrl
        var dashboardCount = DashboardParamsModel.dashboardCount

        var readerFile = GeneralParamsModel.urlToFilePath(uploadImage)

        // Dashboard name, report count, image name, image data
        var dashboardDetails = "["
        var dashboardNames = DashboardParamsModel.fetchAllDashboards()

        Object.keys(dashboardNames).forEach(dashboardId => {
                                                let reportsCount = DashboardParamsModel.getDasbboardReportCount(dashboardId)
                                                dashboardDetails += '{
                                                                          "dashboardId" : '+ dashboardId +',
                                                                          "name" : "' + dashboardNames[dashboardId] + '",
                                                                          "count" : '+ reportsCount + ',
                                                                          "image" : "",
                                                                          "imageData" : ""
                                                                      },'
                                            })

        dashboardDetails = dashboardDetails.slice(0,-1);
        dashboardDetails += "]"

        if(wbName !== "" && projectId > 0 )
            PublishWorkbookModel.publishWorkbook(projectId, wbName, description, readerFile, dashboardCount, dashboardDetails)
    }


    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts

    FileDialog{
        id: fileDialog1
        title: Messages.msc_pwb_selectImageDialogTxt
        selectMultiple: false
    }

    SaveWorkbook{
        id: fileDialog2
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
            text: Messages.msc_pwb_header
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

    // Row : Enter Project name

    Row{

        id: projectName
        anchors.top: header_popup.bottom
        anchors.topMargin: 30
        anchors.left: parent.left
        anchors.leftMargin: 30

        Rectangle{

            id: label0
            width:label_col
            height: 40
            anchors.leftMargin: 30

            Text{
                id : projectNameLabel
                text: Messages.msc_pwb_projectName
                anchors.left: parent.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        CustomComboBox{
            id: projectNameCombo
            anchors.verticalCenter: parent.verticalCenter
            textRole: "projectName"
            valueRole: "projectId"
            width: 370
            model: projectsModel
        }

    }

    // Row : Enter Data Source name

    Row{

        id: wbName
        anchors.top: projectName.bottom
        anchors.topMargin: 30
        anchors.left: parent.left
        anchors.leftMargin: 30

        Rectangle{

            id: label1
            width:label_col
            height: 40
            anchors.leftMargin: 30

            Text{
                id : wbNameLabel
                text: Messages.msc_pwb_workbookName
                anchors.left: parent.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        CustomTextBox{
            id: wbNamefield
            anchors.verticalCenter: parent.verticalCenter
            maxLength: 150
            boxWidth: 370
            boxHeight: 40
            onTextChanged: DashboardParamsModel.setWbName(wbNamefield.text)
        }

    }


    // Row1: Enter Description starts

    Row{

        id: row1
        anchors.top: wbName.bottom
        anchors.topMargin: 30
        anchors.left: parent.left
        anchors.leftMargin: 30

        Rectangle{

            id: label2
            width:label_col
            height: 40

            Text{
                text: Messages.msc_pwb_description
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
                text: Messages.msc_pwb_uploadImage
                anchors.left: parent.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        FileUploadBtn{
            id: file
            btnHeight: 40
            btnWidth: 370
            textValue: Messages.msc_pwb_uploadImageDialogTxt

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

            id: btn_publish
            textValue: Messages.publishBtnTxt
            onClicked: onPublishWorkbookClicked()
        }

        CustomButton{
            id: btn_cancel
            textValue: Messages.cancelBtnTxt
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
            text: qsTr(Messages.msc_pwb_contactAdminTxt)
        }

        Text {
            id: errorMsg
            color: "red"
        }

    }


    // Page Design Ends
    /***********************************************************************************************************************/

}
