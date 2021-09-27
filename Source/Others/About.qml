import QtQuick 2.15
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0

Popup {
    id: aboutPopup
    x: parent.width/2 - 300
    y: parent.height/2 - 200
    width: 600
    height: 360
    modal: true
    focus: true

    property var appInfo;

    Component.onCompleted: {
        appInfo = GeneralParamsModel.getAppInfo()
    }

    Image {
        id: grafieks_logo
        source: "/Images/logos/logo_full_small.png"
        height: 20
        width: 76
    }

    Text{
        id: header
        text: "About Grafieks Desktop"
        font.pointSize: Constants.fontHeader
        font.family: Constants.fontDefault
        anchors.top: grafieks_logo.bottom
    }

    Text{
        id: appName
        text: appInfo["APP_NAME"]
        anchors.top: header.bottom
    }

    Text{
        id: appVersion
        text: appInfo["APP_VERSION"]
        anchors.top: appName.bottom
    }


}
