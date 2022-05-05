import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0
import com.grafieks.singleton.messages 1.0

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

    property int counter: 0


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

    signal clearData()
    signal subCategoryEditMode(string subCategory)
    signal signalCalendarEditData(string relation, string slug, string value)
    signal signalTimeFrameEditData(string subCategory, string relation, string value, string value)

    // SIGNALS ENDS
    /***********************************************************************************************************************/



    /***********************************************************************************************************************/
    // Connections Starts


    Connections{
        target: DSParamsModel

        function onInternalCounterChanged(){
            counter = DSParamsModel.internalCounter
        }

        function onFilterIndexChanged(){
            counter = DSParamsModel.filterIndex
        }
    }

    Connections{
        target: CSVJsonDataModel

        function onColumnListModelDataChanged(values){
            updateData(values)
        }
    }

    Connections{
        target: ExcelDataModel

        function onColumnListModelDataChanged(values){
            updateData(values)
        }
    }

    Connections{
        target: ForwardOnlyDataModel

        function onColumnListModelDataChanged(values){
            updateData(values)
        }
    }

    Connections{
        target: QueryDataModel

        function onColumnListModelDataChanged(values){
            updateData(values)
        }
    }


    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS
    Component.onCompleted: {
        dateFilterPopup.subCategoryEditMode.connect(listContent.slotEditModeSubCategory)
        dateFilterPopup.signalCalendarEditData.connect(calendarContent.slotEditModeCalendar)
        dateFilterPopup.signalTimeFrameEditData.connect(dateTimeFrameContent.slotEditModeTimeFrame)

        dateFilterPopup.clearData.connect(listContent.slotDataCleared)
        dateFilterPopup.clearData.connect(calendarContent.slotDataCleared)
        dateFilterPopup.clearData.connect(dateTimeFrameContent.slotDataCleared)
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

    function updateData(options){

        var jsonOptions = JSON.parse(options)

        if(jsonOptions.section === Constants.dateTab){

            switch(jsonOptions.category){
            case Constants.dateMainListType:

                listContent.visible = true
                calendarContent.visible = false
                dateTimeFrameContent.visible = false

                listRadio.checked = true

                break

            case Constants.dateMainCalendarType:

                listContent.visible = false
                calendarContent.visible = true
                dateTimeFrameContent.visible = false

                dateRadio.checked = true

                break

            case Constants.dateMainTimeFrameType:

                listContent.visible = false
                calendarContent.visible = false
                dateTimeFrameContent.visible = true

                topRadio.checked = true

                break
            }

        }
    }


    function closeDateFilterPopup(){
        dateFilterPopup.visible = false
        DSParamsModel.clearFilter();

        // Clear tabs individual temp data
        dateFilterPopup.clearData()
    }

    function applyDateFilter(){

        dateFilterPopup.visible = false

        var filterIndex = DSParamsModel.filterIndex
        var section = DSParamsModel.section
        var category = DSParamsModel.category
        var subCategory = DSParamsModel.subCategory
        var tableName = DSParamsModel.tableName
        var columnName = DSParamsModel.colName
        var tmpFilterIndexes = DSParamsModel.getTmpFilterIndex(0, true)

        var singleValue = "";
        var singleRelation = "";
        var singleSlug = "";

        let joinRelation = ""
        let joinValue = ""
        let actualValue = ""
        let joinSlug = ""
        let includeNull =  false
        let exclude = false
        let dateFormatId = 0

        switch(category){

        case Constants.dateMainListType:
        case Constants.dateMainTimeFrameType:


            joinRelation = DSParamsModel.fetchJoinRelation(counter)
            joinValue = DSParamsModel.fetchJoinValue(counter)
            actualValue = DSParamsModel.getActualDateValues(counter)
            joinSlug = DSParamsModel.fetchJoinRelationSlug(counter)
            includeNull = DSParamsModel.getIncludeNullMap(counter)[counter] === "1" ? true : false
            exclude = DSParamsModel.getExcludeMap(counter)[counter] === "1" ? true : false
            dateFormatId = category === Constants.dateMainTimeFrameType ? DSParamsModel.getDateFormatMap(counter): 0

            singleRelation = joinRelation[counter]
            singleValue = joinValue[counter]
            singleSlug = joinSlug[counter]
            manageFilters(DSParamsModel.mode, section, category, subCategory, tableName, columnName, singleRelation, singleSlug, singleValue, actualValue, includeNull, exclude, dateFormatId, counter, DSParamsModel.filterModelIndex)

            break

        case Constants.dateMainCalendarType:


            joinRelation = DSParamsModel.fetchJoinRelation(counter)
            joinValue = DSParamsModel.fetchJoinValue(counter)
            actualValue = DSParamsModel.getActualDateValues(counter)
            joinSlug = DSParamsModel.fetchJoinRelationSlug(counter)
            includeNull = false
            exclude = DSParamsModel.getExcludeMap(counter)[counter] === "1" ? true : false

            singleRelation = joinRelation[counter]
            singleValue = joinValue[counter]
            singleSlug = joinSlug[counter]

            manageFilters(DSParamsModel.mode, section, category, subCategory, tableName, columnName, singleRelation, singleSlug, singleValue, actualValue, includeNull, exclude, 0, counter, DSParamsModel.filterModelIndex)


            break


        default:
            break
        }

        DSParamsModel.clearFilter();

        // Clear tabs individual temp data
        dateFilterPopup.clearData()


    }

    function manageFilters(mode, section, category, subCategory, tableName, columnName, relation, slug, value, actualValue, includeNull, exclude, dateFormatId, counter = 0, filterId = 0){

        console.log("Filter insert date", mode, section, category, subCategory, tableName, columnName, relation, slug, value, actualValue, includeNull, exclude, dateFormatId, counter, filterId)

        // Save the filter
        if(mode === Constants.modeCreate){
            FilterDateListModel.newFilter(counter, dateFormatId,  section, category, subCategory, tableName, columnName, relation, slug, value, actualValue, includeNull, exclude)

        } else{
            FilterDateListModel.updateFilter(filterId, dateFormatId, section, category, subCategory, tableName, columnName, relation, slug, value, actualValue, includeNull, exclude)
        }
    }
    function resetDateFilter(){
        // Reset date filter here
        closeDateFilterPopup()
        DSParamsModel.clearFilter()

        dateFilterPopup.clearData()
    }


    function onListClicked(){
        listContent.visible = true
        calendarContent.visible = false
        dateTimeFrameContent.visible = false

        //DSParamsModel.resetFilter();
        DSParamsModel.setCategory(Constants.dateMainListType)

        // For list date type
        // The db WHERE relation can only be LIKE / NOT LIKE ARRAY type

    }
    function onCalendarClicked(){
        listContent.visible = false
        calendarContent.visible = true
        dateTimeFrameContent.visible = false

        DSParamsModel.setCategory(Constants.dateMainCalendarType)
    }

    function onTimeFrameClicked(){
        listContent.visible = false
        calendarContent.visible = false
        dateTimeFrameContent.visible = true


        DSParamsModel.setCategory(Constants.dateMainTimeFrameType)
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
            text: Messages.mo_sub_common_header
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
                radio_text: Messages.filterCalendar
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
                radio_text: Messages.filterTimeframe
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
            textValue: Messages.resetBtnTxt

            anchors.left: parent.left
            anchors.leftMargin: 20


            onClicked: {
                resetDateFilter()
            }
        }



        CustomButton{
            id: apply_btn1
            textValue: Messages.applyBtnTxt

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

            textValue: Messages.cancelBtnTxt
            onClicked: {
                closeDateFilterPopup()
            }

        }


    }

    // Footer ends


    // Page Design Ends
    /***********************************************************************************************************************/

}
