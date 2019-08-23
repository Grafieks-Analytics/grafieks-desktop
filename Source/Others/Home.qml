import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtWebEngine 1.7

import "../MainSubComponents"
import "../../Constants.js" as Constants

Page {

    id: homepage

    property int menu_width: 60



    LeftMenuBar{

        id: left_menubar
    }

    GroupBox{

        id: groupbox_primaryvideo_row

        anchors.top:parent.top
        anchors.left:parent.left
        anchors.topMargin: 100
        anchors.leftMargin: 250


        Column{
            id: primaryvideo_row
            spacing: 10

            WebEngineView {
                id:primary_video

                url: "https://www.youtube.com/embed/hDJdkcdG1iA"
                width:500
                height:250
            }

            Text{
                id: primary_video_desc
                text:"Getting started with Grafieks"
                color:"gray"
                font.pointSize: 14
            }
        }

        background: Rectangle {
            color: "transparent"
            border.color: Constants.themeColor
            radius: 1
        }
    }

    Row{
        id: secondary_videos

        anchors.top:groupbox_primaryvideo_row.bottom
        anchors.left:parent.left
        anchors.topMargin: 20
        anchors.leftMargin: 250
        spacing: 10

        GroupBox{

            id: groupbox_secondaryvideo_col1

            Column{

                id: secondary_col1

                anchors.top:parent.top
                spacing: 10

                WebEngineView {
                    id:secondary_video1

                    url: "https://www.youtube.com/embed/i-pGuzNkpDg"
                    width:200
                    height:130
                }

                Text{
                    id: secondary_video_desc1
                    text:"Connect to Database"
                    color:"gray"
                    font.pointSize: 11
                }
            }

            background: Rectangle {
                color: "transparent"
                border.color: Constants.themeColor
                radius: 1
            }
        }


        GroupBox{

            id: groupbox_secondaryvideo_col2
            Column{

                id: secondary_col2

                anchors.top:parent.top
                spacing: 10

                WebEngineView {
                    id:secondary_video2

                    url: "https://www.youtube.com/embed/9ldOuVuas1c"
                    width:200
                    height:130
                }

                Text{
                    id: secondary_video_desc2
                    text:"Build a report"
                    color:"gray"
                    font.pointSize: 11
                }
            }

            background: Rectangle {
                color: "transparent"
                border.color: Constants.themeColor
                radius: 1
            }

        }

        GroupBox{

            id: groupbox_secondaryvideo_col3

            Column{

                id: secondary_col3

                anchors.top:parent.top
                spacing: 10

                WebEngineView {
                    id:secondary_video3

                    url: "https://www.youtube.com/embed/N8F7eOqgH8Q"
                    width:200
                    height:130
                }

                Text{
                    id: secondary_video_desc3
                    text:"Publish your report"
                    color:"gray"
                    font.pointSize: 11
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
        id: rowlayout_home_right

        height:parent.height
        width: 200
        anchors.right:parent.right
        anchors.top: parent.top
        anchors.topMargin: 100
        anchors.rightMargin: 10
        spacing: 50


        Column{
            id: col_rt_1


            Text{
                id:right_head1


                text:"Sample"
                color:"gray"
                font{
                    pointSize: 14
                }
            }

            ToolSeparator {
                id:toolsep1
                orientation: Qt.Horizontal
                width:rowlayout_home_right.width - 10

            }


            Text{
                id:right_text1


                text: "Want to begin developing dashboard with sample data or view dashboard"
                color:"gray"
                wrapMode: Text.Wrap
                width: rowlayout_home_right.width
            }
        }


        Column{
            Text{
                id:right_head2

                text:"Tutorial"
                color:"gray"
                font{
                    pointSize: 14
                }
            }

            ToolSeparator {
                id:toolsep2
                orientation: Qt.Horizontal
                width:rowlayout_home_right.width  - 10

            }


            Text{
                id:right_text2


                text: "Ready to learn how to use Grafieks?"
                color:"gray"
                wrapMode: Text.Wrap
                width: rowlayout_home_right.width
            }
        }


        Column{
            Text{
                id:right_head3

                text:"Community"
                color:"gray"
                font{
                    pointSize: 14
                }
            }

            ToolSeparator {
                id:toolsep3
                orientation: Qt.Horizontal
                width:rowlayout_home_right.width  - 10

            }


            Text{
                id:right_text3


                text: "Join the community and interact with others"
                color:"gray"
                wrapMode: Text.Wrap
                width: rowlayout_home_right.width
            }
        }

        Column{
            Text{
                id:right_head4

                text:"Blog"
                color:"gray"
                font{
                    pointSize: 14
                }
            }

            ToolSeparator {
                id:toolsep4
                orientation: Qt.Horizontal
                width:rowlayout_home_right.width  - 10

            }


            Text{
                id:right_text4


                text: "Want to stay updated with news, resources and others"
                color:"gray"
                wrapMode: Text.Wrap
                width: rowlayout_home_right.width
            }
        }
    }
}
