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

    function slotEditYear(relation, slug, value){

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
        var thisYear = tmpDate.getFullYear()
        var pastYear = thisYear - newValue
        var finalValue = pastYear + "-01-01," + thisYear + "-01-01"

        console.log("Past " + value + " Year", pastYear)
        ReportParamsModel.setCategory(Constants.dateMainTimeFrameType)
        ReportParamsModel.setSubCategory(Constants.dateSubYear)
        ReportParamsModel.setActualDateValues(counter, finalValue.toString())
        ReportParamsModel.addToFilterValueMap(counter, "Last " + value + " Years")
        ReportParamsModel.addToFilterRelationMap(counter, Constants.betweenRelation)
        ReportParamsModel.addToFilterSlugMap(counter, Constants.slugBetweenRelation)

        nextXRadioTextField.focus = false
        lastXRadioTextField.focus = true
    }
    function onNextXChecked(){

        var value = nextXRadioTextField.text
        var newValue = Number(value)
        var tmpDate = new Date()
        var thisYear = tmpDate.getFullYear()
        var futureYear = thisYear + newValue
        var finalValue = thisYear + "-12-31," + futureYear + "-12-31"

        console.log("Next " + value + " Year", futureYear)
        ReportParamsModel.setCategory(Constants.dateMainTimeFrameType)
        ReportParamsModel.setSubCategory(Constants.dateSubYear)
        ReportParamsModel.setActualDateValues(counter, finalValue.toString())
        ReportParamsModel.addToFilterValueMap(counter, "Next " + value + " Years")
        ReportParamsModel.addToFilterRelationMap(counter, Constants.betweenRelation)
        ReportParamsModel.addToFilterSlugMap(counter, Constants.slugBetweenRelation)

        nextXRadioTextField.focus = true
        lastXRadioTextField.focus = false
    }

    function onThisChecked(){

        var tmpDate = new Date()
        var thisYear = tmpDate.getFullYear()

        console.log("This Year", thisYear)
        ReportParamsModel.setCategory(Constants.dateMainTimeFrameType)
        ReportParamsModel.setSubCategory(Constants.dateSubYear)
        ReportParamsModel.setActualDateValues(counter, thisYear.toString())
        ReportParamsModel.addToFilterValueMap(counter, "This Year")
        ReportParamsModel.addToFilterRelationMap(counter, Constants.likeRelation)
        ReportParamsModel.addToFilterSlugMap(counter, Constants.slugLikeRelation)

        nextXRadioTextField.focus = false
        lastXRadioTextField.focus = false
    }

    function onLastChecked(){

        var tmpDate = new Date()
        var lastYear = tmpDate.getFullYear() - 1

        console.log("Last Year", lastYear)
        ReportParamsModel.setCategory(Constants.dateMainTimeFrameType)
        ReportParamsModel.setSubCategory(Constants.dateSubYear)
        ReportParamsModel.setActualDateValues(counter, lastYear.toString())
        ReportParamsModel.addToFilterValueMap(counter, "Last Year")
        ReportParamsModel.addToFilterRelationMap(counter, Constants.likeRelation)
        ReportParamsModel.addToFilterSlugMap(counter, Constants.slugLikeRelation)

        nextXRadioTextField.focus = false
        lastXRadioTextField.focus = false
    }

    function onNextChecked(){

        var tmpDate = new Date()
        var nextYear = tmpDate.getFullYear() + 1

        console.log("Next Year", nextYear)
        ReportParamsModel.setCategory(Constants.dateMainTimeFrameType)
        ReportParamsModel.setSubCategory(Constants.dateSubYear)
        ReportParamsModel.setActualDateValues(counter, nextYear.toString())
        ReportParamsModel.addToFilterValueMap(counter, "Next Year")
        ReportParamsModel.addToFilterRelationMap(counter, Constants.likeRelation)
        ReportParamsModel.addToFilterSlugMap(counter, Constants.slugLikeRelation)

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

            radio_text: qsTr("This Year")
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
            radio_text: qsTr("Last Year")
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
            radio_text: qsTr("Next Year")
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
            text : "Year"
            anchors.leftMargin: 5
            anchors.top :parent.top
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
            text : "Year"
            anchors.leftMargin: 5
            anchors.top :parent.top
            anchors.topMargin: 5
            anchors.left:nextXRadioTextField.right
        }

    }



    // Page Design Ends
    /***********************************************************************************************************************/

}
