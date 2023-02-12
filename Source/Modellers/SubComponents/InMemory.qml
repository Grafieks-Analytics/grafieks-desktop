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
import com.grafieks.singleton.messages 1.0

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

    Connections{
        target: TableSchemaModel

        function onTableSchemaObtained(allList, allCategorical, allNumerical, allDates, allOthers, queriedColumnNames){
            columnsDropdown.model = queriedColumnNames
        }
    }



    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    Component.onCompleted: {
        SchedulerDS.fetchSchedulers()
        DSParamsModel.setSchedulerId(0)
    }


    function closePopup(){
        popupMain.visible = false
    }

    function onAddClicked(){
        closePopup()
    }

    function onIncrementalExtractClicked(){

        // Save the value in C++
        DSParamsModel.setIsFullExtract(false)
    }

    function onFullExtractClicked(){

        // Save the value in C++
        DSParamsModel.setIsFullExtract(true)
    }

    function onSchedulerIndexChanged(currentValue, currentText, currentIndex){
        if(currentValue === "undefined"){
            DSParamsModel.setSchedulerId(0)
        } else {
            DSParamsModel.setSchedulerId(currentValue)
        }


    }

    function onIncrementalIndexChanged(currentText, currentIndex){
        DSParamsModel.setExtractColName(currentText)
    }



    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts

    ButtonGroup{
        id: extractRadio
    }


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
            text: Messages.mo_sub_inm_dataExtract
            anchors.verticalCenter: parent.verticalCenter
            anchors.left : parent.left
            font.pixelSize: Constants.fontCategoryHeader
            anchors.leftMargin: 10
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
                onClicked: closePopup()
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
            CustomRadioButton{
                id: radio_memory
                radio_text: Messages.mo_sub_inm_fullExtract
                radio_checked: false
                parent_dimension: 16
                font.pixelSize: Constants.fontCategoryHeader
                ButtonGroup.group: extractRadio
                onCheckedChanged: onFullExtractClicked()
            }
        }

        // Full Extract Radio Button Ends

        // Incremental Extract Radio Button Starts

        Row{
            id: incrementalExtactRadioBtn
            anchors.top: fullExtactRadioBtn.bottom
            height:40
            padding: 30
            CustomRadioButton{
                id: radio_memory2
                radio_text: Messages.mo_sub_inm_incrementalExtract
                font.pixelSize: Constants.fontCategoryHeader
                radio_checked: false
                enabled: false
                parent_dimension: 16
                ButtonGroup.group: extractRadio
                onCheckedChanged: onIncrementalExtractClicked()
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
                text: Messages.mo_sub_inm_incrExtractCol
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

                anchors.left: parent.left
                anchors.leftMargin: 30

                CustomComboBox{
                    id: columnsDropdown
                    currentIndex: 0
                    anchors.left: parent.left
                    anchors.leftMargin: 30
                    width: parent.width
                    enabled: false
                    onCurrentIndexChanged: onIncrementalExtractClicked(currentText, currentIndex)

                }

            }

            // Incremental Extract Dropdown Ends


            // Text for Schedule Data Extract Content Ends


            Text {
                text: Messages.mo_sub_inm_selSchedule
                anchors.bottomMargin: 20
                leftPadding: 30
            }
            // Text for Schedule Data Extract Content Ends

            // Text for Schedule Data Extract Dropdown Starts

            Rectangle{
                height: 60
                anchors.topMargin: 20
                width: parent.width - 120
                anchors.left: parent.left

                anchors.leftMargin: 30


                CustomComboBox{
                    id: schedulerDropdown
                    textRole: "Name"
                    valueRole: "ScheduleID"
                    currentIndex: 0
                    anchors.left: parent.left
                    anchors.leftMargin: 30
                    width: parent.width
                    enabled: false

                    model: SchedulerModel
                    onCurrentIndexChanged: onSchedulerIndexChanged(currentValue, currentText, currentIndex)

                }

                Text {
                    id: noteText
                    leftPadding: 30
                    anchors.top: schedulerDropdown.bottom
                    anchors.topMargin: 10
                    text: Messages.mo_sub_inm_showFieldMsg
                    font.pixelSize: Constants.fontCategoryHeaderSmall
                }

            }

            // Text for Schedule Data Extract Dropdown ends

            // Add button Starts

            CustomButton{
                id: addBtn
                anchors.right: parent.right
                anchors.rightMargin: 60
                textValue: Messages.applyBtnTxt

                onClicked: onAddClicked()
            }

            // Add button Ends

        }

    }

    // Page Design Ends
    /***********************************************************************************************************************/

}
