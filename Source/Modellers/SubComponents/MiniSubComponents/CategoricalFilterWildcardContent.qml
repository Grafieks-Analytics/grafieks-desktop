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
    property bool listOpened: false
    property int counter: 0

    property string selectOption: "Select Wildcard"
    property var acceptedValues:["containing", "endswith", "equalto", "doesntstartwith", "doesntendwith", "notequalto"]


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



    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    Component.onCompleted: {
        wildcardDropdown.currentText = "Containing"
        wildcardDropdown.currentValue = "containing"

        listviewWildCard.model = numModels

    }

    function onExcludeCheckedClicked(checked){
        DSParamsModel.setExclude(checked)
    }

    function onAddWildcard(){
        if(counter < selectDropdown.count){
            counter++;

            // Append a new ListElement on the ListView model
            listviewWildCardModel.append({"value":0})
        }
    }

    function onWildCardInput(textValue, selectCurrentValue, selectCurrentText, selectCurrentIndex, listIndex){

        let newFilter = ""
        let newRelation = ""
        let existingValues = DSParamsModel.value.split(",")
        let existingRelations = DSParamsModel.relation.split(",")

        // Set maximum length of the array
        existingValues.length = existingValues.length > selectDropdown.count ? selectDropdown.count : existingValues.length;
        existingRelations.length = existingRelations.length > selectDropdown.count ? selectDropdown.count : existingRelations.length;

        switch(selectCurrentValue){

        case acceptedValues[0]:

            newFilter = "%"+ textValue +"%"
            newRelation = Constants.likeRelation

            break

        case acceptedValues[1]:

            newFilter = "%"+ textValue
            newRelation = Constants.likeRelation

            break

        case acceptedValues[2]:

            newFilter = textValue
            newRelation = Constants.equalRelation

            break

        case acceptedValues[3]:

            newFilter = "%" + textValue
            newRelation = Constants.notLikeRelation

            break

        case acceptedValues[4]:

            newFilter =  textValue + "%"
            newRelation = Constants.notLikeRelation

            break

        case acceptedValues[5]:

            newFilter =  textValue
            newRelation = Constants.notEqualRelation

            break


        }

        existingValues[listIndex] = newFilter
        existingRelations[listIndex] = newRelation

        DSParamsModel.setRelation(existingRelations.toString())
        DSParamsModel.setValue(existingValues.toString())

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

            anchors.verticalCenter: parent.verticalAlignment

            CustomButton {
                textValue: qsTr("Add Wildcard")

                onClicked: {
                    onAddWildcard();
                }
            }

        }

        Column{
            id: singleSelectRadioColumn

            anchors.right: parent.right
            rightPadding: 30

            CheckBoxTpl {

                checked: DSParamsModel.exclude
                text: qsTr("Exclude")
                parent_dimension: Constants.defaultCheckBoxDimension

                onCheckStateChanged: {
                    onExcludeCheckedClicked(checked)
                }
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

            Column{

                width: parent.width/2

                CustomComboBox{
                    id: wildcardDropdown
                    currentIndex: 0
                    model: selectDropdown
                    textRole: "menuItem"
                    width: parent.width*2/3
                    valueRole: "compareValue"
                    onCurrentIndexChanged: {
                        selectDropdown.setProperty(index ,"value", currentIndex)
                        onWildCardInput(valueText.text, wildcardDropdown.currentValue, wildcardDropdown.currentText, wildcardDropdown.currentIndex, index)
                    }
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

                    onTextChanged: {
                        onWildCardInput(valueText.text, wildcardDropdown.currentValue, wildcardDropdown.currentText, wildcardDropdown.currentIndex, index)
                    }

                }
            }

        }

    }




    // Page Design Ends
    /***********************************************************************************************************************/

}
