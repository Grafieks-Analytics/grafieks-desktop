/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Data/SubComponents
** Data Sources Grid
**
****************************************************************************/

import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
//import QtQuick.Controls 1.4 as OldControls

import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents"


Page {

    id: datasources_grid
    width: parent.width
    height: parent.height

    signal updateDSName(string signalDSName);

    GridView {
        width: datasources_grid.width
        height: datasources_grid.height
        cellWidth: width/3
        cellHeight: 300
        model: DatasourceModel


        delegate: Rectangle{
            id:data_source_main
            border.color: Constants.darkThemeColor
            width: 340
            height: 240
            radius: 10

            MouseArea{
                anchors.fill:parent
                onClicked: {
                    updateDSName(datasourceName)
                }
            }

            Rectangle{
                id:data_source_head
                anchors.left: data_source_main.left
                anchors.top: data_source_main.top
                anchors.leftMargin: 1
                anchors.topMargin: 1
                width: 338
                height: 40
                color: Constants.themeColor
                radius: 10


                Text{
                    id: title
                    text:  datasourceName
                    font: Constants.fontCategoryHeaderSmall
                    anchors.centerIn: parent
                    opacity: enabled ? 1.0 : 0.3
                    verticalAlignment: Text.AlignVCenter
                }



                ToolButton {
                    id:data_source_edit

                    anchors.right:data_source_head.right
                    anchors.rightMargin: 10
                    anchors.top:data_source_head.top
                    anchors.topMargin: 10
                    z:10

                    background: Rectangle {
                        implicitWidth: 20
                        implicitHeight: 20
                        opacity: enabled ? 1 : 0.3
                        color: "transparent"
                    }


                    Image {
                        source: "../../../Images/icons/Edit_20.png"
                        width:20
                        height:width

                    }
                    onClicked: optionsMenu.open()

                    Menu {
                        id: optionsMenu
                        x: parent.width - width
                        transformOrigin: Menu.TopRight

                        MenuItem {
                            text: "Edit Connection"
                            onTriggered: {
                                if(typeof settings.value("user/sessionToken") != "undefined"){
                                    connectGrafieks1.visible = true
                                } else{

                                }
                            }
                        }
                        MenuItem {
                            text: "Remove"
                            onTriggered: {

                                // Delete Datasource
                                DatasourceDS.deleteDatasource(id, index)
                            }
                        }
                    }
                }


            }



            Image{
                id: image_datasource
                source: "../../../Images/icons/sample_graph.png"
                anchors.top: data_source_head.bottom
                anchors.topMargin:10
                anchors.horizontalCenter: data_source_main.horizontalCenter
                width: 250
                height:76

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                    }
                }


            }


            Column{
                id: description_datasource
                anchors.top: image_datasource.bottom
                anchors.left: data_source_main.left
                anchors.right: data_source_main.right
                anchors.topMargin: 10
                anchors.leftMargin: 10
                anchors.rightMargin: 10

                Text{
                    text: "Description"
                }
                Text{
                    id: description_id
                    width:data_source_main.width - 10
                    text: descriptions
                    wrapMode: Text.WordWrap
                    font.pointSize: Constants.fontReading
                }
            }

            RowLayout{
                id: info_datasource
                anchors.top: description_datasource.bottom
                anchors.left: data_source_main.left
                anchors.right: data_source_main.right
                anchors.topMargin: 15
                anchors.leftMargin: 10
                anchors.rightMargin: 10


                Column{
                    Text{
                        text: "Published by"
                    }
                    Text{
                        id: owner_name_id
                        text: firstname + " "+ lastname
                        font.pointSize: Constants.fontReading
                    }

                }

                Column{


                    Text{
                        text: "Live / In Memory"

                    }
                    Text{
                        id: mode_id
                        text: connectionType
                        font.pointSize: Constants.fontReading
                    }

                }

            }
        }
    }




}

