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
    property bool listOpened: false

    property string selectOption: "Select top"
    property string calculatedFieldType : "number"

    id: topHead

    height: parent.height - 80 - 40
    width: parent.width - 40
    x:20
    y:30
    anchors.top:  fullExtactRadioBtn.bottom
    color: Constants.whiteColor
    border.color: Constants.darkThemeColor

    visible: false


    /***********************************************************************************************************************/
    // LIST MODEL STARTS


    ListModel{
        id: listModel
        ListElement{
            menuItem:"Top"
        }
        ListElement{
            menuItem:"Bottom"
        }
    }

    ListModel{
        id: fieldsModel
        ListElement{
            fieldName:"Order unit"
            fieldType: "number"
        }
        ListElement{
            fieldName:"Profit"
            fieldType: "string"
        }
        ListElement{
            fieldName:"Sales value"
            fieldType: "number"
        }
    }

    ListModel{
        id: calculations

        ListElement{
            calculationName:"Count"
            calculationType: "string"
            calculationCompareValue : "count"
        }
        ListElement{
            calculationName:"Count (Distinct)"
            calculationType: "string"
            calculationCompareValue : "countdistinct"
        }
        ListElement{
            calculationName:"Minimum"
            calculationType: "string"
            calculationCompareValue : "minimum"
        }
        ListElement{
            calculationName:"Maximum"
            calculationType: "string"
            calculationCompareValue : "maximum"
        }
        ListElement{
            calculationName:"Sum"
            calculationType: "number"
            calculationCompareValue : "sum"
        }
        ListElement{
            calculationName:"Average"
            calculationType: "number"
            calculationCompareValue : "average"
        }
        ListElement{
            calculationName:"Median"
            calculationType: "number"
            calculationCompareValue : "median"
        }
        ListElement{
            calculationName:"Count"
            calculationType: "number"
            calculationCompareValue : "count"
        }
        ListElement{
            calculationName:"Count (Distinct)"
            calculationType: "number"
            calculationCompareValue : "countdistinct"
        }
        ListElement{
            calculationName:"Minimum"
            calculationType: "number"
            calculationCompareValue : "minimum"
        }
        ListElement{
            calculationName:"Maximum"
            calculationType: "number"
            calculationCompareValue : "maximum"
        }
        ListElement{
            calculationName:"Percentile"
            calculationType: "number"
            calculationCompareValue : "percentile"
        }
        ListElement{
            calculationName:"Std. Dev"
            calculationType: "number"
            calculationCompareValue : "stddev"
        }
        ListElement{
            calculationName:"Std. Dev (Pop.)"
            calculationType: "number"
            calculationCompareValue : "stddevpop"
        }
        ListElement{
            calculationName:"Variance"
            calculationType: "number"
            calculationCompareValue : "variance"
        }
        ListElement{
            calculationName:"Variance (Pop.)"
            calculationType: "number"
            calculationCompareValue : "variancepop"
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


    // SLOT function
    function slotEditModeSubCategory(subCategory){

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
        id: topOptionRow
        anchors.top: topHead.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20

        width: parent.width / 3
        height: 30

        color:"transparent"

        //        SelectDropdown{
        //            id: selectOption
        //            textValue:"Top"
        //            list: listModel
        //        }

        CustomComboBox{
            id: topType
            model: listModel
            textRole: "menuItem"
            onCurrentIndexChanged: {
                //                selectDropdown.setProperty(index ,"value", currentIndex)
//                console.log("TOP-BOTTOM", topType.currentValue, topType.currentIndex, topType.currentText )
                //                ReportParamsModel.setSubCategory()
            }
        }

    }

    Rectangle{
        id: topOption2Row
        anchors.top: topHead.top
        anchors.right: topHead.right
        anchors.topMargin: 20

        width: parent.width / 3
        height: 30
        anchors.rightMargin: 20


        color:"transparent"

        Rectangle{
            id: topTextBox
            height: 30
            width: parent.width


            anchors.rightMargin: 20

            Column{
                height: parent.height
                width: parent.width
                rightPadding: 20

                CustomTextBox {
                    placeholderText: Messages.mo_mini_cfwc_enterValue
                    boxWidth: parent.width
                    boxHeight:  30
                }
            }

        }

    }

    //    By Select Box Start

    Rectangle{
        id: topByTextField
        anchors.top: topOptionRow.bottom
        anchors.left: topOptionRow.left
        anchors.topMargin: 50

        width: parent.width / 3
        height: 30

        color:"transparent"

        Rectangle{
            id: topByTextBox
            height: 30
            width: parent.width
            anchors.right: parent.right
            anchors.rightMargin: 20
            color: "transparent"

            Rectangle{
                height: parent.height
                width: parent.width
                color: "transparent"
                anchors.left: parent.left
                anchors.leftMargin: 20

                Text {
                    id: topByText
                    text: Messages.filterBy
                    y:6

                }

                //                SelectDropdown{
                //                    id: bySelectDropdown
                //                    textValue:""
                //                    list: bySelectModel
                //                }

                CustomComboBox{
                    id: fields
                    model: fieldsModel
                    textRole: "fieldName"
                    valueRole: "fieldType"
                    anchors.left: topByText.right
                    anchors.leftMargin: 10
                    onCurrentIndexChanged: {
//                        console.log("FIELDS", fields.currentValue, fields.currentIndex, fields.currentText)

                        if(fields.currentValue === "number"){
                            calculatedFieldType = "number"
                        } else{
                            calculatedFieldType = "string"
                        }

//                        console.log(calculatedFieldType)
                    }
                }



            }

        }

    }


    //    By Select Box Ends


    //    By Calculated Field Starts
    CustomComboBox{
        id: calculatedFields
        anchors.left: topOption2Row.left
        anchors.verticalCenter: topByTextField.verticalCenter
        model: calculations
        textRole: "calculationName"
        valueRole: "calculationCompareValue"
        onCurrentIndexChanged: {
//            console.log("CALCULATIONS", currentValue, currentIndex, currentText, topType.currentText)

        }
        delegate: ItemDelegate {
            width: calculatedFields.width
            text: calculationName
            font.weight: calculatedFields.currentIndex === index ? Font.DemiBold : Font.Normal
            highlighted: ListView.isCurrentItem
            height: calculatedFieldType === calculationType ? calculatedFields.height : 0
        }
    }

    //    By Calculated Field Ends


    // Page Design Ends
    /***********************************************************************************************************************/

}
