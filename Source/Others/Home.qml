/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Other
** Home Layout
**
****************************************************************************/

import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtWebEngine 1.7

import com.grafieks.singleton.constants 1.0

import "../MainSubComponents"

Page {

    id: homepage
    property int menu_width: 60

    LeftMenuBar{

        id: leftMenuBar
    }

    GroupBox{

        id: groupBoxPrimaryVideo
        anchors.top:parent.top
        anchors.left:parent.left
        anchors.topMargin: 100
        anchors.leftMargin: 250

        Column{
            id: primaryVideoSection
            spacing: 10

            WebEngineView {
                id:primaryVideo

                url: "http://www.youtube.com/embed/hDJdkcdG1iA"
                width:500
                height:250
            }

            Text{
                id: primaryVideoDesc
                text:"Getting started with Grafieks"
                color:"gray"
                font.pointSize: Constants.fontSubHeaderSmall
            }
        }

        background: Rectangle {
            color: "transparent"
            border.color: Constants.themeColor
            radius: 1
        }
    }

    Row{
        id: secondaryVideoSection

        anchors.top:groupBoxPrimaryVideo.bottom
        anchors.left:parent.left
        anchors.topMargin: 20
        anchors.leftMargin: 250
        spacing: 10

        GroupBox{

            id: groupboxSecondaryVideoCol1

            Column{

                id: secondaryCol1

                anchors.top:parent.top
                spacing: 10

                WebEngineView {
                    id:secondaryVideo1

                    url: "http://www.youtube.com/embed/i-pGuzNkpDg"
                    width:200
                    height:130
                }

                Text{
                    id: secondaryVideoDesc1
                    text:"Connect to Database"
                    color:"gray"
                    font.pointSize: Constants.fontCategoryHeaderSmall
                }
            }

            background: Rectangle {
                color: "transparent"
                border.color: Constants.themeColor
                radius: 1
            }
        }


        GroupBox{

            id: groupboxSecondaryVideoCol2
            Column{

                id: secondaryCol2

                anchors.top:parent.top
                spacing: 10

                WebEngineView {
                    id:secondaryVideo2

                    url: "http://www.youtube.com/embed/9ldOuVuas1c"
                    width:200
                    height:130
                }

                Text{
                    id: secondaryVideoDesc2
                    text:"Build a report"
                    color:"gray"
                    font.pointSize: Constants.fontCategoryHeaderSmall
                }
            }

            background: Rectangle {
                color: "transparent"
                border.color: Constants.themeColor
                radius: 1
            }

        }

        GroupBox{

            id: groupboxSecondaryVideoCol3

            Column{

                id: secondaryCol3

                anchors.top:parent.top
                spacing: 10

                WebEngineView {
                    id:secondaryVideo3

                    url: "http://www.youtube.com/embed/N8F7eOqgH8Q"
                    width:200
                    height:130
                }

                Text{
                    id: secondaryVideoDesc3
                    text:"Publish your report"
                    color:"gray"
                    font.pointSize: Constants.fontCategoryHeaderSmall
                }
            }

            background: Rectangle {
                color: "transparent"
                border.color: Constants.themeColor
                radius: 1
            }

        }
    }


    Column{
        id: rowLayoutHomeRight

        height:parent.height
        width: 200
        anchors.right:parent.right
        anchors.top: parent.top
        anchors.topMargin: 100
        anchors.rightMargin: 10
        spacing: 50


        Column{
            id: rightColumn


            Text{
                id:rightHead1


                text:"Sample"
                color:"gray"
                font{
                    pointSize: 20
                }
            }

            ToolSeparator {
                id:toolsep1
                orientation: Qt.Horizontal
                width:rowLayoutHomeRight.width - 10

            }


            Text{
                id:rightText1


                text: "Want to begin developing dashboard with sample data or view dashboard"
                color:"gray"
                wrapMode: Text.Wrap
                width: rowLayoutHomeRight.width
            }
        }


        Column{
            Text{
                id:rightHead2

                text:"Tutorial"
                color:"gray"
                font{
                    pointSize: 20
                }
            }

            ToolSeparator {
                id:toolsep2
                orientation: Qt.Horizontal
                width:rowLayoutHomeRight.width  - 10

            }


            Text{
                id:rightText2


                text: "Ready to learn how to use Grafieks?"
                color:"gray"
                wrapMode: Text.Wrap
                width: rowLayoutHomeRight.width
            }
        }


        Column{
            Text{
                id:rightHead3

                text:"Community"
                color:"gray"
                font{
                    pointSize: 20
                }
            }

            ToolSeparator {
                id:toolsep3
                orientation: Qt.Horizontal
                width:rowLayoutHomeRight.width  - 10

            }


            Text{
                id:rightText3


                text: "Join the community and interact with others"
                color:"gray"
                wrapMode: Text.Wrap
                width: rowLayoutHomeRight.width
            }
        }

        Column{
            Text{
                id:rightHead4

                text:"Blog"
                color:"gray"
                font{
                    pointSize: 20
                }
            }

            ToolSeparator {
                id:toolsep4
                orientation: Qt.Horizontal
                width:rowLayoutHomeRight.width  - 10

            }


            Text{
                id:rightText4


                text: "Want to stay updated with news, resources and others"
                color:"gray"
                wrapMode: Text.Wrap
                width: rowLayoutHomeRight.width
            }
        }
    }
}
