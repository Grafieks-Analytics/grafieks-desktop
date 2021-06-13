import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

Column{
    width: parent.width
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.leftMargin: 80
    anchors.topMargin: 30
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

        function onResetInput(){

            thisRadio.checked = false
            lastRadio.checked = false
            nextRadio.checked = false
            nextXRadio.checked = false
            nextXRadioTextField.text = ""
            lastXRadio.checked = false
            lastXRadioTextField.text = ""

        }

        function onInternalCounterChanged(){
            counter = ReportParamsModel.internalCounter
        }

        function onFilterIndexChanged(){
            counter = ReportParamsModel.filterIndex
        }
    }


    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    function slotDataCleared(){

    }

    function slotEditMonth(relation, slug, value){

        var valueList = value.split(" ")

        if(valueList.length === 3){
            if(valueList[0] === "Last"){
                lastXRadio.checked = true
                lastXRadioTextField.text = valueList[1]
                lastXRadio.activeFocus = true
            }
            else{
                nextXRadio.checked = true
                nextXRadioTextField.text = valueList[1]
                nextXRadio.activeFocus = true
            }
        }
        else{
            if(valueList[0] === "This"){
                thisRadio.checked = true
                thisRadio.activeFocus = true
            }
            else if(valueList[0] === "Last"){
                lastRadio.checked = true
                lastRadio.activeFocus = true
            }
            else{
                nextRadio.checked = true
                nextRadio.activeFocus = true
            }
        }
    }

    function daysInMonth (month, year) {
        return new Date(year, month, 0).getDate();
    }

    function onLastXChecked(){

        var value = lastXRadioTextField.text
        var newValue = Number(value)
        var tmpDate = new Date()
        var thisMonth = tmpDate.getMonth()
        var thisYear = tmpDate.getFullYear()
        thisMonth = thisMonth + 1

        var tmpValue;
        var lastXMonths = []

        for(let i = 0; i < newValue; i++){

            if(thisMonth === 1){
                thisYear = thisYear - 1
                thisMonth = 12
                tmpValue = thisYear.toString() + "-" + thisMonth.toString() + "-" + daysInMonth(thisMonth, thisYear)
//                lastXMonths.push(tmpValue)
            }
            else{
                thisMonth = thisMonth - 1
                if(thisMonth < 10){
                    tmpValue = thisYear.toString() + "-" + "0" + thisMonth.toString() + "-" + daysInMonth(thisMonth, thisYear)
                }
                else{
                    tmpValue = thisYear.toString() + "-" + thisMonth.toString() + "-" + daysInMonth(thisMonth, thisYear)
                }

            }

            lastXMonths.push(tmpValue)

        }

        lastXMonths.sort()
        var firstValueArray = lastXMonths[0].split("-")
        var firstValue = firstValueArray[0] + "-" + firstValueArray[1] + "-01"
        var finalValue = firstValue + "," + lastXMonths[lastXMonths.length - 1]

        console.log("Last " + value + " Months", lastXMonths.toString())
        ReportParamsModel.setCategory(Constants.dateMainTimeFrameType)
        ReportParamsModel.setSubCategory(Constants.dateSubMonth)
        ReportParamsModel.setActualDateValues(counter, finalValue.toString())
        ReportParamsModel.addToFilterValueMap(counter, "Last " + value + " Months")
        ReportParamsModel.addToFilterRelationMap(counter, Constants.betweenRelation)
        ReportParamsModel.addToFilterSlugMap(counter, Constants.slugBetweenRelation)

        nextXRadioTextField.focus = false
        lastXRadioTextField.focus = true
    }


    function onNextXChecked(){

        var value = nextXRadioTextField.text
        var newValue = Number(value)
        var tmpDate = new Date()
        var thisMonth = tmpDate.getMonth()
        var thisYear = tmpDate.getFullYear()
        thisMonth = thisMonth + 1

        var tmpValue;
        var nextXMonths = []

        for(let i = 0; i < newValue; i++){

            if(thisMonth === 12){
                thisYear = thisYear + 1
                thisMonth = 1
                tmpValue = thisYear.toString() + "-" + "0" + thisMonth.toString() + "-" + daysInMonth(thisMonth, thisYear)
                nextXMonths.push(tmpValue)
            }
            else{
                thisMonth = thisMonth + 1
                if(thisMonth < 10){
                    tmpValue = thisYear.toString() + "-" + "0" + thisMonth.toString() + "-" + daysInMonth(thisMonth, thisYear)
                }
                else{
                    tmpValue = thisYear.toString() + "-" + thisMonth.toString() + "-" + daysInMonth(thisMonth, thisYear)
                }
                nextXMonths.push(tmpValue)
            }
        }

        nextXMonths.sort()
        var firstValueArray = nextXMonths[0].split("-")
        var firstValue = firstValueArray[0] + "-" + firstValueArray[1] + "-01"
        var finalValue = firstValue + "," + nextXMonths[nextXMonths.length - 1]

        console.log("Next " + value + " Month", nextXMonths.toString())
        ReportParamsModel.setCategory(Constants.dateMainTimeFrameType)
        ReportParamsModel.setSubCategory(Constants.dateSubMonth)
        ReportParamsModel.setActualDateValues(counter, finalValue.toString())
        ReportParamsModel.addToFilterValueMap(counter, "Next " + value + " Months")
        ReportParamsModel.addToFilterRelationMap(counter, Constants.betweenRelation)
        ReportParamsModel.addToFilterSlugMap(counter, Constants.slugBetweenRelation)

        nextXRadioTextField.focus = true
        lastXRadioTextField.focus = false
    }

    function onThisChecked(){

        var tmpDate = new Date()
        var thisMonth = tmpDate.getMonth()
        var thisYear = tmpDate.getFullYear()
        thisMonth = thisMonth + 1
        var newValue;

        if(thisMonth < 10){
            newValue = thisYear.toString() + "-" + "0" + thisMonth.toString() + "-" + daysInMonth(thisMonth, thisYear)
        }
        else{
            newValue = thisYear.toString() + "-" + thisMonth.toString() + "-" + daysInMonth(thisMonth, thisYear)
        }

        var firstValueArray = newValue.split("-")
        var firstValue = firstValueArray[0] + "-" + firstValueArray[1] + "-01"
        var finalValue = firstValue + "," + newValue

        console.log("This Month", newValue)
        ReportParamsModel.setCategory(Constants.dateMainTimeFrameType)
        ReportParamsModel.setSubCategory(Constants.dateSubMonth)
        ReportParamsModel.setActualDateValues(counter, finalValue.toString())
        ReportParamsModel.addToFilterValueMap(counter, "This Month")
        ReportParamsModel.addToFilterRelationMap(counter, Constants.betweenRelation)
        ReportParamsModel.addToFilterSlugMap(counter, Constants.slugBetweenRelation)

        nextXRadioTextField.focus = false
        lastXRadioTextField.focus = false
    }

    function onLastChecked(){

        var tmpDate = new Date()
        var thisMonth = tmpDate.getMonth()
        var thisYear = tmpDate.getFullYear()
        thisMonth = thisMonth + 1
        var newValue;

        if(thisMonth === 1){
            thisYear = thisYear - 1
            thisMonth = 12
            newValue = thisYear.toString() + "-" + thisMonth.toString() + "-" + daysInMonth(thisMonth, thisYear)
        }
        else{
            thisMonth = thisMonth - 1
            if(thisMonth < 10){
                newValue = thisYear.toString() + "-" + "0" + thisMonth.toString() + "-" + daysInMonth(thisMonth, thisYear)
            }
            else{
                newValue = thisYear.toString() + "-" + thisMonth.toString() + "-" + daysInMonth(thisMonth, thisYear)
            }
        }

        var firstValueArray = newValue.split("-")
        var firstValue = firstValueArray[0] + "-" + firstValueArray[1] + "-01"
        var finalValue = firstValue + "," + newValue

        console.log("Last Month", newValue)
        ReportParamsModel.setCategory(Constants.dateMainTimeFrameType)
        ReportParamsModel.setSubCategory(Constants.dateSubMonth)
        ReportParamsModel.setActualDateValues(counter, finalValue.toString())
        ReportParamsModel.addToFilterValueMap(counter, "Last Month")
        ReportParamsModel.addToFilterRelationMap(counter, Constants.betweenRelation)
        ReportParamsModel.addToFilterSlugMap(counter, Constants.slugBetweenRelation)

        nextXRadioTextField.focus = false
        lastXRadioTextField.focus = false
    }

    function onNextChecked(){

        var tmpDate = new Date()
        var thisMonth = tmpDate.getMonth()
        var thisYear = tmpDate.getFullYear()
        thisMonth = thisMonth + 1
        var newValue;

        if(thisMonth === 12){
            thisYear = thisYear + 1
            thisMonth = 1
            newValue = thisYear.toString() + "-" + "0" + thisMonth.toString() + "-" + daysInMonth(thisMonth, thisYear)
        }
        else{
            thisMonth = thisMonth + 1
            if(thisMonth < 10){
                newValue = thisYear.toString() + "-" + "0" + thisMonth.toString() + "-" + daysInMonth(thisMonth, thisYear)
            }
            else{
                newValue = thisYear.toString() + "-" + thisMonth.toString() + "-" + daysInMonth(thisMonth, thisYear)
            }
        }

        var firstValueArray = newValue.split("-")
        var firstValue = firstValueArray[0] + "-" + firstValueArray[1] + "-01"
        var finalValue = firstValue + "," + newValue

        console.log("Next Month", newValue)
        ReportParamsModel.setCategory(Constants.dateMainTimeFrameType)
        ReportParamsModel.setSubCategory(Constants.dateSubMonth)
        ReportParamsModel.setActualDateValues(counter, finalValue.toString())
        ReportParamsModel.addToFilterValueMap(counter, "Next Month")
        ReportParamsModel.addToFilterRelationMap(counter, Constants.betweenRelation)
        ReportParamsModel.addToFilterSlugMap(counter, Constants.slugBetweenRelation)

        nextXRadioTextField.focus = false
        lastXRadioTextField.focus = false
    }

    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts

    ButtonGroup{
        id: timeFrameRadio
    }


    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts


    Rectangle{
        id:thisTimeFrameRow
        height: 30
        width: parent.width
        anchors.left: parent.left


        CustomRadioButton{
            id:thisRadio

            radio_text: qsTr("This Month")
            radio_checked: false
            parent_dimension: 16
            ButtonGroup.group: timeFrameRadio
            onCheckedChanged: {
                onThisChecked()
            }
        }

    }

    Rectangle{
        id:lastTimeFrameRow
        height: 30
        width: parent.width

        anchors.left: parent.left
        anchors.top: thisTimeFrameRow.bottom
        anchors.topMargin: 10
        anchors.leftMargin: parent.width * 0.2
        anchors.rightMargin: parent.width * 0.2

        CustomRadioButton{
            id:lastRadio
            radio_text: qsTr("Last Month")
            radio_checked: false
            parent_dimension: 16
            ButtonGroup.group: timeFrameRadio
            onCheckedChanged: {
                onLastChecked()
            }
        }

    }

    Rectangle{
        id:nextTimeFrameRow
        height: 30
        width: parent.width

        anchors.left: parent.left
        anchors.top: lastTimeFrameRow.bottom
        anchors.topMargin: 10
        anchors.leftMargin: parent.width * 0.2
        anchors.rightMargin: parent.width * 0.2

        CustomRadioButton{
            id:nextRadio
            radio_text: qsTr("Next Month")
            radio_checked: false
            parent_dimension: 16
            ButtonGroup.group: timeFrameRadio
            onCheckedChanged: {
                onNextChecked()
            }
        }

    }


    Rectangle{
        id:lastXTimeFrameRow
        height: 30
        width: parent.width

        anchors.left: parent.left
        anchors.top: nextTimeFrameRow.bottom
        anchors.leftMargin: parent.width * 0.2
        anchors.topMargin: 10
        anchors.rightMargin: parent.width * 0.2

        CustomRadioButton{
            id:lastXRadio
            radio_text: qsTr("Last")
            radio_checked: false
            parent_dimension: 16
            width: 200
            ButtonGroup.group: timeFrameRadio
            onCheckedChanged: {
                onLastXChecked()
            }
        }

        TextField{
            height: 30
            width: 80
            id:lastXRadioTextField
            selectByMouse: true
            anchors.left: lastXRadio.right
            onTextChanged:{
                onLastXChecked()
            }
        }
        Text{
            height: 30
            width : 80
            text : "Month"
            anchors.leftMargin: 5
            anchors.top : parent.top
            anchors.topMargin: 5
            anchors.left:lastXRadioTextField.right

        }

    }

    Rectangle{
        id:nextXTimeFrameRow
        height: 30
        width: parent.width

        anchors.left: parent.left
        anchors.top: lastXTimeFrameRow.bottom
        anchors.leftMargin: parent.width * 0.2
        anchors.rightMargin: parent.width * 0.2
        anchors.topMargin: 10

        CustomRadioButton{
            id:nextXRadio
            radio_text: qsTr("Next")
            radio_checked: false
            parent_dimension: 16
            width: 200
            ButtonGroup.group: timeFrameRadio
            onCheckedChanged: {
                onNextXChecked()
            }
        }

        TextField{
            id: nextXRadioTextField
            selectByMouse: true
            height: 30
            width: 80
            anchors.left: nextXRadio.right
            onTextChanged: {
                onNextXChecked()
            }
        }
        Text{
            height: 30
            width : 80
            text : "Month"
            anchors.leftMargin: 5
            anchors.top : parent.top
            anchors.topMargin: 5
            anchors.left:nextXRadioTextField.right

        }

    }

    // Page Design Ends
    /***********************************************************************************************************************/

}
