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

    property var checkedValues : []
    property var masterColData: []
    property int counter: 0
    property int selectedFormat: 6
    property var columnDataModel: []

    readonly property var availableformats : ["removedTZ",  "year", "quarter_year", "month_year", "week_year", "full_date", "date_time", "original"]
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
        target: ReportParamsModel

        function onResetInput(){
            if(ReportParamsModel.section === Constants.dateTab && ReportParamsModel.category === Constants.dateMainListType){
                customBox.currentIndex = 0
                ReportParamsModel.addToIncludeExcludeMap(counter, false)
                ReportParamsModel.addToIncludeNullMap(counter, true)
            }
        }


        function onFilterIndexChanged(){

            if(ReportParamsModel.section === Constants.dateTab){

                idPlesaeWaitText.visible = true
                idPlesaeWaitThorbber.visible = true

                var colName = ReportParamsModel.colName
                var colData
                ReportParamsModel.removeTmpSelectedValues(0, true)

                if(GeneralParamsModel.getAPISwitch()) {
                    ReportsDataModel.fetchColumnDataAPI(colName)
                } else if(GeneralParamsModel.getFromLiveFile() || GeneralParamsModel.getFromLiveQuery()){
                    colData = ReportsDataModel.fetchColumnDataLive(colName)
                    processDataList(columnData)
                } else {
                    colData = ReportsDataModel.fetchColumnData(colName)
                    processDataList(columnData)
                }
            }
        }
    }

    Connections{
        target: ReportsDataModel

        function onColumnDataChanged(columnData, options){
            processDataList(columnData)
        }
    }


    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    Component.onCompleted: {
        if(ReportParamsModel.section === Constants.dateTab && ReportParamsModel.category === Constants.dateMainListType){
            mainCheckBox.visible = true
        }
    }

    function processDataList(colData){
        counter = ReportParamsModel.filterIndex
        var values = ReportParamsModel.fetchFilterValueMap(counter)[counter]

        // Just to reset the data if the previous `colData` and the new `colData` are same
        singleSelectCheckList.model = []
        multiSelectCheckList.model = []

        columnDataModel = colData

        singleSelectCheckList.model = columnDataModel
        multiSelectCheckList.model  = columnDataModel

        // Date format
        selectedFormat = ReportParamsModel.getDateFormatMap(counter)
        customBox.currentIndex = selectedFormat

        convertDate(columnDataModel)

        if(ReportParamsModel.subCategory === Constants.categorySubMulti){
            multiSelectRadio.checked = true

            multiSelectCheckList.visible = true
            singleSelectCheckList.visible = false

            if(values[0] === "%"){
                masterColData.forEach((item) => {
                                          ReportParamsModel.setTmpSelectedValues(item[selectedFormat])
                                      })

            } else{
                var checkedValues = values[0].split(",")
                checkedValues.forEach((item) => {
                                          ReportParamsModel.setTmpSelectedValues(item)
                                      })
            }
        } else{
            singleSelectRadio.checked = true

            multiSelectCheckList.visible = false
            singleSelectCheckList.visible = true

            if(ReportParamsModel.searchTmpSelectedValues(values) < 0){
                ReportParamsModel.setTmpSelectedValues(values)
            }
        }

        idPlesaeWaitText.visible = false
        idPlesaeWaitThorbber.visible = false
    }

    function slotDataCleared(){
        if(ReportParamsModel.section === Constants.dateTab && ReportParamsModel.category === Constants.dateMainListType){
            ReportParamsModel.removeTmpSelectedValues(0, true)
        }
    }


    function onMultiSelectSelected(){
        if(ReportParamsModel.section === Constants.dateTab && ReportParamsModel.category === Constants.dateMainListType){
            multiSelectCheckList.visible = true
            singleSelectCheckList.visible = false

            // Set the sub category for filter
            ReportParamsModel.setSubCategory(Constants.categorySubMulti)
            mainCheckBox.visible = true
        }
    }


    function onSingleSelectSelected(){

        if(ReportParamsModel.section === Constants.dateTab && ReportParamsModel.category === Constants.dateMainListType){
            multiSelectCheckList.visible = false
            singleSelectCheckList.visible = true

            // Set the sub category for filter
            ReportParamsModel.setSubCategory(Constants.categorySubSingle)
            mainCheckBox.visible = false
        }
    }


    function onSingleSelectRadioSelected(modelData, format){

        if(ReportParamsModel.section === Constants.dateTab && ReportParamsModel.category === Constants.dateMainListType){
            var actualValueArray = []

            actualValueArray.push(searchDateFormat(modelData, selectedFormat))
            ReportParamsModel.setActualDateValues(counter, actualValueArray)
            ReportParamsModel.addToFilterValueMap(counter, modelData.toString())
            ReportParamsModel.addToFilterRelationMap(counter, Constants.equalRelation)
            ReportParamsModel.addToFilterSlugMap(counter, Constants.slugEqualRelation)

            // Clear all tmp selected values and insert again
            ReportParamsModel.removeTmpSelectedValues(0, true)
            ReportParamsModel.setTmpSelectedValues(modelData.toString())
        }
    }


    function onTextChangedSearch(){
        if(ReportParamsModel.section === Constants.dateTab && ReportParamsModel.category === Constants.dateMainListType){
            var options = {
                "section" : ReportParamsModel.section,
                "category" : ReportParamsModel.category,
                "subCategory" : ReportParamsModel.subCategory,
                "values" : ReportParamsModel.fetchFilterValueMap(counter)[counter],
                "relation" : ReportParamsModel.fetchFilterRelationMap(counter),
                "slug" : ReportParamsModel.fetchFilterSlugMap(counter)

            }

            var filteredColumns = filterItems(columnDataModel, searchText.text)

            singleSelectCheckList.model = filteredColumns
            multiSelectCheckList.model  = filteredColumns

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

        if(ReportParamsModel.section === Constants.dateTab && ReportParamsModel.category === Constants.dateMainListType){
            setCheckedAll(checked)
        }
    }

    function setCheckedAll(checked){

        // If Select All option is true
        if(ReportParamsModel.section === Constants.dateTab && ReportParamsModel.category === Constants.dateMainListType){
            if(checked === true){

                ReportParamsModel.addToFilterValueMap(counter, "%")
                ReportParamsModel.setActualDateValues(counter, "%")
                ReportParamsModel.addToSelectAllMap(counter, true)
                ReportParamsModel.addToFilterRelationMap(counter, Constants.likeRelation)
                ReportParamsModel.addToFilterSlugMap(counter, Constants.slugLikeRelation)
            }
        }
    }

    function onMultiSelectCheckboxSelected(modelData,checked){


        if(ReportParamsModel.section === Constants.dateTab && ReportParamsModel.category === Constants.dateMainListType){
            if(mainCheckBox.checked === true){

                if(checked === false){

                    // Set SELECT ALL to false
                    ReportParamsModel.addToSelectAllMap(counter, false)
                    ReportParamsModel.setActualDateValues(counter, "")
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

                if(ReportParamsModel.getTmpSelectedValues(0, true).toString() !== ""){
                    var actualValueArray = []
                    ReportParamsModel.getTmpSelectedValues(0, true).forEach((item)  => {
                        searchDateFormat(item, selectedFormat).forEach((item2) => {
                           actualValueArray.push(item2)
                       })
                    })
                    ReportParamsModel.setActualDateValues(counter, actualValueArray)
                    ReportParamsModel.addToFilterValueMap(counter, ReportParamsModel.getTmpSelectedValues(0, true).toString())
                    ReportParamsModel.addToFilterRelationMap(counter, Constants.inRelation)
                    ReportParamsModel.addToFilterSlugMap(counter, Constants.slugInRelation)
                }
            }
        }
    }

    function onIncludeCheckedClicked(checked){
        if(ReportParamsModel.section === Constants.dateTab && ReportParamsModel.category === Constants.dateMainListType){
            ReportParamsModel.addToIncludeNullMap(counter, checked)
        }
    }


    function onExcludeCheckedClicked(checked){
        if(ReportParamsModel.section === Constants.dateTab && ReportParamsModel.category === Constants.dateMainListType){
            ReportParamsModel.addToIncludeExcludeMap(counter, checked)
        }
    }

    function filterItems(arr, query) {
        return arr.filter(function(el) {
            return el.toLowerCase().indexOf(query.toLowerCase()) !== -1
        })
    }


    function searchDateFormat(inputDate, formatId){
        var outputData = []
        if(ReportParamsModel.section === Constants.dateTab && ReportParamsModel.category === Constants.dateMainListType){
            masterColData.forEach((item, index) => {
                                      if(String(item[formatId]) === String(inputDate)){
                                          outputData.push(item[item.length - 1])
                                      }
                                  })
        }
        return outputData
    }

    function changeDateFormat(currentIndex){

        if(ReportParamsModel.section === Constants.dateTab && ReportParamsModel.category === Constants.dateMainListType){
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


            ReportParamsModel.setDateFormatMap(counter, selectedFormat)
            ReportParamsModel.removeTmpSelectedValues(0, true)
            ReportParamsModel.removeFilterValueMap(counter)
            ReportParamsModel.removeFilterRelationMap(counter)
            ReportParamsModel.removeFilterSlugMap(counter)
        }
    }

    function convertDate(dateColumnData){

        let sortedMasterColData = []
        for(var i = 0; i < dateColumnData.length; i++){

            let dateData = dateColumnData[i]

            let removeTZ = getRemoveTZ(dateData)
            let getYear = getYearValue(dateData)
            let getQuarterYear = getQuarterYearValue(dateData)
            let getMonthYear = getMonthYearValue(dateData)
            let getWeekYear = getWeekYearValue(dateData)
            let getFullDate = getFullDateValue(dateData)
            let getDateTime = getDateTimeValue(dateData)

            var tmpColData = [removeTZ, getYear, getQuarterYear, getMonthYear, getWeekYear, getFullDate, getDateTime, dateData]
            sortedMasterColData.push(tmpColData)
        }

        masterColData = sortedMasterColData
    }

    function getRemoveTZ(inputDate){

        let outDate = inputDate.replace(/T/gi, " ")
        outDate = outDate.replace(/Z/gi, " ")
        return outDate;
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
                radio_text: Messages.filterMultiSelect
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
                radio_text: Messages.filterSingleSelect
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
                id: searchText
                placeholderText: Messages.search
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


        // Checklist Button ListView
        // List Filters starts

        ButtonGroup {
            id: childGroup
            exclusive: false
            checkState: mainCheckBox.checkState
        }

        CheckBoxTpl {
            id: mainCheckBox
            checked: ReportParamsModel.fetchSelectAllMap(counter)[0] === true ? true : false
            text: Messages.filterAll
            parent_dimension: Constants.defaultCheckBoxDimension

            onCheckedChanged: {
                onAllCheckBoxCheckedChanged(checked)
            }
        }
        ListView {
            id: multiSelectCheckList
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
                    y:2
                    text  : modelData
                    objectName: modelData
                    parent_dimension: Constants.defaultCheckBoxDimension
                    ButtonGroup.group: childGroup

                    onCheckedChanged: {
                        onMultiSelectCheckboxSelected(modelData,checked)
                    }

                    // On search, highlight selected option
                    Component.onCompleted: {
                        if(ReportParamsModel.section === Constants.dateTab){
                            modelCheckBoxes.checked = ReportParamsModel.searchTmpSelectedValues(modelData) >= 0 ? true: false
                        }
                    }

                    // On edit, highlight the selected option

                    Connections{
                        target: ReportParamsModel
                        function onTmpSelectedValuesChanged(values){
                            if(ReportParamsModel.mode === Constants.modeEdit && ReportParamsModel.category === Constants.dateMainListType && ReportParamsModel.subCategory === Constants.categorySubMulti){
                                modelCheckBoxes.checked = values.indexOf(modelCheckBoxes.objectName) >= 0 ? true: false
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
                        objectName: modelData
                        ButtonGroup.group: singleSelectRadioGroup
                        height: Constants.defaultRadioDimension
                        width: Constants.defaultRadioDimension
                        parent_dimension: Constants.defaultRadioDimension
                        onCheckedChanged: {
                            onSingleSelectRadioSelected(modelData)
                        }

                        // On search, highlight the selected radio
                        Component.onCompleted: {
                            if(ReportParamsModel.section === Constants.dateTab){
                                modelRadioButton.checked = ReportParamsModel.getTmpSelectedValues(0, true)[0] === modelData ? true: false
                            }
                        }

                        // On edit, highlight the selected option
                        Connections{
                            target: ReportParamsModel
                            function onTmpSelectedValuesChanged(values){
                                if(ReportParamsModel.mode === Constants.modeEdit && ReportParamsModel.category === Constants.dateMainListType && ReportParamsModel.subCategory === Constants.categorySubSingle){
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
                checked: ReportParamsModel.fetchIncludeNullMap(counter)[0]
                text: Messages.filterIncludeNull

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
                checked: ReportParamsModel.fetchIncludeExcludeMap(counter)[0]
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
