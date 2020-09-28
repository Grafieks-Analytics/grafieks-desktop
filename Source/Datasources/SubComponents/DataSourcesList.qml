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

Page {

    id: data_source_list_page
    property var headersModel : ["Data Source Name", "Published By", "Live/Extract", "Published On", "Last Refreshed", "Edit"]
    property int headerSize : headersModel.length


    /***********************************************************************************************************************/
    // LIST MODEL STARTS


    // LIST MODEL ENDS
    /***********************************************************************************************************************/


    /***********************************************************************************************************************/
    // SIGNALS STARTS


    signal updateDSName(string signalDSName);



    // SIGNALS ENDS
    /***********************************************************************************************************************/



    /***********************************************************************************************************************/
    // Connections Starts



    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    function onDataSourceNameClicked(datasourceName, index){
        listView.currentIndex = index
        updateDSName(datasourceName)
    }

    function onDataSourceOwnerClicked(datasourceName, index){
        listView.currentIndex = index
        updateDSName(datasourceName)
    }

    function onConnectionClicked(datasourceName, index){
        listView.currentIndex = index;
        updateDSName(datasourceName)
    }

    function onDateCreatedClicked(datasourceName, index){
        listView.currentIndex = index;
        updateDSName(datasourceName)
    }

    function onLastRefreshedClicked(datasourceName, index){
        listView.currentIndex = index;
        updateDSName(datasourceName)

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

                                onDataSourceNameClicked(datasourceName, index)

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
                                onDataSourceOwnerClicked(datasourceName, index)
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

                                onConnectionClicked(datasourceName, index)

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
                                onDateCreatedClicked(datasourceName, index)
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
                                onLastRefreshedClicked(datasourceName, index)
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

                            onClicked: {
                                onEditClicked(datasourceName, index)
                            }
                        }

                        Button{
                            id: btn_remove
                            text: "Remove"
                            height: 23
                            width: implicitWidth

                            onClicked: {
                                onRemoveClicked(id,index)
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



    // Page Design Ends
    /***********************************************************************************************************************/


}
