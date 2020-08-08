/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Data/SubComponents
** InMemory
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3


import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents"

Popup {
    id: popupMain
    width: 600
    height: 400
    x: parent.width / 2 - 380
    y: 100
    modal: true
    visible: false
    padding: 0


    background: Rectangle{
        color: Constants.whiteColor
    }



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


    Component.onCompleted: {
        SchedulerDS.fetchSchedulers()
    }

    Connections{
        target: TableSchemaModel

        onTableSchemaObtained:{
            columnsDropdown.model = queriedColumnNames
        }
    }



    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS


    function closePopup(){
        popupMain.visible = false
    }

    function onAddClicked(){
        closePopup()
    }

    function onIncrementalExtractClicked(){
        console.log("clicked incremental extract")

        // Save the value in C++
        DSParamsModel.setIsFullExtract(false)
    }

    function onFullExtractClicked(){
        console.log("clicked full extract")

        // Save the value in C++
        DSParamsModel.setIsFullExtract(true)
    }

    function onSchedulerIndexChanged(currentValue, currentText, currentIndex){
        DSParamsModel.setSchedulerId(currentValue)
    }

    function onIncrementalIndexChanged(currentText, currentIndex){
        DSParamsModel.setExtractColName(currentText)
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
        id: headerPopup
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
            text: "Data Extract"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left : parent.left
            font.pixelSize: Constants.fontCategoryHeader
            anchors.leftMargin: 10
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
                    closePopup()
                }
            }
        }

    }
    // Popup Header ends

    Rectangle{
        id: content
        anchors.top: headerPopup.bottom
        height: 100
        width: parent.width
        color: Constants.whiteColor

        // Full Extract Radio Button Starts

        Row{
            id: fullExtactRadioBtn
            height: 40
            padding: 30
            RadioButtonTpl{
                id: radio_memory
                radio_text: qsTr("Full Extract")
                radio_checked: false
                parent_dimension: 16

                MouseArea{

                    anchors.fill: parent
                    onClicked: {
                        onFullExtractClicked()
                    }
                }
            }
        }

        // Full Extract Radio Button Ends

        // Incremental Extract Radio Button Starts

        Row{
            id: incrementalExtactRadioBtn
            anchors.top: fullExtactRadioBtn.bottom
            height:40
            padding: 30
            RadioButtonTpl{
                id: radio_memory2
                radio_text: qsTr("Incremental Extract")
                radio_checked: false
                parent_dimension: 16

                MouseArea{

                    anchors.fill: parent
                    onClicked: {

                        onIncrementalExtractClicked()

                    }
                }
            }
        }

        // Incremental Extract Radio Button Ends

        // Select Dropdown Content Starts

        Column{
            id: selectColumn
            anchors.top: incrementalExtactRadioBtn.bottom
            anchors.topMargin: 10
            height: 40
            padding: 30
            width: parent.width

            spacing: 10

            // Text for Incremental Extract Dropdown Content Starts

            Text {
                id: incrementalExtactSelectbtnText
                text: qsTr("Select the column for incremental extract")
                anchors.bottomMargin: 20
                leftPadding: 30
            }

            // Text for Incremental Extract Dropdown Content Ends

            // Incremental Extract Dropdown  Ends

            Rectangle{
                id: incrementalExtactSelectbtn
                height: 40
                anchors.topMargin: 20
                width: parent.width - 120



                ComboBox{
                    id: columnsDropdown
                    currentIndex: 0
                    onCurrentIndexChanged: {

                        console.log(currentText, currentIndex)
                        onIncrementalExtractClicked(currentText, currentIndex)

                    }

                }


                //                SelectDropdown{
                //                    textValue:"abc"
                //                    list: incrementalExtactDropDown
                //                    height: incrementalExtactDropDown.count * 30
                //                    anchors.topMargin: 20
                //                    anchors.left: parent.left
                //                    anchors.leftMargin: 30
                //                }

            }

            // Incremental Extract Dropdown Ends


            // Text for Schedule Data Extract Content Ends


            Text {
                text: qsTr("Select schedule for data extraction")
                anchors.bottomMargin: 20
                leftPadding: 30
            }
            // Text for Schedule Data Extract Content Ends

            // Text for Schedule Data Extract Dropdown Starts

            Rectangle{
                height: 60
                anchors.topMargin: 20
                width: parent.width - 120



                ComboBox{
                    id: schedulerDropdown
                    textRole: "Name"
                    valueRole: "ScheduleID"
                    currentIndex: 0
                    model: SchedulerModel
                    onCurrentIndexChanged: {
                        console.log(currentValue, currentText, currentIndex)

                        onSchedulerIndexChanged(currentValue, currentText, currentIndex)

                    }

                }

                //                SelectDropdown{
                //                    id: scheduleForExtractDropdown
                //                    textValue:"abc"
                //                    list: incrementalExtactDropDown
                //                    height: incrementalExtactDropDown.count * 30
                //                    anchors.topMargin: 20
                //                    anchors.left: parent.left
                //                    anchors.leftMargin: 30
                //                }

                Text {
                    id: noteText
                    leftPadding: 30
                    anchors.top: schedulerDropdown.bottom
                    anchors.topMargin: 10
                    text: qsTr("Above field will show all data extract schedule that is set up in GRS")
                }

            }

            // Text for Schedule Data Extract Dropdown ends

            // Add button Starts

            CustomButton{
                id: addBtn
                anchors.right: parent.right
                anchors.rightMargin: 60
                textValue: "Add"

                onClicked: {
                    onAddClicked()
                }
            }

            // Add button Ends

        }

    }

    // Page Design Ends
    /***********************************************************************************************************************/

}
