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

    property var headersModel : ["Data Source Name", "Published By", "Live/Extract", "Published On", "Last Refreshed", "Edit"]
    property int headerSize : headersModel.length

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


        delegate: Column {

            id: delegate

            Row {
                spacing: 1
                height: 25


                Column{
                    id: dsName_col
                    width: listView.width / headerSize
                    leftPadding: 10
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        text: qsTr(datasourceName)
                    }
                }

                Column{
                    id: dsOwner_col
                    width: listView.width / headerSize
                    leftPadding: 10
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        text: qsTr(firstname + " " + lastname)
                    }
                }

                Column{
                    id: dsConType_col
                    width: listView.width / headerSize
                    leftPadding: 10
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        text: qsTr(connectionType)
                    }
                }

                Column{
                    id: dsCreatedDate_col
                    width: listView.width / headerSize
                    leftPadding: 10
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        text: qsTr(createdDate)
                    }
                }

                Column{
                    id: dsLastRefreshed_col
                    width: listView.width / headerSize
                    leftPadding: 10
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        text: qsTr(connectionType)
                    }
                }

                Column{
                    id: dsEditRemove_col
                    width: listView.width / headerSize
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
