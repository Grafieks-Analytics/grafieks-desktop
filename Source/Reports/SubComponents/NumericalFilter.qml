import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents"
import "../SubComponents/MiniSubComponents"

Popup {
    id: numericalFilterPopup
    width: parent.width
    height: parent.height
    x: 0
    y: 0
    modal: true
    visible: false
    padding: 0
    closePolicy: Popup.NoAutoClose
    background: Rectangle{
        color: Constants.themeColor
        border.color: Constants.darkThemeColor
    }



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
    signal signalNumericalEditData(string relation, string sug, string value)

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


    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    Component.onCompleted: {
        numericalFilterPopup.signalNumericalEditData.connect(topContent.slotEditModeNumerical)

        numericalFilterPopup.clearData.connect(topContent.slotDataCleared)
    }
    // SLOT function
    function slotEditMode(section, category, subCategory, relation, slug, value){

        if(section === Constants.numericalTab){

            topContent.visible = true
            numericalFilterPopup.signalNumericalEditData(relation, slug, value)
        }
    }


    function closePopup(){
        numericalFilterPopup.visible = false
        ReportParamsModel.clearFilter()
    }

    function onCancelClicked(){
        closePopup()
        ReportParamsModel.clearFilter();
    }

    function onApplyClicked(){

        console.log("Numerical filter applied")

        numericalFilterPopup.visible = false

        var filterIndex = ReportParamsModel.filterIndex
        var section = ReportParamsModel.section
        var category = ReportParamsModel.category
        var subCategory = ReportParamsModel.subCategory
        var tableName = ReportParamsModel.tableName
        var columnName = ReportParamsModel.colName
        var joinRelation = ReportParamsModel.fetchFilterRelationMap(counter)
        var joinValue = ReportParamsModel.fetchFilterValueMap(counter)
        var joinSlug = ReportParamsModel.fetchFilterSlugMap(counter)
        var includeNull = ReportParamsModel.includeNull
        var exclude = ReportParamsModel.exclude

        var singleValue = "";
        var singleRelation = "";
        var singleSlug = "";


        singleRelation = joinRelation[counter]
        singleValue = joinValue[counter]
        singleSlug = joinSlug[counter]
        manageFilters(ReportParamsModel.mode, section, category, subCategory, tableName, columnName, singleRelation, singleSlug, singleValue, includeNull, exclude, counter, ReportParamsModel.filterModelIndex)

//        ReportParamsModel.setMode(Constants.modeCreate)

        // Reset all DSParams
        ReportParamsModel.clearFilter();

        // Clear tabs individual temp data
        dateFilterPopup.clearData()

    }

    function manageFilters(mode, section, category, subCategory, tableName, columnName, relation, slug, value, includeNull, exclude, counter = 0, filterId = 0){

        console.log("INSERT INTO NUMERICAL FILTERS")
        console.log("Filter insert numerical", mode, section, category, subCategory, tableName, columnName, relation, slug, value, includeNull, exclude, filterId)

//        // Save the filter
//        if(mode === Constants.modeCreate){
//            FilterNumericalListModel.newFilter(counter, section, category, subCategory, tableName, columnName, relation, slug, value, includeNull, exclude)

//        } else{
//            FilterNumericalListModel.updateFilter(filterId, section, category, subCategory, tableName, columnName, relation, slug, value, includeNull, exclude)
//        }
    }



    function onResetClicked(){
        closePopup()
    }


    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



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
            text: "Numerical Data Filter"
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

                    closePopup()

                }
            }
        }

    }

    // Popup Header ends

    //    Top Menu Contents

    NumericalFilterInnerPopup{
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

        color: "transparent"

        CustomButton{
            id: resetBtn
            textValue:  "Reset"

            anchors.left: parent.left
            anchors.leftMargin: 20

            onClicked: {

                onResetClicked()
            }
        }



        CustomButton{
            id: apply_btn1
            textValue:  "Apply"

            anchors.right: parent.right
            anchors.rightMargin: 20


            onClicked: {

                onApplyClicked()

            }
        }


        CustomButton{
            id: cancel_btn1

            anchors.right: apply_btn1.left
            anchors.rightMargin: 20

            textValue: "Cancel"
            onClicked: {
                onCancelClicked()
            }


        }


    }

    // Footer ends

    // Page Design Ends
    /***********************************************************************************************************************/


}
