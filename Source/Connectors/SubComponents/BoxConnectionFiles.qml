/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Data/SubComponents
** Sqlite Connection
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
    width: parent.width * 0.75
    height: parent.height * 0.75
    modal: true
    visible: false
    x: parent.width * 0.125
    y: parent.height * 0.125
    padding: 0
    closePolicy: Popup.NoAutoClose

    property int label_col : 135
    property var pathFolder: "Box"
    property var folderName: "Folder name"

    property var fileName: ""
    property var fileType: ""
    property var folderId: ""
    property var fileId: ""
    property var fileExtension: ""



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

    Connections{
        target: BoxDS

        function onGetBoxUsername(username){
            connectedById.text = "Connected to: "+ username
        }

        function onShowBusyIndicator(status){
            if(status === true){
                busyindicator.running = true
            } else{
                busyindicator.running = false
            }
        }

        function onFileDownloaded(filePath, fileType){

            if(fileType === "csv"){
                ConnectorsLoginModel.csvLogin(filePath, false, ",")
            } else if(fileType === "excel"){
                ConnectorsLoginModel.excelLogin(filePath, false)
            } else if(fileType === "json"){
                ConnectorsLoginModel.jsonLogin(filePath, false)
            }
        }
    }

    Connections{
        target: ConnectorsLoginModel

        function onCsvLoginStatus(status, directLogin){

            if(directLogin === false){
                if(status.status === true){
                    popup.visible = false
                    stacklayout_home.currentIndex = 5
                }
                else{
                    popup.visible = true
                    msg_dialog.open()
                    msg_dialog.text = status.msg
                }
            }

        }
        function onExcelLoginStatus(status, directLogin){

            if(directLogin === false){
                if(status.status === true){
                    popup.visible = false
                    stacklayout_home.currentIndex = 5
                }
                else{
                    popup.visible = true
                    msg_dialog.open()
                    msg_dialog.text = status.msg
                }
            }
        }

        function onJsonLoginStatus(status, directLogin){

            if(directLogin === false){
                if(status.status === true){
                    popup.visible = false
                    stacklayout_home.currentIndex = 5
                }
                else{
                    popup.visible = true
                    msg_dialog.open()
                    msg_dialog.text = status.msg
                }
            }
        }
    }



    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS


    function closePopup(){
        popup.visible = false
    }

    function updatePath(text){
        path.text=text;
    }


    function onHomeClicked(){
        BoxDS.folderNav("0")
        // refer boxds.cpp for function info
        updatePath(pathFolder)
    }

    function searchFiles(){
        BoxDS.searchQuer(server_files.text)
    }


    function showSelectedFileDetails(){
        fileSelected.visible = true
    }

    function hideFileNotSelectedMessage(){
        fileNotSelectedMsg.visible = false
    }

    function onFileClicked(name, type, extension, modifiedTime, id){

        showSelectedFileDetails();
        hideFileNotSelectedMessage();


        if(type === "folder"){
            folderName = name;
            detailNameDisplay.text = name;
            documentTypeDisplay.text = "--";
            modifiedTimeDisplay.text = "--";

        }
        else{
            path.text = name

            path.text = name
            detailNameDisplay.text = name;
            documentTypeDisplay.text = extension;
            modifiedTimeDisplay.text = modifiedTime;

        }

        fileName = name
        fileType = type
        folderId = id
        fileExtension = extension
        fileId = id

    }

    function onFolderDoubleClicked(name, type, folder_id = null){

        if(type === "folder")
            BoxDS.folderNav(folder_id)

        BoxDS.fetchFileData(fileId, fileExtension)

        updatePath(name);
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
            text: "Connect to Box"
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
                    updatePath(pathFolder)
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

        // Row  User Details Starts

        Row{
            id: userDetails

            Text {
                id: connectedById
                text: qsTr("Not Connected")
            }
        }

        // Row  User Details Ends

        // Row  File Search Starts

        Row{
            id: searchFileRow
            anchors.top: userDetails.bottom
            anchors.topMargin: 20

            TextField{
                id: server_files
                placeholderText: "file name"

                width: popup.width * 0.6
                height: 40
                background: Rectangle {
                    border.color: Constants.borderBlueColor
                    radius: 5
                    width: popup.width * 0.6
                }

                CustomButton{

                    id: searchBtn
                    height: 40
                    width: 100
                    textValue: "Search"
                    x : popup.width * 0.6 - 100

                    onClicked: searchFiles();

                }

            }


        }

        // Row  File Search Ends

        // Row  File List Table Starts

        Row{
            id: dropboxFilesList
            anchors.top : searchFileRow.bottom

            anchors.topMargin: 20

            Row{
                width: popup.width * 0.6

                Rectangle{
                    height: popup.height * 0.75 - 100
                    width: popup.width * 0.6
                    border.color: Constants.themeColor

                    ListView{
                        id: fileList
                        model:BoxModel
                        clip: true
                        height: parent.height
                        width: popup.width * 0.6
                        ScrollBar.vertical: ScrollBar {}
                        headerPositioning: ListView.OverlayHeader

                        header: Row{

                            width: popup.width * 0.6
                            z: 10
                            Column{
                                width: 20
                                Rectangle{
                                    color: Constants.themeColor
                                    height:30
                                    width:fileList.width / 2

                                }
                            }


                            Column{
                                width: parent.width / 2
                                Rectangle {
                                    color: Constants.themeColor
                                    height: 30
                                    width: fileList.width / 2

                                    Text{
                                        text: "Name"
                                        anchors.verticalCenter: parent.verticalCenter
                                        leftPadding: 20
                                    }
                                }
                            }
                            Column{
                                width: parent.width / 4
                                Rectangle {
                                    color: Constants.themeColor
                                    height: 30
                                    width: fileList.width / 2

                                    Text{
                                        text: qsTr("Kind")
                                        leftPadding: 20
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                }
                            }
                            Column{
                                width: parent.width / 4
                                Rectangle {
                                    color: Constants.themeColor
                                    height: 30
                                    width: parent.width

                                    Text{
                                        text: qsTr("Last Modified")
                                        leftPadding: 20
                                        anchors.verticalCenter: parent.verticalCenter

                                    }
                                }
                            }

                        }

                        delegate: Row{
                            height:30
                            width: popup.width * 0.6

                            Column{
                                width: 20
                                height: parent.height
                                Row{

                                    Image{
                                        id: fileMenuIcon
                                        source: type=="folder"?"/Images/icons/folder-invoices.png" :"/Images/icons/file-icon.png"
                                        width:25
                                        height: 25
                                    }
                                }
                            }

                            Column{
                                width: parent.width / 2
                                height: parent.height

                                Row{
                                    height: parent.height
                                    width: parent.width
                                    anchors.left: parent
                                    anchors.leftMargin: 2

                                    Text {
                                        text: qsTr(name)
                                        padding: 5
                                        leftPadding: 20
                                    }


                                    MouseArea{

                                        anchors.fill:parent
                                        onClicked: onFileClicked(name, type, extension, modifiedAt, id);
                                        onDoubleClicked: onFolderDoubleClicked(name, type, id)
                                    }
                                }

                            }


                            Column{
                                width: parent.width / 4
                                height: 30

                                Row{
                                    height: parent.height
                                    width: parent.width
                                    anchors.left: parent

                                    Text {
                                        text: qsTr(extension)
                                        padding: 5
                                        leftPadding: 20
                                    }
                                }

                            }

                            Column{
                                width: parent.width / 4
                                height: 30

                                Row{
                                    height: parent.height
                                    width: parent.width
                                    anchors.left: parent

                                    Text {
                                        text: qsTr(modifiedAt)
                                        padding: 5
                                        leftPadding: 20
                                    }
                                }
                            }

                        }

                    }
                }

            }
            Row{
                id:fileDetails
                width: popup.width * 0.4  - 40

                Rectangle{
                    id: fileNotSelected
                    height: popup.height * 0.75 - 100
                    width: popup.width * 0.4 - 40
                    border.color: Constants.themeColor

                    Rectangle{
                        id: detailsHeading
                        height: 30
                        width: parent.width
                        border.color: Constants.themeColor

                        Text {
                            text: qsTr("Details")
                            anchors.topMargin: 5
                            font.pointSize: Constants.fontReading
                            anchors.top: detailsHeading.top
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                    }

                    HorizontalLineTpl{
                        width: parent.width
                        anchors.top: detailsHeading.bottom
                        line_color: Constants.themeColor
                    }

                    Image {
                        id: boxImage
                        source: "/Images/icons/box.png"
                        anchors.topMargin: 50
                        anchors.top: detailsHeading.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        id: fileNotSelectedMsg
                        anchors.topMargin: 20
                        anchors.top: boxImage.bottom
                        text: qsTr("Select a file from the list that you want to connect to")
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Rectangle{
                        id: fileSelected
                        visible: false
                        width: parent.width
                        anchors.top: boxImage.bottom
                        anchors.topMargin: 20

                        Column{
                            id: fileHeadingColumn
                            width: parent.width/2 - 5

                            Text {
                                anchors.right: parent.right
                                padding: 5
                                text: qsTr("Name")
                            }
                            Text {
                                anchors.right: parent.right
                                padding: 5
                                text: qsTr("Kind")
                            }
                            Text {
                                anchors.right: parent.right
                                padding: 5
                                text: qsTr("Last Modified")
                            }


                        }

                        Column{
                            id:fileDetailsColumn
                            anchors.left: fileHeadingColumn.right
                            width: parent.width/2 + 5

                            Text {
                                id: detailNameDisplay
                                padding: 5
                            }
                            Text {
                                id: documentTypeDisplay
                                padding: 5
                            }
                            Text {
                                id: modifiedTimeDisplay
                                padding: 5
                            }


                        }
                    }

                }
            }


        }

        // Row  File List Table Ends



        Row{
            anchors.top: dropboxFilesList.bottom

            anchors.topMargin: 20

            Row{
                id: breadcrumb
                width: popup.width * 0.6
                Rectangle{
                    height: 40
                    width: popup.width * 0.6
                    border.color: Constants.borderBlueColor
                    anchors.verticalCenter: parent

                    Text {
                        id: path
                        anchors.verticalCenter: parent.verticalCenter
                        leftPadding: 10
                        text: qsTr("Box")
                    }
                }
            }


            Rectangle{
                width: popup.width * 0.4
                anchors.left:breadcrumb.right
                anchors.leftMargin: popup.width * 0.4  - 250

                BusyIndicatorTpl {
                    id: busyindicator
                    running: true
                    anchors.right: homeBtn.left
                    anchors.rightMargin: 10
                }

                CustomButton{

                    id: homeBtn
                    height: 40
                    width: 100
                    textValue: "Home"
                    anchors.right: cancelBtn.left
                    anchors.rightMargin: 10

                    onClicked: onHomeClicked();

                }

                CustomButton{

                    id: cancelBtn
                    height: 40
                    width: 100
                    textValue: "Back"
                    anchors.leftMargin: 10
                    onClicked: backCalled()

                }

                CustomButton{

                    id: nextBtn
                    height: 40
                    width: 100
                    textValue: "Next"
                    anchors.left: cancelBtn.right
                    anchors.leftMargin: 10

                    onClicked: onFolderDoubleClicked(fileName, fileType, folderId)

                }

            }
        }
    }

    // Modal Content Starts



    // Page Design Ends
    /***********************************************************************************************************************/


}
