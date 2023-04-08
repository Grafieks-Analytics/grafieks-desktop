/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Data/SubComponents
** Data Sources Grid
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
//import QtQuick.Controls 1.4 as OldControls

import com.grafieks.singleton.constants 1.0
import com.grafieks.singleton.messages 1.0

import "../../MainSubComponents"


Page {

    id: datasources_grid
    width: parent.width
    height: parent.height
    background:Rectangle{
        height:parent.height
        width:parent.width
        color:"white"
    }

    /***********************************************************************************************************************/
    // LIST MODEL STARTS


    // LIST MODEL ENDS
    /***********************************************************************************************************************/


    /***********************************************************************************************************************/
    // SIGNALS STARTS


    signal updateDSName(string signalDSName, string connectionType, bool connectAllowed);



    // SIGNALS ENDS
    /***********************************************************************************************************************/



    /***********************************************************************************************************************/
    // Connections Starts



    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS


    function onRemoveClicked(id,index){
        // Delete Datasource
        DatasourceDS.deleteDatasource(id, index)
    }
    function onEditClicked(){
        if(typeof settings.value("user/sessionToken") != "undefined"){
            connectGrafieks1.visible = true
        } else{

        }
    }

    function onDataSourceNameClicked(datasourceName, connectionType, connectAllowed){
        if(connectionType === Constants.extractDS){
            GeneralParamsModel.setPath(datasourceName + "." + Constants.extractFileExt, Constants.extractDS)
        } else {
            GeneralParamsModel.setPath(datasourceName + "." + Constants.liveFileExt, Constants.liveDS)
        }
        updateDSName(datasourceName, connectionType, connectAllowed)
    }

    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts




    GridView {
        id:gridGrs
        width: datasources_grid.width
        height: datasources_grid.height
        cellWidth: gridGrs.width/3
        cellHeight: 300
        clip: true
                interactive: true
                ScrollBar.vertical: ScrollBar{
                     policy: ScrollBar.AlwaysOn
                }
               


        anchors.horizontalCenter: parent.horizontalCenter

        model: DatasourceModel


        delegate:
            Rectangle{
            width: gridGrs.width/3
            height: 280


            Rectangle{
            id:data_source_main
            border.color: Constants.darkThemeColor
            anchors.horizontalCenter: parent.horizontalCenter

            width: 320
            height: 240
            radius: 10
            scale: 1



            MouseArea{
                anchors.fill:parent
                onClicked: onDataSourceNameClicked(datasourceName, connectionType, connectAllowed)
            }

            Rectangle{
                id:data_source_head
                anchors.left: data_source_main.left
                anchors.top: data_source_main.top
                anchors.leftMargin: 1
                anchors.topMargin: 1
                width: 320
                height: 40
                color: Constants.themeColor
                radius: 10



                Text{
                    id: title
                    text: datasourceName
                    font.pointSize: Constants.fontCategoryHeaderSmall
                    anchors.centerIn: parent
                    opacity: enabled ? 1.0 : 0.3
                    verticalAlignment: Text.AlignVCenter
                }



//                ToolButton {
//                    id:data_source_edit

//                    anchors.right:data_source_head.right
//                    anchors.rightMargin: 10
//                    anchors.top:data_source_head.top
//                    anchors.topMargin: 10
//                    z:10

//                    background: Rectangle {
//                        implicitWidth: 20
//                        implicitHeight: 20
//                        opacity: enabled ? 1 : 0.3
//                        color: "transparent"
//                    }


//                    Image {
//                        source: "/Images/icons/Edit_20.png"
//                        width:20
//                        height:width

//                    }
//                    onClicked: optionsMenu.open()

//                    Menu {
//                        id: optionsMenu
//                        x: parent.width - width
//                        transformOrigin: Menu.TopRight

//                        MenuItem {
//                            text: "Edit Connection"
//                            onTriggered: {
//                                onEditClicked()
//                            }
//                        }
//                        MenuItem {
//                            text: "Remove"
//                            onTriggered: onRemoveClicked(id,index)
//                        }
//                    }
//                }


            }



            Image{
                id: image_datasource
                source: "/Images/icons/Data Sourse.png"
                anchors.top: data_source_head.bottom
                anchors.topMargin:10
                anchors.horizontalCenter: data_source_main.horizontalCenter
                width: 150
                height:76


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
                    text: Messages.ds_sub_dsg_description
                }
                Text{
                    id: description_id
                    width:data_source_main.width - 10
                    text: descriptions
                    wrapMode: Text.WordWrap
                    font.pixelSize: Constants.fontCategoryHeaderSmall
                }
            }

            RowLayout{
                id: info_datasource
                anchors.bottom: parent.bottom
                anchors.left: data_source_main.left
                anchors.right: data_source_main.right
                anchors.bottomMargin: 15
                anchors.leftMargin: 10
                anchors.rightMargin: 10


                Column{

                    Text{
                        text: Messages.ds_sub_dsg_publishedBy
                    }
                    Text{
                        id: owner_name_id
                        text: firstname + " "+ lastname
                        font.pixelSize: Constants.fontCategoryHeaderSmall
                    }

                }

                Column{
                    anchors.right: parent.right
                    Text{
                        text: Messages.ds_sub_dsg_liveExtract

                    }
                    Text{
                        id: mode_id
                        text: connectionType
                        font.pixelSize: Constants.fontCategoryHeaderSmall
                    }

                }

            }
        }
    }
    }



    // Page Design Ends
    /***********************************************************************************************************************/


}

