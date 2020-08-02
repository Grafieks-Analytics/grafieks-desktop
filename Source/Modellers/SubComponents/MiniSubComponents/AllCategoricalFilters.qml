import QtQuick 2.15
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

Rectangle{
    y:10
    width: parent.width

    property int rowSpacing: 8


    /***********************************************************************************************************************/
    // LIST MODELS STARTS


    ListModel{
        id: listModel

    }
    ListModel{
        id: wildcardModel
        ListElement{
            columnName:"Customer Name"
            filterKey:"Doesn't Start With"
            columnValue:"ab"
        }
    }

    ListModel{
        id: topModel
        ListElement{
            columnName:"Customer Name"
            filterKey:"Top 50 by"
            columnValue:"Sales Order Unit"
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

    function onRemoveListElement(){
        console.log('Remove List Element')
    }

    function onEditListElement(){

    }


    function onRemoveWildcardElement(){

    }
    function onEditWildcardElement(){

    }


    function onRemoveTopElement(){

    }
    function onEditTopElement(){

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
    // 2. for Wildcard - list view
    // 3. for Top - list view

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
            height:listFiltersListView.height + listFilters.height

            spacing: 10

            Text {
                id: listFilters
                text: qsTr("List")
                font.pointSize: Constants.fontReading
            }


            ListView{
                id: listFiltersListView
                model: FilterListModel
                width: parent.width
                height: listModel.count * (30 + rowSpacing)
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
                            text: exclude === true ? "NOT " +relation : relation
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
                                source: '../../../../Images/icons/Edit_20.png'

                                anchors.top: parent.top
                                anchors.topMargin: 5
                                anchors.left: parent.left
                                anchors.leftMargin: 20

                                anchors.verticalCenter: Image.verticalCenter

                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: {
                                        onEditListElement()
                                    }
                                }
                            }

                            Image{
                                id: removeBtn
                                source: '../../../../Images/icons/remove.png'

                                anchors.top: parent.top
                                anchors.left: editBtn.right
                                anchors.topMargin: 8
                                anchors.leftMargin: 10
                                anchors.verticalCenter: Image.verticalCenter

                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: {
                                        onRemoveListElement()
                                    }
                                }

                            }

                        }

                    }
                }


            }
        }


        // List - list view Ends


        // Wildcard - list view Starts


        Column{
            id: wildcardFiltersColumn

            width: parent.width
            height:wildcardFiltersListView.height + wildcardHeading.height

            anchors.left: parent.left
            anchors.leftMargin: 20

            anchors.top: listFiltersColumn.bottom
            anchors.topMargin: 20

            spacing: 10

            Text {
                id: wildcardHeading
                text: qsTr("Wildcard")
                font.pointSize: Constants.fontReading
            }



            ListView{
                id: wildcardFiltersListView
                model: wildcardModel
                width: parent.width
                height: wildcardModel.count * 30
                anchors.topMargin: 10
                interactive: false
                spacing: rowSpacing

                delegate:

                    Row{
                    id:wildcardFiltersContent
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
                                id: editBtn2
                                source: '../../../../Images/icons/Edit_20.png'

                                anchors.top: parent.top
                                anchors.topMargin: 5
                                anchors.left: parent.left
                                anchors.leftMargin: 20

                                anchors.verticalCenter: Image.verticalCenter

                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: {
                                        onEditWildcardElement()
                                    }
                                }
                            }

                            Image{
                                source: '../../../../Images/icons/remove.png'

                                anchors.top: parent.top
                                anchors.left: editBtn2.right
                                anchors.topMargin: 8
                                anchors.leftMargin: 10
                                anchors.verticalCenter: Image.verticalCenter

                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: {
                                        onRemoveWildcardElement()
                                    }
                                }

                            }

                        }

                    }
                }


            }


        }

        // Wildcard - list view Ends

        // Top - list view Starts

        Column{
            id: topFiltersColumn

            width: parent.width
            height:topFiltersListView.height + topHeading.height

            anchors.top: wildcardFiltersColumn.bottom
            anchors.topMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 20
            spacing: 10

            Text {
                id: topHeading
                text: qsTr("Top")
                font.pointSize: Constants.fontReading
            }

            ListView{
                id: topFiltersListView
                model: wildcardModel
                width: parent.width
                height: topModel.count * 30
                anchors.topMargin: 10
                spacing: rowSpacing
                interactive: false

                delegate:

                    Row{
                    id:topFiltersContent
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
                                id: editBtn3
                                source: '../../../../Images/icons/Edit_20.png'

                                anchors.top: parent.top
                                anchors.topMargin: 5
                                anchors.left: parent.left
                                anchors.leftMargin: 20

                                anchors.verticalCenter: Image.verticalCenter

                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: {
                                        onEditTopElement()
                                    }
                                }
                            }

                            Image{
                                source: '../../../../Images/icons/remove.png'

                                anchors.top: parent.top
                                anchors.left: editBtn3.right
                                anchors.topMargin: 8
                                anchors.leftMargin: 10
                                anchors.verticalCenter: Image.verticalCenter

                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: {
                                        onRemoveTopElement()
                                    }
                                }

                            }

                        }
                    }
                }


            }


        }

        // Top - list view Ends


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
