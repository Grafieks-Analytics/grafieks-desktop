import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

Column{
    width: parent.width
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.leftMargin: 80
    anchors.topMargin: 30


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

    function toggleRadios(thisRadioChecked,lastRadioChecked,nextRadioChecked,nextXRadioChecked,lastXRadioChecked,nextXRadioTextFieldFocus,lastXRadioTextFieldFocus){

        thisRadio.radio_checked = thisRadioChecked
        lastRadio.radio_checked = lastRadioChecked
        nextRadio.radio_checked = nextRadioChecked
        nextXRadio.radio_checked = nextXRadioChecked
        lastXRadio.radio_checked = lastXRadioChecked


        nextXRadioTextField.focus = nextXRadioTextFieldFocus
        lastXRadioTextField.focus = lastXRadioTextFieldFocus

    }


    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts



    Rectangle{
        id:thisTimeFrameRow
        height: 30
        width: parent.width
        anchors.left: parent.left


        RadioButtonTpl{
            id:thisRadio

            text: qsTr("This Day")
            checked: false
            parent_dimension: 16

            MouseArea{
                anchors.fill:parent

                onClicked: {
                    toggleRadios(true,false,false,false,false,false,false)

                }
            }
        }

    }

    Rectangle{
        id:lastTimeFrameRow
        height: 30
        width: parent.width

        anchors.left: parent.left
        anchors.top: thisTimeFrameRow.bottom
        anchors.topMargin: 10
        anchors.leftMargin: parent.width * 0.2
        anchors.rightMargin: parent.width * 0.2

        RadioButtonTpl{
            id:lastRadio
            radio_text: qsTr("Last Day")
            radio_checked: false
            parent_dimension: 16

            MouseArea{
                anchors.fill:parent

                onClicked: {
                    toggleRadios(false,true,false,false,false,false,false)
                }
            }
        }

    }

    Rectangle{
        id:nextTimeFrameRow
        height: 30
        width: parent.width

        anchors.left: parent.left
        anchors.top: lastTimeFrameRow.bottom
        anchors.topMargin: 10
        anchors.leftMargin: parent.width * 0.2
        anchors.rightMargin: parent.width * 0.2

        RadioButtonTpl{
            id:nextRadio
            radio_text: qsTr("Next Day")
            radio_checked: false
            parent_dimension: 16

            MouseArea{
                anchors.fill:parent

                onClicked: {
                    toggleRadios(false,false,true,false,false,false,false)
                }
            }
        }

    }


    Rectangle{
        id:lastXTimeFrameRow
        height: 30
        width: parent.width

        anchors.left: parent.left
        anchors.top: nextTimeFrameRow.bottom
        anchors.leftMargin: parent.width * 0.2
        anchors.topMargin: 10
        anchors.rightMargin: parent.width * 0.2

        RadioButtonTpl{
            id:lastXRadio
            radio_text: qsTr("Last")
            radio_checked: false
            parent_dimension: 16
            width: 200

            MouseArea{
                anchors.fill:parent

                onClicked: {
                    toggleRadios(false,false,false,false,true,true,false)
                }
            }
        }

        TextField{
            height: 30
            width: 80
            id:lastXRadioTextField
            anchors.left: lastXRadio.right
            placeholderText: "Day"
        }

    }

    Rectangle{
        id:nextXTimeFrameRow
        height: 30
        width: parent.width

        anchors.left: parent.left
        anchors.top: lastXTimeFrameRow.bottom
        anchors.leftMargin: parent.width * 0.2
        anchors.rightMargin: parent.width * 0.2
        anchors.topMargin: 10

        RadioButtonTpl{
            id:nextXRadio
            radio_text: qsTr("Next")
            radio_checked: false
            parent_dimension: 16
            width: 200

            MouseArea{
                anchors.fill:parent

                onClicked: {

                    toggleRadios(false,false,false,true,false,true,false)

                }
            }
        }

        TextField{
            id: nextXRadioTextField
            height: 30
            width: 80
            anchors.left: nextXRadio.right

            placeholderText: "Day"
        }

    }


    // Page Design Ends
    /***********************************************************************************************************************/

}

