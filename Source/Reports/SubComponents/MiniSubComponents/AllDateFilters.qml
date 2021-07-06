import QtQuick 2.15
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

Rectangle{
    id: allDateId
    y:10
    width: parent.width
    anchors.left: parent.left
    property int rowSpacing: 8

    readonly property int mapKey: 0
    property var listViewModel: []


    /***********************************************************************************************************************/
    // LIST MODELS STARTS


    // LIST MODELS ENDS
    /***********************************************************************************************************************/


    /***********************************************************************************************************************/
    // SIGNALS STARTS

    signal removeFromListModel(int refObjId)

    // SIGNALS ENDS
    /***********************************************************************************************************************/



    /***********************************************************************************************************************/
    // Connections Starts

//    Connections{
//        target: FilterDateListModel

//        // Listview height
//        function onRowCountChanged(){
//            listFiltersListView.height = FilterDateListModel.rowCount() * 40
//        }
//    }

    Connections{
        target: ReportParamsModel

        // Listview height
        function onDateFilterChanged(filterList){

            var newModel = []
            listFiltersListView.model = newModel

            filterList.forEach((item) => {
                                   newModel.push(item)
                               })

            listViewModel = newModel

            listFiltersListView.height = listViewModel.length * 40
            listFiltersListView.model = listViewModel

        }
    }
    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    // Called when remove filter from date list clicked
    function onRemoveElement(filterIndex){
        console.log("REMOVE", filterIndex, ReportParamsModel.reportId, Constants.dateTab)
        ReportParamsModel.removeFilter(filterIndex, ReportParamsModel.reportId, Constants.dateTab)
    }

    // Called when edit filter from date list clicked
    function onEditElement(modelIndex, filterIndex){

        ReportParamsModel.setMode(Constants.modeEdit)
        ReportParamsModel.setColName(ReportParamsModel.fetchFilterColumnMap(filterIndex)[0])
        ReportParamsModel.setSection(ReportParamsModel.fetchFilterSectionMap(filterIndex)[0])
        ReportParamsModel.setCategory(ReportParamsModel.fetchFilterCategoryMap(filterIndex)[0])
        ReportParamsModel.setSubCategory(ReportParamsModel.fetchFilterSubCategoryMap(filterIndex)[0])
        ReportParamsModel.setInternalCounter(filterIndex)
        ReportParamsModel.setFilterIndex(filterIndex)
        ReportParamsModel.setFilterModelIndex(filterIndex)

        var options = {
            "section" : ReportParamsModel.fetchFilterSectionMap(filterIndex)[0],
            "category" : ReportParamsModel.fetchFilterCategoryMap(filterIndex)[0],
            "subCategory" : ReportParamsModel.fetchFilterSubCategoryMap(filterIndex)[0],
            "values" : ReportParamsModel.fetchFilterValueMap(filterIndex)[filterIndex],
            "relation" : ReportParamsModel.fetchFilterRelationMap(filterIndex)[0],
            "slug" : ReportParamsModel.fetchFilterSlugMap(filterIndex)[0]

        }

        //        QueryDataModel.columnData(columnName, tableName, JSON.stringify(options))
        ReportsDataModel.fetchColumnData(ReportParamsModel.fetchFilterColumnMap(filterIndex)[0], JSON.stringify(options))
        console.log("EDIT CLICKED date", ReportParamsModel.fetchFilterColumnMap(filterIndex),ReportParamsModel.fetchFilterCategoryMap(filterIndex)[0], filterIndex, modelIndex, ReportParamsModel.fetchFilterCategoryMap(filterIndex)[0])


    }
    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts


    // Three Columns here
    // 1. for List - list view
    // 2. for Calendar - list view
    // 3. for Time Frame - list view

    Flickable{
        width: parent.width
        anchors.left: parent.left
        height: 100

        // List - list view Starts

        Column{
            id: listFiltersColumn

            anchors.left: parent.left
            anchors.leftMargin: 20
            width: parent.width
            height:listFiltersListView.height

            spacing: 10


            ListView{
                id: listFiltersListView
                width: parent.width
                anchors.topMargin: 10
                spacing: rowSpacing
                interactive: false



                delegate:

                    Row{
                    id:listFiltersContent
                    height: 30
                    width: parent.width

                    anchors.topMargin: 30

                    Column{
                        height: 30
                        width: parent.width / 3 - 25

                        ReadOnlyTextBox{
                            boxWidth: parent.width
                            text: ReportParamsModel.fetchFilterColumnMap(modelData)[0]
                        }
                    }


                    Column{
                        height: 30
                        width: parent.width / 3 - 50

                        Text {
                            text: ReportParamsModel.fetchIncludeExcludeMap(modelData)[0] === true ? "NOT " + ReportParamsModel.fetchFilterSlugMap(modelData)[0] : ReportParamsModel.fetchFilterSlugMap(modelData)[0]
                            anchors.left: parent.left
                            leftPadding: 20

                        }

                    }


                    Column{
                        height: 30
                        width: parent.width / 3 - 25

                        ReadOnlyTextBox{
                            boxWidth: parent.width
                            text: ReportParamsModel.fetchFilterValueMap(modelData)[modelData][0]
                        }
                    }

                    Column{

                        width: 100
                        anchors.right: parent.right


                        Rectangle{

                            width: parent.width
                            anchors.top: parent.top
                            anchors.right: parent.right
                            anchors.leftMargin: 10

                            Image{
                                id: editBtn
                                source: '/Images/icons/Edit_20.png'

                                anchors.top: parent.top
                                anchors.topMargin: 5
                                anchors.left: parent.left
                                anchors.leftMargin: 20

                                anchors.verticalCenter: Image.verticalCenter

                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: {
                                        onEditElement(model.index, modelData)
                                    }
                                }
                            }

                            Image{
                                id: removeBtn
                                source: '/Images/icons/remove.png'

                                anchors.top: parent.top
                                anchors.left: editBtn.right
                                anchors.topMargin: 8
                                anchors.leftMargin: 10
                                anchors.verticalCenter: Image.verticalCenter

                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: {
                                        onRemoveElement(modelData)
//                                        if(category === "date.timeframe"){
//                                            ReportParamsModel.removeDateFormatMap(value)
//                                        }
//                                        if(category === "date.list"){
////                                            ReportParamsModel.removeTimeFrame(value)
//                                        }

//                                        onRemoveElement(model.index)

                                    }
                                }
                            }
                        }
                    }
                }
            }
        }


        // List - list view Ends



        ScrollBar.horizontal: ScrollBar{}
        ScrollBar.vertical: ScrollBar{}

        ScrollBar {
            id: vbar
            hoverEnabled: true
            active: hovered || pressed
            orientation: Qt.Vertical
            size: parent.height / 2
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom
        }

        ScrollBar {
            id: hbar
            hoverEnabled: true
            active: hovered || pressed
            orientation: Qt.Horizontal
            size: parent.width / 2
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
        }


        ScrollIndicator.horizontal: ScrollIndicator { }
        ScrollIndicator.vertical: ScrollIndicator { }

    }


    // Page Design Ends
    /***********************************************************************************************************************/

}

