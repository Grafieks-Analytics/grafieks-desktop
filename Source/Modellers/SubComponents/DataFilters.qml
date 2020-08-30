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
import "../SubComponents/MiniSubComponents"


Popup {

    property string tabBarOpen: Constants.categoricalTab

    id: popupMain
    width: parent.width * 0.5
    height: 500
    x:  parent.width * 0.25
    y: 100
    modal: true
    visible: false
    padding: 0
    closePolicy: Popup.NoAutoClose


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


    // Listmodel for combobox
    ListModel{
        id: addComboDropdown

        ListElement{
            menuItem:"Add"
        }
        ListElement{
            menuItem:"User Name"
        }
        ListElement{
            menuItem:"First Name"
        }
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


    // LIST MODEL ENDS
    /***********************************************************************************************************************/


    /***********************************************************************************************************************/
    // SIGNALS STARTS



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

            allCategorical.forEach(function (element) {
                categoricalModel.append({"tableName" : element[0], "colName" : element[1]});
            });

            allNumerical.forEach(function (element) {
                numericalModel.append({"tableName" : element[0], "colName" : element[1]});
            });

            allDates.forEach(function (element) {
                datesModel.append({"tableName" : element[0], "colName" : element[1]});
            });

            addMenuList.model =  categoricalModel
            addMenuList.height = categoricalModel.count * 40

        }
    }

    // This section is called when
    // EDIT filter is clicked from various lists
    // On receiving the signal from C++, it will popup the relevant screen

    Connections{
        target: ColumnListModel

        function onEditCalled(){

            if(DSParamsModel.section === Constants.categoricalTab){
                categoricalFilterPopup.visible = true
                dateFilterPopup.visible = false
                numericalFilterPopup.visible = false
                groupFilterPopup.visible = false
            }
            else if(DSParamsModel.section === Constants.dateTab){
                categoricalFilterPopup.visible = false
                dateFilterPopup.visible = true
                numericalFilterPopup.visible = false
                groupFilterPopup.visible = false
            }
            else if(DSParamsModel.section === Constants.numericalTab){
                categoricalFilterPopup.visible = false
                dateFilterPopup.visible = false
                numericalFilterPopup.visible = true
                groupFilterPopup.visible = false
            }
            else if(DSParamsModel.section === Constants.groupTab){
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


    function onAddMenuItemTriggered(colName,tableName){
        ColumnListModel.columnQuery(colName, tableName)
        DSParamsModel.setColName(colName)
        DSParamsModel.setTableName(tableName)
    }

    function onAddMenuItemClicked(){

        if(tabBarOpen === Constants.categoricalTab){
            categoricalFilterPopup.visible = true
            dateFilterPopup.visible = false
            numericalFilterPopup.visible = false
            groupFilterPopup.visible = false
        }
        else if(tabBarOpen === Constants.dateTab){
            categoricalFilterPopup.visible = false
            dateFilterPopup.visible = true
            numericalFilterPopup.visible = false
            groupFilterPopup.visible = false
        }
        else if(tabBarOpen === Constants.numericalTab){
            categoricalFilterPopup.visible = false
            dateFilterPopup.visible = false
            numericalFilterPopup.visible = true
            groupFilterPopup.visible = false
        }
        else if(tabBarOpen === Constants.groupTab){
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
        groupTabBackground.color = Constants.whiteColor

        allCategoricalFilterContent.visible = false
        allDateFilterContent.visible = false
        allNumericalFilterContent.visible = false
        allGroupFilterContent.visible = false

        if(characterFilterTab){
            categoricalTabBackground.color =  Constants.themeColor
            allCategoricalFilterContent.visible = true

        }

        if(dateFilterTab){
            dateTabBackground.color =  Constants.themeColor
            allDateFilterContent.visible = true
        }

        if(numericalFilterTab){
            numericalTabBackground.color = Constants.themeColor
            allNumericalFilterContent.visible = true

        }
        if(groupFilterTab){
            groupTabBackground.color = Constants.themeColor
            allGroupFilterContent.visible=true
            tabBarOpen = Constants.groupTab
        }

    }



    function onCategoricalTabClicked(){

        onTabToggle(true,false,false,false);

        addMenuList.model = categoricalModel
        addMenuList.height = categoricalModel.count * 40

        tabBarOpen = Constants.categoricalTab

        // Set the section in C++
        DSParamsModel.setSection(Constants.categoricalTab)

    }


    function onDateTabClicked(){

        onTabToggle(false,true,false,false);

        addMenuList.model = datesModel
        addMenuList.height = datesModel.count * 40


        tabBarOpen = Constants.dateTab

        // Set the section in C++
        DSParamsModel.setSection(Constants.dateTab)
    }


    function onNumericalTabClicked(){

        onTabToggle(false,false,true,false);
        addMenuList.model = numericalModel
        addMenuList.height = numericalModel.count * 40


        tabBarOpen = Constants.numericalTab

        // Set the section in C++
        DSParamsModel.setSection(Constants.numericalTab)

    }



    function onGroupTabClicked(){

        onTabToggle(false,false,false,true);
        addMenuList.model = groupModelList

        // Set the section in C++
        DSParamsModel.setSection(Constants.groupTab)
    }


    function onApplyClicked(){

        popupMain.visible = false
        var tmpSql = QueryModel.tmpSql

        FilterListModel.callQueryModel(tmpSql)
    }
    function onCancelClicked(){
        popupMain.visible = false
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
            source: "../../../Images/icons/outline_close_black_18dp2x.png"
            anchors.verticalCenter: parent.verticalCenter
            anchors.right:  parent.right
            height: 25
            width: 25
            anchors.rightMargin: 5
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    onCancelClicked()
                }
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
            width:popupMain.width/4 - 1

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

            onClicked: {

                onCategoricalTabClicked()

            }
        }

        // Characters Tab button ends

        // Date Tab button starts

        TabButton{
            id: date_btn
            text: "Date"
            width:popupMain.width/4 - 1

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

            onClicked: {

                onDateTabClicked()
            }
        }

        // Date Tab button ends

        // Numbers Tab button starts

        TabButton{
            id: numbers_btn
            text: "Numerical"
            width:popupMain.width/4 - 1

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

            onClicked: {
                onNumericalTabClicked()
            }
        }

        // Numbers Tab button ends

        // Users Tab button starts

        TabButton{
            id: users_btn
            text: "Group"
            width:popupMain.width/4 - 2


            background: Rectangle {
                id: groupTabBackground
                border.color: Constants.darkThemeColor
                color: users_btn.pressed? Constants.themeColor: Constants.whiteColor

            }

            contentItem: Text{
                id:users_btn_text
                text: users_btn.text
                color:"black"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onClicked: {

                onGroupTabClicked()
            }
        }

        // Users Tab button ends
    }

    // Top header buttons ends

    // Add button starts

//    CustomButton{
//        id: add_btn_1
//        anchors.top: tabbar1.bottom
//        anchors.left: parent.left
//        anchors.topMargin: 10
//        anchors.leftMargin: 20
//        textValue:"Add"
//        onClicked: {
//            optionsMenu1.open()
//        }
//    }


    // Menu options on clicking 'Add button' starts

//    Menu {
//        id: optionsMenu1

//        x: 20
//        y: headerPopup.height + tabbar1.height + add_btn_1.height + 22
//        width: 150

//        ListView{
//            id: addMenuList
//            anchors.top: parent.top
//            width: 150
//            delegate:

//                MenuItem {
//                text: colName
//                onTriggered: {

//                    onAddMenuItemTriggered(colName, tableName);

//                }
//                onClicked: {

//                    onAddMenuItemClicked()
//                }
//            }
//        }
//    }

    // Menu options on clicking 'Add button' ends

    CustomComboBox{
        id: add_btn_1
        anchors.top: tabbar1.bottom
        anchors.left: parent.left
        anchors.topMargin: 10
        anchors.leftMargin: 20

        currentIndex: 0
        model: addComboDropdown
        textRole: "menuItem"

        onCurrentIndexChanged: {

//            onAddMenuItemTriggered(colName, tableName);

        }
    }

    // Add button ends

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
            onClicked: {
                onCancelClicked()
            }
        }


        CustomButton{
            id: apply_btn1
            textValue: "Apply"
            onClicked: {
                onApplyClicked()

            }
        }
    }

    // Action button ends

    // Page Design Ends
    /***********************************************************************************************************************/


}

