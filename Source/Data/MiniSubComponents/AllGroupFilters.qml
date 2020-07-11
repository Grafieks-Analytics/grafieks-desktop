import QtQuick 2.11

import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents"

Row{
    width: parent.width
    y:10
    anchors.left: parent.left
    anchors.leftMargin: 20
    property int rowSpacing: 8

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

    ListView{
        model:groupModel
        anchors.top: parent.top
        width: parent.width
        height: 500
        anchors.topMargin: 10


        delegate:

        Row{
            height: parent.height
            width: parent.width

            Column{
                id: listFiltersColumn
                anchors.left: parent.left
                width: parent.width
                height:listFiltersListView.height + listFilters.height

                Text {
                    id: listFilters
                    text: qsTr(groupName)
                    font.pointSize: Constants.fontReading
                }


                ListModel{
                    id: listModel
                    ListElement{
                        columnName:"Customer Name"
                        filterKey:"Equals"
                        columnValue:"Hirak Kocharee, Chilarai"
                    }
                    ListElement{
                        columnName:"PO Number"
                        filterKey:"Exlcudes"
                        columnValue:"ABC123, BCD987, GHF5"
                    }
                }

                ListView{
                    id: listFiltersListView
                    model: filterObject
                    width: parent.width
                    height: filterObject.count * 30
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
                                text: filterKey
                                anchors.left: parent.left
                                leftPadding: 20
                                anchors.verticalCenter: parent.verticalCenter
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


                            Row{

                                width: parent.width
                                anchors.top: parent.top
                                anchors.right: parent.right
                                anchors.topMargin: 15
                                anchors.leftMargin: 10


                                Image{
                                    id: editBtn
                                    source: '../../../Images/icons/Edit_20.png'
                                    anchors.top: parent.parent.top
                                    anchors.left: parent.left
                                    anchors.leftMargin: 20

                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Image{
                                    id: removeBtn
                                    source: '../../../Images/icons/remove.png'
                                    anchors.left: editBtn.right
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.leftMargin: 10
                                }

                            }

                        }
                    }


                }
            }

        }
    }
}
