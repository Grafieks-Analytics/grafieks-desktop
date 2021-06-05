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

    function slotEditQuarter(relation, slug, value){

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
        var noOfQuarter = Number(value)
        var tmpDate = new Date()
        var thisYear = tmpDate.getFullYear()
        var thisMonth = tmpDate.getMonth()
        thisMonth = thisMonth + 1
        var tmpMonth;
        var newValue;

        var lastMonth = 1
        var lastXQuarter = []

        for(let i = 0; i < noOfQuarter; i++){

            if(lastMonth){
                if(thisMonth >= 1 && thisMonth <= 3){
                    tmpMonth = 10
                    thisYear = thisYear - 1
                }
                else if(thisMonth >= 4 && thisMonth <= 6){
                    tmpMonth = 1
                }
                else if(thisMonth >= 7 && thisMonth <= 9){
                    tmpMonth = 4
                }
                else{
                    tmpMonth = 7
                }
                lastMonth = 0
            }

            if(tmpMonth >= 1 && tmpMonth <= 3){

                newValue = thisYear.toString() + "-" + "0" + tmpMonth.toString() + "-01"
                lastXQuarter.push(newValue)

                newValue = thisYear.toString() + "-" + "0" + (tmpMonth+2).toString() + "-" + daysInMonth(tmpMonth + 2, thisYear)
                lastXQuarter.push(newValue)
                thisMonth = 1
                lastMonth = 1
            }
            else if(tmpMonth >= 4 && tmpMonth <= 6){

                newValue = thisYear.toString() + "-" + "0" + tmpMonth.toString() + "-01"
                lastXQuarter.push(newValue)

                newValue = thisYear.toString() + "-" + "0" + (tmpMonth+2).toString() + "-" + daysInMonth(tmpMonth + 2, thisYear)
                lastXQuarter.push(newValue)
                tmpMonth = 1
            }
            else if(tmpMonth >= 7 && tmpMonth <= 9){

                newValue = thisYear.toString() + "-" + "0" + tmpMonth.toString() + "-01"
                lastXQuarter.push(newValue)

                newValue = thisYear.toString() + "-" + "0" + (tmpMonth+2).toString() + "-" + daysInMonth(tmpMonth + 2, thisYear)
                lastXQuarter.push(newValue)
                tmpMonth = 4
            }
            else{

                newValue = thisYear.toString() + "-" + tmpMonth.toString() + "-01"
                lastXQuarter.push(newValue)

                newValue = thisYear.toString() + "-" + (tmpMonth+2).toString() + "-" + daysInMonth(tmpMonth + 2, thisYear)
                lastXQuarter.push(newValue)
                tmpMonth = 7
            }
        }

        lastXQuarter.sort()

        var finalValue = lastXQuarter[0] + "," + lastXQuarter[lastXQuarter.length - 1]

        console.log("Last "+ noOfQuarter + " Quarters", lastXQuarter[0], lastXQuarter[lastXQuarter.length - 1])
        ReportParamsModel.setSubCategory(Constants.dateSubQuarter)
        ReportParamsModel.setActualDateValues(counter, finalValue.toString())
        ReportParamsModel.addToJoinValue(counter, "Last " + value + " Quarter")
        ReportParamsModel.addToJoinRelation(counter, Constants.betweenRelation)
        ReportParamsModel.addToJoinRelationSlug(counter, Constants.betweenRelation)

        nextXRadioTextField.focus = false
        lastXRadioTextField.focus = true
    }

    function onNextXChecked(){

        var value = nextXRadioTextField.text
        var noOfQuarter = Number(value)
        var tmpDate = new Date()
        var thisYear = tmpDate.getFullYear()
        var thisMonth = tmpDate.getMonth()
        thisMonth = thisMonth + 1
        var tmpMonth;
        var newValue;

        var nextMonth = 1
        var nextXQuarter = []

        for(let i = 0; i < noOfQuarter; i++){

            if(nextMonth){
                if(thisMonth >= 1 && thisMonth <= 3){
                    tmpMonth = 4
                }
                else if(thisMonth >= 4 && thisMonth <= 6){
                    tmpMonth = 7
                }
                else if(thisMonth >= 7 && thisMonth <= 9){
                    tmpMonth = 10
                }
                else{
                    tmpMonth = 1
                    thisYear = thisYear + 1
                }
                nextMonth = 0
            }

            if(tmpMonth >= 1 && tmpMonth <= 3){

                newValue = thisYear.toString() + "-" + "0" + tmpMonth.toString() + "-01"
                nextXQuarter.push(newValue)

                newValue = thisYear.toString() + "-" + "0" + (tmpMonth+2).toString() + "-" + daysInMonth(tmpMonth + 2, thisYear)
                nextXQuarter.push(newValue)
                tmpMonth = 4
            }
            else if(tmpMonth >= 4 && tmpMonth <= 6){

                newValue = thisYear.toString() + "-" + "0" + tmpMonth.toString() + "-01"
                nextXQuarter.push(newValue)

                newValue = thisYear.toString() + "-" + "0" + (tmpMonth+2).toString() + "-" + daysInMonth(tmpMonth + 2, thisYear)
                nextXQuarter.push(newValue)
                tmpMonth = 7
            }
            else if(tmpMonth >= 7 && tmpMonth <= 9){

                newValue = thisYear.toString() + "-" + "0" + tmpMonth.toString() + "-01"
                nextXQuarter.push(newValue)

                newValue = thisYear.toString() + "-" + "0" + (tmpMonth+2).toString() + "-" + daysInMonth(tmpMonth + 2, thisYear)
                nextXQuarter.push(newValue)
                tmpMonth = 10
            }
            else{

                newValue = thisYear.toString() + "-" + tmpMonth.toString() + "-01"
                nextXQuarter.push(newValue)

                newValue = thisYear.toString() + "-" + (tmpMonth+2).toString() + "-" + daysInMonth(tmpMonth + 2, thisYear)
                nextXQuarter.push(newValue)
                thisMonth = 10
                nextMonth = 1
            }
        }

        nextXQuarter.sort()
        var finalValue = nextXQuarter[0] + "," + nextXQuarter[nextXQuarter.length - 1]

        console.log("Next "+ noOfQuarter + " Quarters", nextXQuarter[0], nextXQuarter[nextXQuarter.length - 1])
        ReportParamsModel.setSubCategory(Constants.dateSubQuarter)
        ReportParamsModel.setActualDateValues(counter, finalValue.toString())
        ReportParamsModel.addToJoinValue(counter, "Next " + value + " Quarter")
        ReportParamsModel.addToJoinRelation(counter, Constants.betweenRelation)
        ReportParamsModel.addToJoinRelationSlug(counter, Constants.betweenRelation)

        nextXRadioTextField.focus = true
        lastXRadioTextField.focus = false
    }

    function onThisChecked(){

        var tmpDate = new Date()
        var thisYear = tmpDate.getFullYear()
        var thisMonth = tmpDate.getMonth()
        thisMonth = thisMonth + 1
        var thisQuarter = []
        var tmpMonth;
        var newValue;

        if(thisMonth >= 1 && thisMonth <= 3){

            tmpMonth = 1
            newValue = thisYear.toString() + "-" + "0" + tmpMonth.toString() + "-01"
            thisQuarter.push(newValue)

            newValue = thisYear.toString() + "-" + "0" + (tmpMonth+2).toString() + "-" + daysInMonth(tmpMonth + 2, thisYear)
            thisQuarter.push(newValue)
        }
        else if(thisMonth >= 4 && thisMonth <= 6){

            tmpMonth = 4
            newValue = thisYear.toString() + "-" + "0" + tmpMonth.toString() + "-01"
            thisQuarter.push(newValue)

            newValue = thisYear.toString() + "-" + "0" + (tmpMonth+2).toString() + "-" + daysInMonth(tmpMonth + 2, thisYear)
            thisQuarter.push(newValue)
        }
        else if(thisMonth >= 7 && thisMonth <= 9){

            tmpMonth = 7
            newValue = thisYear.toString() + "-" + "0" + tmpMonth.toString() + "-01"
            thisQuarter.push(newValue)

            newValue = thisYear.toString() + "-" + "0" + (tmpMonth+2).toString() + "-" + daysInMonth(tmpMonth + 2, thisYear)
            thisQuarter.push(newValue)
        }
        else{

            tmpMonth = 10
            newValue = thisYear.toString() + "-" + tmpMonth.toString() + "-01"
            thisQuarter.push(newValue)

            newValue = thisYear.toString() + "-" + (tmpMonth+2).toString() + "-" + daysInMonth(tmpMonth + 2, thisYear)
            thisQuarter.push(newValue)
        }

        thisQuarter.sort()
        var finalValue = thisQuarter[0] + "," + thisQuarter[thisQuarter.length - 1]

        console.log("This Quarter", thisQuarter[0], thisQuarter[thisQuarter.length - 1])
        ReportParamsModel.setSubCategory(Constants.dateSubQuarter)
        ReportParamsModel.setActualDateValues(counter, finalValue.toString())
        ReportParamsModel.addToJoinValue(counter, "This Quarter")
        ReportParamsModel.addToJoinRelation(counter, Constants.betweenRelation)
        ReportParamsModel.addToJoinRelationSlug(counter, Constants.betweenRelation)

        nextXRadioTextField.focus = false
        lastXRadioTextField.focus = false
    }

    function onLastChecked(){

        var tmpDate = new Date()
        var thisYear = tmpDate.getFullYear()
        var thisMonth = tmpDate.getMonth()
        thisMonth = thisMonth + 1
        var lastQuarter = []
        var tmpMonth;
        var newValue;

        if(thisMonth >= 1 && thisMonth <= 3){

            tmpMonth = 10
            thisYear = thisYear - 1
            newValue = thisYear.toString() + "-" + tmpMonth.toString() + "-01"
            lastQuarter.push(newValue)

            newValue = thisYear.toString() + "-" + (tmpMonth+2).toString() + "-" + daysInMonth(tmpMonth + 2, thisYear)
            lastQuarter.push(newValue)
        }
        else if(thisMonth >= 4 && thisMonth <= 6){

            tmpMonth = 1
            newValue = thisYear.toString() + "-" + "0" + tmpMonth.toString() + "-01"
            lastQuarter.push(newValue)

            newValue = thisYear.toString() + "-" + "0" + (tmpMonth+2).toString() + "-" + daysInMonth(tmpMonth + 2, thisYear)
            lastQuarter.push(newValue)
        }
        else if(thisMonth >= 7 && thisMonth <= 9){

            tmpMonth = 4
            newValue = thisYear.toString() + "-" + "0" + tmpMonth.toString() + "-01"
            lastQuarter.push(newValue)

            newValue = thisYear.toString() + "-" + "0" + (tmpMonth+2).toString() + "-" + daysInMonth(tmpMonth + 2, thisYear)
            lastQuarter.push(newValue)
        }
        else{

            tmpMonth = 7
            newValue = thisYear.toString() + "-" + "0" + tmpMonth.toString() + "-01"
            lastQuarter.push(newValue)

            newValue = thisYear.toString() + "-" + "0" + (tmpMonth+2).toString() + "-" + daysInMonth(tmpMonth + 2, thisYear)
            lastQuarter.push(newValue)
        }

        lastQuarter.sort()
        var finalValue = lastQuarter[0] + "," + lastQuarter[lastQuarter.length - 1]

        console.log("Last Quarter", lastQuarter[0], lastQuarter[lastQuarter.length - 1])
        ReportParamsModel.setSubCategory(Constants.dateSubQuarter)
        ReportParamsModel.setActualDateValues(counter, finalValue.toString())
        ReportParamsModel.addToJoinValue(counter, "Last Quarter")
        ReportParamsModel.addToJoinRelation(counter, Constants.betweenRelation)
        ReportParamsModel.addToJoinRelationSlug(counter, Constants.betweenRelation)

        nextXRadioTextField.focus = false
        lastXRadioTextField.focus = false
    }

    function onNextChecked(){

        var tmpDate = new Date()
        var thisYear = tmpDate.getFullYear()
        var thisMonth = tmpDate.getMonth()
        thisMonth = thisMonth + 1
        var nextQuarter = []
        var tmpMonth;
        var newValue;

        if(thisMonth >= 1 && thisMonth <= 3){

            tmpMonth = 4
            newValue = thisYear.toString() + "-" + "0" + tmpMonth.toString() + "-01"
            nextQuarter.push(newValue)

            newValue = thisYear.toString() + "-" + "0" + (tmpMonth+2).toString() + "-" + daysInMonth(tmpMonth + 2, thisYear)
            nextQuarter.push(newValue)
        }
        else if(thisMonth >= 4 && thisMonth <= 6){

            tmpMonth = 7
            newValue = thisYear.toString() + "-" + "0" + tmpMonth.toString() + "-01"
            nextQuarter.push(newValue)

            newValue = thisYear.toString() + "-" + "0" + (tmpMonth+2).toString() + "-" + daysInMonth(tmpMonth + 2, thisYear)
            nextQuarter.push(newValue)
        }
        else if(thisMonth >= 7 && thisMonth <= 9){

            tmpMonth = 10
            newValue = thisYear.toString() + "-" + tmpMonth.toString() + "-01"
            nextQuarter.push(newValue)

            newValue = thisYear.toString() + "-" + (tmpMonth+2).toString() + "-" + daysInMonth(tmpMonth + 2, thisYear)
            nextQuarter.push(newValue)
        }
        else{

            tmpMonth = 1
            thisYear = thisYear + 1
            newValue = thisYear.toString() + "-" + "0" + tmpMonth.toString() + "-01"
            nextQuarter.push(newValue)

            newValue = thisYear.toString() + "-" + "0" + (tmpMonth+2).toString() + "-" + daysInMonth(tmpMonth + 2, thisYear)
            nextQuarter.push(newValue)
        }


        nextQuarter.sort()
        var finalValue = nextQuarter[0] + "," + nextQuarter[nextQuarter.length - 1]

        console.log("Next Quarter", nextQuarter[0], nextQuarter[nextQuarter.length - 1])
        ReportParamsModel.setSubCategory(Constants.dateSubQuarter)
        ReportParamsModel.setActualDateValues(counter, finalValue.toString())
        ReportParamsModel.addToJoinValue(counter, "Next Quarter")
        ReportParamsModel.addToJoinRelation(counter, Constants.betweenRelation)
        ReportParamsModel.addToJoinRelationSlug(counter, Constants.betweenRelation)

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

            radio_text: qsTr("This Quarter")
            checked: false
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
            radio_text: qsTr("Last Quarter")
            checked: false
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
            radio_text: qsTr("Next Quarter")
            checked: false
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
            checked: false
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
            onTextChanged: {
                onLastXChecked()
            }
        }

        Text{
            height: 30
            width : 80
            text : "Quarter"
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
            checked: false
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
            text : "Quarter"
            anchors.leftMargin: 5
            anchors.top : parent.top
            anchors.topMargin: 5
            anchors.left:nextXRadioTextField.right
        }

    }
}
