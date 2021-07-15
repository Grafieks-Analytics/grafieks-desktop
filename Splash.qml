
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

Window {
    id: splashScreen
    modality: Qt.ApplicationModal
    flags: Qt.SplashScreen
    width: 300
    height: 300

    Connections{
        target: GeneralParamsModel

        function onHideSplash(){
            splashScreen.visible = false
        }
    }

    Rectangle {
        id: splashRect
        anchors.fill: parent
        color: "transparent"

        Image {
            id: splashImage
            source: "Images/logos/logo.png"
        }
    }

    Component.onCompleted: visible = true
}
