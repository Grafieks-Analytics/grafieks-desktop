import QtQuick 2.15
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0

import "../../SubComponents"
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


    ListModel{
        id: colorListModel
        ListElement{
            textValue: "Quantity"
        }
        ListElement{
            textValue: "Quantity 1"
        }
        ListElement{
            textValue: "Quantity 2"
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


    function onDropAreaEntered(drag){
        console.log('Drop area in')
    }

    function onDropAreaDropped(drag){
        console.log('dropped')
    }

    function onDropAreaPositionChanged(drag){
        console.log('Position change!!');
    }
    function onDropAreaExited(){
        console.log('Exit');
    }


    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts



    // Color By Component Starts
    Rectangle {
        id: colorByComponent
        height: allParameter.height + colorByText.height + 2*colorListTopMargin
        width: 150
        Text {
            id: colorByText
            x: leftMargin
            anchors.top: parent.top
            anchors.topMargin: 5
            font.pixelSize: Constants.fontCategoryHeaderSmall
            text: "Color By"
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                console.log('Okay')
            }
        }

        Rectangle{
            id: allParameter

            width: parent.width-2*leftMargin
            height: 30
            x:leftMargin
            anchors.top: colorByText.bottom
            anchors.topMargin: colorListTopMargin

            border.color: Constants.grafieksLightGreenColor
            border.width: 1

            DropArea {
                id: dropArea
                anchors.fill: parent
                onEntered:  parent.border.width = 2
                onExited:  parent.border.width = 1
                onDropped: {
                    console.log('Dropped!!!')
                    parent.border.width = 1

//                    console.log(numericalList.itemName)

                }
            }

        // list view for dropped colors
        //            ListView{
        //                id: colorList
        //                height: colorListModel.count*colorBoxHeight + spacingColorList
        //                width: parent.width-10
        //                x:5
        //                anchors.top: parent.top
        //                anchors.topMargin: 5
        //                model: colorListModel
        //                spacing: spacingColorList
        //                delegate: Rectangle{
        //                    height: colorBoxHeight
        //                    width: parent.width
        //                    color: "#BADCFF"
        //                    border.width: 1
        //                    border.color: "#CDE6FF"
        //                    Text {
        //                        text: textValue
        //                        anchors.centerIn: parent
        //                        font.pixelSize: Constants.fontCategoryHeaderSmall
        //                    }
        //                }
        //            }
        // list view ends!


        }
    }


    // Color By Component Ends



    // Tool tip starts
    Rectangle{

        height: 20
        width: parent.width

        Rectangle{
            anchors.fill: parent

            Text {
                text: qsTr("Tool Tip")
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

        }

    }
    // Tool tip Ends


    // Size starts
    Rectangle{

        height: 20
        width: parent.width


        Rectangle{
            anchors.fill: parent

            Text {
                text: qsTr("Size")
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

        }

    }
    // Size Ends


    // Marker Shape starts
    Rectangle{

        height: 20
        width: parent.width

        Rectangle{
            anchors.fill: parent

            Text {
                text: qsTr("Marker Shape")
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

        }

    }
    // Marker Shape Ends


    // Label starts
    Rectangle{

        height: 20
        width: parent.width


        Rectangle{
            anchors.fill: parent

            Text {
                text: qsTr("Label")
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

        }

    }
    // Label Ends


    // Merge Axis starts
    Rectangle{

        height: 30
        width: parent.width

        Rectangle{

            height: 20
            width: parent.width

            Text {
                text: qsTr("Merge Axis")
                anchors.left: parent.left
                anchors.leftMargin: leftMargin
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: Constants.fontCategoryHeaderSmall
            }

            CheckBoxTpl{

                checked: false
                parent_dimension: editImageSize - 2
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 5
                anchors.top: parent.top

            }

        }

    }
    // Merge Axis Ends


}
