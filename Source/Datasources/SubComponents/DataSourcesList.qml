/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Data/SubComponents
** Data Sources List
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15


import com.grafieks.singleton.constants 1.0
import com.grafieks.singleton.messages 1.0

Page {

    id: data_source_list_page
    property var headersModel : Messages.ds_sub_dsl_headers
    property int headerSize : headersModel.length


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

    function onDataSourceNameClicked(datasourceName, index, connectionType, connectAllowed){
        listView.currentIndex = index
        updateDSName(datasourceName, connectionType, connectAllowed)
    }

    function onDataSourceOwnerClicked(datasourceName, index, connectionType, connectAllowed){
        listView.currentIndex = index
        updateDSName(datasourceName, connectionType, connectAllowed)
    }

    function onConnectionClicked(datasourceName, index, connectionType, connectAllowed){
        listView.currentIndex = index;
        updateDSName(datasourceName, connectionType, connectAllowed)
    }

    function onDateCreatedClicked(datasourceName, index, connectionType, connectAllowed){
        listView.currentIndex = index;
        updateDSName(datasourceName, connectionType, connectAllowed)
    }

    function onLastRefreshedClicked(datasourceName, index, connectionType, connectAllowed){
        listView.currentIndex = index;
        updateDSName(datasourceName, connectionType, connectAllowed)

    }


    function onRemoveClicked(id,index){
        // Remove datasource
        DatasourceDS.deleteDatasource(id, index)
    }

    function onEditClicked(datasourceName, index){

        if(typeof settings.value("user/sessionToken") != "undefined"){
            connectGrafieks1.visible = true
        } else{

        }
    }


    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts


    ListView {
        id: listView
        model: DatasourceModel
        anchors.fill: parent
        contentWidth: parent.width
        width: parent.width
        flickableDirection: Flickable.HorizontalAndVerticalFlick


        header: Row {
            id:dsHeader
            spacing: 1
            function itemAt(index) { return repeater.itemAt(index) }


            Repeater {
                id: repeater
                model: headersModel


                Rectangle {
                    height: 30
                    width: listView.width / headerSize


                    Text{
                        text: modelData
                        anchors.verticalCenter: parent.verticalCenter
                        leftPadding: 40
                    }
                }
            }

        }


        highlight: Rectangle{
            color:"#AEE5FC"
            width: parent
            opacity: 0.3
            z:10

        }


        delegate: Column {

            id: delegate


            Row {
                spacing: 2
                height: 40

//                MouseArea:{
//                    hoverEnabled: true
//                    onHoveredChanged:dsName_col
//                }

                Column{
                    id: dsName_col
                    width: listView.width / headerSize
                    height: parent.height


                    Rectangle{
                        width: parent.width
                        height: parent.height

                        Text {
                            text: qsTr(datasourceName)
                            leftPadding: 40
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                onDataSourceNameClicked(datasourceName, index, connectionType, connectAllowed)
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
                            leftPadding: 40
                            anchors.verticalCenter: parent.verticalCenter

                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                onDataSourceOwnerClicked(datasourceName, index, connectionType, connectAllowed)
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
                            leftPadding: 40
                            anchors.verticalCenter: parent.verticalCenter

                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {

                                onConnectionClicked(datasourceName, index, connectionType, connectAllowed)

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
                            leftPadding: 40
                            anchors.verticalCenter: parent.verticalCenter

                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                onDateCreatedClicked(datasourceName, index, connectionType, connectAllowed)
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
                            text: qsTr(lastrun)
                            leftPadding: 40
                            anchors.verticalCenter: parent.verticalCenter

                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                onLastRefreshedClicked(datasourceName, index, connectionType, connectAllowed)
                            }
                        }
                    }


                }

//                Column{
//                    id: dsEditRemove_col
//                    width: listView.width / headerSize
//                    height: parent.height

//                    leftPadding: 10
//                    anchors.verticalCenter: parent.verticalCenter

//                    Row{
//                        spacing: 5

//                        Button{
//                            id: btn_edit
//                            text: "Edit"
//                            height: 23
//                            width: implicitWidth

//                            onClicked: {
//                                onEditClicked(datasourceName, index)
//                            }
//                        }

//                        Button{
//                            id: btn_remove
//                            text: "Remove"
//                            height: 23
//                            width: implicitWidth

//                            onClicked: {
//                                onRemoveClicked(id,index)
//                            }
//                        }
//                    }
//                }

            }
//            Rectangle {
//                color: Constants.themeColor
//                width: parent.width
//                height: 1
//            }
        }

        ScrollIndicator.horizontal: ScrollIndicator { }
        ScrollIndicator.vertical: ScrollIndicator { }
    }



    // Page Design Ends
    /***********************************************************************************************************************/


}
