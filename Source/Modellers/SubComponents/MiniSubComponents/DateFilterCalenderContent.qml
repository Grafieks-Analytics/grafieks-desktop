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
import QtQuick.Controls
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0
import com.grafieks.singleton.messages 1.0

import "../../../MainSubComponents"


Rectangle{
    property bool listOpened: false

    property var locale: Qt.locale()

    property string selectOption: Messages.mo_mini_cfwc_header

    height: parent.height - 80 - 40
    width: parent.width - 40
    x:20
    y:10
    color: Constants.whiteColor
    border.color: Constants.darkThemeColor
    visible: false
    property int counter: 0

    property var date1: ""
    property var date2: ""

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

        function onResetInput(){
            fromDateInput.text =""
            toDateInput.text   =""
            DSParamsModel.setExcludeMap(counter, false)
            DSParamsModel.setIncludeNullMap(counter, true)
        }

        function onInternalCounterChanged(){
            if(DSParamsModel.section === Constants.dateTab && DSParamsModel.category === Constants.dateMainCalendarType){
                counter = DSParamsModel.internalCounter
            }
        }

        function onFilterIndexChanged(){
            counter = DSParamsModel.filterIndex
        }
    }

    Connections{
        target: CSVJsonDataModel

        function onColumnListModelDataChanged(values){
            updateData(values)
        }
    }

    Connections{
        target: ExcelDataModel

        function onColumnListModelDataChanged(values){
            updateData(values)
        }
    }

    Connections{
        target: ForwardOnlyDataModel

        function onColumnListModelDataChanged(values){
            updateData(values)
        }
    }

    Connections{
        target: QueryDataModel

        function onColumnListModelDataChanged(values){
            updateData(values)
        }
    }

    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    function slotDataCleared(){

    }

    function slotEditModeCalendar(relation, slug, value){

        calendarContent.visible = true

        if(value !== ""){
            var valueList = value.split(" To ")
            fromDateInput.text = valueList[0]
            toDateInput.text  = valueList[1]
            fromDateInput.activeFocus = true
            toDateInput.activeFocus = true
        }
    }

    function updateData(options){

        var jsonOptions = JSON.parse(options)
        console.log(JSON.parse(options))
        if(DSParamsModel.section === Constants.dateTab && DSParamsModel.category === Constants.dateMainCalendarType){

            var newDates = jsonOptions.values.split(",")
            if(newDates.length > 0){

                date1 = newDates[0]
                date2 = newDates[1]

                fromDateInput.text = date1
                toDateInput.text = date2
            }
        }
    }

    function showFromDateCalendar(){
        fromDateCalendar.visible = true
    }
    function showToDateCalendar(){
        toDateCalendar.visible = true
    }

    function closeFromDateCalendar(){
        fromDateCalendar.visible = false
    }
    function closeToDateCalendar(){
        toDateCalendar.visible = false
    }

    function setFromDate(date){
        fromDateInput.text = date
    }

    function setToDate(date){
        toDateInput.text = date
    }

    function onSelectFromDate(){
        closeFromDateCalendar()
        let date = fromDateCalendar.selectedDate.toLocaleDateString(locale,"dd/MM/yyyy")
        setFromDate(date)
    }


    function onSelectToDate(){
        closeToDateCalendar()
        let date = toDateCalendar.selectedDate.toLocaleDateString(locale,"dd/MM/yyyy")
        setToDate(date)
    }

    function onCalendarFromInput(fromDate){

        if(fromDate.trim().length > 0){
            date1 = fromDate
            var newValue = date1 + ","  + date2;
            DSParamsModel.addToJoinValue(counter, newValue)
            DSParamsModel.addToJoinRelation(counter, Constants.betweenRelation)
            DSParamsModel.addToJoinRelationSlug(counter, Constants.slugBetweenRelation)
        }
    }

    function onCalendarToInput(toDate){

        if(toDate.trim().length > 0){
            date2 = toDate
            var newValue = date1 + ","  + date2;
            DSParamsModel.addToJoinValue(counter, newValue)
            DSParamsModel.addToJoinRelation(counter, Constants.betweenRelation)
            DSParamsModel.addToJoinRelationSlug(counter, Constants.slugBetweenRelation)
        }
    }

    function onIncludeCheckedClicked(checked){
        DSParamsModel.setIncludeNullMap(counter,checked)
    }


    function onExcludeCheckedClicked(checked){
        DSParamsModel.setExcludeMap(counter,checked)
    }

    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts




    Row{
        id: dateRangeText

        height: 40
        width: parent.width

        Column{

            padding: 12
            leftPadding: 20

            Text {
                text: Messages.filterDateRange
            }

        }
    }

    Rectangle{
        id: dateOptionRow
        anchors.top: dateRangeText.bottom
        anchors.topMargin: 8
        height: 30
        anchors.left: parent.left
        anchors.leftMargin: 10
        width: parent.width - 20

        Column{
            id: fromDate
            anchors.top: parent.top
            width: parent.width/2
            anchors.left: parent.left
            anchors.leftMargin: 10

            spacing: 10

            Text {
                id: fromDateText
                text: Messages.filterFrom
            }

            Rectangle{
                width: parent.width

                anchors.left: parent.left
                anchors.topMargin: 10
                height: 30

                TextField {
                    id:fromDateInput
                    placeholderText: Messages.filterDefaultDateFormat

                    height: parent.height
                    onTextChanged: {
                        onCalendarFromInput(fromDateInput.text)
                    }

                }

                Image{
                    id: fromDatePicker
                    source: '/Images/icons/clipart268070@2x.png'
                    anchors.left: fromDateInput.right
                    anchors.leftMargin: 20

                    height: parent.height - 3
                    width: parent.height - 10

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            showFromDateCalendar()
                        }
                    }
                }

//                Calendar{
//                    id: fromDateCalendar
//                    visible: false
//                    onClicked: {
//                        onSelectFromDate();
//                    }

//                }

            }

        }

        Column{

            width: parent.width/2
            anchors.left: fromDate.right
            anchors.leftMargin: 20

            spacing: 10

            Text {
                id: toDateText
                text: Messages.filterTo
            }

            Rectangle{
                width: parent.width - 50
                anchors.left: parent.left
                height: 30

                TextField {
                    id: toDateInput
                    placeholderText: Messages.filterDefaultDateFormat

                    height: parent.height
                    onTextChanged: {
                        onCalendarToInput(toDateInput.text)
                    }
                }


                Image{
                    id: toDatePicker
                    source: '/Images/icons/clipart268070@2x.png'
                    anchors.left: toDateInput.right
                    anchors.leftMargin: 20

                    height: parent.height - 3
                    width: parent.height - 10

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            showToDateCalendar();
                        }
                    }
                }

//                Calendar{
//                    id: toDateCalendar
//                    visible: false
//                    onClicked: {
//                        onSelectToDate();
//                    }

//                }


            }

        }

    }

    Row{
        height: 30
        anchors.bottom: parent.bottom;

        anchors.left: parent.left
        anchors.leftMargin: 20

        CheckBoxTpl {
            checked: DSParamsModel.getIncludeNullMap(counter)[counter] === "1" ? true : false
            text: Messages.filterIncludeNull
            parent_dimension: Constants.defaultCheckBoxDimension

            onCheckStateChanged: {
                onIncludeCheckedClicked(checked)
            }
        }
    }

    Row{
        height: 30
        anchors.bottom: parent.bottom;

        anchors.right: parent.right
        anchors.rightMargin: 20

        CheckBoxTpl {
            checked: DSParamsModel.getExcludeMap(counter)[counter] === "1" ? true : false
            text: Messages.filterExclude
            parent_dimension: Constants.defaultCheckBoxDimension

            onCheckedChanged: {
                onExcludeCheckedClicked(checked);
            }

        }
    }


    // Page Design Ends
    /***********************************************************************************************************************/


}
