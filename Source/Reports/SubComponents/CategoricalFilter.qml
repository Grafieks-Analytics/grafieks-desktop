import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents"
import "../SubComponents/MiniSubComponents"

Popup {
    id: categoricalFilterPopup
    width: parent.width
    height: parent.height
    x: 0
    y: 0
    modal: true
    visible: false
    padding: 0
    closePolicy: Popup.NoAutoClose

    property int filterIndex: 0


    background: Rectangle{
        color: Constants.themeColor
        border.color: Constants.darkThemeColor
    }

    property int counter: 0


    /***********************************************************************************************************************/
    // LIST MODEL STARTS


    // LIST MODEL ENDS
    /***********************************************************************************************************************/


    /***********************************************************************************************************************/
    // SIGNALS STARTS

    signal clearData()

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


        function onSectionChanged(){

            if(ReportParamsModel.section === Constants.categoricalTab){

                switch(ReportParamsModel.category){
                case Constants.categoryMainListType:

                    listContent.visible = true
                    wildcardContent.visible = false
                    topContent.visible = false

                    listRadio.checked = true

                    break

                case Constants.categoryMainWildCardType:

                    listContent.visible = false
                    wildcardContent.visible = true
                    topContent.visible = false

                    wildcardRadio.checked = true

                    break

                case Constants.categoryMainTopType:

                    listContent.visible = false
                    wildcardContent.visible = false
                    topContent.visible = true

                    topRadio.checked = true

                    break
                }

            }
        }
    }


    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS


    Component.onCompleted: {
        categoricalFilterPopup.clearData.connect(listContent.slotDataCleared)
        categoricalFilterPopup.clearData.connect(wildcardContent.slotDataCleared)
    }


    function closeCategoricalFilterPopup(){
        categoricalFilterPopup.visible = false

        // Reset all DSParams
        ReportParamsModel.clearFilter();

        // Clear tabs individual temp data
        categoricalFilterPopup.clearData()

    }

    function onApplyClicked(){

        categoricalFilterPopup.visible = false

        var section = ReportParamsModel.section
        var category = ReportParamsModel.category
        var subCategory = ReportParamsModel.subCategory
        var tableName = ReportParamsModel.tableName
        var columnName = ReportParamsModel.colName
        var tmpFilterIndexes = ReportParamsModel.getTmpFilterIndex(0, true)

        var singleValue = "";
        var singleRelation = "";
        var singleSlug = "";



        switch(category){

        case Constants.categoryMainListType:

            let joinRelation = ReportParamsModel.fetchJoinRelation(counter)
            let joinValue = ReportParamsModel.fetchJoinValue(counter)
            let joinSlug = ReportParamsModel.fetchJoinRelationSlug(counter)
            let includeNull = ReportParamsModel.getIncludeNullMap(counter)[counter] === "1" ? true : false
            let exclude = ReportParamsModel.getExcludeMap(counter)[counter] === "1" ? true : false

            singleRelation = joinRelation[counter]
            singleValue = joinValue[counter]
            singleSlug = joinSlug[counter]

            manageFilters(ReportParamsModel.mode, section, category, subCategory, tableName, columnName, singleRelation, singleSlug, singleValue, includeNull, exclude, counter, ReportParamsModel.filterModelIndex)
            break

        case Constants.categoryMainWildCardType:

            for(let i = 0; i < tmpFilterIndexes.length; i++){
                let fi = tmpFilterIndexes[i]

                let joinRelation = ReportParamsModel.fetchJoinRelation(fi)
                let joinValue = ReportParamsModel.fetchJoinValue(fi)
                let joinSlug = ReportParamsModel.fetchJoinRelationSlug(fi)
                let includeNull = false
                let exclude = ReportParamsModel.getExcludeMap(fi)[fi] === "1" ? true : false

                singleRelation = joinRelation[fi]
                singleValue = joinValue[fi]
                singleSlug = joinSlug[fi]

                manageFilters(ReportParamsModel.mode, section, category, subCategory, tableName, columnName, singleRelation, singleSlug, singleValue, includeNull, exclude, fi, ReportParamsModel.filterModelIndex)
            }

            break

        case Constants.categoryMainTopType:
            break

        default:
            break
        }

        // Clear filters
        ReportParamsModel.clearFilter();

        // Clear tabs individual temp data
        categoricalFilterPopup.clearData()



    }

    function manageFilters(mode, section, category, subCategory, tableName, columnName, relation, slug, value, includeNull, exclude, counter = 0, filterId = 0){

        console.log("Filter insert categorical", mode, section, category, subCategory, tableName, columnName, relation, slug, value, includeNull, exclude, counter, filterId)
        // Save the filter
        if(mode === Constants.modeCreate){
            FilterCategoricalListModel.newFilter(counter, section, category, subCategory, tableName, columnName, relation, slug, value, includeNull, exclude)

        } else{
            FilterCategoricalListModel.updateFilter(filterId, section, category, subCategory, tableName, columnName, relation, slug, value, includeNull, exclude)
        }
    }

    function onResetClicked(){
        categoricalFilterPopup.visible = false
        ReportParamsModel.clearFilter()

        // Clear tabs individual temp data
        categoricalFilterPopup.clearData()
    }

    function onListClicked(){

        listContent.visible = true
        wildcardContent.visible = false
        topContent.visible = false

        // Set the main category of the filter
        ReportParamsModel.clearFilter()
        ReportParamsModel.setCategory(Constants.categoryMainListType)

        // For list category type
        // The db WHERE relation can only be IN / NOT IN ARRAY type
        // Except when "Select All" checked.
        // Then Relation will be LIKE

        ReportParamsModel.addToJoinRelation(filterIndex, Constants.likeRelation)
    }


    function onWildcardClicked(){

        listContent.visible = false
        wildcardContent.visible = true
        topContent.visible = false

        // Set the main category of the filter
        ReportParamsModel.clearFilter();
        ReportParamsModel.setCategory(Constants.categoryMainWildCardType)

    }


    function onTopClicked(){

        listContent.visible = false
        wildcardContent.visible = false
        topContent.visible = true

        // Set the main category of the filter
        ReportParamsModel.clearFilter();
        ReportParamsModel.setCategory(Constants.categoryMainTopType)
    }


    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts


    ButtonGroup{
        id: filterType
    }


    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts




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
                onClicked: closeCategoricalFilterPopup()
            }
        }

    }

    // Popup Header ends

    //    Menu Starts

    Rectangle{
        id: fullExtactRadioBtn
        height: 40
        width: parent.width
        anchors.top: headerPopup.bottom

        color:"transparent"

        Column{

            id: listRadioColumn
            anchors.top: fullExtactRadioBtn.top

            width: parent.width/2
            anchors.left: parent.left
            leftPadding: 30
            topPadding: 8

            anchors.verticalCenter: parent.verticalCenter

            CustomRadioButton{
                id: listRadio
                x:21
                text: qsTr("List")
                ButtonGroup.group: filterType
                checked: true
                parent_dimension: 16
                onCheckedChanged: onListClicked()
            }

        }
        Column{
            id: wildcardRadioColumn
            topPadding: 10
            bottomPadding: 10
            anchors.right: parent.right
            //            leftPadding: 293
            width: parent.width /2
            anchors.top: fullExtactRadioBtn.top
            //            anchors.centerIn: parent

            CustomRadioButton{
                id: wildcardRadio
                text: qsTr("Wildcard")

                //                anchors.left: listRadioColumn.left
                anchors.right: parent.right
                anchors.rightMargin: 72
                checked: false
                parent_dimension: 16
                ButtonGroup.group: filterType
                onCheckedChanged: onWildcardClicked()

            }
        }

        /*******************/
        /** DO NOT DELETE **/
        /*******************/

        //        Column{
        //            id: topRadioColumn

        //            anchors.right: fullExtactRadioBtn.right
        //            topPadding: 8
        //            rightPadding: 30

        //            CustomRadioButton{
        //                id: topRadio
        //                text: qsTr("Top")
        //                checked: false
        //                parent_dimension: 16
        //                ButtonGroup.group: filterType
        //                onCheckedChanged: onTopClicked()
        //            }
        //        }

        /*******************/
        /** DO NOT DELETE **/
        /*******************/
    }

    //   Menu Ends

    //    Top Menu Contents

    CategoricalFilterListContent{
        id: listContent
    }

    CategoricalFilterWildcardContent{
        id: wildcardContent
    }

    CategoricalFilterTopContent{
        id: topContent
    }

    // Footer starts

    Rectangle{
        id: footerContent
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        anchors.rightMargin: 20

        height: 30
        width: parent.width
        color:"transparent"

        CustomButton{
            id: resetBtn
            textValue: "Reset"

            anchors.left: parent.left
            anchors.leftMargin: 20
            onClicked: onResetClicked()
        }



        CustomButton{
            id: apply_btn1
            textValue: "Apply"

            anchors.right: parent.right
            anchors.rightMargin: 20
            onClicked: onApplyClicked()
        }


        CustomButton{
            id: cancel_btn1

            anchors.right: apply_btn1.left
            anchors.rightMargin: 20
            textValue: "Cancel"
            onClicked: closeCategoricalFilterPopup()

        }


    }

    // Footer ends


    // Page Design Ends
    /***********************************************************************************************************************/

}
