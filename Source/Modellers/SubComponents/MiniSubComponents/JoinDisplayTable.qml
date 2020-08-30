import QtQuick 2.0


import QtQuick.Controls 2.15

import "../../SubComponents"
import "../../../MainSubComponents"

import com.grafieks.singleton.constants 1.0

Rectangle{

    width: parent.width
    height: parent.height


    /***********************************************************************************************************************/
    // LIST MODEL STARTS


    ListModel{
        id:tableList
        ListElement{
            columnName: "colm1"
        }
        ListElement{
            columnName: "colm2"
        }
        ListElement{
            columnName: "colm3"
        }
        ListElement{
            columnName: "colm4"
        }
    }



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



    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts


    ButtonGroup{
        id: tableLeftRightJoinGrp
    }

    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts



    // Page Design Ends
    /***********************************************************************************************************************/

    Rectangle{
        id: content
        height: parent.height
        width: parent.width - 20
        border.color: Constants.darkThemeColor

        anchors.top: parent.top
        anchors.topMargin: 8
        anchors.left: parent.left
        anchors.leftMargin: 10

        Rectangle{
            id: header

            color: Constants.lightThemeColor

            border.color: Constants.darkThemeColor

            height: 30
            width: parent.width
            anchors.left: parent.left

            Row{
                id: tableHeader
                height: parent.height
                anchors.top: parent.top

                Text{
                    id : title
                    text: "Table Name"
                    anchors.left : parent.left
                    anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                }


                Rectangle{
                    height: parent.height
                    anchors.left: title.right

                    CustomRadioButton{

                        id: leftJoinRadio
                        radio_text: "L"
                        checked: true
                        parent_dimension: 16
                        ButtonGroup.group: tableLeftRightJoinGrp

                    }

                    CustomRadioButton{
                        id: rightJoinRadio
                        anchors.left: leftJoinRadio.right
                        checked: false
                        radio_text: "R"
                        parent_dimension: 16
                        ButtonGroup.group: tableLeftRightJoinGrp
                    }

                }

            }

        }


        ListView{

            anchors.top: header.bottom
            height: parent.height - header.height
            width: parent.width
            anchors.left: parent.left

            spacing: 2

            model: 4

            delegate:   CustomComboBox{
                id: columnDropDown
                height: 30
                width: parent.width
                model: tableList
                currentIndex: 0
            }


        }


    }

}
