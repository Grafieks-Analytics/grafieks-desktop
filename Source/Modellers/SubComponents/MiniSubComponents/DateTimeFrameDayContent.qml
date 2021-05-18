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
    property var weekDays: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

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

    function slotEditDay(relation, slug, value){

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

    function isLeapYear(year){

        if(year % 400 === 0)
            return 1

        if (year % 100 == 0)
            return 0

        if (year % 4 == 0)
            return 1

        return 0
    }

    function onLastXChecked(){

        var value = lastXRadioTextField.text
        var numOfDays = Number(value)

        var tmpDate = new Date()
        var newDate = Qt.formatDateTime(tmpDate,'yyyy-MM-dd')
        var dateList = newDate.split("-")

        var year = Number(dateList[0])
        var month = Number(dateList[1])
        var day = Number(dateList[2])

        var newValue;
        var lastXDays = []

        for (let i = 0; i < numOfDays; i++){

            if(day === 1){
                if(month === 1){
                    year = year - 1
                    month = 12
                    day = 31
                    newValue = year.toString() + "-" + month.toString() + "-" + day.toString()
                }
                else{
                    month = month - 1
                    if(month === 2){
                        if(isLeapYear(year)){
                            day = 29
                        }
                        else{
                            day = 28
                        }
                        newValue = year.toString() + "-" + "0" + month.toString() + "-" + day.toString()
                    }
                    else{
                        if(month === 4 || month === 6 || month === 9 || month === 11){
                            day = 30
                            if(month < 10){
                                newValue = year.toString() + "-" + "0" + month.toString() + "-" + day.toString()
                            }
                            else{
                                newValue = year.toString() + "-" + month.toString() + "-" + day.toString()
                            }
                        }
                        else{
                            day = 31
                            if(month < 10){
                                newValue = year.toString() + "-" + "0" + month.toString() + "-" + day.toString()
                            }
                            else{
                                newValue = year.toString() + "-" + month.toString() + "-" + day.toString()
                            }
                        }
                    }
                }
            }
            else{
                day = day - 1
                if(day < 10 && month < 10){
                    newValue = year.toString() + "-" + "0" + month.toString() + "-" + "0" + day.toString()
                }
                else if(month < 10){
                    newValue = year.toString() + "-" + "0" + month.toString() + "-" + day.toString()
                }
                else if(day < 10){
                    newValue = year.toString() + "-" + month.toString() + "-" + "0" + day.toString()
                }
                else{
                    newValue = year.toString() + "-" + month.toString() + "-" + day.toString()
                }
            }

            lastXDays.push(newValue)
        }

        console.log(lastXDays.toString())
        DSParamsModel.setTimeFrame("Last " + value + " Day", lastXDays.toString())
        DSParamsModel.setSubCategory("Day")
        DSParamsModel.addToJoinValue(counter, "Last " + value + " Day")
        DSParamsModel.addToJoinRelation(counter, Constants.likeRelation)
        DSParamsModel.addToJoinRelationSlug(counter, Constants.likeRelation)

        nextXRadioTextField.focus = false
        lastXRadioTextField.focus = true
    }
    function onNextXChecked(){

        var value = nextXRadioTextField.text
        var numOfDays = Number(value)

        var tmpDate = new Date()
        var newDate = Qt.formatDateTime(tmpDate,'yyyy-MM-dd')
        var dateList = newDate.split("-")

        var year = Number(dateList[0])
        var month = Number(dateList[1])
        var day = Number(dateList[2])

        var newValue;
        var nextXDays = []

        for(let i = 0; i < numOfDays; i++){

            if(day === 31){
                if(month === 12){
                    year = year + 1
                    month = 1
                    day = 1
                    newValue = year.toString() + "-" + "0" + month.toString() + "-" + "0" + day.toString()
                }
                else{
                    month = month + 1
                    day = 1
                    if(month < 10)
                        newValue = year.toString() + "-" + "0" + month.toString() + "-" + "0" + day.toString()
                    else
                        newValue = year.toString() + "-" + month.toString() + "-" + "0" + day.toString()
                }
            }
            else if(day === 30){

                if(month === 4 || month === 6 || month === 9 || month === 11){
                        day = 1
                        month = month + 1
                        if(month < 10)
                            newValue = year.toString() + "-" + "0" + month.toString() + "-" + "0" + day.toString()
                        else
                            newValue = year.toString() + "-" + month.toString() + "-" + "0" + day.toString()
                }
                else{
                    day = day + 1
                    if(month < 10)
                        newValue = year.toString() + "-" + "0" + month.toString() + "-" + day.toString()
                    else
                        newValue = year.toString() + "-" + month.toString() + "-" + day.toString()

                }
            }
            else{
                if(day === 29 && month === 2){
                    month = 3
                    day = 1
                    newValue = year.toString() + "-" + "0" + month.toString() + "-" + "0" + day.toString()
                }
                else if(day === 28 && month === 2){
                    if(isLeapYear(year)){
                        day = day + 1
                        newValue = year.toString() + "-" + "0" + month.toString() + "-" + day.toString()
                    }
                    else{
                        month = 3
                        day = 1
                        newValue = year.toString() + "-" + "0" + month.toString() + "-" + "0" + day.toString()
                    }
                }
                else{
                    day = day + 1
                    if(day < 10 && month < 10){
                        newValue = year.toString() + "-" + "0" + month.toString() + "-" + "0" + day.toString()
                    }
                    else if(month < 10){
                        newValue = year.toString() + "-" + "0" + month.toString() + "-" + day.toString()
                    }
                    else if(day < 10){
                        newValue = year.toString() + "-" + month.toString() + "-" + "0" + day.toString()
                    }
                    else{
                        newValue = year.toString() + "-" + month.toString() + "-" + day.toString()
                    }
                }
            }
            nextXDays.push(newValue)
        }

        console.log(nextXDays.toString())
        DSParamsModel.setTimeFrame("Next " + value + " Day", nextXDays.toString())
        DSParamsModel.setSubCategory("Day")
        DSParamsModel.addToJoinValue(counter, "Next " + value + " Day")
        DSParamsModel.addToJoinRelation(counter, Constants.likeRelation)
        DSParamsModel.addToJoinRelationSlug(counter, Constants.likeRelation)

        nextXRadioTextField.focus = true
        lastXRadioTextField.focus = false
    }

    function onThisChecked(){

        var tmpDate = new Date()
        var newDate = Qt.formatDateTime(tmpDate,'yyyy-MM-dd')
        var thisDay = newDate

        DSParamsModel.setTimeFrame("This Day", thisDay.toString())
        DSParamsModel.setSubCategory("Day")
        DSParamsModel.addToJoinValue(counter, "This Day")
        DSParamsModel.addToJoinRelation(counter, Constants.likeRelation)
        DSParamsModel.addToJoinRelationSlug(counter, Constants.likeRelation)

        nextXRadioTextField.focus = false
        lastXRadioTextField.focus = false
    }

    function onLastChecked(){

        var tmpDate = new Date()
        var newDate = Qt.formatDateTime(tmpDate,'yyyy-MM-dd')
        var dateList = newDate.split("-")

        var year = Number(dateList[0])
        var month = Number(dateList[1])
        var day = Number(dateList[2])

        var newValue;

        if(day === 1){
            if(month === 1){
                year = year - 1
                month = 12
                day = 31
                newValue = year.toString() + "-" + month.toString() + "-" + day.toString()
            }
            else{
                month = month - 1
                if(month === 2){
                    if(isLeapYear(year)){
                        day = 29
                    }
                    else{
                        day = 28
                    }
                    newValue = year.toString() + "-" + "0" + month.toString() + "-" + day.toString()
                }
                else{
                    if(month === 4 || month === 6 || month === 9 || month === 11){
                        day = 30
                        if(month < 10){
                            newValue = year.toString() + "-" + "0" + month.toString() + "-" + day.toString()
                        }
                        else{
                            newValue = year.toString() + "-" + month.toString() + "-" + day.toString()
                        }
                    }
                    else{
                        day = 31
                        if(month < 10){
                            newValue = year.toString() + "-" + "0" + month.toString() + "-" + day.toString()
                        }
                        else{
                            newValue = year.toString() + "-" + month.toString() + "-" + day.toString()
                        }
                    }
                }

            }
        }
        else{
            day = day - 1
            if(day < 10 && month < 10){
                newValue = year.toString() + "-" + "0" + month.toString() + "-" + "0" + day.toString()
            }
            else if(month < 10){
                newValue = year.toString() + "-" + "0" + month.toString() + "-" + day.toString()
            }
            else if(day < 10){
                newValue = year.toString() + "-" + month.toString() + "-" + "0" + day.toString()
            }
            else{
                newValue = year.toString() + "-" + month.toString() + "-" + day.toString()
            }
        }

        DSParamsModel.setTimeFrame("Last Day", newValue.toString())
        DSParamsModel.setSubCategory("Day")
        DSParamsModel.addToJoinValue(counter, "Last Day")
        DSParamsModel.addToJoinRelation(counter, Constants.likeRelation)
        DSParamsModel.addToJoinRelationSlug(counter, Constants.likeRelation)

        nextXRadioTextField.focus = false
        lastXRadioTextField.focus = false
    }

    function onNextChecked(){

        var tmpDate = new Date()
        var newDate = Qt.formatDateTime(tmpDate,'yyyy-MM-dd')
        var dateList = newDate.split("-")

        var year = Number(dateList[0])
        var month = Number(dateList[1])
        var day = Number(dateList[2])

        var newValue;

        if(day === 31){
            if(month === 12){
                year = year + 1
                month = 1
                day = 1
                newValue = year.toString() + "-" + "0" + month.toString() + "-" + "0" + day.toString()
            }
            else{
                month = month + 1
                day = 1
                if(month < 10)
                    newValue = year.toString() + "-" + "0" + month.toString() + "-" + "0" + day.toString()
                else
                    newValue = year.toString() + "-" + month.toString() + "-" + "0" + day.toString()
            }
        }
        else if(day === 30){

            if(month === 4 || month === 6 || month === 9 || month === 11){
                    day = 1
                    month = month + 1
                    if(month < 10)
                        newValue = year.toString() + "-" + "0" + month.toString() + "-" + "0" + day.toString()
                    else
                        newValue = year.toString() + "-" + month.toString() + "-" + "0" + day.toString()
            }
            else{
                day = day + 1
                if(month < 10)
                    newValue = year.toString() + "-" + "0" + month.toString() + "-" + day.toString()
                else
                    newValue = year.toString() + "-" + month.toString() + "-" + day.toString()

            }
        }
        else{
            if(day === 29 && month === 2){
                month = 3
                day = 1
                newValue = year.toString() + "-" + "0" + month.toString() + "-" + "0" + day.toString()
            }
            else if(day === 28 && month === 2){
                if(isLeapYear(year)){
                    day = day + 1
                    newValue = year.toString() + "-" + "0" + month.toString() + "-" + day.toString()
                }
                else{
                    month = 3
                    day = 1
                    newValue = year.toString() + "-" + "0" + month.toString() + "-" + "0" + day.toString()
                }
            }
            else{
                day = day + 1
                if(day < 10 && month < 10){
                    newValue = year.toString() + "-" + "0" + month.toString() + "-" + "0" + day.toString()
                }
                else if(month < 10){
                    newValue = year.toString() + "-" + "0" + month.toString() + "-" + day.toString()
                }
                else if(day < 10){
                    newValue = year.toString() + "-" + month.toString() + "-" + "0" + day.toString()
                }
                else{
                    newValue = year.toString() + "-" + month.toString() + "-" + day.toString()
                }
            }
        }

        DSParamsModel.setTimeFrame("Next Day", newValue.toString())
        DSParamsModel.setSubCategory("Day")
        DSParamsModel.addToJoinValue(counter, "Next Day")
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

            text: qsTr("This Day")
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
            radio_text: qsTr("Last Day")
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
            radio_text: qsTr("Next Day")
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
            selectByMouse: true
            id:lastXRadioTextField
            anchors.left: lastXRadio.right
            onTextChanged: {
                onLastXChecked()
            }
        }
        Text{
            height: 30
            width : 80
            text : "Day"
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
            text : "Day"
            anchors.leftMargin: 5
            anchors.top : parent.top
            anchors.topMargin: 5
            anchors.left:nextXRadioTextField.right
        }

    }


    // Page Design Ends
    /***********************************************************************************************************************/

}

