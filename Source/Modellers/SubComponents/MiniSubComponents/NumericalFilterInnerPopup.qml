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

    property string selectOption: "Select numerical"

    height: parent.height - 80 - 40
    width: parent.width - 40
    x:20
    y:60
    color: Constants.whiteColor
    border.color: Constants.darkThemeColor

    readonly property string mapKey: "0"
    property var acceptedValues:["Equal", "Not Equal To", "Smaller Than", "Greater Than", "Equal or Smaller Than", "Equal or Greater Than", "Between"]



    /***********************************************************************************************************************/
    // LIST MODEL STARTS

    ListModel{
        id: listModel
        ListElement{
            menuItem:"Equal"
        }
        ListElement{
            menuItem:"Not Equal To"
        }
        ListElement{
            menuItem:"Smaller Than"
        }
        ListElement{
            menuItem:"Greater Than"
        }
        ListElement{
            menuItem:"Equal or Smaller Than"
        }
        ListElement{
            menuItem:"Equal or Greater Than"
        }
        ListElement{
            menuItem:"Between"
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

    function slotEditMode(){
        topContent.visible = true
    }

    function getNewRelation(tmpRelation){

        let newRelation = ""

        switch(tmpRelation){

        case acceptedValues[0]:
            newRelation = Constants.equalRelation
            break

        case acceptedValues[1]:
            newRelation = Constants.notEqualRelation
            break

        case acceptedValues[2]:
            newRelation = Constants.smallerThanRelation
            break

        case acceptedValues[3]:
            newRelation = Constants.greaterThanRelation
            break

        case acceptedValues[4]:
            newRelation = Constants.smallerThanEqualRelation
            break

        case acceptedValues[5]:
            newRelation = Constants.greaterThanEqualRelation
            break

        case acceptedValues[6]:

            newRelation = Constants.betweenRelation
            break
        }
        return newRelation
    }

    function onNumericalInput(value1, value2, tmpRelation){

        var newValue = value1
        if(tmpRelation === "Between"){
            newValue = value1 + " To " + value2
        }

        let relation = getNewRelation(tmpRelation)
        DSParamsModel.addToJoinValue(mapKey, newValue)
        DSParamsModel.addToJoinRelation(mapKey, relation)
        DSParamsModel.addToJoinRelationSlug(mapKey, tmpRelation)

    }

    function onExludeCheckStateChanged(checked){
        DSParamsModel.setExclude(checked)
    }


    function onIncludeCheckStateChanged(checked){
        DSParamsModel.setIncludeNull(checked)
    }


    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts



    Rectangle{
        id: numericalHeading

        height: 40
        width: parent.width

        color: "transparent"

        Column{

            id: addnumerical
            anchors.top: parent.top

            anchors.left: parent.left
            leftPadding: 20

            anchors.verticalCenter: parent.verticalAlignment

            CheckBox {
                checked: DSParamsModel.includeNull
                text: qsTr("Include Null")
                indicator.width: 15
                indicator.height: 15

                onCheckStateChanged: {
                    onIncludeCheckStateChanged(checked)
                }
            }


        }

        Column{
            id: singleSelectRadioColumn

            anchors.right: parent.right
            rightPadding: 20

            anchors.verticalCenter: parent.verticalAlignment

            CheckBox {
                checked: DSParamsModel.exclude
                text: qsTr("Exclude")
                indicator.width: 15
                indicator.height: 15

                onCheckStateChanged: {

                    onExludeCheckStateChanged(checked)
                }
            }


        }
    }

    Rectangle{
        id: conditionRow

        height: 30
        width: parent.width
        color: "transparent"

        anchors.top: numericalHeading.bottom
        anchors.topMargin: 5

        Text {
            id: name
            text: qsTr("Condition")
            leftPadding: 20
        }



    }

    Rectangle{
        anchors.top: conditionRow.bottom
        width: parent.width
        height: 30
        color: "transparent"

        Rectangle{
            id: numericalOptionRow
            anchors.left: parent.left
            width: parent.width / 3
            height: 30
            color: "transparent"


            SelectDropdown{
                id: selectOption
                textValue:"Equal"
                list: listModel
                height: listModel.count * 30
                anchors.left: parent.left
                anchors.leftMargin: 20
                onTextValueChanged: {
                    if(selectOption.textValue === "Between"){
                        numericalTextBox2nd.visible = true
                    }
                    else{
                        numericalTextBox2nd.visible = false
                    }
                }
            }

            Rectangle{
                id: numericalTextBox
                width : 200
                height : 30
                anchors {
                    left : selectOption.right
                    leftMargin: 100
                }

                TextField{
                    id : textField
                    height : parent.height
                    width : parent.width
                    placeholderText: "Enter Text"
                    onActiveFocusChanged: {
                        numericalTextBox.border.color = "blue"
                    }
                    onTextChanged: onNumericalInput(textField.text, textField2nd.text, selectOption.textValue)

                }

            }

            Rectangle{
                id: numericalTextBox2nd
                width : 200
                height : 30
                visible : false
                anchors {
                    left : numericalTextBox.right
                    leftMargin: 15
                }

                TextField{
                    id : textField2nd
                    height : parent.height
                    width : parent.width
                    placeholderText: "Enter Text"
                    onActiveFocusChanged: {
                        numericalTextBox.border.color = "blue"
                    }
                    onTextChanged: onNumericalInput(textField.text, textField2nd.text, selectOption.textValue)
                }
            }
        }
    }



    // Page Design Ends
    /***********************************************************************************************************************/

}

