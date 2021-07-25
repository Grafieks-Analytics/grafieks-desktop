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
import QtQml.Models 2.2

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

    property int counter: 0


    /***********************************************************************************************************************/
    // LIST MODEL STARTS

    ListModel{
        id: listModel
        dynamicRoles: true
        //           Component.onCompleted: {
        //               var numbers = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40]
        //               for(var i in numbers){
        //                   var number = numbers[i]
        //                   listModel.append({"number": number, "checked": true})
        //               }
        //           }
    }

    // LIST MODEL ENDS
    /***********************************************************************************************************************/


    /***********************************************************************************************************************/
    // SIGNALS STARTS



    // SIGNALS ENDS
    /***********************************************************************************************************************/



    /***********************************************************************************************************************/
    // Connections Starts

    Connections{
        target: DSParamsModel

        function onInternalCounterChanged(){
            if(DSParamsModel.section === Constants.categoricalTab){
                counter = DSParamsModel.internalCounter
            }
        }

        function onFilterIndexChanged(){
            counter = DSParamsModel.filterIndex
        }
    }

    Connections{
        target: DuckDataModel

        function onColumnListModelDataChanged(colData, values){
            updateData(colData, values)
        }
    }

    Connections{
        target: ForwardOnlyDataModel

        function onColumnListModelDataChanged(colData, values){
            updateData(colData, values)
        }
    }

    Connections{
        target: QueryDataModel

        function onColumnListModelDataChanged(colData, values){
            updateData(colData, values)
        }
    }

    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    Component.onCompleted: {
        if(DSParamsModel.section === Constants.categoricalTab){
            mainCheckBox.visible = true
        }
    }


    // SLOT function
    function slotDataCleared(){
        if(DSParamsModel.section === Constants.categoricalTab){
            DSParamsModel.removeTmpSelectedValues(0, true)
        }
    }

    function updateData(colData, options){

        if(DSParamsModel.section === Constants.categoricalTab){
            // Just to reset the data if the previous `colData` and the new `colData` are same

            var i = 0
            colData.forEach(item => {
                                listModel.append({"name": item, "checked": true, "index" : i})
                                i++
                            })

//            singleSelectCheckList.model = []
//            multiSelectCheckList.model = []

//            singleSelectCheckList.model = colData
//            multiSelectCheckList.model  = colData

            singleSelectCheckList.model = listModel
            multiSelectCheckList.model  = listModel

            var jsonOptions = JSON.parse(options)


            if(jsonOptions.subCategory === Constants.categorySubMulti){
                multiSelectRadio.checked = true

                multiSelectCheckList.visible = true
                singleSelectCheckList.visible = false

                if(jsonOptions.values.length > 0){

                    if(jsonOptions.values === "%"){
                        colData.forEach((item) => {
                                            DSParamsModel.setTmpSelectedValues(item)
                                        })
                    } else{

                        var checkedValues = jsonOptions.values.split(",")
                        checkedValues.forEach((item) => {
                                                  DSParamsModel.setTmpSelectedValues(item)
                                              })
                    }
                }

            } else{
                singleSelectRadio.checked = true

                multiSelectCheckList.visible = false
                singleSelectCheckList.visible = true

                if(DSParamsModel.searchTmpSelectedValues(jsonOptions.values) < 0){
                    DSParamsModel.setTmpSelectedValues(jsonOptions.values)
                }
            }
        }
    }

    function onMultiSelectSelected(){
        if(DSParamsModel.section === Constants.categoricalTab){
            multiSelectCheckList.visible = true
            singleSelectCheckList.visible = false

            // Set the sub category for filter
            DSParamsModel.setSubCategory(Constants.categorySubMulti)
            mainCheckBox.visible = true
        }
    }


    function onSingleSelectSelected(){

        if(DSParamsModel.section === Constants.categoricalTab){
            multiSelectCheckList.visible = false
            singleSelectCheckList.visible = true

            // Set the sub category for filter
            DSParamsModel.setSubCategory(Constants.categorySubSingle)
            mainCheckBox.visible = false
        }
    }


    function onSingleSelectRadioSelected(modelData){

        if(DSParamsModel.section === Constants.categoricalTab){
            DSParamsModel.addToJoinValue(counter, modelData.toString())
            DSParamsModel.addToJoinRelation(counter, Constants.equalRelation)
            DSParamsModel.addToJoinRelationSlug(counter, Constants.slugEqualRelation)

            // Clear all tmp selected values and insert again
            DSParamsModel.removeTmpSelectedValues(0, true)
            DSParamsModel.setTmpSelectedValues(modelData.toString())
        }
    }


    function onTextChangedSearch(){
        if(DSParamsModel.section === Constants.categoricalTab){
            var options = {
                "section" : DSParamsModel.section,
                "category" : DSParamsModel.category,
                "subCategory" : DSParamsModel.subCategory,
                "values" : DSParamsModel.fetchJoinValue(counter)[counter],
                "relation" : DSParamsModel.fetchJoinRelation(counter),
                "slug" : DSParamsModel.fetchJoinRelationSlug(counter)

            }

            QueryDataModel.columnSearchData(DSParamsModel.colName, DSParamsModel.tableName, searchText.text, JSON.stringify(options))

            if(DSParamsModel.subCategory === Constants.categorySubMulti){
                if(searchText.text.length > 0){
                    mainCheckBox.visible = false
                } else{
                    mainCheckBox.visible = true
                }
            }
        }
    }

    function onAllCheckBoxCheckedChanged(checked){
        if(DSParamsModel.section === Constants.categoricalTab){
            setCheckedAll(checked)
        }
    }

    function setCheckedAll(checked){

        if(DSParamsModel.section === Constants.categoricalTab){
            // If Select All option is true
            if(DSParamsModel.section === Constants.categoricalTab){
                if(checked === true){

                    DSParamsModel.addToJoinValue(counter, "%")
                    DSParamsModel.setActualDateValues(counter, "%")
                    DSParamsModel.setSelectAllMap(counter, true)
                    DSParamsModel.addToJoinRelation(counter, Constants.likeRelation)
                    DSParamsModel.addToJoinRelationSlug(counter, Constants.slugLikeRelation)
                }
            }
        }
    }

    function onMultiSelectCheckboxSelected(modelData,checked){

        if(DSParamsModel.section === Constants.categoricalTab){
            if(mainCheckBox.checked === true){

                if(checked === false){
                    // Set SELECT ALL to false
                    DSParamsModel.setSelectAllMap(counter, false)
                    mainCheckBox.checked = false
                }
            } else{
                if(checked === true){

                    // Start pushing the individual checked item in the array
                    if(DSParamsModel.searchTmpSelectedValues(modelData) < 0){
                        DSParamsModel.setTmpSelectedValues(modelData)
                    }

                } else{
                    // Remove item if unchecked
                    const index = DSParamsModel.searchTmpSelectedValues(modelData);
                    if (index > -1) {
                        DSParamsModel.removeTmpSelectedValues(index);
                    }
                }

                // Save the array and Set relation type to IN


                DSParamsModel.addToJoinValue(counter, DSParamsModel.getTmpSelectedValues(0, true).toString())
                DSParamsModel.addToJoinRelation(counter, Constants.inRelation)
                DSParamsModel.addToJoinRelationSlug(counter, Constants.slugInRelation)
            }
        }
    }

    function onIncludeCheckedClicked(checked){
        if(DSParamsModel.section === Constants.categoricalTab){
            DSParamsModel.setIncludeNullMap(counter,checked)
        }
    }


    function onExcludeCheckedClicked(checked){
        if(DSParamsModel.section === Constants.categoricalTab){
            DSParamsModel.setExcludeMap(counter, checked)
        }
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
                selectByMouse: true
                leftPadding: 20
                height: 30
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
                checked: DSParamsModel.getSelectAllMap(counter)[counter] === "1" ? true : false
                text: "All"
                y:2
                parent_dimension: Constants.defaultCheckBoxDimension
                checkState: childGroup.checkState

                //                onCheckedChanged: {
                //                    onAllCheckBoxCheckedChanged(checked)
                //                }

                onCheckStateChanged: {
                    for(var i =0; i < listModel.count; ++i){
                        listModel.setProperty(i, "checked", checked)
                    }
                    onAllCheckBoxCheckedChanged(checked)
                }
            }

            ListView {
                id: multiSelectCheckList
                //                model: ColumnListModel
                model: listModel
                height: parent.height-38
                width: parent.width
                anchors.top: mainCheckBox.bottom
                anchors.topMargin: 0

                flickableDirection: Flickable.VerticalFlick
                boundsBehavior: Flickable.StopAtBounds
                clip: true
                ScrollBar.vertical: CustomScrollBar {}



                delegate: Column{
                    height:20
                    CheckBoxTpl {
                        id: modelCheckBoxes
                        y:2
//                        text: modelData
                        text: model.name
                        parent_dimension: Constants.defaultCheckBoxDimension
                        ButtonGroup.group: childGroup
//                        objectName: modelData
                        objectName: model.index

                        onCheckedChanged: {
//                            onMultiSelectCheckboxSelected(modelData,checked)
//                            onMultiSelectCheckboxSelected(model.name,checked)
                        }
                        // On search, highlight selected option
                        Component.onCompleted: {
//                            modelCheckBoxes.checked = DSParamsModel.searchTmpSelectedValues(modelData) >= 0 ? true: false
                            modelCheckBoxes.checked = DSParamsModel.searchTmpSelectedValues(model.name) >= 0 ? true: false
                        }

                        // On edit, highlight the selected option
//                        Connections{
//                            target: DSParamsModel
//                            function onTmpSelectedValuesChanged(values){
//                                if(DSParamsModel.mode === Constants.modeEdit && DSParamsModel.category === Constants.categoryMainListType && DSParamsModel.subCategory === Constants.categorySubMulti){
//                                    modelCheckBoxes.checked = values.indexOf(modelCheckBoxes.objectName) >= 0 ? true: false
//                                }
//                            }
//                        }
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
            height: parent.height-35
            width: parent.width
            visible: false
            spacing: 2
            anchors.top: mainCheckBox.bottom
            anchors.topMargin: 1
            y:30

            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds
            clip: true
            ScrollBar.vertical: CustomScrollBar {}

            delegate: Row{

                height: 20
                width: singleSelectCheckList.width

                Column{

                    CustomRadioButton {
                        id: modelRadioButton
                        text: modelData
                        objectName: modelData
                        ButtonGroup.group: btngrp
                        height: Constants.defaultRadioDimension
                        width: Constants.defaultRadioDimension
                        parent_dimension: Constants.defaultRadioDimension
                        onCheckedChanged: {
                            onSingleSelectRadioSelected(modelData)
                        }

                        // On search, highlight the selected radio
                        Component.onCompleted: {
                            if(DSParamsModel.section === Constants.categoricalTab){
                                modelRadioButton.checked = DSParamsModel.getTmpSelectedValues(0, true)[0] === modelData ? true: false
                            }
                        }

                        // On edit, highlight the selected option
                        Connections{
                            target: DSParamsModel
                            function onTmpSelectedValuesChanged(values){
                                if(DSParamsModel.mode === Constants.modeEdit && DSParamsModel.category === Constants.categoryMainListType && DSParamsModel.subCategory === Constants.categorySubSingle){
                                    modelRadioButton.checked = values[0] === modelRadioButton.objectName ? true: false
                                }
                            }
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
        anchors.topMargin: 7
        anchors.left: parent.left
        height: 30
        width: parent.width
        anchors.leftMargin: 10

        color: "transparent"




        Column{
            anchors.left: includeExcludeRow.left

            CheckBoxTpl {
                checked: DSParamsModel.getIncludeNullMap(counter)[counter] === "1" ? true : false
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
                checked: DSParamsModel.getExcludeMap(counter)[counter] === "1" ? true : false
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