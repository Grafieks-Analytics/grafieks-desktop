/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Dashboard/Subcomponents
** Report Customizations
**
****************************************************************************/

import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

Item{
    width: 150
    x: 60
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
            categoryName: "Axis"
            collapsed: false
            subItems: [
                ListElement { itemName: "X Axis" },
                ListElement { itemName: "Y Axis" },
                ListElement { itemName: "Edit Axis" }
            ]
        }

        ListElement {
            categoryName: "Properties"
            collapsed: false

            subItems: [

                ListElement { itemName: "Color" },
                ListElement { itemName: "Tool Tip" },
                ListElement { itemName: "Size" },
                ListElement { itemName: "Marker Shape" },
                ListElement { itemName: "Label" }
            ]
        }

        ListElement {
            categoryName: "Reference Line"
            collapsed: false
            subItems: [
                ListElement { itemName: "Add Reference Line" }
            ]
        }

        ListElement {
            categoryName: "Legend"
            collapsed: false

            subItems: [
                ListElement { itemName: "Show Legend" },
                ListElement { itemName: "Text Format" }
            ]
        }

        ListElement {
            categoryName: "Background"
            collapsed: false
            subItems: [
                ListElement { itemName: "Color" },
                ListElement { itemName: "Show Grid" },
                ListElement { itemName: "Show Border" }
            ]
        }

        ListElement {
            categoryName: "Drill Through"
            collapsed: false
            subItems: [
                ListElement { itemName: "Region" },
                ListElement { itemName: "Cluster" },
                ListElement { itemName: "Country" },
                ListElement { itemName: "Warehouse" }
            ]
        }


    }

    Component {
        id: categoryDelegate

        Column {
            width: 150

            Rectangle {
                id: categoryItem
                height: 30
                width: 150
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
            width: 150
            Repeater {
                id: subItemRepeater
                delegate: Rectangle {
                    height: 20
                    width: 150

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        x: 30
                        font.pixelSize: 12
                        text: itemName
                    }
                }
            }
        }

    }




}

