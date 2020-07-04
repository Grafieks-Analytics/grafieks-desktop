/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Data/SubComponents
** Sqlite Connection
**
****************************************************************************/

import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents"

Popup {
    id: sheetListPopup
    width: parent.width * 0.75
    height: parent.height * 0.75
    modal: true
    visible: false
    x: parent.width * 0.125
    y: parent.height * 0.125
    padding: 0
    property int label_col : 135
    property var pathFolder: "Sheet"
    property var folderName: "Folder name"


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

    Connections{
        target: ConnectorsLoginModel

        onSqliteLoginStatus:{

            if(status.status === true){

                sheetPopup.visible = false
                stacklayout_home.currentIndex = 5
            }
            else{
                sheetPopup.visible = true
                msg_dialog.open()
                msg_dialog.text = status.msg
            }
        }
    }


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
            text: "Connect to Sheet"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left : parent.left
            font.pixelSize: Constants.fontReading
            anchors.leftMargin: 20
        }
        Image {
            id: close_icn
            source: "../../../Images/icons/outline_close_black_18dp2x.png"
            anchors.verticalCenter: parent.verticalCenter
            anchors.right:  parent.right
            height: 25
            width: 25
            anchors.rightMargin: 5
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    sheetListPopup.visible = false
                    path.text="Sheet";
                }
            }
        }

    }

    // Popup Header ends

    // Modal Content Starts


    Column{
        id: dropboxModalContent
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
//                    x:sheetListPopup.width - sheetListPopup.parent.width * 0.125 - 30
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
                font.pixelSize: Constants.fontReading
                width: sheetListPopup.width * 0.6
                height: 40
                background: Rectangle {
                    border.color: Constants.borderBlueColor
                    radius: 5
                    width: sheetListPopup.width * 0.6
                }

                Button{
                    id: searchBtn
                    height: 40
                    width: 100
                    x : sheetListPopup.width * 0.6 - 100
                    background: Rectangle {
                        id: searchBtnBackground
                        color: searchBtn.hovered ?  Constants.buttonHoverColor : Constants.darkThemeColor
                    }

                    Text{
                        text: "Search"
                        anchors.centerIn: parent
                        font.pixelSize: Constants.fontReading
                    }
                    onClicked: {
                        SheetDS.searchQuer(server_files.text);
                    }


                }


                //                Button{
                //                    id: search_btn
                //                    height: 40
                //                    width: 100
                //                    x : sheetListPopup.width * 0.6 - 100
                //                    background: Rectangle{
                //                        id: search_btn_background
                //                        color: search_btn.hovered ? Constants.darkThemeColor : Constants.ThemeColor

                //                        Text{
                //                            text: "Search"
                //                            anchors.centerIn: parent
                //                            font.pixelSize: Constants.fontReading
                //                        }

                //                    }


                //                }


            }


        }

        // Row  File Search Ends

        // Row  File List Table Starts

        Row{
            id: dropboxFilesList
            anchors.top : searchFileRow.bottom

            anchors.topMargin: 20

            Row{
                width: sheetListPopup.width * 0.6

                Rectangle{
                    height: sheetListPopup.height * 0.75 - 100
                    width: sheetListPopup.width * 0.6
                    border.color: Constants.themeColor

                    ListView{
                        id: fileList
                        model:SheetModel

                        height: 200
                        width: sheetListPopup.width * 0.6

                        header: Row{

                            width: sheetListPopup.width * 0.6
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
                            width: sheetListPopup.width * 0.6

                            Column{
                                width: 20
                                height: parent.height
                                Row{

                                    Image{
                                        id: fileMenuIcon
                                        source: kind=="drive#folder"?"../../../Images/icons/folder-invoices.png" :"../../../Images/icons/file-icon.png"
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
                                        onClicked: {

                                            fileSelected.visible = true
                                            fileNotSelectedMsg.visible = false
                                            detailName.text = name;
                                            if(tag == "folder"){
                                                pathFolder = pathLower;
                                                folderName = name;
                                            }

                                            if(kind == "drive#file")
                                            {
                                                path.text = pathLower
                                               detailName.text = name;
                                            }
                                        }
                                        onDoubleClicked: {
                                            if(tag == "folder")
                                            DropboxDS.fetchDatasources(pathLower)

                                            path.text = pathLower
                                        }
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
                                        text: qsTr(modifiedTime)
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
                width: sheetListPopup.width * 0.4  - 40

                Rectangle{
                    id: fileNotSelected
                    height: sheetListPopup.height * 0.75 - 100
                    width: sheetListPopup.width * 0.4 - 40
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
                        id: dropBoxImage
                        source: "../../../Images/icons/16_google-sheets_1b1915a4b0.png"
                        anchors.topMargin: 50
                        anchors.top: detailsHeading.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        id: fileNotSelectedMsg
                        anchors.topMargin: 20
                        anchors.top: dropBoxImage.bottom
                        text: qsTr("Select a file from the list that you want to connect to")
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Rectangle{
                        id: fileSelected
                        visible: false
                        width: parent.width
                        anchors.top: dropBoxImage.bottom
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
            anchors.top: dropboxFilesList.bottom

            anchors.topMargin: 20

            Row{
                id: breadcrumb
                width: sheetListPopup.width * 0.6
                Rectangle{
                    height: 40
                    width: sheetListPopup.width * 0.6
                    border.color: Constants.borderBlueColor
                    anchors.verticalCenter: parent

                    Text {
                        id: path
                        anchors.verticalCenter: parent.verticalCenter
                        leftPadding: 10
                        text: qsTr("Sheet")
                    }
                }
            }


            Row{
                width: sheetListPopup.width * 0.4
                anchors.left:breadcrumb.right
                anchors.leftMargin: sheetListPopup.width * 0.4  - 270

                Button{
                    id: homeBtn
                    height: 40
                    width: 100
                    anchors.right: cancelBtn.left
                    anchors.rightMargin: 30

                    background: Rectangle {
                        id: homeBtnBackground
                        color: homeBtn.hovered ?  Constants.buttonHoverColor : Constants.darkThemeColor
                    }

                    Text{
                        text: "Home"
                        anchors.centerIn: parent
                        font.pixelSize: Constants.fontReading
                    }

                    onClicked: {
                        SheetDS.homeBut();
                        //refer sheetds.cpp for function info
                    }


                }

                Button{
                    id: cancelBtn
                    height: 40
                    width: 100

                    background: Rectangle {
                        id: cancelBtnBackground
                        color: cancelBtn.hovered ?  Constants.buttonHoverColor : Constants.darkThemeColor
                    }

                    Text{
                        text: "Cancel"
                        anchors.centerIn: parent
                        font.pixelSize: Constants.fontReading
                    }

                    onClicked: {
                        sheetListPopup.visible = false
                    }


                }

                Button{
                    id: nextBtn
                    height: 40
                    width: 100
                    anchors.left: cancelBtn.right
                    anchors.leftMargin: 30
                    background: Rectangle {
                        id: nextBtnBackground
                        color: nextBtn.hovered ?  Constants.buttonHoverColor : Constants.darkThemeColor
                    }

                    Text{
                        text: "Next"
                        anchors.centerIn: parent
                        font.pixelSize: Constants.fontReading
                    }


                }

            }
        }
    }

    // Modal Content ends




}
