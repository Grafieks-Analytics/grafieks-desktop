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
    //    anchors.top:  fullExtactRadioBtn.bottom
    color: Constants.whiteColor
    border.color: Constants.darkThemeColor

    property var checkedValues : []
    readonly property string mapKey: "0"

    /***********************************************************************************************************************/
    // LIST MODEL STARTS



    ListModel{
        id: dateFormatList

        ListElement{
            menuItem:"dd/mm/yyyy"
        }

        ListElement{
            menuItem:"dd mmmm yyyy"
        }

        ListElement{
            menuItem:"d mmmm yyyy"
        }

        ListElement{
            menuItem:"dddd, d mmmm yyyy"
        }

        ListElement{
            menuItem:"dddd, dd mmmm yyyy"
        }

        ListElement{
            menuItem:"dd/mm/yy"
        }

        ListElement{
            menuItem:"d/m/yy"
        }

        ListElement{
            menuItem:"d.m.yy"
        }

        ListElement{
            menuItem:"yyyy-mm-dd"
        }
        ListElement{
            menuItem:"d mmmm"
        }
        ListElement{
            menuItem:"yy"
        }

        ListElement{
            menuItem:"yyyy"
        }

        ListElement{
            menuItem:"dd/mm/yyyy HH:MM:SS"
        }
    }


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

        DSParamsModel.addToJoinValue(mapKey, modelData.toString())
        DSParamsModel.addToJoinRelation(mapKey, Constants.equalRelation)
    }


    function onTextChangedSearch(){
        ColumnListModel.likeColumnQuery(DSParamsModel.colName, DSParamsModel.tableName, searchText.text)
    }

    function onAllCheckBoxCheckedChanged(checked){
        // If Select All option is true
        if(checked === true){

            if(DSParamsModel.mode === Constants.modeCreate){

                DSParamsModel.addToJoinValue(mapKey, "%")

            } else{
                DSParamsModel.addToJoinValue(mapKey, checkedValues.toString())
            }

            DSParamsModel.addToJoinRelation(mapKey, Constants.likeRelation)
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

            DSParamsModel.addToJoinValue(mapKey, checkedValues.toString())
            DSParamsModel.addToJoinRelation(mapKey, Constants.inRelation)
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

    ButtonGroup{
        id: selectTypeRadioGroup
    }

    ButtonGroup{
        id:singleSelectRadioGroup
    }

    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts


    Rectangle{
        id: selectTypeRadioBtn
        height: 40
        width: parent.width - 4
        anchors.left: parent.left
        anchors.leftMargin: 2

        Column{

            id: multiSelectRadioColumn
            //            anchors.top: selectTypeRadioBtn.top

            padding: 10
            leftPadding: 30

            CustomRadioButton{
                id: multiSelectRadio
                radio_text: qsTr("Multi Select")
                radio_checked: true
                parent_dimension: 16
                ButtonGroup.group: selectTypeRadioGroup
                onCheckedChanged: {
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
                radio_text: qsTr("Single Select")
                radio_checked: false
                parent_dimension: 16
                ButtonGroup.group: selectTypeRadioGroup
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
        width: parent.width - 4
        height: 40
        anchors.left: parent.left
        anchors.leftMargin: 2

        Rectangle{

            height: 30
            radius: 4
            width: parent.width - 10
            anchors.left: searchTextBox.left
            anchors.leftMargin: 4

            TextField{
                placeholderText: "Search"
                leftPadding: 20
                height: 40
                anchors.top: parent.top
                width: parent.width - 20
                x: 10

                background: Rectangle{
                    border.color: Constants.borderBlueColor
                    radius: 4
                }
            }
        }

    }


    Rectangle{
        id: listInnerContent
        height: listContent.height - ( selectTypeRadioBtn.height  + searchTextBox.height + includeExcludeRow.height + footerContent.height)
        width: parent.width - 35
        anchors.top: searchTextBox.bottom
        anchors.left: searchTextBox.left
        anchors.leftMargin: 15
        anchors.topMargin: 8

        color: Constants.themeColor
        border.color: Constants.darkThemeColor

        // Checklist Button ListView
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



            ListView {
                id: multiSelectCheckList
                model: ColumnListModel
                height: parent.height
                width: parent.width
                anchors {
                    top: mainCheckBox.top
                    topMargin: 20
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
                delegate: Row{
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
        // Checklist Button ListView
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
                        ButtonGroup.group: singleSelectRadioGroup
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





        Column{
            width: parent.width/2
            height: parent.height

            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.right: parent.right
            spacing: 5

            CustomComboBox{
                currentIndex: 0
                model: dateFormatList
                textRole: "menuItem"
                valueRole: "compareValue"

                anchors{
                    right: parent.right
                    rightMargin: 10
                }
            }

        }

    }

    Rectangle{
        id: includeExcludeRow
        anchors.top:  listInnerContent.bottom
        anchors.left: parent.left
        height: 30
        width: parent.width - 25
        anchors.leftMargin: 10

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
