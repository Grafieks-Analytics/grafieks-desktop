/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Other
** Home Layout
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtWebEngine 1.10

import com.grafieks.singleton.constants 1.0

import "../MainSubComponents"

Page {

    id: homepage
    property int menu_width: 60

    LeftMenuBar{

        id: leftMenuBar
    }

    Column{
        topPadding: 20
        leftPadding: 160

        Text{
            text:"Welcome to Grafieks Desktop"
            color:"#707070"
            font.pointSize: Constants.fontHeader
        }
    }
    Column{
        topPadding: 80
        leftPadding: 160

        Text{

            text:"Grafieks Desktop is a graphical user interface for data connectors, data modeller,
SQL query builder, report builder and dashboard designer."
            color:"#707070"
            font.pointSize: Constants.fontReading
        }
    }
    GroupBox{

        id: groupBoxPrimaryVideo
        anchors.top:parent.top
        anchors.left:parent.left
        anchors.topMargin: 160
        anchors.leftMargin: 150


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
                text:"Getting started"
                color:"gray"
                font.pointSize: Constants.fontCategoryHeader
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
        anchors.leftMargin: 150
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
                    width:300
                    height:200
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
                    width:300
                    height:200
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
                    width:300
                    height:200
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
        width: parent.width - (secondaryVideoSection.width + 300)
        anchors.right:parent.right
        anchors.top: parent.top
        anchors.topMargin: 100
        anchors.rightMargin: 10
        spacing: 80


        Column{
            id: rightColumn


            Text{
                id:rightHead1


                text:"Sample"
                color:"gray"
                font{
                    pointSize: Constants.fontCategoryHeaderSmall
                }
            }

            ToolSeparator {
                id:toolsep1
                orientation: Qt.Horizontal
                width:rowLayoutHomeRight.width - 10

            }


            Text{
                id:rightText1


                text: "Want to begin developing dashboard with sample data or view dashboard?"
                color:"gray"
                wrapMode: Text.Wrap
                width: rowLayoutHomeRight.width
                font.pointSize: Constants.fontReading
            }
        }


        Column{

            Text{
                id:rightHead2

                text:"Tutorial"
                color:"gray"
                font{
                    pointSize: Constants.fontCategoryHeaderSmall
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
                font.pointSize: Constants.fontReading
            }
        }


        Column{
            Text{
                id:rightHead3

                text:"Community"
                color:"gray"
                font{
                    pointSize: Constants.fontCategoryHeaderSmall
                }
            }

            ToolSeparator {
                id:toolsep3
                orientation: Qt.Horizontal
                width:rowLayoutHomeRight.width  - 10

            }


            Text{
                id:rightText3

                text: "Join the community and interact with other users"
                color:"gray"
                wrapMode: Text.Wrap
                width: rowLayoutHomeRight.width
                font.pointSize: Constants.fontReading
            }
        }

        Column{
            Text{
                id:rightHead4

                text:"Blog"
                color:"gray"
                font{
                    pointSize: Constants.fontCategoryHeaderSmall
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
                font.pointSize: Constants.fontReading
            }
        }
    }
}
