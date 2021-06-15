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
        target: ReportParamsModel

        function onInternalCounterChanged(){
            counter = ReportParamsModel.internalCounter
        }

        function onFilterIndexChanged(){
            counter = ReportParamsModel.filterIndex
        }
    }


    Connections{
        target: ChartsModel

        function onColumnDataChanged(columData, options){

            if(options !== ""){
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


    function closeDateFilterPopup(){
        dateFilterPopup.visible = false
        ReportParamsModel.clearFilter();
    }

    function applyDateFilter(){

        dateFilterPopup.visible = false

        var filterIndex = ReportParamsModel.filterIndex
        var section = ReportParamsModel.section
        var category = ReportParamsModel.category
        var subCategory = ReportParamsModel.subCategory
        var tableName = ReportParamsModel.tableName
        var columnName = ReportParamsModel.colName
        var tmpFilterIndexes = ReportParamsModel.getTmpFilterIndex(0, true)

        switch(category){

        case Constants.dateMainListType:
        case Constants.dateMainTimeFrameType:
        case Constants.dateMainCalendarType:

            ReportParamsModel.addToFilterSectionMap(counter, section)
            ReportParamsModel.addToFilterCategoryMap(counter, category)
            ReportParamsModel.addToFilterSubCategoryMap(counter, subCategory)
            ReportParamsModel.addToFilterColumnMap(counter, columnName)
            ReportParamsModel.addToDateFilters(counter)

            console.log("INSERT DATE", section, category, subCategory)

            manageFilters(ReportParamsModel.mode, counter, ReportParamsModel.filterModelIndex)

            break
        default:
            break
        }

        ReportParamsModel.clearFilter();

        // Clear tabs individual temp data
        dateFilterPopup.clearData()


    }

    function manageFilters(mode, counter = 0, filterId = 0){

        console.log("INSERT DATE FILTER HERE  - INSERT REPORT ID", mode, counter, filterId)
        ReportParamsModel.addToMasterReportFilters(Constants.uniqueReportId);
    }
    function resetDateFilter(){
        // Reset date filter here
        closeDateFilterPopup()
    }


    function onListClicked(){
        listContent.visible = true
        calendarContent.visible = false
        dateTimeFrameContent.visible = false

        //ReportParamsModel.resetFilter();
        ReportParamsModel.setCategory(Constants.dateMainListType)

        // For list date type
        // The db WHERE relation can only be LIKE / NOT LIKE ARRAY type

    }
    function onCalendarClicked(){
        listContent.visible = false
        calendarContent.visible = true
        dateTimeFrameContent.visible = false

        ReportParamsModel.setCategory(Constants.dateMainCalendarType)
    }

    function onTimeFrameClicked(){
        listContent.visible = false
        calendarContent.visible = false
        dateTimeFrameContent.visible = true


        ReportParamsModel.setCategory(Constants.dateMainTimeFrameType)
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
