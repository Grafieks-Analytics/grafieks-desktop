import QtQuick 2.15
import QtQuick.Controls 2.15
import QtWebEngine 1.7

import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents"
import "../SubComponents"
import "./MiniSubComponents"


Column{

    height:parent.height - submenu.height
    width: 200
    anchors.right:parent.right
    anchors.top: submenu.bottom
    anchors.topMargin: 8
    spacing: 40

    visible: false

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
    }


    ToolSeparator{

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: -8
        anchors.topMargin: -4
        height:parent.height

        contentItem: Rectangle {
            implicitWidth: parent.vertical ? 1 : 24
            implicitHeight: parent.vertical ? 24 : 1
            color: Constants.darkThemeColor
        }
    }


    Rectangle{
        id: rectangle_newdashboard_right_col
        color:Constants.themeColor
        width:parent.width
        height:parent.height
        anchors.top: parent.top

        Rectangle{
            id: customizeReportHeading

            height:50
            width: parent.width

            Row{
                id: customizeReportTitle
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.right: parent.right
                anchors.rightMargin: 10

                Text{
                    text: "Customize Report"
                    anchors.verticalCenter: parent.verticalCenter
                }

                Image {
                    id: close
                    source: "../../../Images/icons/remove.png"
                    height: 12
                    width: 12
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter

                    MouseArea{
                        anchors.fill: parent
                        onClicked: customizeReport.visible = false
                    }
                }

            }


        }

        Rectangle{
            anchors.top: customizeReportHeading.bottom

            height: parent.height - 50

            ListView {
                anchors.fill: parent
                model: nestedModel
                interactive: false

                delegate: categoryDelegate
            }


        }

        // Widget Drawer ends
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
                        if(categoryName == "General"){
                            return generalComponent
                        }else if(categoryName == "Style"){
                            return styleComponent
                        }else if(categoryName == "Canvas Size"){
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

    Component{
        id: generalComponent

        CustomizeGeneralMenu{
            height: 60
            width: listViewElem.width
        }

    }

    Component{
        id: styleComponent

        CustomizeReportStyleMenu{
            height: 120
            width: listViewElem.width
        }

    }


}
