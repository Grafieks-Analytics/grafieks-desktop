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
        target: DSParamsModel

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
            counter = DSParamsModel.internalCounter
        }

        function onFilterIndexChanged(){
            counter = DSParamsModel.filterIndex
        }
    }


    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

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
                tmpValue = thisYear.toString() + "-" + thisMonth.toString()
                lastXMonths.push(tmpValue)
            }
            else{
                thisMonth = thisMonth - 1
                if(thisMonth < 10){
                    tmpValue = thisYear.toString() + "-" + "0" + thisMonth.toString()
                }
                else{
                    tmpValue = thisYear.toString() + "-" + thisMonth.toString()
                }
                lastXMonths.push(tmpValue)
            }
        }

        DSParamsModel.setTimeFrame("Last " + value + " Month", lastXMonths.toString())
        DSParamsModel.setSubCategory("Month")
        DSParamsModel.addToJoinValue(counter, "Last " + value + " Month")
        DSParamsModel.addToJoinRelation(counter, Constants.likeRelation)
        DSParamsModel.addToJoinRelationSlug(counter, Constants.likeRelation)

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
                tmpValue = thisYear.toString() + "-" + "0" + thisMonth.toString()
                nextXMonths.push(tmpValue)
            }
            else{
                thisMonth = thisMonth + 1
                if(thisMonth < 10){
                    tmpValue = thisYear.toString() + "-" + "0" + thisMonth.toString()
                }
                else{
                    tmpValue = thisYear.toString() + "-" + thisMonth.toString()
                }
                nextXMonths.push(tmpValue)
            }
        }
        console.log(nextXMonths.toString())
        DSParamsModel.setTimeFrame("Next " + value + " Month", nextXMonths.toString())
        DSParamsModel.setSubCategory("Month")
        DSParamsModel.addToJoinValue(counter, "Next " + value + " Month")
        DSParamsModel.addToJoinRelation(counter, Constants.likeRelation)
        DSParamsModel.addToJoinRelationSlug(counter, Constants.likeRelation)

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
            newValue = thisYear.toString() + "-" + "0" + thisMonth.toString()
        }
        else{
            newValue = thisYear.toString() + "-" + thisMonth.toString()
        }

        DSParamsModel.setTimeFrame("This Month", newValue.toString())
        DSParamsModel.setSubCategory("Month")
        DSParamsModel.addToJoinValue(counter, "This Month")
        DSParamsModel.addToJoinRelation(counter, Constants.likeRelation)
        DSParamsModel.addToJoinRelationSlug(counter, Constants.likeRelation)

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
            newValue = thisYear.toString() + "-" + thisMonth.toString()
        }
        else{
            thisMonth = thisMonth - 1
            if(thisMonth < 10){
                newValue = thisYear.toString() + "-" + "0" + thisMonth.toString()
            }
            else{
                newValue = thisYear.toString() + "-" + thisMonth.toString()
            }
        }

        DSParamsModel.setTimeFrame("Last Month", newValue.toString())
        DSParamsModel.setSubCategory("Month")
        DSParamsModel.addToJoinValue(counter, "Last Month")
        DSParamsModel.addToJoinRelation(counter, Constants.likeRelation)
        DSParamsModel.addToJoinRelationSlug(counter, Constants.likeRelation)

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
            newValue = thisYear.toString() + "-" + "0" + thisMonth.toString()
        }
        else{
            thisMonth = thisMonth + 1
            if(thisMonth < 10){
                newValue = thisYear.toString() + "-" + "0" + thisMonth.toString()
            }
            else{
                newValue = thisYear.toString() + "-" + thisMonth.toString()
            }
        }

        DSParamsModel.setTimeFrame("Next Month", newValue.toString())
        DSParamsModel.setSubCategory("Month")
        DSParamsModel.addToJoinValue(counter, "Next Month")
        DSParamsModel.addToJoinRelation(counter, Constants.likeRelation)
        DSParamsModel.addToJoinRelationSlug(counter, Constants.likeRelation)

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
