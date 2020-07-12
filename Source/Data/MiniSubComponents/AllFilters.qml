import QtQuick 2.11
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents"

Row{
    width: parent.width
    y:10
    anchors.left: parent.left
    anchors.leftMargin: 20

    property int rowSpacing: 8

    Flickable{
        width: parent.width
        anchors.left: parent.left
        height: 100

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
                    columnName:"Customer Name"
                    filterKey:"Equals"
                    columnValue:"Hirak Kocharee, Chilarai"
                }
                ListElement{
                    columnName:"PO Number"
                    filterKey:"Exlcudes"
                    columnValue:"ABC123, BCD987, GHF5"
                }

                ListElement{
                    columnName:"PO Number"
                    filterKey:"Exlcudes"
                    columnValue:"ABC123, BCD987, GHF5"
                }
                ListElement{
                    columnName:"PO Number"
                    filterKey:"Exlcudes"
                    columnValue:"ABC123, BCD987, GHF5"
                }
                ListElement{
                    columnName:"PO Number"
                    filterKey:"Exlcudes"
                    columnValue:"ABC123, BCD987, GHF5"
                }
            }

            ListView{
                id: listFiltersListView
                model: listModel
                width: parent.width
                height: listModel.count * (30 + rowSpacing)
                anchors.top: listFilters.bottom
                anchors.topMargin: 10
                spacing: rowSpacing
                interactive: false

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
            id: wildcardFiltersColumn

            width: parent.width
            height:wildcardFiltersListView.height + wildcardHeading.height

            anchors.left: parent.left
            anchors.top: listFiltersColumn.bottom
            anchors.topMargin: 20

            Text {
                id: wildcardHeading
                text: qsTr("Wildcard")
                font.pointSize: Constants.fontReading
            }

            ListModel{
                id: wildcardModel
                ListElement{
                    columnName:"Customer Name"
                    filterKey:"Doesn't Start With"
                    columnValue:"ab"
                }
            }


            ListView{
                id: wildcardFiltersListView
                model: wildcardModel
                width: parent.width
                height: wildcardModel.count * 30
                anchors.top: wildcardHeading.bottom
                anchors.topMargin: 10
                interactive: false
                spacing: rowSpacing

                delegate:

                    Row{
                    id:wildcardFiltersContent
                    height: 30
                    width: parent.width

                    anchors.top:wildcardFiltersColumn.top
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
                                id: editBtnWildcard
                                source: '../../../Images/icons/Edit_20.png'
                                anchors.top: parent.parent.top
                                anchors.left: parent.left
                                anchors.leftMargin: 20

                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Image{
                                source: '../../../Images/icons/remove.png'
                                anchors.left: editBtnWildcard.right
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.leftMargin: 10
                            }

                        }

                    }
                }


            }


        }


        Column{
            id: topFiltersColumn

            width: parent.width
            height:topFiltersListView.height + topHeading.height

            anchors.left: parent.left
            anchors.top: wildcardFiltersColumn.bottom
            anchors.topMargin: 20


            Text {
                id: topHeading
                text: qsTr("Top")
                font.pointSize: Constants.fontReading
            }

            ListModel{
                id: topModel
                ListElement{
                    columnName:"Customer Name"
                    filterKey:"Top 50 by"
                    columnValue:"Sales Order Unit"
                }
            }


            ListView{
                id: topFiltersListView
                model: wildcardModel
                width: parent.width
                height: topModel.count * 30
                anchors.top: topHeading.bottom
                anchors.topMargin: 10
                spacing: rowSpacing
                interactive: false

                delegate:

                    Row{
                    id:topFiltersContent
                    height: 30
                    width: parent.width

                    anchors.top:topFiltersColumn.top
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
                                id: editBtnTop
                                source: '../../../Images/icons/Edit_20.png'
                                anchors.top: parent.parent.top
                                anchors.left: parent.left
                                anchors.leftMargin: 20

                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Image{
                                source: '../../../Images/icons/remove.png'
                                anchors.left: editBtnTop.right
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.leftMargin: 10
                            }

                        }

                    }
                }


            }


        }


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
}
