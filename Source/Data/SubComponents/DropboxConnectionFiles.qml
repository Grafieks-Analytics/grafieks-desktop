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
    id: filePopup
    width: parent.width * 0.75
    height: parent.height * 0.75
    modal: true
    visible: false
    x: parent.width * 0.125
    y: parent.height * 0.125
    padding: 0
    property int label_col : 135


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
            text: "Connect to Dropbox"
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
                    fileListPopup.visible = false
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

            Column{
                x: parent.width * 0.75

                Text {
                    id: signOutBtn
                    x:filePopup.width - filePopup.parent.width * 0.125 - 30
                    text: qsTr("Sign Out")
                    color: "blue"
                }
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
                font.pixelSize: Constants.fontReading
                width: filePopup.width * 0.6
                height: 40
                background: Rectangle {
                    border.color: Constants.borderBlueColor
                    radius: 5
                    width: filePopup.width * 0.6
                }

                Button{
                    id: searchBtn
                    height: 40
                    width: 100
                    x : filePopup.width * 0.6 - 100
                    background: Rectangle {
                        id: searchBtnBackground
                        color: searchBtn.hovered ?  Constants.darkThemeColor : Constants.themeColor
                    }

                    Text{
                        text: "Search"
                        anchors.centerIn: parent
                        font.pixelSize: Constants.fontReading
                    }


                }


//                Button{
//                    id: search_btn
//                    height: 40
//                    width: 100
//                    x : filePopup.width * 0.6 - 100
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
                width: filePopup.width * 0.6
                Rectangle{
                    height: filePopup.height * 0.75 - 100
                    width: filePopup.width * 0.6
                    border.color: Constants.darkThemeColor

                    ListView{
                        id: fileList
                        model:allFileData

                        height: 200
                        width: filePopup.width * 0.6

                        header: Row{

                            width: filePopup.width * 0.6


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
                                        anchors.verticalCenter: parent.verticalCenter
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
                                        text: qsTr("Last Modified")
                                        anchors.verticalCenter: parent.verticalCenter

                                    }
                                }
                            }

                        }

                        delegate: Row{

                            height: 20
                            width: filePopup.width * 0.6

                            Column{
                                width: parent.width / 2
                                Text {
                                    text: qsTr(fileName)
                                    leftPadding: 20
                                }
                            }


                            Column{
                                width: parent.width / 4

                                Text {
                                    text: qsTr(kind)
                                    horizontalAlignment: Text.AlignHCenter
                                }
                            }

                            Column{
                                width: parent.width / 4
                                Text {
                                    text: qsTr(lastModified)

                                }
                            }

                        }


                    }
                }

            }
            Row{
                id:fileDetails
                width: filePopup.width * 0.4  - 40

                Rectangle{
                    height: filePopup.height * 0.75 - 100
                    width: filePopup.width * 0.4 - 40
                    border.color: Constants.darkThemeColor

                    Text {
                        id: detailsHeading
                        x: parent.width/2 - detailsHeading.width/2
                        text: qsTr("Details")
                        anchors.topMargin: 20
                        font.pointSize: Constants.fontReading
                    }


                    HorizontalLineTpl{
                        width: parent.width
                        anchors.top: detailsHeading.bottom
                        line_color: Constants.themeColor
                    }

                    Image {
                        id: dropBoxImage
                        source: "../../../Images/icons/dropbox-2.png"
                        anchors.top: detailsHeading.bottom
                        x: parent.width/2 - dropBoxImage.width/2
                        anchors.topMargin: 50
                    }

                    Text {
                        id: msg
                        anchors.top: dropBoxImage.bottom
                        anchors.topMargin: 20
                        text: qsTr("Select a file from the list that you want to connect to")
                        x:parent.width/2 - msg.width/2
                    }

                }
            }


        }

        // Row  File List Table Ends



        Row{
            anchors.top: dropboxFilesList.bottom

            anchors.topMargin: 20

            Row{
                width: filePopup.width * 0.6
                Rectangle{
                    height: 40
                    width: filePopup.width * 0.6
                    border.color: Constants.borderBlueColor
                    anchors.verticalCenter: parent

                    Text {
                        id: path
                        anchors.topMargin: 10
                        anchors.verticalCenter: parent
                        text: qsTr("abhishek/abhi/file.txt")
                    }
                }
            }


            Row{
                width: filePopup.width * 0.4
                anchors.leftMargin: 40

                Button{
                    id: cancelBtn
                    height: 40
                    width: 100

                    background: Rectangle {
                        id: cancelBtnBackground
                        color: cancelBtn.hovered ?  Constants.darkThemeColor : Constants.themeColor
                    }

                    Text{
                        text: "Cancel"
                        anchors.centerIn: parent
                        font.pixelSize: Constants.fontReading
                    }

                    onClicked: {
                        fileListPopup.visible = false
                    }


                }

                Button{
                    id: nextBtn
                    height: 40
                    width: 100
                    x : 200
                    background: Rectangle {
                        id: nextBtnBackground
                        color: nextBtn.hovered ?  Constants.darkThemeColor : Constants.themeColor
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
