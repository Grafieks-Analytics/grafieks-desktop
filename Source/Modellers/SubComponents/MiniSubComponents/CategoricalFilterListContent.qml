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
import com.grafieks.singleton.messages 1.0

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
        target: DSParamsModel

        function onInternalCounterChanged(){
            if(DSParamsModel.section === Constants.categoricalTab){
                counter = DSParamsModel.internalCounter
            }
        }

        function onFilterIndexChanged(){
            counter = DSParamsModel.filterIndex
        }

        function onModeChanged(){
            searchText.text = ""
        }
    }

    Connections{
        target: CSVJsonDataModel

        function onColumnListModelDataChanged(values){
            idPlesaeWaitText.visible = false
            idPlesaeWaitThorbber.visible = false
            updateData(values)
        }

        function onFetchingColumnListModel(){
            idPlesaeWaitText.visible = true
            idPlesaeWaitThorbber.visible = true
        }
    }

    Connections{
        target: ExcelDataModel

        function onColumnListModelDataChanged(values){
            idPlesaeWaitText.visible = false
            idPlesaeWaitThorbber.visible = false
            updateData(values)
        }

        function onFetchingColumnListModel(){
            idPlesaeWaitText.visible = true
            idPlesaeWaitThorbber.visible = true
        }
    }

    Connections{
        target: ForwardOnlyDataModel

        function onColumnListModelDataChanged(values){
            idPlesaeWaitText.visible = false
            idPlesaeWaitThorbber.visible = false
            updateData(values)
        }

        function onFetchingColumnListModel(){
            idPlesaeWaitText.visible = true
            idPlesaeWaitThorbber.visible = true
        }
    }

    Connections{
        target: QueryDataModel

        function onColumnListModelDataChanged(values){
            idPlesaeWaitText.visible = false
            idPlesaeWaitThorbber.visible = false
            updateData(values)
        }

        function onFetchingColumnListModel(){
            idPlesaeWaitText.visible = true
            idPlesaeWaitThorbber.visible = true
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

    function updateData(options){

        if(DSParamsModel.section === Constants.categoricalTab){
            // Just to reset the data if the previous `colData` and the new `colData` are same
            singleSelectCheckList.model = []
            multiSelectCheckList.model = []

            if(GeneralParamsModel.getDbClassification() === Constants.csvType || GeneralParamsModel.getDbClassification() === Constants.jsonType){
                singleSelectCheckList.model = CSVJsonDataModel
                multiSelectCheckList.model  = CSVJsonDataModel
            } else if(GeneralParamsModel.getDbClassification() === Constants.excelType) {
                singleSelectCheckList.model = ExcelDataModel
                multiSelectCheckList.model  = ExcelDataModel
            } else if(GeneralParamsModel.getDbClassification() === Constants.sqlType || GeneralParamsModel.getDbClassification() === Constants.accessType) {
                singleSelectCheckList.model = QueryDataModel
                multiSelectCheckList.model  = QueryDataModel
            } else if(GeneralParamsModel.getDbClassification() === Constants.forwardType) {
                singleSelectCheckList.model = ForwardOnlyDataModel
                multiSelectCheckList.model  = ForwardOnlyDataModel
            }

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

            if(GeneralParamsModel.getDbClassification() === Constants.sqlType || GeneralParamsModel.getDbClassification() === Constants.accessType){
                QueryDataModel.columnSearchData(DSParamsModel.colName, DSParamsModel.tableName, searchText.text, JSON.stringify(options))
            } else if(GeneralParamsModel.getDbClassification() === Constants.forwardType){
                ForwardOnlyDataModel.columnSearchData(DSParamsModel.colName, DSParamsModel.tableName, searchText.text, JSON.stringify(options))
            } else if(GeneralParamsModel.getDbClassification() === Constants.excelType){
                ExcelDataModel.columnSearchData(DSParamsModel.colName, DSParamsModel.tableName, searchText.text, JSON.stringify(options))
            } else {
                CSVJsonDataModel.columnSearchData(DSParamsModel.colName, DSParamsModel.tableName, searchText.text, JSON.stringify(options))
            }

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
        if(DSParamsModel.section === Constants.categoricalTab && mainCheckBox.visible === true){
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
                text: Messages.filterMultiSelect
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
                text: Messages.filterSingleSelect
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
                placeholderText: Messages.search
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

        BusyIndicatorTpl{
            id: idPlesaeWaitThorbber
            anchors.centerIn: parent
        }

        Text {
            id: idPlesaeWaitText
            text: Messages.loadingPleaseWait
            anchors.top: idPlesaeWaitThorbber.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }



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
                text: Messages.filterAll
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
                            modelCheckBoxes.checked = DSParamsModel.searchTmpSelectedValues(modelData) >= 0 ? true: false
                        }

                        // On edit, highlight the selected option
                        Connections{
                            target: DSParamsModel
                            function onTmpSelectedValuesChanged(values){
                                if(DSParamsModel.mode === Constants.modeEdit && DSParamsModel.category === Constants.categoryMainListType && DSParamsModel.subCategory === Constants.categorySubMulti){
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
                text: Messages.filterIncludeNull
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
                text: Messages.filterExclude
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
