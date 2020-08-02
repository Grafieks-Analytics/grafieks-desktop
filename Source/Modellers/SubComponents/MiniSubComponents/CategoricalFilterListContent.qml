/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Data
** Data Query Modeller
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

Rectangle{
    id: listContent
    height: parent.height - 80 - 40
    width: parent.width - 40
    x:20
    y:10
    anchors.top:  fullExtactRadioBtn.bottom
    color: Constants.whiteColor
    border.color: Constants.darkThemeColor

    property var checkedValues : []


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



    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS


    Component.onCompleted: {

        // For list category type
        // The db WHERE relation can only be IN / NOT IN ARRAY type
        // Except when "Select All" checked.
        // Then Relation will be LIKE

        DSParamsModel.setRelation(Constants.likeRelation)
    }


    function onMultiSelectSelected(){
        singleSelectRadio.radio_checked = false
        multiSelectRadio.radio_checked = true
        multiSelectCheckList.visible = true
        singleSelectCheckList.visible = false

        // Set the sub category for filter
        DSParamsModel.setSubCategory(Constants.categorySubMulti)
    }


    function onSingleSelectSelected(){

        singleSelectRadio.radio_checked = true
        multiSelectRadio.radio_checked = false
        multiSelectCheckList.visible = false
        singleSelectCheckList.visible = true

        // Set the sub category for filter
        DSParamsModel.setSubCategory(Constants.categorySubSingle)
    }


    function onSingleSelectRadioSelected(modelData){
        DSParamsModel.setValue(modelData.toString())
        DSParamsModel.setRelation(Constants.equalRelation)
    }


    function onTextChangedSearch(){
        ColumnListModel.likeColumnQuery(DSParamsModel.colName, DSParamsModel.tableName, searchText.text)
    }

    function onAllCheckBoxCheckedChanged(checked){
        // If Select All option is true
        if(checked === true){

            DSParamsModel.setRelation(Constants.likeRelation)
            DSParamsModel.setValue("%")
            checkedValues = []

        }
    }

    function onMultiSelectCheckboxSelected(modelData,checked){

//        if(mainCheckBox.checked === true){

//            if(checked === false){

//                // Set SELECT ALL to false
//                DSParamsModel.setSelectAll(false)
//                mainCheckBox.checked = false


//                // Start pushing the individual checked intem in the array
//                // Save the array and Set relation type to IN
//                checkedValues.push(modelData)
//                DSParamsModel.setValue(checkedValues.toString())
//                DSParamsModel.setRelation("IN")
//            }
//        }

        if(mainCheckBox.checked === true){

            if(checked === false){

                // Set SELECT ALL to false
                DSParamsModel.setSelectAll(false)
                mainCheckBox.checked = false

            }
        } else{
            if(checked === true){

                // Start pushing the individual checked item in the array
                checkedValues.push(modelData)
                console.log(checkedValues)

            } else{
                 // Remove item if unchecked
                const index = checkedValues.indexOf(modelData);
                if (index > -1) {
                  checkedValues.splice(index, 1);
                }
            }

            // Save the array and Set relation type to IN

            DSParamsModel.setValue(checkedValues.toString())
            DSParamsModel.setRelation(Constants.inRelation)
        }

    }

    function onIncludeCheckedClicked(checked){
        DSParamsModel.setIncludeNull(checked)
    }


    function onExcludeCheckedClicked(checked){
        DSParamsModel.setExclude(checked)
    }

    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts




    Rectangle{
        id: selectTypeRadioBtn
        height: 40
        width: parent.width
        color: "transparent"

        Column{

            id: multiSelectRadioColumn
            anchors.top: selectTypeRadioBtn.top

            padding: 10
            leftPadding: 30

            RadioButtonTpl{
                id: multiSelectRadio
                radio_text: qsTr("Multi Select")
                radio_checked: true
                parent_dimension: 16

                MouseArea{
                    anchors.fill: parent
                    onClicked: {

                        onMultiSelectSelected()
                    }
                }
            }

        }

        Column{
            id: singleSelectRadioColumn

            padding: 10
            anchors.right: selectTypeRadioBtn.right
            rightPadding: 30

            RadioButtonTpl{
                id: singleSelectRadio
                radio_text: qsTr("Single Select")
                radio_checked: false
                parent_dimension: 16


                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        onSingleSelectSelected()
                    }
                }

            }
        }
    }

    Rectangle{
        id: searchTextBox
        anchors.top: selectTypeRadioBtn.bottom
        anchors.topMargin: 8
        width: parent.width
        height: 40
        color: "transparent"

        Rectangle{

            height: 30
            radius: 4
            width: parent.width - 8
            anchors.left: searchTextBox.left
            anchors.leftMargin: 4

            TextField{
                id: searchText
                placeholderText: "Search"
                leftPadding: 20
                height: 40
                width: parent.width - 20
                x: 10

                background: Rectangle{
                    border.color: Constants.borderBlueColor
                    radius: 4
                }

                onTextChanged: {
                    onTextChangedSearch()
                }
            }
        }

    }


    Rectangle{
        id: listInnerContent
        height: listContent.height - ( selectTypeRadioBtn.height  + searchTextBox.height + includeExcludeRow.height + footerContent.height)
        width: parent.width - 30
        anchors.top: searchTextBox.bottom
        anchors.left: searchTextBox.left
        anchors.leftMargin: 15
        anchors.topMargin: 8

        color: Constants.themeColor
        border.color: Constants.darkThemeColor



        // Checkbox ListView
        // List Filters starts

        Item {
            id : somepageid
            height: parent.height
            width: parent.width

            ButtonGroup {
                id: childGroup
                exclusive: false
                checkState: mainCheckBox.checkState
            }

            CheckBox {
                id: mainCheckBox
                checked: DSParamsModel.selectAll
                text: "All"
                indicator.width: 15
                indicator.height: 15
                checkState: childGroup.checkState

                onCheckedChanged: {
                    onAllCheckBoxCheckedChanged(checked)
                }
            }

            ListView {
                id: multiSelectCheckList
                model: ColumnListModel
                height: parent.height
                width: parent.width
                anchors {
                    top: mainCheckBox.top
                    topMargin: 20
                }

                delegate: Column{
                    height:20
                    CheckBox {
                        id: modelCheckBoxes
                        checked: true
                        text: modelData
                        indicator.width: 15
                        indicator.height: 15
                        ButtonGroup.group: childGroup

                        onCheckedChanged: {
                            onMultiSelectCheckboxSelected(modelData,checked)
                        }
                    }
                }
            }
        }



        // Checkbox ListView
        // List Filters ends

        // Mutually exclusive radio buttons

        ButtonGroup {
            id: btngrp
            buttons: singleSelectCheckList.RadioButtonTpl

        }

        // Radio button ListView
        // List Filters starts

        ListView{

            id: singleSelectCheckList
            model: ColumnListModel
            height: parent.height
            width: parent.width
            visible: false

            delegate: Row{

                height: 20
                width: singleSelectCheckList.width

                Column{

//                        RadioButtonTpl {
//                            radio_text: modelData
//                            parent_dimension: 16
//                            ButtonGroup.group: btngrp

//                            onRadio_checkedChanged: {
//                                console.log(modelData, radio_checked)
//                            }

//                        }


                    RadioButtonTpl {
                        text: modelData
                        ButtonGroup.group: btngrp
                        height: 16
                        width: 16
                        parent_dimension: 16
                        onCheckedChanged: {
                            onSingleSelectRadioSelected(modelData)
                        }
                    }
                }

            }
        }

        // Radio button ListView
        // List Filters ends

    }

    Rectangle{
        id: includeExcludeRow
        anchors.top:  listInnerContent.bottom
        anchors.left: parent.left
        height: 30
        width: parent.width
        anchors.leftMargin: 10

        color: "transparent"

        Column{
            anchors.left: includeExcludeRow.left

            CheckBox {
                checked: DSParamsModel.includeNull
                text: qsTr("Include Null")
                indicator.width: 15
                indicator.height: 15

                onCheckStateChanged: {
                    onIncludeCheckedClicked(checked)
                }

            }
        }

        Column{
            anchors.right: includeExcludeRow.right
            anchors.rightMargin: 30
            CheckBox {
                checked: DSParamsModel.exclude
                text: qsTr("Exclude")
                indicator.width: 15
                indicator.height: 15

                onCheckStateChanged: {
                    onExcludeCheckedClicked(checked)
                }


            }
        }

    }



    // Page Design Ends
    /***********************************************************************************************************************/


}
