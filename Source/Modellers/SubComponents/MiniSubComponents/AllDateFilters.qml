import QtQuick 2.15
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

Rectangle{
    id : allDateId
    width: parent.width
    y:10
    anchors.left: parent.left
    anchors.leftMargin: 20
    property int rowSpacing: 8

    readonly property int mapKey: 0

    /***********************************************************************************************************************/
    // LIST MODELS STARTS

    /*
    ListModel{
        id: timeFrameModel
        ListElement{
            columnName:"GR Date"
            filterKey:"Last"
            columnValue:"3 Months"
        }
    }
    */

    /*
    ListModel{
        id: listModel
        ListElement{
            columnName:"Order Date"
            filterKey:"Equals"
            columnValue:"6 Jan 2018, 21 Apr 2018"
        }
        ListElement{
            columnName:"PO Request Date"
            filterKey:"Exlcudes"
            columnValue:"6 Jan 2018, 21 Apr 2018"
        }
    }

    */

    ListModel{
        id: calendarModel
        ListElement{
            columnName:"Requested Ship Date"
            filterKey:"Between"
            dateFrom:"ab"
            dateTo:"ab"
        }
    }



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
        target: FilterDateListModel

        // Listview height
        function onRowCountChanged(){
            listFiltersListView.height = FilterDateListModel.rowCount() * 30
        }
    }


    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS
    function onRemoveElement(filterIndex){
        FilterDateListModel.deleteFilter(filterIndex)
        DSParamsModel.removeJoinRelation(filterIndex)
        DSParamsModel.removeJoinValue(filterIndex)
    }

    // Called when edit filter from categorical list clicked
    function onEditElement(filterIndex, section, category, subCategory, tableName, columnName, relation, slug, value, includeNull, exclude){
        ColumnListModel.columnEditQuery(columnName, tableName, value)

        DSParamsModel.setMode(Constants.modeEdit)
        DSParamsModel.setFilterIndex(filterIndex)
        DSParamsModel.setSection(section)
        DSParamsModel.setCategory(category)
        DSParamsModel.setSubCategory(subCategory)
        DSParamsModel.setTableName(tableName)
        DSParamsModel.setColName(columnName)
        DSParamsModel.addToJoinRelation(mapKey, relation)
        DSParamsModel.addToJoinRelationSlug(mapKey, slug)
        DSParamsModel.addToJoinValue(mapKey, value)
        //DSParamsModel.setRelation(relation)
        DSParamsModel.setIncludeNull(includeNull)
        DSParamsModel.setExclude(exclude)
        DSParamsModel.setInternalCounter(1)

        ColumnListModel.columnEditQuery(columnName, tableName, value, category)
    }


    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts


    // All List Filter Starts

    Column{
        id: listFiltersColumn

        anchors.left: parent.left
        width: parent.width
        height:listFiltersListView.height + listFilters.height

        spacing: rowSpacing

        //        Text {
        //            id: listFilters
        //            text: qsTr("List")
        //            font.pointSize: Constants.fontReading
        //        }

        ListView{
            id: listFiltersListView
            model: FilterDateListModel
            width: parent.width
            height: 50

            anchors.topMargin: 10
            spacing: rowSpacing

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

                        text: exclude === true ? "NOT " +relation : relation
                        anchors.left: parent.left
                        leftPadding: 20
                        //anchors.verticalCenter: Text.verticalCenter

                    }
                    /*
                    Text {
                        text: filterKey
                        anchors.left: parent.left
                        leftPadding: 20

                    }
                    */

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
                                    onEditElement(model.index, section, category, subCategory, tableName, columnName, relation, slug, value, includeNull, exclude)
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


    // All Calendar Filter Ends

    // All Calendar Filter Starts

    Column{
        id: calendarFiltersColumn

        width: parent.width
        height:calendarFiltersListView.height + calendarHeading.height

        anchors.left: parent.left
        anchors.top: listFiltersColumn.bottom
        anchors.topMargin: 20
        spacing: rowSpacing

        Text {
            id: calendarHeading
            text: qsTr("Calendar")
            font.pointSize: Constants.fontReading
        }



        ListView{
            id: calendarFiltersListView
            model: calendarModel
            width: parent.width
            height: calendarModel.count * 30

            anchors.topMargin: 10
            spacing: rowSpacing

            delegate:

                Row{
                id:calendarFiltersContent
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
                        text: filterKey
                        //                        anchors.left: parent.left
                        leftPadding: 20
                        anchors.verticalCenter: Text.verticalCenter
                    }

                }


                Column{
                    height: 30
                    width: (parent.width / 3 - 60)/2

                    ReadOnlyTextBox{
                        boxWidth: parent.width
                        text: dateFrom
                    }
                }


                Column{
                    height: 30
                    width: 30

                    Text {
                        id: name
                        text: qsTr("To")
                        anchors.topMargin: 5
                    }
                }

                Column{
                    height: 30
                    width: (parent.width / 3 - 60)/2

                    ReadOnlyTextBox{
                        boxWidth: parent.width
                        text: dateTo
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
                            id: editBtn1
                            source: '/Images/icons/Edit_20.png'

                            anchors.top: parent.top
                            anchors.topMargin: 5
                            anchors.left: parent.left
                            anchors.leftMargin: 20

                            anchors.verticalCenter: Image.verticalCenter
                        }

                        Image{
                            id: removeBtn1
                            source: '/Images/icons/remove.png'

                            anchors.top: parent.top
                            anchors.left: editBtn1.right
                            anchors.topMargin: 8
                            anchors.leftMargin: 10
                            anchors.verticalCenter: Image.verticalCenter

                        }

                    }

                }
            }


        }


    }

    // All Calendar Filter End

    // All Time Frame Filter Starts

    Column{
        id: timeFrameFiltersColumn

        width: parent.width
        height:timeFrameFiltersListView.height + timeFrameHeading.height

        anchors.top: calendarFiltersColumn.bottom
        anchors.topMargin: 20

        spacing: rowSpacing

        Text {
            id: timeFrameHeading
            text: qsTr("Time Frame")
            font.pointSize: Constants.fontReading
        }


        ListView{
            id: timeFrameFiltersListView
            model: timeFrameModel
            width: parent.width
            height: timeFrameModel.count * 30

            anchors.topMargin: 20
            spacing: rowSpacing

            delegate:

                Row{
                id:timeFrameFiltersContent
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
                        text: filterKey
                        anchors.left: parent.left
                        leftPadding: 20
                        anchors.verticalCenter: Text.verticalCenter
                    }

                }


                Column{
                    height: 30
                    width: parent.width / 3 - 25

                    ReadOnlyTextBox{
                        boxWidth: parent.width
                        text: columnValue
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
                            id: editBtn2
                            source: '/Images/icons/Edit_20.png'

                            anchors.top: parent.top
                            anchors.topMargin: 5
                            anchors.left: parent.left
                            anchors.leftMargin: 20

                            anchors.verticalCenter: Image.verticalCenter
                        }

                        Image{
                            id: removeBtn2
                            source: '/Images/icons/remove.png'

                            anchors.top: parent.top
                            anchors.left: editBtn2.right
                            anchors.topMargin: 8
                            anchors.leftMargin: 10
                            anchors.verticalCenter: Image.verticalCenter

                        }

                    }

                }
            }


        }


    }

    // All Time Frame Filter Ends



    // Page Design Ends
    /***********************************************************************************************************************/

}
