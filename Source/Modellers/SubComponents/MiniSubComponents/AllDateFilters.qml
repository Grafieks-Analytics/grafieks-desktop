import QtQuick 2.11

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

Rectangle{
    width: parent.width
    y:10
    anchors.left: parent.left
    anchors.leftMargin: 20
    property int rowSpacing: 8

    ListModel{
        id: timeFrameModel
        ListElement{
            columnName:"GR Date"
            filterKey:"Last"
            columnValue:"3 Months"
        }
    }


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

    ListModel{
        id: calendarModel
        ListElement{
            columnName:"Requested Ship Date"
            filterKey:"Between"
            dateFrom:"ab"
            dateTo:"ab"
        }
    }

    // All List Filter Starts

    Column{
        id: listFiltersColumn

        anchors.left: parent.left
        width: parent.width
        height:listFiltersListView.height + listFilters.height

        Text {
            id: listFilters
            text: qsTr("List")
            font.pointSize: Constants.fontReading
        }

        ListView{
            id: listFiltersListView
            model: listModel
            width: parent.width
            height: listModel.count * 30

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


    // All Calendar Filter Ends

    // All Calendar Filter Starts

    Column{
        id: calendarFiltersColumn

        width: parent.width
        height:calendarFiltersListView.height + calendarHeading.height

        anchors.left: parent.left
        anchors.top: listFiltersColumn.bottom
        anchors.topMargin: 20

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
                            source: '../../../../Images/icons/Edit_20.png'

                            anchors.top: parent.top
                            anchors.topMargin: 5
                            anchors.left: parent.left
                            anchors.leftMargin: 20

                            anchors.verticalCenter: Image.verticalCenter
                        }

                        Image{
                            id: removeBtn1
                            source: '../../../../Images/icons/remove.png'

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
                            source: '../../../../Images/icons/Edit_20.png'

                            anchors.top: parent.top
                            anchors.topMargin: 5
                            anchors.left: parent.left
                            anchors.leftMargin: 20

                            anchors.verticalCenter: Image.verticalCenter
                        }

                        Image{
                            id: removeBtn2
                            source: '../../../../Images/icons/remove.png'

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

}
