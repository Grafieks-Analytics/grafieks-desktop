/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Dashboard/Subcomponents
** Dashboard Customize
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "./MiniSubComponents"

Item{

    id: listViewElem
    width:200
    height: parent.height

    property string itemName : ""
    property string itemType: ""



    /***********************************************************************************************************************/
    // LIST MODEL STARTS


    ListModel {
        id: nestedModel

        ListElement {
            categoryName: "General"
            collapsed: false

            subItems: [

                ListElement { itemName: "Name"; itemType: "name"  }
            ]
        }

        ListElement {
            categoryName: "Style"
            collapsed: false
            subItems: [
                ListElement { itemName: "Background Color"; itemType: "backgroundColor" },
                ListElement { itemName: "Report Border"; itemType: "reportBorder" }
            ]
        }


        ListElement {
            categoryName: "Canvas Size"
            collapsed: false
            subItems: [
                ListElement { itemName: "Background Color"; itemType: "backgroundColor" },
                ListElement { itemName: "Report Border"; itemType: "reportBorder" }
            ]
        }

        ListElement {
            categoryName: "Widgets"
            collapsed: false
            subItems: [
                ListElement { itemName: "Blank"; itemType: "blank" },
                ListElement { itemName: "Text"; itemType: "text" },
                ListElement { itemName: "Image"; itemType: "image" }
            ]
        }

        ListElement {
            categoryName: "Reports"
            collapsed: false

            subItems: [
                ListElement { itemName: "Report 1"; itemType: "chart" },
                ListElement { itemName: "Report 2"; itemType: "chart" },
                ListElement { itemName: "Report 3"; itemType: "chart" },
                ListElement { itemName: "Report 4"; itemType: "chart" }
            ]
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




    Component {
        id: categoryDelegate
        Column {
            width: 200

            Rectangle {
                id: categoryItem
                height: 30
                width: 200
                color: Constants.themeColor

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    x: 15
                    font.pixelSize: 12
                    text: categoryName
                }

                Image {
                    id: drop_icon
                    source: "/Images/icons/Up_20.png"
                    width: 10
                    height: 10
                    anchors.right: parent.right
                    anchors.rightMargin: 5
                    anchors.verticalCenter: parent.verticalCenter
                    visible: true

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            nestedModel.setProperty(index, "collapsed", !collapsed)

                            if(collapsed === true){
                                drop_icon.source = "/Images/icons/Down_20.png"
                            }
                            else{
                                drop_icon.source = "/Images/icons/Up_20.png"
                            }
                        }
                    }
                }
            }

            Loader {
                id: subItemLoader

                visible: !collapsed
                property variant subItemModel : subItems
                sourceComponent: {
                    if(collapsed){
                        null
                    }else{
                        if(categoryName === "General"){
                            return generalComponent
                        }else if(categoryName === "Style"){
                            return styleComponent
                        }else if(categoryName === "Canvas Size"){
                            return canvasMenuComponent
                        }
                        else{
                            subItemColumnDelegate
                        }
                    }
                }
                onStatusChanged: {
                    if (status == Loader.Ready && (categoryName == "Widgets" || categoryName == "Reports") ){
                        item.model = subItemModel
                    }
                }
            }
        }

    }

    Component {
        id: subItemColumnDelegate
        Column {
            property alias model : subItemRepeater.model
            width: 200
            Repeater {
                id: subItemRepeater
                property string itemName : ""
                property string itemType: ""

                delegate: Rectangle {
                    id: dragRect
                    height: 20
                    width: 200

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        x: 30
                        font.pixelSize: 12
                        text: itemName
                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        drag.target:  dragRect
                        drag.minimumX: -( new_dashboard_page.width - parent.width)
                        drag.maximumX: 0

                        drag.onActiveChanged: {

                            if (mouseArea.drag.active) {
                                listViewElem.itemName = itemName
                                listViewElem.itemType = itemType
                            }
                            dragRect.Drag.drop();
                        }
                    }

                    states: [
                        State {
                            when: dragRect.Drag.active
                            ParentChange {
                                target: dragRect
                                parent: subItemRepeater
                            }

                            AnchorChanges {
                                target: dragRect
                                anchors.horizontalCenter: undefined
                                anchors.verticalCenter: undefined
                            }
                        }
                    ]

                    Drag.active: mouseArea.drag.active
                    Drag.hotSpot.x: - dragRect.width / 2
                    Drag.hotSpot.y: - dragRect.height / 2
                    Drag.keys: ['1','2']

                }
            }
        }

    }

    Component{
        id: generalComponent

        CustomizeGeneralMenu{
            id: mainGeneralComponent
            height: 60
            width: listViewElem.width
        }

    }

    Component{
        id: styleComponent

        CustomizeStyleMenu{
            height: 120
            width: listViewElem.width
        }

    }

    Component{
        id: canvasMenuComponent

        CustomizeCanvasSizeMenu{
            height: 70
            width: listViewElem.width
        }

    }


    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts



    // Item 1 Starts

    ListView {
        anchors.fill: parent
        model: nestedModel
        interactive: false
        delegate: categoryDelegate
    }


}

