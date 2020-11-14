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

    readonly property string mapKey: "0"



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

    function onLastXChecked(){

        var value = lastXRadioTextField.text
        DSParamsModel.setSubCategory("Year")
        DSParamsModel.addToJoinValue(mapKey, value)
        DSParamsModel.addToJoinRelation(mapKey, Constants.likeRelation)
        DSParamsModel.addToJoinRelationSlug(mapKey, Constants.likeRelation)

        nextXRadioTextField.focus = false
        lastXRadioTextField.focus = true
    }
    function onNextXChecked(){

        var value = nextXRadioTextField.text
        DSParamsModel.setSubCategory("Year")
        DSParamsModel.addToJoinValue(mapKey, value)
        DSParamsModel.addToJoinRelation(mapKey, Constants.likeRelation)
        DSParamsModel.addToJoinRelationSlug(mapKey, Constants.likeRelation)

        nextXRadioTextField.focus = true
        lastXRadioTextField.focus = false
    }

    function onThisChecked(){

        var tmpDate = new Date()
        var thisYear = tmpDate.getFullYear()
        DSParamsModel.setSubCategory("Year")
        DSParamsModel.addToJoinValue(mapKey, thisYear.toString())
        DSParamsModel.addToJoinRelation(mapKey, Constants.likeRelation)
        DSParamsModel.addToJoinRelationSlug(mapKey, Constants.likeRelation)

        nextXRadioTextField.focus = false
        lastXRadioTextField.focus = false
    }

    function onLastChecked(){

        var tmpDate = new Date()
        var lastYear = tmpDate.getFullYear() - 1
        DSParamsModel.setSubCategory("Year")
        DSParamsModel.addToJoinValue(mapKey, lastYear.toString())
        DSParamsModel.addToJoinRelation(mapKey, Constants.likeRelation)
        DSParamsModel.addToJoinRelationSlug(mapKey, Constants.likeRelation)

        nextXRadioTextField.focus = false
        lastXRadioTextField.focus = false
    }

    function onNextChecked(){

        var tmpDate = new Date()
        var nextYear = tmpDate.getFullYear() + 1
        DSParamsModel.setSubCategory("Year")
        DSParamsModel.addToJoinValue(mapKey, nextYear.toString())
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
