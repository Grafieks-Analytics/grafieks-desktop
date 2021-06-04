import QtQuick 2.15
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

Rectangle{
    y:10
    width: parent.width
    anchors.left: parent.left
    property int rowSpacing: 8

    readonly property int mapKey: 0


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

    Connections{
        target: FilterNumericalListModel

        // Listview height
        function onRowCountChanged(){
            listFiltersListView.height = FilterNumericalListModel.rowCount() * 40
        }
    }
    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    // Called when remove filter from date list clicked
    function onRemoveElement(filterIndex){
        FilterNumericalListModel.deleteFilter(filterIndex)
        DSParamsModel.removeJoinRelation(filterIndex)
        DSParamsModel.removeJoinValue(filterIndex)
    }

    // Called when edit filter from date list clicked
    function onEditElement(modelIndex, filterIndex, section, category, subCategory, tableName, columnName, relation, slug, value, includeNull, exclude){

        DSParamsModel.setMode(Constants.modeEdit)
//        DSParamsModel.setFilterIndex(filterIndex)
        DSParamsModel.setInternalCounter(filterIndex)
        DSParamsModel.setFilterModelIndex(modelIndex)
        DSParamsModel.setSection(section)
        DSParamsModel.setCategory(category)
        DSParamsModel.setSubCategory(subCategory)
        DSParamsModel.setTableName(tableName)
        DSParamsModel.setColName(columnName)
//        DSParamsModel.addToJoinRelation(mapKey, relation)
//        DSParamsModel.addToJoinRelationSlug(mapKey, slug)
//        DSParamsModel.addToJoinValue(mapKey, value)
//        DSParamsModel.setIncludeNullMap(includeNull)
//        DSParamsModel.setExcludeMap(exclude)
//        DSParamsModel.setInternalCounter(1)

        var options = {
            "section" : section,
            "category" : category,
            "subCategory" : subCategory,
            "values" : value,
            "relation" : relation,
            "slug" : slug

        }

        QueryDataModel.columnData(columnName, tableName, JSON.stringify(options))
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
                model: FilterNumericalListModel
                width: parent.width
                height: 50
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
                            text: columnName
                        }
                    }


                    Column{
                        height: 30
                        width: parent.width / 3 - 50

                        Text {
                            text: exclude === true ? "NOT " + slug : slug
                            anchors.left: parent.left
                            leftPadding: 20

                        }

                    }


                    Column{
                        height: 30
                        width: parent.width / 3 - 25

                        ReadOnlyTextBox{
                            boxWidth: parent.width
                            text: value
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
                                        onEditElement(model.index, filterId, section, category, subCategory, tableName, columnName, relation, slug, value, includeNull, exclude)
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
                                        onRemoveElement(model.index)
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


