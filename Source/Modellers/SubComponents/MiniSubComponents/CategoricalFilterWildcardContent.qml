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
    property var numModels: []
    property int counter: 0

    property string selectOption: "Select Wildcard"


    /***********************************************************************************************************************/
    // LIST MODEL STARTS



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

    function onAddWidcard(){
        if(counter < selectDropdown.count){
            counter++;
            console.log(counter, numModels)
            numModels.push(counter)
            console.log(numModels)
            listviewWildCard.model = numModels
        }


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
                    onAddWidcard();
                }
            }

        }

        Column{
            id: singleSelectRadioColumn

            anchors.right: parent.right
            rightPadding: 30

            CheckBox {

                checked: DSParamsModel.exclude
                text: qsTr("Exclude")
                indicator.width: 15
                indicator.height: 15

                onCheckStateChanged: {
                    onExcludeCheckedClicked(checked)
                }
            }


        }
    }



    ListView{
        id: listviewWildCard
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

                //                SelectDropdown{
                //                    id: wildcardDropdown
                //                    width: parent.width*2/3
                //                    textValue:"Containing"
                //                    list: selectDropdown
                //                }

                ComboBox{
                    id: wildcardDropdown
                    currentIndex: 0
                    model: selectDropdown
                    textRole: "menuItem"
                    valueRole: "compareValue"
                    onCurrentIndexChanged: {
                        console.log(valueText.text, wildcardDropdown.currentValue, wildcardDropdown.currentText)
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
                        console.log(valueText.text, wildcardDropdown.currentValue, wildcardDropdown.currentText)
                    }


                }
            }

        }

    }




    // Page Design Ends
    /***********************************************************************************************************************/

}
