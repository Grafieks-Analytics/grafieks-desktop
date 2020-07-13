import QtQuick 2.11

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

Row{
    width: parent.width
    y:10
    anchors.left: parent.left
    anchors.leftMargin: 20
    property int rowSpacing: 8

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

        ListView{
            id: listFiltersListView
            model: listModel
            width: parent.width
            height: listModel.count * 30
            anchors.top: listFilters.bottom
            anchors.topMargin: 10
            spacing: rowSpacing

            delegate:

            Row{
                id:listFiltersContent
                height: 30
                width: parent.width

                anchors.top:listFilters.top
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

        ListModel{
            id: calendarModel
            ListElement{
                columnName:"Requested Ship Date"
                dateFrom:"ab"
                dateTo:"ab"
            }
        }


        ListView{
            id: calendarFiltersListView
            model: calendarModel
            width: parent.width
            height: calendarModel.count * 30
            anchors.top: calendarHeading.bottom
            anchors.topMargin: 10
            spacing: rowSpacing

            delegate:

            Row{
                id:calendarFiltersContent
                height: 30
                width: parent.width

                anchors.top:calendarFiltersColumn.top
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
                        text: dateFrom
                        anchors.left: parent.left
                        leftPadding: 20
                        anchors.verticalCenter: parent.verticalCenter
                    }

                }


                Column{
                    height: 30
                    width: (parent.width / 3 - 60)/2

                    ReadOnlyTextBox{
                        boxWidth: parent.width
                        text: columnValue
                    }
                }


                Column{
                    height: 30
                    width: 30

                    Text {
                        id: name
                        text: qsTr("To")
                        anchors.left: parent.left
                        anchors.centerIn: parent
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


                    Row{

                        width: parent.width
                        anchors.top: parent.top
                        anchors.right: parent.right
                        anchors.topMargin: 15
                        anchors.leftMargin: 10


                        Image{
                            id: editBtncalendar
                            source: '../../../Images/icons/Edit_20.png'
                            anchors.top: parent.parent.top
                            anchors.left: parent.left
                            anchors.leftMargin: 20

                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Image{
                            source: '../../../Images/icons/remove.png'
                            anchors.left: editBtncalendar.right
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.leftMargin: 10
                        }

                    }

                }
            }


        }


    }

    Column{
        id: timeFrameFiltersColumn

        width: parent.width
        height:timeFrameFiltersListView.height + timeFrameHeading.height

        anchors.left: parent.left
        anchors.top: calendarFiltersColumn.bottom
        anchors.topMargin: 20

        Text {
            id: timeFrameHeading
            text: qsTr("Time Frame")
            font.pointSize: Constants.fontReading
        }

        ListModel{
            id: timeFrameModel
            ListElement{
                columnName:"GR Date"
                filterKey:"Last"
                columnValue:"3 Months"
            }
        }


        ListView{
            id: timeFrameFiltersListView
            model: timeFrameModel
            width: parent.width
            height: timeFrameModel.count * 30
            anchors.top: timeFrameHeading.bottom
            anchors.topMargin: 10
            spacing: rowSpacing

            delegate:

            Row{
                id:timeFrameFiltersContent
                height: 30
                width: parent.width

                anchors.top:timeFrameFiltersColumn.top
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
                            id: editBtnTimeFrame
                            source: '../../../Images/icons/Edit_20.png'
                            anchors.top: parent.parent.top
                            anchors.left: parent.left
                            anchors.leftMargin: 20

                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Image{
                            source: '../../../Images/icons/remove.png'
                            anchors.left: editBtnTimeFrame.right
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.leftMargin: 10
                        }

                    }

                }
            }


        }


    }

}
