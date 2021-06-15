import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents"
import "./MiniSubComponents"

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
    background: Rectangle{
        color: Constants.themeColor
        border.color: Constants.darkThemeColor
    }

    property int filterIndex: 0
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
    }

    Connections{
        target: ChartsModel

        function onColumnDataChanged(columnData, options){

            if(options !== ""){

                var jsonOptions = JSON.parse(options)
                if(jsonOptions.section === Constants.categoricalTab){

                    switch(jsonOptions.category){
                    case Constants.categoryMainListType:

                        listContentReport.visible = true
                        wildcardContentReport.visible = false
                        topContentReport.visible = false

                        listRadio.checked = true

                        break

                    case Constants.categoryMainWildCardType:

                        listContentReport.visible = false
                        wildcardContentReport.visible = true
                        topContentReport.visible = false

                        wildcardRadio.checked = true

                        break

                    case Constants.categoryMainTopType:

                        listContentReport.visible = false
                        wildcardContentReport.visible = false
                        topContentReport.visible = true

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
        categoricalFilterPopup.clearData.connect(listContentReport.slotDataCleared)
        categoricalFilterPopup.clearData.connect(wildcardContentReport.slotDataCleared)
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


        switch(category){

        case Constants.categoryMainListType:

            ReportParamsModel.addToFilterSectionMap(counter, section)
            ReportParamsModel.addToFilterCategoryMap(counter, category)
            ReportParamsModel.addToFilterSubCategoryMap(counter, subCategory)
            ReportParamsModel.addToFilterColumnMap(counter, columnName, tableName)
            ReportParamsModel.addToCategoricalFilters(counter)

            manageFilters(ReportParamsModel.mode, counter, ReportParamsModel.filterModelIndex)
            break

        case Constants.categoryMainWildCardType:

            for(let i = 0; i < tmpFilterIndexes.length; i++){
                let fi = tmpFilterIndexes[i]


                ReportParamsModel.addToFilterSectionMap(fi, section)
                ReportParamsModel.addToFilterCategoryMap(fi, category)
                ReportParamsModel.addToFilterSubCategoryMap(fi, subCategory)
                ReportParamsModel.addToFilterColumnMap(fi, columnName, tableName)
                ReportParamsModel.addToCategoricalFilters(fi)

                manageFilters(ReportParamsModel.mode, fi, ReportParamsModel.filterModelIndex)
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

    function manageFilters(mode, counter = 0, filterId = 0){

        console.log("Filter insert categorical - INSERT REPORT ID", mode, counter, filterId)
        ReportParamsModel.addToMasterReportFilters(Constants.uniqueReportId);
    }

    function onResetClicked(){
        categoricalFilterPopup.visible = false
        ReportParamsModel.clearFilter()

        // Clear tabs individual temp data
        categoricalFilterPopup.clearData()
    }

    function onListClicked(){

        listContentReport.visible = true
        wildcardContentReport.visible = false
        topContentReport.visible = false

        // Set the main category of the filter
        ReportParamsModel.clearFilter()
        ReportParamsModel.setCategory(Constants.categoryMainListType)
    }


    function onWildcardClicked(){

        listContentReport.visible = false
        wildcardContentReport.visible = true
        topContentReport.visible = false

        // Set the main category of the filter
        ReportParamsModel.clearFilter();
        ReportParamsModel.setCategory(Constants.categoryMainWildCardType)

    }


    function onTopClicked(){

        listContentReport.visible = false
        wildcardContentReport.visible = false
        topContentReport.visible = true

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
        id: listContentReport
    }

    CategoricalFilterWildcardContent{
        id: wildcardContentReport
    }

    CategoricalFilterTopContent{
        id: topContentReport
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
