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
    property int label_col : 135
    property var pathFolder: "Github"
    property var folderName: "Folder name"

    closePolicy: Popup.NoAutoClose

    /***********************************************************************************************************************/
    // LIST MODEL STARTS


    ListModel{
        id : allFileData
        ListElement{
            fileName: "file1.txt"
            kind:"text"
            lastModified:"20/04/05"
        }
        ListElement{
            fileName: "file2.txt"
            kind:"text"
            lastModified:"20/04/04"
        }
        ListElement{
            fileName: "file3.txt"
            kind:"text"
            lastModified:"27/04/05"
        }
    }


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
        boxfilePopup.visible = false
    }

    function updatePath(text){
        hidePopup()
        path.text="Github";
    }


    function onHomeClicked(){
        DriveDS.folderNav("0")
        updatePath("Github")
    }

    function searchFiles(){
        DriveDS.searchQuer(server_files.text)
    }


    function showSelectedFileDetails(){
        fileSelected.visible = true
    }

    function hideFileNotSelectedMessage(){
        fileNotSelectedMsg.visible = false
    }

    function onFileClicked(name,type){

        showSelectedFileDetails();
        hideFileNotSelectedMessage();

        detailName.text = name;

        if(type === "folder"){
            pathFolder = id;
            folderName = name;
        }

        if(type === "file")
        {
            path.text = name
            detailName.text = name;
        }

    }

    function onFolderDoubleClicked(name,type){
        if(type === "folder")
            DriveDS.folderNav(pathFolder)

        path.text = name
    }

    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/



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
            text: "Connect to Github"
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
                onClicked: updatePath("Github")
            }
        }

    }

    // Popup Header ends

    // Modal Content Starts


    Column{
        id: dropdriveModalContent
        anchors.top: header_filePopup.bottom
        anchors.margins: 20
        anchors.left: parent.left

        // Row  User Details Starts

        Row{
            id: userDetails

            Text {
                id: connectedById
                text: qsTr("Connected by: test@test.com")
            }

            //            Column{
            //                x: parent.width * 0.75

            //                Text {
            //                    id: signOutBtn
            //                    x:popup.width - popup.parent.width * 0.125 - 30
            //                    text: qsTr("Sign Out")
            //                    color: "blue"
            //                }
            //            }
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
            id: dropdriveFilesList
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
                        model:DriveModel

                        height: 200
                        width: popup.width * 0.6

                        header: Row{

                            width: popup.width * 0.6
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

                                Rectangle{
                                    height: parent.height
                                    width: parent.width
                                    anchors.left: parent
                                    anchors.leftMargin: 2
                                    color: "transparent"

                                    Text {
                                        text: qsTr(name)
                                        padding: 5
                                        leftPadding: 20
                                    }


                                    MouseArea{

                                        anchors.fill:parent
                                        onClicked:onFileClicked(name,tag);
                                        onDoubleClicked: onFolderDoubleClicked(name,tag)
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
                            font.pixelSize: Constants.fontCategoryHeader
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
                        id: driveImage
                        source: "/Images/icons/github-1.png"
                        anchors.topMargin: 50
                        anchors.top: detailsHeading.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        id: fileNotSelectedMsg
                        anchors.topMargin: 20
                        anchors.top: driveImage.bottom
                        text: qsTr("Select a file from the list that you want to connect to")
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Rectangle{
                        id: fileSelected
                        visible: false
                        width: parent.width
                        anchors.top: driveImage.bottom
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
                            Text {
                                anchors.right: parent.right
                                padding: 5
                                text: qsTr("Size")
                            }

                        }

                        Column{
                            id:fileDetailsColumn
                            anchors.left: fileHeadingColumn.right
                            width: parent.width/2 + 5

                            Text {
                                id: detailName
                                text: qsTr("Test.xlsx")
                                padding: 5
                            }
                            Text {
                                text: qsTr("Document")
                                padding: 5
                            }
                            Text {
                                text: qsTr("24/05/2020 14:30")
                                padding: 5
                            }
                            Text {
                                text: qsTr("50 MB")
                                padding: 5
                            }


                        }
                    }

                }
            }


        }

        // Row  File List Table Ends



        Row{
            anchors.top: dropdriveFilesList.bottom

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
                        text: qsTr("Drive")
                    }
                }
            }


            Rectangle{
                width: popup.width * 0.4
                anchors.left:breadcrumb.right
                anchors.leftMargin: popup.width * 0.4  - 270

                CustomButton{

                    id: homeBtn
                    height: 40
                    width: 100
                    textValue: "Home"
                    anchors.right: cancelBtn.left
                    anchors.rightMargin: 30

                    onClicked: onHomeClicked();

                }

                CustomButton{

                    id: cancelBtn
                    height: 40
                    width: 100
                    textValue: "Back"
                    anchors.leftMargin: 30
                    onClicked: hidePopup()

                }

                CustomButton{

                    id: nextBtn
                    height: 40
                    width: 100
                    textValue: "Next"
                    anchors.left: cancelBtn.right
                    anchors.leftMargin: 30

                }

            }
        }
    }

    // Modal Content ends




}