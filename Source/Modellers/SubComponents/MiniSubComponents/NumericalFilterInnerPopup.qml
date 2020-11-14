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

    function onNumericalInput(value, tmpRelation){

        let relation = getNewRelation(tmpRelation)
        DSParamsModel.addToJoinValue(mapKey, value)
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
            }


            CustomTextBox{
                id: textField
                placeholderText: "Enter Text"
                boxWidth: 200
                boxHeight: 30
                //width : 100

                anchors{
                    left: selectOption.right
                    leftMargin: 100
                }
                onTextChanged: onNumericalInput(textField.text, selectOption.textValue)
            }


        }

        /********* DO NOT DELETE **************************

        Rectangle{
            id: numericalTextRow
            anchors.top: parent.top
            anchors.right: parent.right

            width: parent.width / 3
            height: 30
            anchors.rightMargin: 20


            color: "transparent"

            Rectangle{
                id: numericalTextBox
                height: 30
                width: parent.width
                anchors.left: parent.left
                anchors.rightMargin: 20

                Rectangle{
                    height: parent.height
                    width: parent.width
                    color: "transparent"

                    TextField {
                        id : textField
                        placeholderText: "Enter Text"
                        anchors.centerIn: parent
                        width: parent.width - 10
                        height: 30
                        onTextChanged: onNumericalInput(textField.text, selectOption.textValue)
                    }
                }

            }

            Rectangle{
                id: numericalTextBoxes
                height: 30
                width: parent.width
                anchors.left: parent.left
                anchors.rightMargin: 20
                visible: false

                Rectangle{
                    height: parent.height
                    width: parent.width/2
                    anchors.left: parent.left
                    color: "transparent"

                    TextField {
                        placeholderText: "Enter Text"
                        anchors.centerIn: parent
                        width: parent.width - 10
                        height: 30
                    }
                }


                Rectangle{
                    height: parent.height
                    width: parent.width/2
                    anchors.right: parent.right

                    color: "transparent"

                    TextField {
                        placeholderText: "Enter Text"
                        anchors.centerIn: parent
                        width: parent.width - 10
                        height: 30
                    }
                }

            }



        }
        ****************************************************/

    }



    // Page Design Ends
    /***********************************************************************************************************************/

}

