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
    property var masterColData: []
    property var radioSelected: ""
    property int counter: 0
    property int selectedFormat: 6

    readonly property var availableformats : ["default", "year", "quarter_year", "month_year", "week_year", "full_date", "date_time"]
    readonly property var months : ["Jan", "Feb", "Mar", "Apr", "May","Jun","Jul", "Aug", "Sep", "Oct", "Nov","Dec"];

    onMasterColDataChanged: {
        var tmpColData = []
        masterColData.forEach((item, index) => {
                                  // Just push "Year" data as default
                                  if(tmpColData.indexOf(item[selectedFormat]) < 0){
                                      tmpColData.push(item[selectedFormat])
                                  }
                              })
        singleSelectCheckList.model = tmpColData
        multiSelectCheckList.model  = tmpColData
    }

    /***********************************************************************************************************************/
    // LIST MODEL STARTS



    ListModel{
        id: dateFormatList

        ListElement{
            menuItem:"Select"
            format: ""
        }

        ListElement{
            menuItem:"Year"
            format: "2020"
        }

        ListElement{
            menuItem:"Quarter & Year"
            format: "Q4 2020"
        }

        ListElement{
            menuItem:"Month & Year"
            format: "Jan 2020"
        }

        ListElement{
            menuItem:"Week & Year"
            format: "Week 5 2020"
        }

        ListElement{
            menuItem:"Full Date"
            format: "20 Jan 2020"
        }

        ListElement{
            menuItem:"Date & Time"
            format: "20 Jan 2020 00:00:20 hrs"
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


    Connections{
        target: DSParamsModel

        function onResetInput(){
            customBox.currentIndex = 0
            DSParamsModel.setExcludeMap(counter, false)
            DSParamsModel.setIncludeNullMap(counter, true)
        }

        function onInternalCounterChanged(){
            counter = DSParamsModel.internalCounter
        }

        function onFilterIndexChanged(){
            counter = DSParamsModel.filterIndex
        }
    }

    Connections{
        target: DuckDataModel

        function onDuckColData(colData){
            convertDate(colData)
        }
    }

    Connections{
        target: QueryDataModel

        function onColumnListModelDataChanged(colData, options){
            selectedFormat = DSParamsModel.getDateFormatMap(counter)
            customBox.currentIndex = selectedFormat

            convertDate(colData)
            var jsonOptions = JSON.parse(options)

            if(jsonOptions.subCategory === Constants.categorySubMulti){
                multiSelectRadio.checked = true

                multiSelectCheckList.visible = true
                singleSelectCheckList.visible = false

                if(jsonOptions.values.length > 0){
                    var checkedValues = jsonOptions.values.split(",")
                    checkedValues.forEach((item) => {
                                              DSParamsModel.setTmpSelectedValues(item)
                                          })
                }

            } else{
                singleSelectRadio.checked = true

                multiSelectCheckList.visible = false
                singleSelectCheckList.visible = true

                radioSelected = jsonOptions.values
            }

        }
    }


    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS
    function slotEditModeSubCategory(subCategory){

        if(subCategory === Constants.categorySubMulti){
            multiSelectRadio.checked = true

            multiSelectCheckList.visible = true
            singleSelectCheckList.visible = false

        } else{
            singleSelectRadio.checked = true

            multiSelectCheckList.visible = false
            singleSelectCheckList.visible = true
        }
    }


    function onMultiSelectSelected(){
        multiSelectCheckList.visible = true
        singleSelectCheckList.visible = false

        // Set the sub category for filter
        DSParamsModel.setSubCategory(Constants.categorySubMulti)
        mainCheckBox.visible = true
    }


    function onSingleSelectSelected(){

        multiSelectCheckList.visible = false
        singleSelectCheckList.visible = true

        // Set the sub category for filter
        DSParamsModel.setSubCategory(Constants.categorySubSingle)
        mainCheckBox.visible = false
    }


    function onSingleSelectRadioSelected(modelData, format){

        DSParamsModel.addToJoinValue(counter, modelData.toString())
        DSParamsModel.addToJoinRelation(counter, Constants.inRelation)
        DSParamsModel.addToJoinRelationSlug(counter, Constants.inRelation)

        radioSelected = modelData.toString()
    }


    function onTextChangedSearch(){
        var options = {}
        QueryDataModel.columnSearchData(DSParamsModel.colName, DSParamsModel.tableName, searchText.text, JSON.stringify(options))

        if(DSParamsModel.subCategory === Constants.categorySubMulti){
            if(searchText.text.length > 0){
                mainCheckBox.visible = false
            } else{
                mainCheckBox.visible = true
            }
        }
    }

    function onAllCheckBoxCheckedChanged(checked){
        // If Select All option is true
        if(checked === true){

            DSParamsModel.addToJoinValue(counter, "%")
            DSParamsModel.addToJoinRelation(counter, Constants.likeRelation)
            DSParamsModel.addToJoinRelationSlug(counter, Constants.likeRelation)
        }
    }

    function onMultiSelectCheckboxSelected(modelData,checked){

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
                    console.log(DSParamsModel.getTmpSelectedValues(0, true), "VALUES FETCHES")
                }

            } else{
                // Remove item if unchecked
                const index = DSParamsModel.searchTmpSelectedValues(modelData);
                if (index > -1) {
                    DSParamsModel.removeTmpSelectedValues(index);
                }
            }

            DSParamsModel.addToJoinValue(counter, DSParamsModel.getTmpSelectedValues(0, true).toString())
            DSParamsModel.addToJoinRelation(counter, Constants.inRelation)
            DSParamsModel.addToJoinRelationSlug(counter, Constants.inRelation)
            console.log("V1S", counter, DSParamsModel.getTmpSelectedValues(0, true).toString())
        }
    }

    function onIncludeCheckedClicked(checked){
        DSParamsModel.setIncludeNullMap(counter, checked)
    }


    function onExcludeCheckedClicked(checked){
        DSParamsModel.setExcludeMap(counter, checked)
    }


    function changeDateFormat(currentIndex){

        var tmpColData = []
        selectedFormat = currentIndex

        masterColData.forEach((item, index) => {
                                  // Just push "Year" data as default
                                  if(tmpColData.indexOf(item[selectedFormat]) < 0){
                                      tmpColData.push(item[selectedFormat])
                                  }
                              })
        singleSelectCheckList.model = tmpColData
        multiSelectCheckList.model  = tmpColData


        DSParamsModel.setValueFormat(counter, selectedFormat)
        DSParamsModel.removeTmpSelectedValues(0, true)
        DSParamsModel.removeJoinValue(counter)
        DSParamsModel.removeJoinRelation(counter)
        DSParamsModel.removeJoinRelationSlug(counter)
    }

    function convertDate(dateColumnData){

        let sortedMasterColData = []
        for(var i = 0; i < dateColumnData.length; i++){

            let dateData = dateColumnData[i]

            let getYear = getYearValue(dateData)
            let getQuarterYear = getQuarterYearValue(dateData)
            let getMonthYear = getMonthYearValue(dateData)
            let getWeekYear = getWeekYearValue(dateData)
            let getFullDate = getFullDateValue(dateData)
            let getDateTime = getDateTimeValue(dateData)

            var tmpColData = [dateData, getYear, getQuarterYear, getMonthYear, getWeekYear, getFullDate, getDateTime]
            sortedMasterColData.push(tmpColData)
        }

        masterColData = sortedMasterColData
    }

    function getYearValue(inputDate){
        let t = Date.parse(inputDate)
        let d = new Date(t);

        let outYear = d.getFullYear();
        return outYear;
    }

    function getQuarterYearValue(inputDate){
        let t = Date.parse(inputDate)
        let d = new Date(t);

        let outYear = d.getFullYear();
        let outMonth = d.getMonth();
        let outQuarter = Math.ceil((outMonth) / 3);

        let out = "Q" + outQuarter + " " + outYear
        return out;
    }

    function getMonthYearValue(inputDate){
        let t = Date.parse(inputDate)
        let d = new Date(t);

        let outYear = d.getFullYear();
        let outMonth = months[d.getMonth()]

        let out = outMonth + " " + outYear
        return out;
    }

    function getWeekYearValue(inputDate){
        let t = Date.parse(inputDate)
        let d = new Date(t);

        let outYear = d.getFullYear();

        let oneJan =  new Date(d.getFullYear(), 0, 1);
        let numberOfDays =  Math.floor((d - oneJan) / (24 * 60 * 60 * 1000));
        let outWeek = Math.ceil(( d.getDay() + 1 + numberOfDays) / 7);


        let out = "Week " + outWeek + " " + outYear
        return out;
    }

    function getFullDateValue(inputDate){
        let t = Date.parse(inputDate)
        let d = new Date(t);

        let outDate = d.getDate();
        let outMonth = months[d.getMonth()]
        let outYear = d.getFullYear();

        let out = outDate + " " + outMonth + " " + outYear
        return out;
    }

    function getDateTimeValue(inputDate){
        let t = Date.parse(inputDate)
        let d = new Date(t);

        let outDate = d.getDate();
        let outMonth = months[d.getMonth()]
        let outYear = d.getFullYear();
        let outHour = d.getHours();
        let outMin = d.getMinutes();
        let outSec = d.getSeconds();

        let out = outDate + " " + outMonth + " " + outYear + " " + outHour + ":" + outMin + ":" + outSec + " Hrs"
        return out;
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
            anchors.top: selectTypeRadioBtn.top

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
                selectByMouse: true
                height: 35
                anchors.top: parent.top
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

    // Main Content Component

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
            height: parent.height-38
            width: parent.width

            anchors.top: mainCheckBox.bottom
            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds
            clip: true
            ScrollBar.vertical: CustomScrollBar {}


            delegate: Row{
                height:20
                CheckBoxTpl {
                    id: modelCheckBoxes
                    checked: true
                    y:2
                    text  : modelData
                    parent_dimension: Constants.defaultCheckBoxDimension
                    ButtonGroup.group: childGroup

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
                                console.log("CHECK", values, modelCheckBoxes.objectName)
                            }
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


            visible: false
            spacing: 2
            height: parent.height-38
            width: parent.width

            anchors.top: mainCheckBox.bottom
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
                        text : modelData
                        ButtonGroup.group: singleSelectRadioGroup
                        height: Constants.defaultRadioDimension
                        width: Constants.defaultRadioDimension
                        parent_dimension: Constants.defaultRadioDimension
                        onCheckedChanged: {
                            onSingleSelectRadioSelected(modelData, customBox.currentText)
                        }

                        // On search, highlight the selected radio
                        Component.onCompleted: {
                            modelRadioButton.checked = radioSelected === modelData ? true: false
                        }

                        // On edit, highlight the selected option
                        Connections{
                            target: QueryDataModel

                            function onColumnListModelDataChanged(colData, options){
                                if(DSParamsModel.mode === Constants.modeEdit && DSParamsModel.category === Constants.categoryMainListType && DSParamsModel.subCategory === Constants.categorySubSingle){
                                    var jsonOptions = JSON.parse(options)
                                    console.log("RADIO", jsonOptions.values, modelRadioButton.objectName)
                                    modelRadioButton.checked = jsonOptions.values === modelRadioButton.objectName ? true: false
                                }
                            }
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
                id : customBox
                model: dateFormatList
                textRole: "menuItem"
                valueRole: "compareValue"
                onActivated: {
                    changeDateFormat(currentIndex)
                }

                anchors{
                    right: parent.right
                    rightMargin: 10
                }
            }

        }
    }

    // Main Content Component ends

    Rectangle{
        id: includeExcludeRow
        anchors.top:  listInnerContent.bottom
        anchors.topMargin: 7
        anchors.left: parent.left
        height: 30
        width: parent.width - 25
        anchors.leftMargin: 10


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
            anchors.rightMargin: 5

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
