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
    id: wildcardContent
    property bool listOpened: false
    property string selectOption: "Select Wildcard"
    property var acceptedValues:["Containing", "Ends With", "Equal", "Doesnt Start With", "Doesnt End With", "Not Equal"]

    property string editRelation : ""
    property string editValue : ""
    property string editSlug : ""
    property int totalWildCards: 1
    property int counter: 0

    property var currenctExclude: false


    /***********************************************************************************************************************/
    // LIST MODEL STARTS

    // List model for Listview
    // Will be dynamically populated
    // on button click
    ListModel {
        id: listviewWildCardModel
    }


    // Listmodel for combobox
    ListModel{
        id: selectDropdown

        ListElement{
            menuItem:"Containing"
            compareValue: "Containing"
        }
        ListElement{
            menuItem:"Ends With"
            compareValue: "Ends With"
        }
        ListElement{
            menuItem:"Equal To"
            compareValue: "Equal"
        }
        ListElement{
            menuItem:"Doesn't Start with"
            compareValue: "Doesnt Start With"
        }
        ListElement{
            menuItem:"Doesn't End with"
            compareValue: "Doesnt End With"
        }
        ListElement{
            menuItem:"Not Equal to"
            compareValue: "Not Equal"
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

        function onInternalCounterChanged(){
            counter = ReportParamsModel.internalCounter
            ReportParamsModel.setTmpFilterIndex(counter)
            excludeCheck.checked = ReportParamsModel.fetchIncludeExcludeMap(counter)[counter] === "1" ? true : false
        }

        function onFilterIndexChanged(){

            if(ReportParamsModel.getTmpFilterIndex(0, true).length === 0){
                counter = ReportParamsModel.filterIndex
                ReportParamsModel.setTmpFilterIndex(ReportParamsModel.filterIndex)
                ReportParamsModel.addToIncludeExcludeMap(ReportParamsModel.filterIndex, false)
            }

            if(ReportParamsModel.category === Constants.categoryMainWildCardType && ReportParamsModel.mode === Constants.modeEdit){
                var finalValue;
                var slug = ReportParamsModel.fetchFilterSlugMap(counter)[0]
                var jsonValue = ReportParamsModel.fetchFilterValueMap(counter)[counter]
                var relation = ReportParamsModel.fetchFilterRelationMap(counter)


                switch(slug){

                case acceptedValues[0]:
                    finalValue = jsonValue[0].slice(1,-1)
                    break

                case acceptedValues[1]:
                case acceptedValues[4]:
                    finalValue = jsonValue[0].slice(1)
                    break

                case acceptedValues[2]:
                case acceptedValues[5]:
                    finalValue = jsonValue[0]
                    break

                case acceptedValues[3]:
                    finalValue = jsonValue[0].slice(0, -1)
                    break
                }

                listviewWildCardModel.append({"value":0})

                wildcardContent.editRelation = relation[0]
                wildcardContent.editSlug = slug
                wildcardContent.editValue = finalValue
            }
        }
    }

    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    Component.onCompleted: {
        wildcardDropdown.currentText = "Containing"
        wildcardDropdown.currentValue = "Containing"

        listviewWildCard.model = numModels

    }


    function slotDataCleared(){
        totalWildCards = 1
        listviewWildCardModel.clear()
        ReportParamsModel.removeTmpFilterIndex(0, true)
    }


    function setValueDelegate(wildcardDropdown, valueText){

        if(ReportParamsModel.mode === Constants.modeEdit){

            var key = acceptedValues.indexOf(editSlug)
            valueText.text = wildcardContent.editValue
            wildcardDropdown.currentIndex = key
        }
    }



    function onExcludeCheckedClicked(checked){
        currenctExclude = checked

        var tmpFilters = ReportParamsModel.getTmpFilterIndex(0, true)

        for(var i = 0; i < tmpFilters.length; i++){
            var fi = tmpFilters[i]
            ReportParamsModel.addToIncludeExcludeMap(fi, currenctExclude)
        }
    }

    function onAddWildcard(){
        if(totalWildCards <= selectDropdown.count){

            // As already filterindex count has been increased on selecting `create` option
            // Hence, no need to increment for the first time
            if(totalWildCards > 1){
                ReportParamsModel.setFilterIndex(ReportParamsModel.filterIndex + 1)
            }

            ReportParamsModel.setTmpFilterIndex(ReportParamsModel.filterIndex)
            ReportParamsModel.addToIncludeExcludeMap(ReportParamsModel.filterIndex, currenctExclude)

            // Append a new ListElement on the ListView model
            listviewWildCardModel.append({"value":0})

            totalWildCards++
        }
    }

    function onWildCardInput(textValue, selectCurrentValue, selectCurrentText, selectCurrentIndex, listIndex){

        let newFilter = ""
        let newRelation = ""
        let slug = ""

        switch(selectCurrentValue){

        case acceptedValues[0]:

            newFilter = "%"+ textValue +"%"
            newRelation = Constants.likeRelation
            slug = wildcardContent.acceptedValues[selectCurrentIndex]

            break

        case acceptedValues[1]:

            newFilter = "%"+ textValue
            newRelation = Constants.likeRelation
            slug = wildcardContent.acceptedValues[selectCurrentIndex]

            break

        case acceptedValues[2]:

            newFilter = textValue
            newRelation = Constants.equalRelation
            slug = wildcardContent.acceptedValues[selectCurrentIndex]

            break

        case acceptedValues[3]:

            newFilter =  textValue + "%"
            newRelation = Constants.notLikeRelation
            slug = wildcardContent.acceptedValues[selectCurrentIndex]

            break

        case acceptedValues[4]:

            newFilter =  "%" + textValue
            newRelation = Constants.notLikeRelation
            slug = wildcardContent.acceptedValues[selectCurrentIndex]

            break

        case acceptedValues[5]:

            newFilter =  textValue
            newRelation = Constants.notEqualRelation
            slug = wildcardContent.acceptedValues[selectCurrentIndex]

            break
        }

        var currentSelectedIndex = ReportParamsModel.getTmpFilterIndex(listIndex)
        ReportParamsModel.addToFilterRelationMap(currentSelectedIndex[0], newRelation)
        ReportParamsModel.addToFilterValueMap(currentSelectedIndex[0], newFilter)
        ReportParamsModel.addToFilterSlugMap(currentSelectedIndex[0], slug)

    }


    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts

    height: parent.height - 80 - 40
    width: parent.width - 40
    x:20
    y:10
    anchors.top:  fullExtactRadioBtn.bottom

    color: Constants.whiteColor
    border.color: Constants.darkThemeColor
    visible: false

    Rectangle{
        id: wildcardHead
        anchors.top: parent.top
        anchors.topMargin: 5

        height: 40
        width: parent.width - 10

        anchors.horizontalCenter: parent.horizontalCenter


        Column{

            id: addWildcard
            anchors.top: wildcardHead.top

            padding: 12
            leftPadding: 30
            visible: ReportParamsModel.mode === Constants.modeCreate? true: false

            anchors.verticalCenter: parent.verticalAlignment

            CustomButton {
                textValue: Messages.mo_mini_cfwc_addWildcard

                onClicked: onAddWildcard();
            }

        }

    }



    ListView{
        id: listviewWildCard
        model: listviewWildCardModel
        anchors.top: wildcardHead.bottom
        anchors.topMargin: 20
        anchors.left: parent.left

        anchors.leftMargin: 30
        width: parent.width
        height: listviewWildCard.count * 40
        spacing: 5

        delegate: Row{
            width: parent.width
            height: 40

            Component.onCompleted: setValueDelegate(wildcardDropdown, valueText)

            Column{

                width: parent.width/2

                CustomComboBox{
                    id: wildcardDropdown
                    currentIndex: 0
                    model: selectDropdown
                    textRole: "menuItem"
                    width: parent.width*2/3
                    valueRole: "compareValue"
                    onCurrentValueChanged: onWildCardInput(valueText.text, wildcardDropdown.currentValue, wildcardDropdown.currentText, wildcardDropdown.currentIndex, index)
                }
            }

            Column{
                width: parent.width/2

                anchors{
                    top: parent.top
                }

                CustomTextBox{
                    id: valueText
                    placeholderText: Messages.mo_mini_cfwc_enterValue
                    boxWidth: parent.width * 2 / 3
                    boxHeight: 30

                    anchors{
                        right: parent.right
                        rightMargin: 50
                    }

                    onTextChanged: onWildCardInput(valueText.text, wildcardDropdown.currentValue, wildcardDropdown.currentText, wildcardDropdown.currentIndex, index)

                }
            }

        }

    }




    // Page Design Ends
    /***********************************************************************************************************************/

}
