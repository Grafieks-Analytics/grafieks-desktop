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

Item{

    width:200
    height: parent.height


    // Item 1 Starts

    ListView {
        anchors.fill: parent
        model: nestedModel
        delegate: categoryDelegate
    }


    ListModel {
        id: nestedModel

        ListElement {
            categoryName: "General"
            collapsed: false

            subItems: [

                ListElement { itemName: "Name" }
            ]
        }

        ListElement {
            categoryName: "Style"
            collapsed: false
            subItems: [
                ListElement { itemName: "Background Color" },
                ListElement { itemName: "Report Border" }
            ]
        }

        ListElement {
            categoryName: "Widgets"
            collapsed: false
            subItems: [
                ListElement { itemName: "Text" },
                ListElement { itemName: "Blank" },
                ListElement { itemName: "Image" }
            ]
        }

        ListElement {
            categoryName: "Reports"
            collapsed: false

            subItems: [
                ListElement { itemName: "Report 1" },
                ListElement { itemName: "Report 2" },
                ListElement { itemName: "Report 3" },
                ListElement { itemName: "Report 4" }
            ]
        }




    }

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
                    source: "../../../Images/icons/Up_20.png"
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
                                drop_icon.source = "../../../Images/icons/Down_20.png"
                            }
                            else{
                                drop_icon.source = "../../../Images/icons/Up_20.png"
                            }
                        }
                    }
                }
            }

            Loader {
                id: subItemLoader

                visible: !collapsed
                property variant subItemModel : subItems
                sourceComponent: collapsed ? null : subItemColumnDelegate
                onStatusChanged: if (status == Loader.Ready) item.model = subItemModel
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
                        drag.target: dragRect
                        drag.minimumX: -( new_dashboard_page.width - parent.width - leftMenuBar.width)
                        drag.maximumX: 0

                        drag.onActiveChanged: {

                            if (mouseArea.drag.active) {

                                console.log(itemName)
                                console.log(index)

                                subItemRepeater.dragItemIndex = index;
                                subItemRepeater.itemName = itemName
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

}

