import QtQuick 2.15
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0
import com.grafieks.singleton.messages 1.0
import "../MainSubComponents"



Popup {
    id: aboutPopup
    x: parent.width/2 - 300
    y: parent.height/2 - 200
    width: 600
    height: 400
    modal: true
    focus: true

    property var appInfo;

    Component.onCompleted: {
        appInfo = GeneralParamsModel.getAppInfo()
    }

    Image {
        id: grafieks_logo
        source: "/Images/logos/logo_large.png"
        // height: 90
        // width: 180
        anchors.horizontalCenter:parent.horizontalCenter
        anchors.top:parent.top
        anchors.topMargin:15

    }


    Text{
        id: header
        text: Messages.oth_abt_header
        font.pointSize: 8
        font.family: Constants.fontDefault
        anchors.top: grafieks_logo.bottom
        anchors.horizontalCenter:parent.horizontalCenter
        anchors.topMargin:17
        
    }
    Text{
        id: version
        text: Messages.oth_abt_version
        font.pointSize: 8
        font.family: Constants.fontDefault
        anchors.top: header.bottom
        anchors.horizontalCenter:parent.horizontalCenter
        anchors.topMargin:17
    }
    ToolSeparator{
        id: toolsep1
        orientation: Qt.Horizontal
        width: parent.width-100
        anchors.top: version.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin:17

        contentItem: Rectangle {
            implicitWidth: parent.vertical ? 1 : 24
            implicitHeight: parent.vertical ? 25 : 1
            color: Constants.darkThemeColor

        }

    }
    Text{
        id: learn
        text: Messages.oth_abt_learn
        onLinkActivated: Qt.openUrlExternally(link)
        font.pointSize: 8
        font.family: Constants.fontDefault
        anchors.top: toolsep1.bottom
        anchors.horizontalCenter:parent.horizontalCenter
        anchors.topMargin:17
    }
    Text{
        id: license
        text: Messages.oth_abt_license
        font.pointSize: 8
        color:"blue"
        font.underline :true
        font.family: Constants.fontDefault
        anchors.top: learn.bottom
        anchors.horizontalCenter:parent.horizontalCenter
        anchors.topMargin:17
        MouseArea{
            anchors.fill:parent
            onClicked:{
                aboutPopup.close()
                openLicense();
            }

        }

    }
    ToolSeparator{
        id: toolsep2
        orientation: Qt.Horizontal
        width: parent.width-100
        anchors.top: license.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin:17

        contentItem: Rectangle {
            implicitWidth: parent.vertical ? 1 : 24
            implicitHeight: parent.vertical ? 25 : 1
            color: Constants.darkThemeColor

        }

    }
    Text{
        id: copyright
        text: Messages.oth_abt_copyright
        font.pointSize: 8
        font.family: Constants.fontDefault
        anchors.top: toolsep2.bottom
        anchors.horizontalCenter:parent.horizontalCenter
        anchors.topMargin:17
    }
    CustomButton{
        id: closeBtn

        height:40
        width:120
        contentItem:Text {
            text: Messages.closeBtnTxt
            color:"white"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }


        anchors.right: parent.right
        anchors.rightMargin: 30
        anchors.bottom:parent.bottom


        onClicked: {
            aboutPopup.close()
        }
        background:Rectangle{
            height:parent.height
            width:parent.width
            color:Constants.buttonHoverColor
        }
    }

    // Text{
    //     id: header
    //     text: "About Grafieks Desktop"
    //     font.pointSize: Constants.fontHeader
    //     font.family: Constants.fontDefault
    //     anchors.top: grafieks_logo.bottom
    // }

    // Text{
    //     id: appName
    //     text: appInfo["APP_NAME"]
    //     anchors.top: header.bottom
    // }

    // Text{
    //     id: appVersion
    //     text: appInfo["APP_VERSION"]
    //     anchors.top: appName.bottom
    // }


}


