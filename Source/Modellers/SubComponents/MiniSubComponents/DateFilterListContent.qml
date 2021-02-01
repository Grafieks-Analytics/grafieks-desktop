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
    anchors.top:  fullExtactRadioBtn.bottom
    color: Constants.whiteColor
    border.color: Constants.darkThemeColor

    property var checkedValues : []
    readonly property string mapKey: "0"
    /***********************************************************************************************************************/
    // LIST MODEL STARTS



    ListModel{
        id: dateFormatList

        ListElement{
            menuItem:"Select"

        }
        ListElement{
            menuItem:"DD/MM/YYYY"
        }

        ListElement{
            menuItem:"DD MMMM YYYY"
        }

        ListElement{
            menuItem:"D MMMM YYYY"
        }

        ListElement{
            menuItem:"dddd, D MMMM YYYY"
        }

        ListElement{
            menuItem:"dddd, DD MMMM YYYY"
        }

        ListElement{
            menuItem:"DD/MM/YY"
        }

        ListElement{
            menuItem:"D/M/YY"
        }

        ListElement{
            menuItem:"D.M.YY"
        }

        ListElement{
            menuItem:"YYYY-MM-DD"
        }
        ListElement{
            menuItem:"MMMM YYYY"
        }
        ListElement{
            menuItem:"D MMMM"
        }
        ListElement{
            menuItem : "YY"
        }

        ListElement{
            menuItem:"YYYY"
        }

        ListElement{
            menuItem:"DD/MM/YYYY hh:mm:ss"
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
        target: DSParamsModel

        function onResetInput(){
            customBox.currentIndex = 0
            DSParamsModel.setExclude(false)
            DSParamsModel.setIncludeNull(true)
        }
    }

    Connections{
        target: CsvColumnListModel

        function onCsvColData(colData){
            singleSelectCheckList.model = colData
            multiSelectCheckList.model  = colData
        }
    }


    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS
    function slotEditModeSubCategory(subCategory){

        if(subCategory === Constants.categorySubMulti){
            multiSelectRadio.checked = true

            multiSelectCheckList.visible = true
            singleSelectCheckList.visible = false

        } else{
            singleSelectRadio.checked = true

            multiSelectCheckList.visible = false
            singleSelectCheckList.visible = true
        }
    }
    function onMultiSelectSelected(){
        multiSelectCheckList.visible = true
        singleSelectCheckList.visible = false

        // Set the sub category for filter
        DSParamsModel.setSubCategory(Constants.categorySubMulti)
    }


    function onSingleSelectSelected(){

        multiSelectCheckList.visible = false
        singleSelectCheckList.visible = true

        // Set the sub category for filter
        DSParamsModel.setSubCategory(Constants.categorySubSingle)
    }


    function onSingleSelectRadioSelected(modelData, format){

        DSParamsModel.setValueFormat(modelData.toString(), format)
        DSParamsModel.addToJoinValue(mapKey, modelData.toString())
        DSParamsModel.addToJoinRelation(mapKey, Constants.likeRelation)
        DSParamsModel.addToJoinRelationSlug(mapKey, Constants.likeRelation)
    }


    function onTextChangedSearch(){
        ColumnListModel.likeColumnQuery(DSParamsModel.colName, DSParamsModel.tableName, searchText.text)
    }

    function onAllCheckBoxCheckedChanged(checked){
        // If Select All option is true
        if(checked === true){

            if(DSParamsModel.mode === Constants.modeCreate){

                DSParamsModel.addToJoinValue(mapKey, "%")

            } else{
                DSParamsModel.addToJoinValue(mapKey, checkedValues.toString())
            }

            DSParamsModel.addToJoinRelation(mapKey, Constants.likeRelation)
            DSParamsModel.addToJoinRelationSlug(mapKey, Constants.likeRelation)
            checkedValues = []

        }
    }

    function onMultiSelectCheckboxSelected(modelData,checked, format){

        if(mainCheckBox.checked === true){

            if(checked === false){

                // Set SELECT ALL to false
                DSParamsModel.setSelectAll(false)
                mainCheckBox.checked = false

            }
        } else{
            if(checked === true){

                // Start pushing the individual checked item in the array
                checkedValues.push(modelData)

            } else{
                // Remove item if unchecked
                const index = checkedValues.indexOf(modelData);
                if (index > -1) {
                    checkedValues.splice(index, 1);
                }
            }

            // Save the array and Set relation type to LIKE

            for(let i = 0; i < checkedValues.length; i++)
            {
                   DSParamsModel.setValueFormat(checkedValues[i].toString(), format)
            }

            DSParamsModel.addToJoinValue(mapKey, checkedValues.toString())
            DSParamsModel.addToJoinRelation(mapKey, Constants.likeRelation)
            DSParamsModel.addToJoinRelationSlug(mapKey, Constants.likeRelation)
        }

    }



    function onIncludeCheckedClicked(checked){
        DSParamsModel.setIncludeNull(checked)
    }


    function onExcludeCheckedClicked(checked){
        DSParamsModel.setExclude(checked)
    }

    function getFormattedDate(modelData, value)
    {
        // Check for Selected Format
        var formattedDate;
        switch(value)
        {
            case 1:
                formattedDate = Qt.formatDateTime(modelData,'dd/MM/yyyy')
                break;
            case 2:
                formattedDate = Qt.formatDateTime(modelData,'dd MMMM yyyy')
                break;
            case 3:
                formattedDate = Qt.formatDateTime(modelData,'d MMMM yyyy')
                break;
            case 4:
                formattedDate = Qt.formatDateTime(modelData,'dddd, d MMMM yyyy')
                break;
            case 5:
                formattedDate = Qt.formatDateTime(modelData,'dddd, dd MMMM yyyy')
                break;
            case 6:
                formattedDate = Qt.formatDateTime(modelData,'dd/MM/yy')
                break;
            case 7:
                formattedDate = Qt.formatDateTime(modelData,'d/M/yy')
                break;
            case 8:
                formattedDate = Qt.formatDateTime(modelData,'d.M.yy')
                break;
            case 9:
                formattedDate = Qt.formatDateTime(modelData,'yyyy-MM-dd')
                break;
            case 10:
                formattedDate = Qt.formatDateTime(modelData,'MMMM yyyy')
                break;
            case 11:
                formattedDate = Qt.formatDateTime(modelData,'d MMMM')
                break;
            case 12:
                formattedDate = Qt.formatDateTime(modelData,'yy')
                break;
            case 13:
                formattedDate = Qt.formatDateTime(modelData,'yyyy')
                break;
            case 14:
                formattedDate = Qt.formatDateTime(modelData,'dd/MM/yyyy hh:mm:ss')
                break;
            default:
                formattedDate = modelData

        }

        return formattedDate

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
            anchors.top: selectTypeRadioBtn.top

            padding: 10
            leftPadding: 30

            CustomRadioButton{
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

            CustomRadioButton{
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
                height: 35
                anchors.top: parent.top
                width: parent.width - 20
                x: 10

                background: Rectangle{
                    border.color: Constants.borderBlueColor
                    radius: 4
                }
                onTextChanged: {
                    onTextChangedSearch()
                }
            }
        }

    }

    // Main Content Component

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


        // Checklist Button ListView
        // List Filters starts

        ButtonGroup {
            id: childGroup
            exclusive: false
            checkState: mainCheckBox.checkState
        }

        CheckBoxTpl {
            id: mainCheckBox
            checked: DSParamsModel.selectAll
            text: "All"
            parent_dimension: Constants.defaultCheckBoxDimension
            checkState: childGroup.checkState

            onCheckedChanged: {
                onAllCheckBoxCheckedChanged(checked)
            }
        }
        ListView {
            id: multiSelectCheckList
            model: ColumnListModel
          height: parent.height-38
            width: parent.width

             anchors.top: mainCheckBox.bottom
            flickableDirection: Flickable.VerticalFlick
                       boundsBehavior: Flickable.StopAtBounds
                       clip: true
                       ScrollBar.vertical: CustomScrollBar {}


            delegate: Row{
                height:20
                CheckBoxTpl {
                    id: modelCheckBoxes
                    checked: true
                    y:2
                    text  : modelData
                    parent_dimension: Constants.defaultCheckBoxDimension
                    ButtonGroup.group: childGroup

                    onCheckedChanged: {
                        onMultiSelectCheckboxSelected(modelData,checked, customBox.currentText)
                    }
                }
            }
        }


        // Checklist Button ListView
        // List Filters ends


        // Radio button ListView
        // List Filters starts

        ListView{

            id: singleSelectCheckList
            model: ColumnListModel


            visible: false
            spacing: 2
            height: parent.height-38
              width: parent.width

               anchors.top: mainCheckBox.bottom
              flickableDirection: Flickable.VerticalFlick
                         boundsBehavior: Flickable.StopAtBounds
                         clip: true
                         ScrollBar.vertical: CustomScrollBar {}

            delegate: Row{

                height: 20
                width: singleSelectCheckList.width

                Column{

                    CustomRadioButton {
                        text : modelData
                        ButtonGroup.group: singleSelectRadioGroup
                        height: Constants.defaultRadioDimension
                        width: Constants.defaultRadioDimension
                        parent_dimension: Constants.defaultRadioDimension
                        onCheckedChanged: {
                            onSingleSelectRadioSelected(modelData, customBox.currentText)
                        }
                    }
                }

            }
        }

        // Radio button ListView
        // List Filters ends

        Column{
            width: parent.width/2
            height: parent.height

            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.right: parent.right
            spacing: 5

            CustomComboBox{
                id : customBox
                currentIndex: 0
                model: dateFormatList
                textRole: "menuItem"
                valueRole: "compareValue"
                onActivated: {
                    ColumnListModel.columnDateFormatQuery(DSParamsModel.colName, DSParamsModel.tableName, currentIndex)
                }

                anchors{
                    right: parent.right
                    rightMargin: 10
                }
            }

        }
    }

    // Main Content Component ends

    Rectangle{
        id: includeExcludeRow
        anchors.top:  listInnerContent.bottom
        anchors.topMargin: 7
        anchors.left: parent.left
        height: 30
        width: parent.width - 25
        anchors.leftMargin: 10


        Column{
            anchors.left: includeExcludeRow.left

            CheckBoxTpl {
                checked: DSParamsModel.includeNull
                text: qsTr("Include Null")

                  parent_dimension: Constants.defaultCheckBoxDimension

                onCheckStateChanged: {
                    onIncludeCheckedClicked(checked)
                }



            }
        }

        Column{
            anchors.right: includeExcludeRow.right
            anchors.rightMargin: 5

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




    // Page Design Ends
    /***********************************************************************************************************************/

}
