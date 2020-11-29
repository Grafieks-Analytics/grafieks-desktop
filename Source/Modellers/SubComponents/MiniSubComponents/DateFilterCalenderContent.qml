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
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"


Rectangle{
    property bool listOpened: false

    property var locale: Qt.locale()

    property string selectOption: "Select Wildcard"

    height: parent.height - 80 - 40
    width: parent.width - 40
    x:20
    y:10
    color: Constants.whiteColor
    border.color: Constants.darkThemeColor
    visible: false
    readonly property string mapKey: "0"

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
            DSParamsModel.setExclude(false)
            DSParamsModel.setIncludeNull(true)
        }
    }


    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

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

    function onCalendarInput(fromDate,toDate){
        var newValue = fromDate + " To "  + toDate;
        DSParamsModel.addToJoinValue(mapKey, newValue)
        DSParamsModel.addToJoinRelation(mapKey, Constants.betweenRelation)
        DSParamsModel.addToJoinRelationSlug(mapKey, Constants.betweenRelation)
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




    Row{
        id: dateRangeText

        height: 40
        width: parent.width

        Column{

            padding: 12
            leftPadding: 20



            Text {
                text: qsTr("Date Range")
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
                text: qsTr("From")
            }

            Rectangle{
                width: parent.width

                anchors.left: parent.left
                anchors.topMargin: 10
                height: 30

                TextField {
                    id:fromDateInput
                    placeholderText: "dd/mm/yyyy"

                    height: parent.height
                    onTextChanged: {
                        onCalendarInput(fromDateInput.text,toDateInput.text)
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

                Calendar{
                    id: fromDateCalendar
                    visible: false
                    onClicked: {
                        onSelectFromDate();
                    }

                }

            }

        }

        Column{

            width: parent.width/2
            anchors.left: fromDate.right
            anchors.leftMargin: 20

            spacing: 10

            Text {
                id: toDateText
                text: qsTr("To")
            }

            Rectangle{
                width: parent.width - 50
                anchors.left: parent.left
                height: 30

                TextField {
                    id: toDateInput
                    placeholderText: "dd/mm/yyyy"

                    height: parent.height
                    onTextChanged: {
                        onCalendarInput(fromDateInput.text,toDateInput.text)
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

                Calendar{
                    id: toDateCalendar
                    visible: false
                    onClicked: {
                        onSelectToDate();
                    }

                }


            }

        }

    }

    Row{
        height: 30
        anchors.bottom: parent.bottom;

        anchors.left: parent.left
        anchors.leftMargin: 20

        CheckBox {
            checked: DSParamsModel.includeNull
            text: qsTr("Include Null")

            onCheckedStateChanged: {
                onIncludeCheckedClicked(checked)
            }

        }
    }

    Row{
        height: 30
        anchors.bottom: parent.bottom;

        anchors.right: parent.right
        anchors.rightMargin: 20

        CheckBox {
            checked: DSParamsModel.exclude
            text: qsTr("Exclude")

            onCheckedChanged: {
                onExcludeCheckedClicked(checked);
            }

        }
    }


    // Page Design Ends
    /***********************************************************************************************************************/


}
