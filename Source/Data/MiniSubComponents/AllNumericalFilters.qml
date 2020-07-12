import QtQuick 2.11

import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents"

Row{
    width: parent.width
    y:10
    anchors.left: parent.left
    anchors.leftMargin: 20
    anchors.top: parent.top
    anchors.topMargin: 40

    property int rowSpacing: 8

    Column{
        id: listFiltersColumn

        anchors.left: parent.left
        width: parent.width
        height:filtersListView.height

        ListModel{
            id: listModel
            ListElement{
                columnName:"Revenue"
                filterKey:"Equal or Greater Than"
                columnValue:"1300"
            }

        }

        ListView{
            id: filtersListView
            model: listModel
            width: parent.width
            height: listModel.count * 30
            anchors.topMargin: 30
            spacing: rowSpacing

            delegate:

                Row{
                id:filtersContent
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

    Column{
        id: multipleValueFiltersColumn

        width: parent.width
        height:multipleValueFiltersListView.height + multipleValueHeading.height

        anchors.left: parent.left
        anchors.top: listFiltersColumn.bottom
        anchors.topMargin: 20

        ListModel{
            id: multipleValueModel
            ListElement{
                columnName:"Requested Ship Date"
                filterKey:"Between"
                fromValue:"100"
                toValue:"500"
            }
        }


        ListView{
            id: multipleValueFiltersListView
            model: multipleValueModel
            width: parent.width
            height: multipleValueModel.count * 30
            anchors.topMargin: 10
            spacing: rowSpacing

            delegate:

                Row{
                id:multipleValueFiltersContent
                height: 30
                width: parent.width

                anchors.top:multipleValueFiltersColumn.top
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
                            id: editBtnmultipleValue
                            source: '../../../Images/icons/Edit_20.png'
                            anchors.top: parent.parent.top
                            anchors.left: parent.left
                            anchors.leftMargin: 20

                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Image{
                            source: '../../../Images/icons/remove.png'
                            anchors.left: editBtnmultipleValue.right
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.leftMargin: 10
                        }

                    }

                }
            }


        }


    }

}
