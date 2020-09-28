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



    function onMultiSelectSelected(){
        multiSelectCheckList.visible = true
        singleSelectCheckList.visible = false

        // Set the sub category for filter
        DSParamsModel.setSubCategory(Constants.categorySubMulti)
    }


    function onSingleSelectSelected(){

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

            if(DSParamsModel.mode === Constants.modeCreate){

                DSParamsModel.setValue("%")
            } else{
                DSParamsModel.setValue(checkedValues.toString())
            }

            DSParamsModel.setRelation(Constants.likeRelation)
            checkedValues = []

        }
    }

    function onMultiSelectCheckboxSelected(modelData,checked){

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

    // Mutually exclusive radio buttons

    ButtonGroup {
        id: btngrp
    }


    ButtonGroup{
        id: selectTypeRadioBtnGrp
    }



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

            CustomRadioButton{
                id: multiSelectRadio
                text: qsTr("Multi Select")
                ButtonGroup.group: selectTypeRadioBtnGrp
                checked: true
                parent_dimension: 16
                onCheckedChanged:{
                    onMultiSelectSelected()
                }
            }

        }

        Column{
            id: singleSelectRadioColumn

            padding: 10
            anchors.right: selectTypeRadioBtn.right
            rightPadding: 30

            CustomRadioButton{
                id: singleSelectRadio
                text: qsTr("Single Select")
                ButtonGroup.group: selectTypeRadioBtnGrp
                parent_dimension: 16
                onCheckedChanged: {
                    onSingleSelectSelected()
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

            CheckBoxTpl {
                id: mainCheckBox
                checked: DSParamsModel.selectAll
                text: "All"
                parent_dimension: Constants.defaultCheckBoxDimension
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
                    CheckBoxTpl {
                        id: modelCheckBoxes
                        checked: true
                        text: modelData
                        parent_dimension: Constants.defaultCheckBoxDimension
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



        // Radio button ListView
        // List Filters starts

        ListView{

            id: singleSelectCheckList
            model: ColumnListModel
            height: parent.height
            width: parent.width
            visible: false
            spacing: 2

            delegate: Row{

                height: 20
                width: singleSelectCheckList.width

                Column{

                    CustomRadioButton {
                        text: modelData
                        ButtonGroup.group: btngrp
                        height: Constants.defaultRadioDimension
                        width: Constants.defaultRadioDimension
                        parent_dimension: Constants.defaultRadioDimension
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

            CheckBoxTpl {
                checked: DSParamsModel.includeNull
                text: qsTr("Include Null")
                parent_dimension: Constants.defaultCheckBoxDimension

                onCheckStateChanged: {
                    onIncludeCheckedClicked(checked)
                }

            }
        }

        Column{
            anchors.right: includeExcludeRow.right
            anchors.rightMargin: 30
            CheckBoxTpl {
                checked: DSParamsModel.exclude
                text: qsTr("Exclude")
                parent_dimension: Constants.defaultCheckBoxDimension

                onCheckStateChanged: {
                    onExcludeCheckedClicked(checked)
                }


            }
        }

    }



    // Page Design Ends
    /***********************************************************************************************************************/


}
