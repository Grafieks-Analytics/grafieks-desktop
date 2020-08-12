/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Data/SubComponents
** Data Modeller
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15



import com.grafieks.singleton.constants 1.0


Item {

    id: dataModellerItem
    property real droppedX : 0
    property real droppedY : 0



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


    function onZoomOutClicked(){
        console.log('Zoom Out')
    }

    function onZoomInClicked(){
        console.log('Zoom In')
    }


    function onAlignBtnClicked(){
        console.log('Align Btn Clicked')
    }


    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts



    Column{
        id: button_options_group
        x:20
        y:10

        Button{
            id: align_btn
            width: 30
            height: 30

            Image{
                id: align_icon
                height: 22
                width: 22

                source: "../../../Images/icons/align.png"
                anchors.centerIn: align_btn
                anchors.topMargin: 3
                anchors.leftMargin: 2
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignVCenter

            }

            onClicked: {

                onAlignBtnClicked()

            }

            background: Rectangle {
                id: align_btn_background
                color:  align_btn.hovered? Constants.darkThemeColor: Constants.themeColor

            }

        }

        Button{
            id:plus_icon_btn
            width: 30
            height: 30
            Image{
                id: plus_icon
                source: "../../../Images/icons/Plus_32.png"
                height: 25
                width: 25
                anchors.centerIn: plus_icon_btn
                anchors.topMargin: 3
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignVCenter

            }

            background: Rectangle {
                id: plus_icon_btn_background
                color:  plus_icon_btn.hovered? Constants.darkThemeColor: Constants.themeColor

            }
            onClicked: {

                onZoomInClicked()

            }
        }

        Button{
            id:minus_icon_btn
            width: 30
            height: 30
            Image{
                id: minus_icon
                source: "../../../Images/icons/zoom out.png"
                height: 20
                width: 20
                anchors.topMargin: 3
                anchors.leftMargin:3
                anchors.centerIn: minus_icon_btn
                anchors.top: minus_icon_btn.top
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignVCenter

            }

            background: Rectangle {
                id: minus_icon_btn_background
                color:  minus_icon_btn.hovered? Constants.darkThemeColor: Constants.themeColor

            }

            onClicked: {

                onZoomOutClicked()
            }
        }

    }

    Rectangle{
        id:highlightRect
        height: parent.height
        width: parent.width

        MouseArea{
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                droppedX = mouseX
                droppedY = mouseY
            }
        }

        DropArea {
            id: dropArea
            anchors.fill: parent
            onEntered: {
                highlightRect.color = "ivory"
            }
            onExited: {
                highlightRect.color = "white"
            }



            onDropped: {
                // listView.model.remove(listView.dragItemIndex);
                // listView.dragItemIndex = -1;
                console.log("dropeed")
                highlightRect.color = "white"
//                Qt.createQmlObject('import QtQuick 2.15; Rectangle {color: "red"; width: 60; height: 30; x:Math.random()*parent.width; y:Math.random()*parent.height; Text{text: tableslist.tableName}}',
//                                   highlightRect,
//                                   "dynamicSnippet1");


            }
        }
    }



    // Page Design Ends
    /***********************************************************************************************************************/

}
