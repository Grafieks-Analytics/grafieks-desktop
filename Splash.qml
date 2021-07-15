
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

import com.grafieks.singleton.constants 1.0

Window {
    id: splashScreen
    modality: Qt.ApplicationModal
    flags: Qt.SplashScreen
    width: 400
    height: 400
    color: "transparent"

    Connections{
        target: GeneralParamsModel

        function onHideSplash(){
            splashScreen.visible = false
        }
    }

    Rectangle {
        id: splashRect
        anchors.fill: parent
        color: "white"
        border.width: 1
        border.color: Constants.greenThemeColor

        Image {
            id: splashImage
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 30
            source: "Images/logos/logo.png"
            height: 267
            width: 278
        }

        Text{
            id: textTitle
            anchors.top:splashImage.bottom
            anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Grafieks Desktop v1.0")
            font.pointSize: Constants.fontCategoryHeaderSmall
            color: Constants.grafieksGreen
        }

        Text{
            id: textInfo
            anchors.top:textTitle.bottom
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("\u00a9 Copyright 2021. All Rights Reserved")
            color: Constants.grayColor
        }
    }

    Component.onCompleted: visible = true
}
