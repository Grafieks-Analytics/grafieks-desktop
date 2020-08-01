import QtQuick 2.15

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

Rectangle{
    width: parent.width
    y:10
    anchors.left: parent.left
    anchors.leftMargin: 20
    anchors.top: parent.top
    anchors.topMargin: 40

    property int rowSpacing: 8


    /***********************************************************************************************************************/
    // LIST MODELS STARTS


    ListModel{
        id: listModel
        ListElement{
            columnName:"Revenue"
            filterKey:"Equal or Greater Than"
            columnValue:"1300"
        }
        ListElement{
            columnName:"Revenue"
            filterKey:"Equal or Greater Than"
            columnValue:"1300"
        }

    }

    ListModel{
        id: multipleValueModel
        ListElement{
            columnName:"Requested Ship Date"
            filterKey:"Between"
            fromValue:"100"
            toValue:"500"
        }

        ListElement{
            columnName:"Requested Ship Date"
            filterKey:"Between"
            fromValue:"100"
            toValue:"500"
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




    // Two Columns here
    // 1. for all the single values
    // 2. for all the 2 values -> "between case"

    // Single Value List Starts

    Column{
        id: listFiltersColumn

        anchors.left: parent.left
        width: parent.width
        height:filtersListView.height

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

    // Single Value List Ends

    // Between Case Value List Starts

    Column{
        id: multipleValueFiltersColumn

        width: parent.width
        height:multipleValueFiltersListView.height

        anchors.left: parent.left
        anchors.top: listFiltersColumn.bottom
        anchors.topMargin: 20


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

                    }

                }


                Column{
                    height: 30
                    width: (parent.width / 3 - 60)/2

                    ReadOnlyTextBox{
                        boxWidth: parent.width
                        text: fromValue
                    }
                }


                Column{
                    height: 30
                    width: 30

                    Text {
                        id: name
                        text: qsTr("To")
                        anchors.left: parent.left
                    }
                }

                Column{
                    height: 30
                    width: (parent.width / 3 - 60)/2

                    ReadOnlyTextBox{
                        boxWidth: parent.width
                        text: toValue
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


        // Between Case Value List Ends

    }


    // Page Design Ends
    /***********************************************************************************************************************/

}
