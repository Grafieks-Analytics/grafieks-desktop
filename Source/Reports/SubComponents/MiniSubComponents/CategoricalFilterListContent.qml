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

    property int counter: 0


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
        target: ReportParamsModel

        function onInternalCounterChanged(){
            if(ReportParamsModel.section === Constants.categoricalTab){
                counter = ReportParamsModel.internalCounter
            }
        }

        function onFilterIndexChanged(){
            if(ReportParamsModel.section === Constants.categoricalTab){
                counter = ReportParamsModel.filterIndex
            }
        }
    }

    Connections{
        target: DuckDataModel

        function onDuckColData(colData){
            if(ReportParamsModel.section === Constants.categoricalTab){
                singleSelectCheckList.model = colData
                multiSelectCheckList.model  = colData
            }
        }
    }

    Connections{
        target: ForwardOnlyDataModel

        function onForwardColData(colData){
            if(ReportParamsModel.section === Constants.categoricalTab){
                singleSelectCheckList.model = colData
                multiSelectCheckList.model  = colData
            }
        }
    }

    Connections{
        target: QueryDataModel

        function onColumnListModelDataChanged(colData, options, searchMode){


            if(ReportParamsModel.section === Constants.categoricalTab){
                // Just to reset the data if the previous `colData` and the new `colData` are same
                singleSelectCheckList.model = []
                multiSelectCheckList.model = []

                singleSelectCheckList.model = colData
                multiSelectCheckList.model  = colData

                var jsonOptions = JSON.parse(options)


                if(jsonOptions.subCategory === Constants.categorySubMulti){
                    multiSelectRadio.checked = true

                    multiSelectCheckList.visible = true
                    singleSelectCheckList.visible = false

                    if(jsonOptions.values.length > 0){
                        var checkedValues = jsonOptions.values.split(",")
                        checkedValues.forEach((item) => {
                                                  ReportParamsModel.setTmpSelectedValues(item)
                                              })
                    }

                } else{
                    singleSelectRadio.checked = true

                    multiSelectCheckList.visible = false
                    singleSelectCheckList.visible = true

                    if(ReportParamsModel.searchTmpSelectedValues(jsonOptions.values) < 0){
                        ReportParamsModel.setTmpSelectedValues(jsonOptions.values)
                    }
                }
            }
        }
    }

    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    Component.onCompleted: {
        if(ReportParamsModel.section === Constants.categoricalTab){
            mainCheckBox.visible = true
        }
    }


    // SLOT function
    function slotDataCleared(){
        if(ReportParamsModel.section === Constants.categoricalTab){
            ReportParamsModel.removeTmpSelectedValues(0, true)
        }
    }

    function onMultiSelectSelected(){
        if(ReportParamsModel.section === Constants.categoricalTab){
            multiSelectCheckList.visible = true
            singleSelectCheckList.visible = false

            // Set the sub category for filter
            ReportParamsModel.setSubCategory(Constants.categorySubMulti)
            mainCheckBox.visible = true
        }
    }


    function onSingleSelectSelected(){

        if(ReportParamsModel.section === Constants.categoricalTab){
            multiSelectCheckList.visible = false
            singleSelectCheckList.visible = true

            // Set the sub category for filter
            ReportParamsModel.setSubCategory(Constants.categorySubSingle)
            mainCheckBox.visible = false
        }
    }


    function onSingleSelectRadioSelected(modelData){

        if(ReportParamsModel.section === Constants.categoricalTab){
            ReportParamsModel.addToJoinValue(counter, modelData.toString())
            ReportParamsModel.addToJoinRelation(counter, Constants.equalRelation)
            ReportParamsModel.addToJoinRelationSlug(counter, Constants.equalRelation)

            // Clear all tmp selected values and insert again
            ReportParamsModel.removeTmpSelectedValues(0, true)
            ReportParamsModel.setTmpSelectedValues(modelData.toString())
        }
    }


    function onTextChangedSearch(){
        if(ReportParamsModel.section === Constants.categoricalTab){
            var options = {
                "section" : ReportParamsModel.section,
                "category" : ReportParamsModel.category,
                "subCategory" : ReportParamsModel.subCategory,
                "values" : ReportParamsModel.fetchJoinValue(counter)[counter],
                "relation" : ReportParamsModel.fetchJoinRelation(counter),
                "slug" : ReportParamsModel.fetchJoinRelationSlug(counter)

            }

            QueryDataModel.columnSearchData(ReportParamsModel.colName, ReportParamsModel.tableName, searchText.text, JSON.stringify(options))

            if(ReportParamsModel.subCategory === Constants.categorySubMulti){
                if(searchText.text.length > 0){
                    mainCheckBox.visible = false
                } else{
                    mainCheckBox.visible = true
                }
            }
        }
    }

    function onAllCheckBoxCheckedChanged(checked){
        if(ReportParamsModel.section === Constants.categoricalTab){
            setCheckedAll(checked)
        }
    }

    function setCheckedAll(checked){

        if(ReportParamsModel.section === Constants.categoricalTab){
            // If Select All option is true
            if(ReportParamsModel.section === Constants.categoricalTab){
                if(checked === true){

                    ReportParamsModel.addToJoinValue(counter, "%")
                    ReportParamsModel.setActualDateValues(counter, "%")
                    ReportParamsModel.setSelectAllMap(counter, true)
                    ReportParamsModel.addToJoinRelation(counter, Constants.likeRelation)
                    ReportParamsModel.addToJoinRelationSlug(counter, Constants.likeRelation)
                }
            }
        }
    }

    function onMultiSelectCheckboxSelected(modelData,checked){

        if(ReportParamsModel.section === Constants.categoricalTab){
            if(mainCheckBox.checked === true){

                if(checked === false){
                    // Set SELECT ALL to false
                    ReportParamsModel.setSelectAllMap(counter, false)
                    mainCheckBox.checked = false
                }
            } else{
                if(checked === true){

                    // Start pushing the individual checked item in the array
                    if(ReportParamsModel.searchTmpSelectedValues(modelData) < 0){
                        ReportParamsModel.setTmpSelectedValues(modelData)
                    }

                } else{
                    // Remove item if unchecked
                    const index = ReportParamsModel.searchTmpSelectedValues(modelData);
                    if (index > -1) {
                        ReportParamsModel.removeTmpSelectedValues(index);
                    }
                }

                // Save the array and Set relation type to IN


                ReportParamsModel.addToJoinValue(counter, ReportParamsModel.getTmpSelectedValues(0, true).toString())
                ReportParamsModel.addToJoinRelation(counter, Constants.inRelation)
                ReportParamsModel.addToJoinRelationSlug(counter, Constants.inRelation)
            }
        }
    }

    function onIncludeCheckedClicked(checked){
        if(ReportParamsModel.section === Constants.categoricalTab){
            ReportParamsModel.setIncludeNullMap(counter,checked)
        }
    }


    function onExcludeCheckedClicked(checked){
        if(ReportParamsModel.section === Constants.categoricalTab){
            ReportParamsModel.setExcludeMap(counter, checked)
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
                checked: ReportParamsModel.getSelectAllMap(counter)[counter] === "1" ? true : false
                text: "All"
                y:2
                parent_dimension: Constants.defaultCheckBoxDimension
                checkState: childGroup.checkState

                onCheckedChanged: {
                    onAllCheckBoxCheckedChanged(checked)
                }
            }

            ListView {
                id: multiSelectCheckList
                model: ColumnListModel
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
                        checked: false
                        y:2
                        text: modelData
                        parent_dimension: Constants.defaultCheckBoxDimension
                        ButtonGroup.group: childGroup
                        objectName: modelData

                        onCheckedChanged: {
                            onMultiSelectCheckboxSelected(modelData,checked)
                        }
                        // On search, highlight selected option
                        Component.onCompleted: {
                            modelCheckBoxes.checked = ReportParamsModel.searchTmpSelectedValues(modelData) >= 0 ? true: false
                        }

                        // On edit, highlight the selected option
                        Connections{
                            target: ReportParamsModel
                            function onTmpSelectedValuesChanged(values){
                                if(ReportParamsModel.mode === Constants.modeEdit && ReportParamsModel.category === Constants.categoryMainListType && ReportParamsModel.subCategory === Constants.categorySubMulti){
                                    console.log(ReportParamsModel.mode === Constants.modeEdit, ReportParamsModel.category === Constants.categoryMainListType, ReportParamsModel.subCategory === Constants.categorySubMulti)
                                    modelCheckBoxes.checked = values.indexOf(modelCheckBoxes.objectName) >= 0 ? true: false
                                }
                            }
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
                            if(ReportParamsModel.section === Constants.categoricalTab){
                                modelRadioButton.checked = ReportParamsModel.getTmpSelectedValues(0, true)[0] === modelData ? true: false
                            }
                        }

                        // On edit, highlight the selected option
                        Connections{
                            target: ReportParamsModel
                            function onTmpSelectedValuesChanged(values){
                                if(ReportParamsModel.mode === Constants.modeEdit && ReportParamsModel.category === Constants.categoryMainListType && ReportParamsModel.subCategory === Constants.categorySubSingle){
                                    console.log(ReportParamsModel.mode === Constants.modeEdit, ReportParamsModel.category === Constants.categoryMainListType, ReportParamsModel.subCategory === Constants.categorySubSingle)
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
                checked: ReportParamsModel.getIncludeNullMap(counter)[counter] === "1" ? true : false
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
                checked: ReportParamsModel.getExcludeMap(counter)[counter] === "1" ? true : false
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
