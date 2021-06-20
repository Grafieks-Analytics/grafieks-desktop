/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Data/SubComponents
** Data Filters
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents"
import "../SubComponents"
import "../SubComponents/MiniSubComponents"


Popup {


    id: popupMain
    width: report_desiner_page.parent.width*0.5
    height: 500
    x:  report_desiner_page.parent.width*0.25
    y: 100
    modal: true
    visible: false
    padding: 0
    closePolicy: Popup.NoAutoClose

    property string tabBarOpen: Constants.categoricalTab
    property int mapKey : 0


    /***********************************************************************************************************************/
    // LIST MODEL STARTS


    // ListModels
    // Dynamically populated by
    // Connections: TableSchemaModel

    ListModel{
        id: categoricalModel
    }

    ListModel{
        id: numericalModel
    }

    ListModel{
        id: datesModel
    }


    // For Groups tab

    ListModel{
        id:groupModelList
        ListElement{
            textValue:"group1"
        }
        ListElement{
            textValue:"group2"
        }
        ListElement{
            textValue:"group2"
        }
        ListElement{
            textValue:"group2"
        }
        ListElement{
            textValue:"group2"
        }
        ListElement{
            textValue:"group2"
        }
        ListElement{
            textValue:"group2"
        }
    }

    // Listmodel for combobox
    ListModel{
        id: addComboDropdown
    }


    // LIST MODEL ENDS
    /***********************************************************************************************************************/


    /***********************************************************************************************************************/
    // SIGNALS STARTS

    signal signalEditMode(string section, string category, string subCategory, string relation, string value, string slug)

    // SIGNALS ENDS
    /***********************************************************************************************************************/



    /***********************************************************************************************************************/
    // Connections Starts


    // This function is used to create models
    // for FILTERS section type
    // Populates Listmodel

    Connections{
        target: TableSchemaModel

        // Set the model of the `Add Button` in each tab
        function onTableSchemaObtained(allList, allCategorical, allNumerical, allDates, allOthers, queriedColumnNames){

            categoricalModel.clear()
            numericalModel.clear()
            datesModel.clear()

            allCategorical.forEach(function (element) {
                categoricalModel.append({"tableName" : element[0], "colName" : element[1]});
            });

            allNumerical.forEach(function (element) {
                numericalModel.append({"tableName" : element[0], "colName" : element[1]});
            });

            allDates.forEach(function (element) {
                datesModel.append({"tableName" : element[0], "colName" : element[1]});
            });

            add_btn_1.model =  categoricalModel

        }

        function onTableSchemaCleared(){
            categoricalModel.clear()
            numericalModel.clear()
            datesModel.clear()
        }
    }

    // This section is called when
    // EDIT filter is clicked from various lists
    // On receiving the signal from C++, it will popup the relevant screen

    Connections{
        target: ChartsModel

        function onColumnDataChanged(columnData, options){
            if(ReportParamsModel.section === Constants.categoricalTab){

                // Fire the signal for show specific category
                popupMain.signalEditMode(ReportParamsModel.section, ReportParamsModel.category, ReportParamsModel.subCategory, ReportParamsModel.fetchFilterRelationMap(mapKey, false)[0], ReportParamsModel.fetchFilterSlugMap(mapKey, false)[0], ReportParamsModel.fetchFilterValueMap(mapKey, false)[0])

                // show specific section for edit param
                categoricalFilterPopup.visible = true
                dateFilterPopup.visible = false
                numericalFilterPopup.visible = false
                groupFilterPopup.visible = false
            }
            else if(ReportParamsModel.section === Constants.dateTab){

                // Fire the signal for show specific category
                popupMain.signalEditMode(ReportParamsModel.section, ReportParamsModel.category, ReportParamsModel.subCategory, ReportParamsModel.fetchFilterRelationMap(mapKey, false)[0], ReportParamsModel.fetchFilterSlugMap(mapKey, false)[0], ReportParamsModel.fetchFilterValueMap(mapKey, false)[0])


                // show specific section for edit param
                categoricalFilterPopup.visible = false
                dateFilterPopup.visible = true
                numericalFilterPopup.visible = false
                groupFilterPopup.visible = false
            }
            else if(ReportParamsModel.section === Constants.numericalTab){

                // Fire the signal for show specific category
                popupMain.signalEditMode(ReportParamsModel.section, ReportParamsModel.category, ReportParamsModel.subCategory, ReportParamsModel.fetchFilterRelationMap(mapKey, false)[0], ReportParamsModel.fetchFilterSlugMap(mapKey, false)[0], ReportParamsModel.fetchFilterValueMap(mapKey, false)[0])

                // show specific section for edit param
                categoricalFilterPopup.visible = false
                dateFilterPopup.visible = false
                numericalFilterPopup.visible = true
                groupFilterPopup.visible = false
            }
            else if(ReportParamsModel.section === Constants.groupTab){

                // Fire the signal for show specific category
                popupMain.signalEditMode(ReportParamsModel.section, ReportParamsModel.category, ReportParamsModel.subCategory, ReportParamsModel.fetchJoinRelation(mapKey, false)[0], ReportParamsModel.fetchJoinRelationSlug(mapKey, false)[0], ReportParamsModel.fetchJoinValue(mapKey, false)[0])

                // show specific section for edit param
                categoricalFilterPopup.visible = false
                dateFilterPopup.visible = false
                numericalFilterPopup.visible = false
                groupFilterPopup.visible = true
            }
        }
    }

    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS


    Component.onCompleted: {

        ReportParamsModel.setSection(Constants.categoricalTab)
        ReportParamsModel.setCategory(Constants.categoryMainListType)
        ReportParamsModel.setSubCategory(Constants.categorySubMulti)
    }


    function onAddMenuItemTriggered(colName,tableName, section, category, subCategory){

        var options = {
            "section" : section,
            "category" : category,
            "subCategory" : subCategory,
            "values" : ""
        }

        if(GeneralParamsModel.getDbClassification() === Constants.sqlType){
            QueryDataModel.columnData(colName, tableName, JSON.stringify(options));
        } else if(GeneralParamsModel.getDbClassification() === Constants.duckType){
            DuckDataModel.columnData(colName, tableName, JSON.stringify(options))
        } else{
            ForwardOnlyDataModel.columnData(colName, tableName, JSON.stringify(options))
        }

        ReportParamsModel.setColName(colName)
        ReportParamsModel.setTableName(tableName)

    }

    function onAddMenuItemClicked(){

        ReportParamsModel.setFilterIndex(ReportParamsModel.filterIndex + 1)
        ReportParamsModel.setMode(Constants.modeCreate)

        if(tabBarOpen === Constants.categoricalTab){

            // Fire the signal for show specific category
            ReportParamsModel.setSection(Constants.categoricalTab)
            ReportParamsModel.setCategory(Constants.categoryMainListType)

            categoricalFilterPopup.visible = true
            dateFilterPopup.visible = false
            numericalFilterPopup.visible = false
            groupFilterPopup.visible = false
        }
        else if(tabBarOpen === Constants.dateTab){

            // Fire the signal for show specific category
            ReportParamsModel.setSection(Constants.dateTab)
            ReportParamsModel.setCategory(Constants.dateMainListType)
            ReportParamsModel.setSubCategory(Constants.categorySubMulti)

            ReportParamsModel.resetInputFields()
            categoricalFilterPopup.visible = false
            dateFilterPopup.visible = true
            numericalFilterPopup.visible = false
            groupFilterPopup.visible = false
        }
        else if(tabBarOpen === Constants.numericalTab){

            // Fire the signal for show specific category
            ReportParamsModel.setSection(Constants.numericalTab)

            ReportParamsModel.resetInputFields()
            categoricalFilterPopup.visible = false
            dateFilterPopup.visible = false
            numericalFilterPopup.visible = true
            groupFilterPopup.visible = false
        }
        else if(tabBarOpen === Constants.groupTab){

            // Fire the signal for show specific category
            ReportParamsModel.setSection(groupTab)

            categoricalFilterPopup.visible = false
            dateFilterPopup.visible = false
            numericalFilterPopup.visible = false
            groupFilterPopup.visible = true
        }
    }

    function onTabToggle(characterFilterTab,dateFilterTab,numericalFilterTab,groupFilterTab){

        categoricalTabBackground.color =  Constants.whiteColor
        dateTabBackground.color =  Constants.whiteColor
        numericalTabBackground.color = Constants.whiteColor

        allCategoricalFilterContent.visible = false
        allDateFilterContent.visible = false
        allNumericalFilterContent.visible = false
        allGroupFilterContent.visible = false

        if(characterFilterTab){
            categoricalTabBackground.color =  Constants.themeColor
            allCategoricalFilterContent.visible = true
            tabBarOpen = Constants.categoricalTab

        }

        if(dateFilterTab){
            dateTabBackground.color =  Constants.themeColor
            allDateFilterContent.visible = true
            tabBarOpen = Constants.dateTab
        }

        if(numericalFilterTab){
            numericalTabBackground.color = Constants.themeColor
            allNumericalFilterContent.visible = true
            tabBarOpen = Constants.numericalTab

        }
        if(groupFilterTab){
            groupTabBackground.color = Constants.themeColor
            allGroupFilterContent.visible=true
            tabBarOpen = Constants.groupTab
        }

    }



    function onCategoricalTabClicked(){

        onTabToggle(true,false,false,false);

        add_btn_1.model = categoricalModel

        tabBarOpen = Constants.categoricalTab

        // Set the section in C++
        ReportParamsModel.setSection(Constants.categoricalTab)
        ReportParamsModel.setCategory(Constants.categoryMainListType)
        ReportParamsModel.setSubCategory(Constants.categorySubMulti)

    }


    function onDateTabClicked(){

        onTabToggle(false,true,false,false);

        add_btn_1.model = datesModel

        tabBarOpen = Constants.dateTab

        // Set the section in C++
        ReportParamsModel.setSection(Constants.dateTab)
        ReportParamsModel.setCategory(Constants.dateMainListType)
        ReportParamsModel.setSubCategory(Constants.categorySubMulti)
    }


    function onNumericalTabClicked(){

        onTabToggle(false,false,true,false);
        add_btn_1.model = numericalModel

        tabBarOpen = Constants.numericalTab

        // Set the section in C++
        ReportParamsModel.setSection(Constants.numericalTab)
        ReportParamsModel.setCategory("")
        ReportParamsModel.setSubCategory("")

    }



    function onGroupTabClicked(){

        onTabToggle(false,false,false,true);
        add_btn_1.model = groupModelList

        // Set the section in C++
        ReportParamsModel.setSection(Constants.groupTab)
    }


    function onApplyClicked(){

        popupMain.visible = false
        ReportParamsModel.clearFilter()

        onTabToggle(true,false,false,false);
        console.log("APPLY APPLY", "REPORT ID", ReportParamsModel.reportId)

        // Call the function to apply all the filters in reports
        // This will emit a signal from ReportParamsModel.fetchMasterReportFilters to the slot in ChartsModel.updateFilterData
        ReportParamsModel.fetchMasterReportFilters(ReportParamsModel.reportId)


    }
    function onCancelClicked(){
        popupMain.visible = false
        ReportParamsModel.clearFilter()

        onTabToggle(true,false,false,false);
    }




    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts


    CategoricalFilter{
        id:categoricalFilterPopup
    }

    DateFilter{
        id: dateFilterPopup
    }

    NumericalFilter{
        id: numericalFilterPopup
    }

    GroupFilter{
        id: groupFilterPopup
    }

    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts




    background: Rectangle{
        color: Constants.themeColor
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
            text: "Data Source Filter"
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
                onClicked: onCancelClicked()
            }
        }

    }

    // Popup Header ends

    //    Top header buttons starts

    TabBar{
        id: tabbar1
        anchors.top: headerPopup.bottom
        anchors.left: parent.left
        anchors.topMargin: 1
        anchors.leftMargin: 1

        Component.onCompleted: {
            categoricalTabBackground.color =  Constants.themeColor
        }


        // Characters Tab button starts

        TabButton{
            id: character_btn
            text: "Categorical"
            width:popupMain.width/3 - 1

            background: Rectangle {
                id: categoricalTabBackground
                border.color: Constants.darkThemeColor
                color: character_btn.pressed? Constants.themeColor: Constants.whiteColor
            }

            contentItem: Text{
                id:character_btn_text
                text: character_btn.text
                color:"black"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onClicked: onCategoricalTabClicked()
        }

        // Characters Tab button ends

        // Date Tab button starts

        TabButton{
            id: date_btn
            text: "Date"
            width:popupMain.width/3 - 1

            background: Rectangle {
                id: dateTabBackground
                border.color: Constants.darkThemeColor
                color: date_btn.pressed? Constants.themeColor: Constants.whiteColor
            }

            contentItem: Text{
                id:date_btn_text
                text: date_btn.text
                color:"black"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onClicked: onDateTabClicked()
        }

        // Date Tab button ends

        // Numbers Tab button starts

        TabButton{
            id: numbers_btn
            text: "Numerical"
            width:popupMain.width/3 - 1

            background: Rectangle {
                id: numericalTabBackground
                border.color: Constants.darkThemeColor
                color: character_btn.pressed? Constants.themeColor: Constants.whiteColor
            }

            contentItem: Text{
                id:numbers_btn_text
                text: numbers_btn.text
                color:"black"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onClicked: onNumericalTabClicked()
        }

        // Numbers Tab button ends

        // Users Tab button starts

        //        TabButton{
        //            id: users_btn
        //            text: "Group"
        //            width:popupMain.width/4 - 2


        //            background: Rectangle {
        //                id: groupTabBackground
        //                border.color: Constants.darkThemeColor
        //                color: users_btn.pressed? Constants.themeColor: Constants.whiteColor

        //            }

        //            contentItem: Text{
        //                id:users_btn_text
        //                text: users_btn.text
        //                color:"black"
        //                horizontalAlignment: Text.AlignHCenter
        //                verticalAlignment: Text.AlignVCenter
        //            }

        //            onClicked: onGroupTabClicked()
        //        }

        // Users Tab button ends
    }

    // Top header buttons ends


    // Menu option starts
    CustomComboBox{
        id: add_btn_1
        anchors.top: tabbar1.bottom
        anchors.left: parent.left
        anchors.topMargin: 10
        anchors.leftMargin: 20

        textRole: "colName"
        valueRole: "tableName"

        onActivated: {
            onAddMenuItemTriggered(currentText, currentValue, ReportParamsModel.section, ReportParamsModel.category, ReportParamsModel.subCategory)
            onAddMenuItemClicked()

        }
    }

    // Menu option ends

    // Center Panel Starts

    Rectangle{
        id: rect1
        width: popupMain.width - 40
        height: parent.height - headerPopup.height - tabbar1.height - 100;
        border.color: Constants.darkThemeColor
        anchors.top:add_btn_1.bottom
        anchors.left: parent.left
        anchors.topMargin: 10
        anchors.leftMargin: 20

        /***************************************************************************************************************/
        // Inner Popups SubComponents Starts

        AllCategoricalFilters{
            id: allCategoricalFilterContent
        }


        AllDateFilters{
            id: allDateFilterContent
            visible: false
        }


        AllNumericalFilters{
            id: allNumericalFilterContent
            visible: false
        }


        AllGroupFilters{
            id: allGroupFilterContent
            visible: false
        }


        // Inner Popups SubComponents Ends
        /***************************************************************************************************************/

    }

    // Center Panel Ends

    // Action button starts

    Row{
        anchors.top:rect1.bottom
        anchors.right: parent.right
        anchors.topMargin: 10
        anchors.rightMargin: 20
        spacing: 5

        CustomButton{
            id: cancel_btn1
            textValue: "Cancel"
            onClicked: onCancelClicked()
        }


        CustomButton{
            id: apply_btn1
            textValue: "Apply"
            onClicked: onApplyClicked()
        }
    }

    // Action button ends

    // Page Design Ends
    /***********************************************************************************************************************/


}

