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



    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

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
        DSParamsModel.setSubCategory("Day")
        DSParamsModel.addToJoinValue(mapKey, value)
        DSParamsModel.addToJoinRelation(mapKey, Constants.likeRelation)
        DSParamsModel.addToJoinRelationSlug(mapKey, Constants.likeRelation)

        nextXRadioTextField.focus = false
        lastXRadioTextField.focus = true
    }
    function onNextXChecked(){

        var value = nextXRadioTextField.text
        DSParamsModel.setSubCategory("Day")
        DSParamsModel.addToJoinValue(mapKey, value)
        DSParamsModel.addToJoinRelation(mapKey, Constants.likeRelation)
        DSParamsModel.addToJoinRelationSlug(mapKey, Constants.likeRelation)

        nextXRadioTextField.focus = true
        lastXRadioTextField.focus = false
    }

    function onThisChecked(){

        var tmpDate = new Date()
        var newDate = Qt.formatDateTime(tmpDate,'yyyy-MM-dd')
        var thisDay = newDate

        DSParamsModel.setTimeFrame("This Day", thisDay.toString())
        DSParamsModel.setSubCategory("Day")
        DSParamsModel.addToJoinValue(mapKey, "This Day")
        DSParamsModel.addToJoinRelation(mapKey, Constants.likeRelation)
        DSParamsModel.addToJoinRelationSlug(mapKey, Constants.likeRelation)

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
        DSParamsModel.addToJoinValue(mapKey, "Last Day")
        DSParamsModel.addToJoinRelation(mapKey, Constants.likeRelation)
        DSParamsModel.addToJoinRelationSlug(mapKey, Constants.likeRelation)

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
            else{
                newValue = year.toString() + "-" + month.toString() + "-" + "0" + day.toString()
            }
        }

        DSParamsModel.setSubCategory("Day")
        DSParamsModel.addToJoinValue(mapKey, newValue)
        DSParamsModel.addToJoinRelation(mapKey, Constants.likeRelation)
        DSParamsModel.addToJoinRelationSlug(mapKey, Constants.likeRelation)

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
            id:lastXRadioTextField
            anchors.left: lastXRadio.right
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
            height: 30
            width: 80
            anchors.left: nextXRadio.right
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

