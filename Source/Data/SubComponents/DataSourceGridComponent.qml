import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

import "../../MainSubComponents"
import "../../../Constants.js" as Constants

Item {

    width: data_source_main.width
    height:data_source_main.height

    Rectangle{
        id:data_source_main
        border.color: Constants.darkThemeColor
        width: 370
        height: 250
        radius: 10

        Rectangle{
            id:data_source_head
//            border.color: Constants.darkThemeColor
            anchors.left: data_source_main.left
            anchors.top: data_source_main.top
            anchors.leftMargin: 1
            anchors.topMargin: 1
            width: 368
            height: 40
            color: Constants.themeColor
            radius: 10

            Rectangle{
                id: inner_rectangle
                width: parent.width
                anchors.bottom: parent.bottom
                height:10
                color: Constants.themeColor
            }

            CheckBoxTpl{

                id: data_source_name
                checkbox_text: "Data Source Name"
                checkbox_checked: false
                parent_dimension: 16
                anchors.centerIn: parent
            }



            ToolButton {
                id:data_source_edit

                anchors.right:data_source_head.right
                anchors.rightMargin: 10
                anchors.top:data_source_head.top
                anchors.topMargin: 10

                background: Rectangle {
                    implicitWidth: 20
                    implicitHeight: 20
                    opacity: enabled ? 1 : 0.3
                    color: "transparent"
                }


                Image {
                    source: "../../../Images/icons/Edit_20.png"
                    width:20
                    height:width

                }
                onClicked: optionsMenu.open()

                Menu {
                    id: optionsMenu
                    x: parent.width - width
                    transformOrigin: Menu.TopRight

                    MenuItem {
                        text: "Edit Connection"
                        onTriggered: {}
                    }
                    MenuItem {
                        text: "Remove"
                        onTriggered: {}
                    }
                }
            }
        }



        Image{
            id: image_datasource
            source: "../../../Images/icons/sample_graph.png"
            anchors.top: data_source_head.bottom
            anchors.topMargin:10
            anchors.horizontalCenter: data_source_main.horizontalCenter
            width: 250
            height:76

            MouseArea{
                anchors.fill: parent
                onClicked: {

                }
            }


        }






        Column{
            id: description_datasource
            anchors.top: image_datasource.bottom
            anchors.left: data_source_main.left
            anchors.right: data_source_main.right
            anchors.topMargin: 10
            anchors.leftMargin: 10
            anchors.rightMargin: 10

            Text{
                text: "Description"
                font.bold: true
            }
            Text{
                width:data_source_main.width - 10
                text: "Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs."
                wrapMode: Text.WordWrap
            }
        }

        RowLayout{
            id: info_datasource
            anchors.top: description_datasource.bottom
            anchors.left: data_source_main.left
            anchors.right: data_source_main.right
            anchors.topMargin: 15
            anchors.leftMargin: 10
            anchors.rightMargin: 10


            Column{
                Text{
                    text: "Published by"
                }
                Text{
                    text: "Hirak Kocharee"
                    font.bold: true
                }

            }

            Column{


                Text{
                    text: "Live / In Memory"

                }
                Text{
                    text: "Live"
                    font.bold:true
                }

            }

        }
    }
}
