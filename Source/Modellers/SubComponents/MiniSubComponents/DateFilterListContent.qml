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
    id: listContent
    height: parent.height - 80 - 40
    width: parent.width - 40
    x:20
    y:10
//    anchors.top:  fullExtactRadioBtn.bottom
    color: Constants.whiteColor
    border.color: Constants.darkThemeColor


    /***********************************************************************************************************************/
    // LIST MODEL STARTS



    ListModel{
        id: dateFormatList

        ListElement{
            menuItem:"DD/MM/YYYY 1"
        }

        ListElement{
            menuItem:"DD/MM/YYYY 2"
        }

        ListElement{
            menuItem:"DD/MM/YYYY 3"
        }

        ListElement{
            menuItem:"DD/MM/YYYY 4"
        }
    }

    ListModel{
        id: dateCheckListModel

        ListElement{
            textValue:"All"
        }

        ListElement{
            textValue:"6 Jan 2019"
        }
        ListElement{
            textValue:"12 Jan 2019"
        }
        ListElement{
            textValue:"30 Jan 2019"
        }
        ListElement{
            textValue:"6 Jan 2019"
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


    function onMultiSelectSelected(){
        multiSelectCheckList.visible = true
        singleSelectCheckList.visible = false

    }


    function onSingleSelectSelected(){

        multiSelectCheckList.visible = false
        singleSelectCheckList.visible = true
   }


    function onIncludeCheckedClicked(checked){
        DSParamsModel.setIncludeNull(checked)
    }


    function onExcludeCheckedClicked(checked){
        DSParamsModel.setExclude(checked)
    }

    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts

    ButtonGroup{
        id: selectTypeRadioGroup
    }

    ButtonGroup{
        id:singleSelectRadioGroup
    }

    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts


    Rectangle{
        id: selectTypeRadioBtn
        height: 40
        width: parent.width - 4
        anchors.left: parent.left
        anchors.leftMargin: 2

        Column{

            id: multiSelectRadioColumn
//            anchors.top: selectTypeRadioBtn.top

            padding: 10
            leftPadding: 30

            RadioButtonTpl{
                id: multiSelectRadio
                radio_text: qsTr("Multi Select")
                radio_checked: true
                parent_dimension: 16
                ButtonGroup.group: selectTypeRadioGroup
                onCheckedChanged: {
                    onMultiSelectSelected()
                }
            }

        }

        Column{
            id: singleSelectRadioColumn

            padding: 10
            anchors.right: selectTypeRadioBtn.right
            rightPadding: 30

            RadioButtonTpl{
                id: singleSelectRadio
                radio_text: qsTr("Single Select")
                radio_checked: false
                parent_dimension: 16
                ButtonGroup.group: selectTypeRadioGroup
                onCheckedChanged: {
                    onSingleSelectSelected()
                }
            }
        }
    }

    Rectangle{
        id: searchTextBox
        anchors.top: selectTypeRadioBtn.bottom
        anchors.topMargin: 8
        width: parent.width - 4
        height: 40
        anchors.left: parent.left
        anchors.leftMargin: 2

        Rectangle{

            height: 30
            radius: 4
            width: parent.width - 10
            anchors.left: searchTextBox.left
            anchors.leftMargin: 4

            TextField{
                placeholderText: "Search"
                leftPadding: 20
                height: 40
                anchors.top: parent.top
                width: parent.width - 20
                x: 10

                background: Rectangle{
                    border.color: Constants.borderBlueColor
                    radius: 4
                }
            }
        }

    }


    Rectangle{
        id: listInnerContent
        height: listContent.height - ( selectTypeRadioBtn.height  + searchTextBox.height + includeExcludeRow.height + footerContent.height)
        width: parent.width - 35
        anchors.top: searchTextBox.bottom
        anchors.left: searchTextBox.left
        anchors.leftMargin: 15
        anchors.topMargin: 8

        color: Constants.themeColor
        border.color: Constants.darkThemeColor



        Column{
            width: parent.width/2
            height: parent.height


        ListView{

            id: multiSelectCheckList
            model: dateCheckListModel
            height: parent.height
            width: parent.width

            delegate: Row{

                height: 20
                width: parent.width

                Column{
                    CheckBox {
                        checked: true
                        text: qsTr(textValue)
                        indicator.width: 15
                        indicator.height: 15

                    }
                }

            }
        }


        ListView{

            id: singleSelectCheckList
            model: dateCheckListModel
            height: parent.height
            width: parent.width
            visible: false

            delegate: Row{

                height: 20
                width: parent.width

                Column{
                    RadioButtonTpl {

                        radio_text: qsTr(textValue)
                        parent_dimension: 16
                        ButtonGroup.group: singleSelectRadioGroup
                    }
                }

            }
        }


        }

        Column{
            width: parent.width/2
            height: parent.height

            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.right: parent.right
            spacing: 5

            CustomComboBox{
                currentIndex: 0
                model: dateFormatList
                textRole: "menuItem"
                valueRole: "compareValue"
                anchors{
                    right: parent.right
                    rightMargin: 10
                }
            }

        }

    }

    Rectangle{
        id: includeExcludeRow
        anchors.top:  listInnerContent.bottom
        anchors.left: parent.left
        height: 30
        width: parent.width - 25
        anchors.leftMargin: 10

        Column{
            anchors.left: includeExcludeRow.left

            CheckBox {
                checked: DSParamsModel.includeNull
                text: qsTr("Include Null")
                indicator.width: 15
                indicator.height: 15

                onCheckStateChanged: {
                    onIncludeCheckedClicked(checked)
                }

            }
        }

        Column{
            anchors.right: includeExcludeRow.right
            anchors.rightMargin: 30
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




    // Page Design Ends
    /***********************************************************************************************************************/

}
