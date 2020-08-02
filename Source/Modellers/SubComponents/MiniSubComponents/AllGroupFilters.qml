import QtQuick 2.15

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

Row{
    id:allGroupFilter
    width: parent.width - 22
    y:10
    anchors.left: parent.left
    anchors.leftMargin: 20
    property int rowSpacing: 8


    /***********************************************************************************************************************/
    // LIST MODELS STARTS

    ListModel{
        id: groupModel
        ListElement{
            groupName : "Group 1"
            filterObject:  [
                ListElement{
                    columnName:"Country"
                    filterKey:"Equals 2"
                    columnValue:"USA, Canada 2"
                },
                ListElement{
                    columnName:"Country"
                    filterKey:"Equals 3"
                    columnValue:"USA, Canada 2"
                },
                ListElement{
                    columnName:"Country"
                    filterKey:"Equals 5"
                    columnValue:"USA, Inid 2"
                }
            ]
        }
        ListElement{
            groupName : "Group 2"
            filterObject:  [
                ListElement{
                    columnName:"Country 2"
                    filterKey:"Equals 2"
                    columnValue:"USA, Canada 2"
                },
                ListElement{
                    columnName:"Country"
                    filterKey:"Equals 3"
                    columnValue:"USA, Canada 2"
                }
            ]
        }
    }



    // LIST MODELS ENDS
    /***********************************************************************************************************************/


    /***********************************************************************************************************************/
    // SIGNALS STARTS



    // SIGNALS ENDS
    /***********************************************************************************************************************/



    /***********************************************************************************************************************/
    // Connections Starts



    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS



    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts




    ListView{
        model:groupModel
        anchors.top: parent.top
        width: allGroupFilter.width
        height: 500
        anchors.topMargin: 10
        spacing: rowSpacing

        delegate:

            Rectangle{

            height: filterObject.count * (40 + rowSpacing)
            width: allGroupFilter.width

            Column{
                id: listFiltersColumn
                anchors.left: parent.left
                width: parent.width
                height:listFiltersListView.height + listFilters.height

                spacing: rowSpacing

                Text {
                    id: listFilters
                    text: qsTr(groupName)
                    font.pointSize: Constants.fontReading
                }

                ListView{
                    id: listFiltersListView
                    model: filterObject
                    width: parent.width
                    height: filterObject.count * 30
                    anchors.topMargin: 10

                    spacing: rowSpacing

                    delegate:

                        Rectangle{
                        id:listFiltersContent
                        height: 30
                        width: parent.width

                        anchors.topMargin: 30

                        Column{
                            id: columnId
                            height: 30
                            width: parent.width / 3 - 25

                            ReadOnlyTextBox{
                                boxWidth: parent.width
                                text: columnName
                            }
                        }


                        Column{
                            id: filterKeyId
                            height: 30
                            width: parent.width / 3 - 50

                            anchors.left: columnId.right

                            Text {
                                text: filterKey
                                leftPadding: 20
                                topPadding: 7

                            }

                        }


                        Column{
                            id: valueContent
                            height: 30
                            width: parent.width / 3 - 25

                            anchors.left: filterKeyId.right

                            ReadOnlyTextBox{
                                boxWidth: parent.width
                                text: columnValue
                            }
                        }

                        Column{
                            id:btnsColumn
                            width: 100

                            anchors.left: valueContent.right

                            Rectangle{

                                width: parent.width -2
                                anchors.left: parent.left
                                anchors.leftMargin: 2
                                height: 20

                                Image{
                                    id: editBtn
                                    source: '../../../../Images/icons/Edit_20.png'

                                    anchors.top: parent.top
                                    anchors.topMargin: 5
                                    anchors.left: parent.left
                                    anchors.leftMargin: 20

                                    anchors.verticalCenter: Image.verticalCenter
                                }

                                Image{
                                    id: removeBtn
                                    source: '../../../../Images/icons/remove.png'

                                    anchors.top: parent.top
                                    anchors.left: editBtn.right
                                    anchors.topMargin: 8
                                    anchors.leftMargin: 10
                                    anchors.verticalCenter: Image.verticalCenter

                                }

                            }

                        }
                    }


                }
            }

        }
    }


    // Page Design Ends
    /***********************************************************************************************************************/

}
