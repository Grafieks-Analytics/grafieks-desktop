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

import "../../../MainSubComponents"


Rectangle{
    id: wildcardContent
    property bool listOpened: false
    property string selectOption: "Select Wildcard"
    property var acceptedValues:["containing", "endswith", "equalto", "doesntstartwith", "doesntendwith", "notequalto"]

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
            compareValue: "containing"
        }
        ListElement{
            menuItem:"Ends With"
            compareValue: "endswith"
        }
        ListElement{
            menuItem:"Equal To"
            compareValue: "equalto"
        }
        ListElement{
            menuItem:"Doesn't Start with"
            compareValue: "doesntstartwith"
        }
        ListElement{
            menuItem:"Doesn't End with"
            compareValue: "doesntendwith"
        }
        ListElement{
            menuItem:"Not Equal to"
            compareValue: "notequalto"
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
            excludeCheck.checked = ReportParamsModel.getExcludeMap(counter)[counter] === "1" ? true : false
        }

        function onFilterIndexChanged(){

            if(ReportParamsModel.getTmpFilterIndex(0, true).length === 0){
                counter = ReportParamsModel.filterIndex
                ReportParamsModel.setTmpFilterIndex(ReportParamsModel.filterIndex)
                ReportParamsModel.setExcludeMap(ReportParamsModel.filterIndex, false)
            }
        }
    }

    Connections{
        target: QueryDataModel

        function onColumnListModelDataChanged(colData, options){

            if(ReportParamsModel.category === Constants.categoryMainWildCardType){
                var finalValue;
                var jsonOptions = JSON.parse(options)

                switch(jsonOptions.slug){

                case acceptedValues[0]:
                    finalValue = jsonOptions.values.slice(1,-1)
                    break

                case acceptedValues[1]:
                case acceptedValues[4]:
                    finalValue = jsonOptions.values.slice(1)
                    break

                case acceptedValues[2]:
                case acceptedValues[5]:
                    finalValue = jsonOptions.values
                    break

                case acceptedValues[3]:
                    finalValue = jsonOptions.values.slice(0, -1)
                    break
                }

                listviewWildCardModel.append({"value":0})

                wildcardContent.editRelation = jsonOptions.relation
                wildcardContent.editSlug = jsonOptions.slug
                wildcardContent.editValue = finalValue
                console.log("WILD", finalValue, JSON.stringify(jsonOptions))
            }
        }
    }

    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    Component.onCompleted: {
        wildcardDropdown.currentText = "Containing"
        wildcardDropdown.currentValue = "containing"

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
            ReportParamsModel.setExcludeMap(fi, currenctExclude)
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
            ReportParamsModel.setExcludeMap(ReportParamsModel.filterIndex, currenctExclude)

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
        ReportParamsModel.addToJoinRelation(currentSelectedIndex, newRelation)
        ReportParamsModel.addToJoinValue(currentSelectedIndex, newFilter)
        ReportParamsModel.addToJoinRelationSlug(currentSelectedIndex, slug)

        console.log("FILTER VALUES1a", currentSelectedIndex, ReportParamsModel.fetchJoinRelation(currentSelectedIndex)[currentSelectedIndex], ReportParamsModel.fetchJoinValue(currentSelectedIndex)[currentSelectedIndex], ReportParamsModel.fetchJoinRelationSlug(currentSelectedIndex)[currentSelectedIndex])

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
                textValue: qsTr("Add Wildcard")

                onClicked: onAddWildcard();
            }

        }

        Column{
            id: singleSelectRadioColumn

            anchors.right: parent.right
            rightPadding: 30

            CheckBoxTpl {

                id: excludeCheck
                text: qsTr("Exclude")
                parent_dimension: Constants.defaultCheckBoxDimension

                onCheckStateChanged: onExcludeCheckedClicked(checked)
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
                    placeholderText: "Enter Text"
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
