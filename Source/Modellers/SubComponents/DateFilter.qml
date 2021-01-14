import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents"
import "../SubComponents/MiniSubComponents"

Popup {
    id: dateFilterPopup
    width: parent.width
    height: parent.height
    x: 0
    y: 0
    modal: true
    visible: false
    padding: 0
    closePolicy: Popup.NoAutoClose


    /***********************************************************************************************************************/
    // LIST MODEL STARTS



    ListModel{
        id: checkListModel

        ListElement{
            textValue:"All"
        }

        ListElement{
            textValue:"All 1"
        }

        ListElement{
            textValue:"All 2"
        }

        ListElement{
            textValue:"All 3"
        }
    }



    // LIST MODEL ENDS
    /***********************************************************************************************************************/


    /***********************************************************************************************************************/
    // SIGNALS STARTS

    signal subCategoryEditMode(string subCategory)
    signal signalCalendarEditData(string relation, string slug, string value)
    signal signalTimeFrameEditData(string subCategory, string relation, string value, string value)

    // SIGNALS ENDS
    /***********************************************************************************************************************/



    /***********************************************************************************************************************/
    // Connections Starts



    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS
    Component.onCompleted: {
        dateFilterPopup.subCategoryEditMode.connect(listContent.slotEditModeSubCategory)
        dateFilterPopup.signalCalendarEditData.connect(calendarContent.slotEditModeCalendar)
        dateFilterPopup.signalTimeFrameEditData.connect(dateTimeFrameContent.slotEditModeTimeFrame)
    }

    // SLOT function
    function slotEditMode(section, category, subCategory, relation, slug, value){

        if(section === Constants.dateTab){

            switch(category){
            case Constants.dateMainListType:

                listContent.visible = true
                calendarContent.visible = false
                dateTimeFrameContent.visible = false
                listRadio.checked = true

                dateFilterPopup.subCategoryEditMode(subCategory)

                break

            case Constants.dateMainCalendarType:

                listContent.visible = false
                calendarContent.visible = true
                dateTimeFrameContent.visible = false
                dateRadio.checked = true

                dateFilterPopup.signalCalendarEditData(relation, slug, value)

                break

            case Constants.dateMainTimeFrameType:

                listContent.visible = false
                calendarContent.visible = false
                dateTimeFrameContent.visible = true
                topRadio.checked = true

                dateFilterPopup.signalTimeFrameEditData(subCategory, relation, slug, value)

                break
            }

        }
    }


    function closeDateFilterPopup(){
        dateFilterPopup.visible = false
        DSParamsModel.resetFilter();
    }

    function applyDateFilter(){

        dateFilterPopup.visible = false

        var filterIndex = DSParamsModel.filterIndex
        var section = DSParamsModel.section
        var category = DSParamsModel.category
        var subCategory = DSParamsModel.subCategory
        var tableName = DSParamsModel.tableName
        var columnName = DSParamsModel.colName
        var joinRelation = DSParamsModel.fetchJoinRelation(0, true)
        var joinValue = DSParamsModel.fetchJoinValue(0, true)
        var joinSlug = DSParamsModel.fetchJoinRelationSlug(0, true)
        var includeNull = DSParamsModel.includeNull
        var exclude = DSParamsModel.exclude

        var singleValue = "";
        var singleRelation = "";
        var singleSlug = "";


        switch(category){

        case Constants.dateMainListType:

            singleRelation = joinRelation[0]
            singleValue = joinValue[0]
            singleSlug = joinSlug[0]
            manageFilters(DSParamsModel.mode, section, category, subCategory, tableName, columnName, singleRelation, singleSlug, singleValue, includeNull, exclude, filterIndex)

            break

        case Constants.dateMainCalendarType:

            for(let i = 0; i < Object.keys(joinRelation).length; i++){
                singleRelation = joinRelation[i]
                singleValue = joinValue[i]
                singleSlug = joinSlug[i]
                manageFilters(DSParamsModel.mode, section, category, subCategory, tableName, columnName, singleRelation, singleSlug, singleValue, includeNull, exclude, filterIndex)
            }

            break

        case Constants.dateMainTimeFrameType:
            singleRelation = joinRelation[0]
            singleValue = joinValue[0]
            singleSlug = joinSlug[0]
            manageFilters(DSParamsModel.mode, section, category, subCategory, tableName, columnName, singleRelation, singleSlug, singleValue, includeNull, exclude, filterIndex)
            break

        default:
            break
        }

        DSParamsModel.setMode(Constants.modeCreate)
        // Reset all DSParams
        //DSParamsModel.resetFilter();

    }

    function manageFilters(mode, section, category, subCategory, tableName, columnName, relation, slug, value, includeNull, exclude, filterIndex = 0){

//        console.log(filterIndex, section, category, subCategory, tableName, columnName, relation, slug, value, includeNull, exclude, "FILTER LIST INSERT/UPDATE")

        // Save the filter
        if(mode === Constants.modeCreate){
            FilterDateListModel.newFilter(section, category, subCategory, tableName, columnName, relation, slug, value, includeNull, exclude)

        } else{
            FilterDateListModel.updateFilter(filterIndex, section, category, subCategory, tableName, columnName, relation, slug, value, includeNull, exclude)
        }
    }
    function resetDateFilter(){
        // Reset date filter here
        closeDateFilterPopup()
    }


    function onListClicked(){
        listContent.visible = true
        calendarContent.visible = false
        dateTimeFrameContent.visible = false

        //DSParamsModel.resetFilter();
        DSParamsModel.setCategory(Constants.dateMainListType)

        // For list date type
        // The db WHERE relation can only be LIKE / NOT LIKE ARRAY type

        DSParamsModel.addToJoinRelation(mapKey, Constants.likeRelation)
    }
    function onCalendarClicked(){
        listContent.visible = false
        calendarContent.visible = true
        dateTimeFrameContent.visible = false

        DSParamsModel.setCategory(Constants.dateMainCalendarType)
        DSParamsModel.addToJoinRelation(mapKey, Constants.betweenRelation)
    }

    function onTimeFrameClicked(){
        listContent.visible = false
        calendarContent.visible = false
        dateTimeFrameContent.visible = true


        DSParamsModel.setCategory(Constants.dateMainTimeFrameType)
        DSParamsModel.addToJoinRelation(mapKey, Constants.likeRelation)
    }


    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts


    //    Top Menu Contents

    DateFilterListContent{
        id: listContent
        anchors.top:  fullExtactRadioBtn.bottom
    }

    DateFilterCalenderContent{
        id: calendarContent
        anchors.top:  fullExtactRadioBtn.bottom
    }

    DateTimeFrameContent{
        id: dateTimeFrameContent
        anchors.top:  fullExtactRadioBtn.bottom
    }

    ButtonGroup{
        id: dateFilterType
    }


    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts



    background: Rectangle{
        color: Constants.themeColor
        border.color: Constants.darkThemeColor
    }


    // Popup Header starts

    Rectangle{
        id: headerPopup
        color: Constants.whiteColor
        border.color: "transparent"
        height: 40
        width: parent.width - 2
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 1
        anchors.leftMargin: 1


        Text{
            id : text1
            text: "Data Source Filter heading"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left : parent.left
            font.pixelSize: Constants.fontCategoryHeader
            anchors.leftMargin: 10
        }

        Image {
            id: close_icn
            source: "/Images/icons/outline_close_black_18dp2x.png"
            anchors.verticalCenter: parent.verticalCenter
            anchors.right:  parent.right
            height: 25
            width: 25
            anchors.rightMargin: 5
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    closeDateFilterPopup()
                }
            }
        }

    }

    // Popup Header ends


    //    Menu Starts

    Rectangle{
        id: fullExtactRadioBtn
        height: 40
        width: parent.width-40
        anchors.horizontalCenter:  parent.horizontalCenter
        anchors.top: headerPopup.bottom

        color: "transparent"



        Column{

            id: listRadioColumn
            anchors.top: fullExtactRadioBtn.top

            width: parent.width/3
            anchors.left: parent.left
            leftPadding: 30
            topPadding: 8
            anchors.verticalCenter: parent.verticalCenter

            CustomRadioButton{
                id: listRadio
                radio_text: qsTr("List")
                radio_checked: true
                parent_dimension: 16
                ButtonGroup.group: dateFilterType
                onCheckedChanged: {
                    onListClicked()
                }
            }

        }
        Column{
            id: dateRadioColumn
            topPadding: 10
            bottomPadding: 10
            leftPadding: 50
            width: parent.width /3
            anchors.top: fullExtactRadioBtn.top
            anchors.centerIn: parent

            CustomRadioButton{
                id: dateRadio
                radio_text: qsTr("Calendar")
                radio_checked: false
                parent_dimension: 16
                ButtonGroup.group: dateFilterType
                onCheckedChanged: {
                    onCalendarClicked()
                }

            }
        }
        Column{
            id: topRadioColumn

            anchors.right: fullExtactRadioBtn.right
            topPadding: 8
            rightPadding: 35

            CustomRadioButton{
                id: topRadio
                radio_text: qsTr("Time Frame")
                radio_checked: false
                parent_dimension: 16
                ButtonGroup.group: dateFilterType
                onCheckedChanged: {
                    onTimeFrameClicked()
                }

            }
        }
    }

    //   Menu Ends

    // Footer starts

    Rectangle{
        id: footerContent
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        anchors.rightMargin: 20

        height: 30
        width: parent.width
        color: "transparent"

        CustomButton{
            id: resetBtn
            textValue: "Reset"

            anchors.left: parent.left
            anchors.leftMargin: 20


            onClicked: {
                resetDateFilter()
            }
        }



        CustomButton{
            id: apply_btn1
            textValue: "Apply"

            anchors.right: parent.right
            anchors.rightMargin: 20

            onClicked: {
                applyDateFilter()
            }
        }


        CustomButton{
            id: cancel_btn1

            anchors.right: apply_btn1.left
            anchors.rightMargin: 20

            textValue: "Cancel"
            onClicked: {
                closeDateFilterPopup()
            }

        }


    }

    // Footer ends


    // Page Design Ends
    /***********************************************************************************************************************/

}
