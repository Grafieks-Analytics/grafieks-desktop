import QtQuick 2.15
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

Column{

    property int leftMargin: 15

    property int spacingColorList: 5
    property int colorBoxHeight: 20
    property int colorListTopMargin: 5
    property int editImageSize: 16

    spacing: 4

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


    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts


    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts



    // Row Total Starts

    Rectangle{

        height: 35
        width: 150

       Rectangle{
            anchors.fill: parent

            KPIDataValuePopup{
                id: dataValueShapePopup
                x: parent.width - 10
            }

            Text {
                text: qsTr("Data Value")
                anchors.left: parent.left
                anchors.leftMargin: leftMargin
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: Constants.fontCategoryHeaderSmall
            }

            Image {
                height: editImageSize
                width: editImageSize
                source: "/Images/icons/Edit_20.png"
                anchors.right: parent.right
                anchors.rightMargin: leftMargin
                anchors.verticalCenter: parent.verticalCenter
            }
            MouseArea{
                anchors.fill: parent
                onClicked: dataValueShapePopup.visible = true
            }

        }

    }


    Rectangle{

        height: 35
        width: 150

       Rectangle{
            anchors.fill: parent

            KPIDataLabelPopup{
                id: dataLabelShapePopup
                x: parent.width - 10
            }

            Text {
                text: qsTr("Data Label")
                anchors.left: parent.left
                anchors.leftMargin: leftMargin
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: Constants.fontCategoryHeaderSmall
            }

            Image {
                height: editImageSize
                width: editImageSize
                source: "/Images/icons/Edit_20.png"
                anchors.right: parent.right
                anchors.rightMargin: leftMargin
                anchors.verticalCenter: parent.verticalCenter
            }
            MouseArea{
                anchors.fill: parent
                onClicked: dataLabelShapePopup.visible = true
            }

        }

    }

    




}
