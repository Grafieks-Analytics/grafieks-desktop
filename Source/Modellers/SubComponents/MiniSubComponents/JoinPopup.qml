import QtQuick 2.0
import QtQuick.Controls 2.15

import "../../SubComponents"
import "../../../MainSubComponents"

import com.grafieks.singleton.constants 1.0

Rectangle{
    anchors.right:parent.right
    anchors.bottom: parent.bottom
    height:parent.height + 1
    width: 400
    z:10
    border.color: Constants.darkThemeColor
    visible: false



    /***********************************************************************************************************************/
    // LIST MODEL STARTS

    // LIST MODEL ENDS
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


    function closePopup(){
        joinPopup.visible = false
    }

    function onJoinChanged(){
        console.log('Join Calls')
    }

    function addKeyToList(){
        console.log('Add Key')
    }

    function onDoneClicked(){
        joinPopup.visible = false
    }

    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



    ButtonGroup{
        id: joinBtnGroup
    }



    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts



    // Page Design Ends
    /***********************************************************************************************************************/


    // header starts

    Rectangle{
        id: headerPopup

        color: Constants.lightThemeColor
        border.color: Constants.darkThemeColor
        height: 30
        width: parent.width

        Text{
            id : title
            text: "Relationship"
            anchors.centerIn: parent
            anchors.left : parent.left
            anchors.leftMargin: 10

        }
        Image {
            id: closeBtn
            source: "../../../../Images/icons/outline_close_black_18dp2x.png"
            anchors.verticalCenter: parent.verticalCenter
            anchors.right:  parent.right
            height: 18
            width: 18
            anchors.rightMargin: 5
            MouseArea{
                anchors.fill: parent
                onClicked: closePopup()
            }
        }

    }

    // header ends

    // Select Option

    Row{
        id: selectJoin
        anchors.top: headerPopup.bottom
        height: 80
        width: parent.width

        Column{
            width: parent.width/4
            height: parent.height
            anchors.top: parent.top
            anchors.topMargin: 5

            CustomRadioDelegate{
                checked: true
                width: 90
                height: 90

                ButtonGroup.group:joinBtnGroup
                onCheckedChanged: {
                    onJoinChanged()
                }
                contentItem: Image {
                    source: "../../../../Images/icons/Inner.png"
                    width: parent.width
                    height: parent.width
                    anchors.left: parent.left
                    anchors.leftMargin: 22
                    verticalAlignment: Image.AlignVCenter
                }
            }

        }
        Column{
            width: parent.width/4
            height: parent.height
            anchors.top: parent.top
            anchors.topMargin: 5

            CustomRadioDelegate{
                width: 90
                height: 90

                ButtonGroup.group:joinBtnGroup
                onCheckedChanged: {
                    onJoinChanged()
                }
                contentItem: Image {
                    source: "../../../../Images/icons/Left.png"
                    width: parent.width
                    height: parent.width
                    anchors.left: parent.left
                    anchors.leftMargin: 22
                    verticalAlignment: Image.AlignVCenter
                }
            }

        }
        Column{
            width: parent.width/4
            height: parent.height
            anchors.top: parent.top
            anchors.topMargin: 5

            CustomRadioDelegate{

                width: 90
                height: 90

                ButtonGroup.group:joinBtnGroup
                onCheckedChanged: {
                    onJoinChanged()
                }
                contentItem: Image {
                    source: "../../../../Images/icons/Right.png"
                    width: parent.width
                    height: parent.width
                    anchors.left: parent.left
                    anchors.leftMargin: 22
                    verticalAlignment: Image.AlignVCenter
                }
            }

        }
        Column{
            width: parent.width/4
            height: parent.height
            anchors.top: parent.top
            anchors.topMargin: 5

            CustomRadioDelegate{
                width: 90
                height: 90

                ButtonGroup.group:joinBtnGroup
                onCheckedChanged: {
                    onJoinChanged()
                }
                contentItem: Image {
                    source: "../../../../Images/icons/Full Outer.png"
                    width: parent.width
                    height: parent.width
                    anchors.left: parent.left
                    anchors.leftMargin: 22
                    verticalAlignment: Image.AlignVCenter
                }
            }

        }
    }

    // Select Option Ends

    // Add Key Starts

    Row{
        id: addKeyRow
        height: 30

        anchors.top: selectJoin.bottom
        width: parent.width

        anchors.left: parent.left
        anchors.leftMargin: 4

        CustomButton{

            id: addKey
            textValue: "Add key"
            onClicked: {
                addKeyToList()
            }
        }

    }


    // Add key Ends

    Column{
        id: tables
        anchors.top: addKeyRow.bottom

        width: parent.width
        height: parent.height - selectJoin.height - headerPopup.height - addKeyRow.height - doneBtn.height

        Row{

            id: tableContent
            height: parent.height
            width: parent.width

            Column{

                height: parent.height
                width: parent.width/2 - 20

                JoinDisplayTable{
                    id: table1
                }


            }

            Column{
                height: parent.height
                width: 40

                ListView{

                    height: parent.height
                    width: parent.width
                    anchors.top: parent.top
                    anchors.topMargin: 40
                    anchors.left: parent.left

                    model: 4

                    delegate:  Row{

                        height: 30
                        anchors.left: parent.left
                        anchors.leftMargin: 3

                        Text {
                            id: equal
                            text: qsTr("=")
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: Constants.fontCategoryHeader
                        }

                        Image {
                            anchors.left: equal.right
                            anchors.leftMargin: 5

                            anchors.verticalCenter: parent.verticalCenter

                            source: "../../../../Images/icons/remove.png"
                            height: 12
                            width: 12
                        }

                    }

                }
            }


            Column{

                height: parent.height
                width: parent.width/2 - 20


                JoinDisplayTable{
                    id: table2
                }

            }

        }

    }

    Row{
        id:doneBtn
        height: 80
        width: parent.width

        anchors.top: tables.bottom
        anchors.topMargin: 15
        anchors.right: parent.right
        anchors.rightMargin: 10

        CustomButton{

            anchors.right: parent.right

            textValue: "Done"
            onClicked: {
                onDoneClicked()
            }
        }
    }

}
