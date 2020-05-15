/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Data/SubComponents
** Data Sources List
**
****************************************************************************/

import QtQuick 2.11
import QtQuick.Controls 2.4


import com.grafieks.singleton.constants 1.0

Page {

    id: data_source_list_page
    property var headersModel : ["Data Source Name", "Published By", "Live/Extract", "Published On", "Last Refreshed", "Edit"]
    property int headerSize : headersModel.length

    signal updateDSName(string signalDSName);

    ListView {
        id: listView
        model: DatasourceModel
        anchors.fill: parent
        contentWidth: parent.width
        width: parent.width
        flickableDirection: Flickable.HorizontalAndVerticalFlick


        header: Row {
            spacing: 1
            function itemAt(index) { return repeater.itemAt(index) }

            Repeater {
                id: repeater
                model: headersModel

                Rectangle {
                    color: Constants.themeColor
                    height: 30
                    width: listView.width / headerSize

                    Text{
                        text: modelData
                        anchors.verticalCenter: parent.verticalCenter
                        leftPadding: 10
                    }
                }
            }
        }


        highlight: Rectangle{
            color:"lightgray"
            width: parent
            opacity: 0.3
            z:10

        }

        delegate: Column {

            id: delegate


            Row {
                spacing: 1
                height: 25

                Column{
                    id: dsName_col
                    width: listView.width / headerSize
                    height: parent.height

                    Rectangle{
                        width: parent.width
                        height: parent.height

                        Text {
                            text: qsTr(datasourceName)
                            leftPadding: 10
                            anchors.verticalCenter: parent.verticalCenter

                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                listView.currentIndex = index
                                updateDSName(datasourceName)
                            }
                        }
                    }

                }

                Column{
                    id: dsOwner_col
                    width: listView.width / headerSize
                    height: parent.height

                    Rectangle{
                        width: parent.width
                        height: parent.height

                        Text {
                            text: qsTr(firstname + " " + lastname)
                            leftPadding: 10
                            anchors.verticalCenter: parent.verticalCenter

                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                listView.currentIndex = index
                                updateDSName(datasourceName)
                            }
                        }
                    }

                }

                Column{
                    id: dsConType_col
                    width: listView.width / headerSize
                    height: parent.height

                    Rectangle{
                        width: parent.width
                        height: parent.height

                        Text {
                            text: qsTr(connectionType)
                            leftPadding: 10
                            anchors.verticalCenter: parent.verticalCenter

                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                listView.currentIndex = index
                                updateDSName(datasourceName)
                            }
                        }
                    }


                }

                Column{
                    id: dsCreatedDate_col
                    width: listView.width / headerSize
                    height: parent.height

                    Rectangle{
                        width: parent.width
                        height: parent.height

                        Text {
                            text: qsTr(createdDate)
                            leftPadding: 10
                            anchors.verticalCenter: parent.verticalCenter

                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                listView.currentIndex = index
                                updateDSName(datasourceName)
                            }
                        }
                    }

                }

                Column{
                    id: dsLastRefreshed_col
                    width: listView.width / headerSize
                    height: parent.height

                    Rectangle{
                        width: parent.width
                        height: parent.height

                        Text {
                            text: qsTr(connectionType)
                            leftPadding: 10
                            anchors.verticalCenter: parent.verticalCenter

                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                listView.currentIndex = index
                                updateDSName(datasourceName)
                            }
                        }
                    }


                }

                Column{
                    id: dsEditRemove_col
                    width: listView.width / headerSize
                    height: parent.height

                    leftPadding: 10
                    anchors.verticalCenter: parent.verticalCenter

                    Row{
                        spacing: 5

                        Button{
                            id: btn_edit
                            text: "Edit"
                            height: 23
                            width: implicitWidth
                        }

                        Button{
                            id: btn_remove
                            text: "Remove"
                            height: 23
                            width: implicitWidth

                            onClicked: {
                                // Remove datasource
                                DatasourceDS.deleteDatasource(id, index)
                            }
                        }
                    }
                }

            }
            Rectangle {
                color: Constants.themeColor
                width: parent.width
                height: 1
            }
        }

        ScrollIndicator.horizontal: ScrollIndicator { }
        ScrollIndicator.vertical: ScrollIndicator { }
    }




}
