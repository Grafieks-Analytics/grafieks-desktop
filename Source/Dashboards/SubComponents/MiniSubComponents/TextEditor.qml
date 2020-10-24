import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.1
//import QtQuick.Window 2.1
import io.qt.examples.texteditor 1.0
import com.grafieks.singleton.constants 1.0

Rectangle{
    width: parent.width
    height: parent.height

    color: Constants.themeColor




    /***********************************************************************************************************************/
    // LIST MODEL STARTS



    ListModel{
        id: fontSizes
        ListElement{
            size: 8
        }
        ListElement{
            size: 9
        }
        ListElement{
            size: 10
        }
        ListElement{
            size: 11
        }
        ListElement{
            size: 12
        }
        ListElement{
            size: 13
        }
        ListElement{
            size: 14
        }
        ListElement{
            size: 16
        }
        ListElement{
            size: 18
        }
        ListElement{
            size: 20
        }
        ListElement{
            size: 22
        }
        ListElement{
            size: 24
        }
        ListElement{
            size: 28
        }
        ListElement{
            size: 32
        }
        ListElement{
            size: 48
        }
        ListElement{
            size: 64
        }
        ListElement{
            size: 78
        }
    }

    // LIST MODEL ENDS
    /***********************************************************************************************************************/


    /***********************************************************************************************************************/
    // SIGNALS STARTS



    // SIGNALS ENDS
    /***********************************************************************************************************************/



    /***********************************************************************************************************************/
    // Connections Starts


    Connections{
        target: DashboardParamsModel

        function onReportBackgroundColorChanged(dashboardId, reportId, color){

            let currentDashboard = DashboardParamsModel.currentDashboard
            let currentReport = DashboardParamsModel.currentReport
            let fileToken = GeneralParamsModel.getFileToken()
            let fileName = dashboardId + "_" + reportId + "_" + fileToken

            if(currentDashboard === dashboardId && currentReport === reportId){
                document.backgroundColor = color
                document.saveTmpFile(fileName)
            }
        }
    }


    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS


    function copyText(){
        textArea.copy()
    }

    function slotSaveDocToHtml(){

        let dashboardId = DashboardParamsModel.currentDashboard
        let reportId = DashboardParamsModel.currentReport
        let fileToken = GeneralParamsModel.getFileToken()
        let fileName = dashboardId + "_" + reportId + "_" + fileToken

        document.saveTmpFile(fileName)
        DashboardParamsModel.setDashboardReportUrl(dashboardId, reportId, fileName)
    }

    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts



    Action {
        id: alignLeftAction
        shortcut: "ctrl+l"
        onTriggered: document.alignment = Qt.AlignLeft
        checkable: true
        checked: document.alignment === Qt.AlignLeft
    }
    Action {
        id: alignCenterAction
        onTriggered: document.alignment = Qt.AlignHCenter
        checkable: true
        checked: document.alignment === Qt.AlignHCenter
    }
    Action {
        id: alignRightAction
        onTriggered: document.alignment = Qt.AlignRight
        checkable: true
        checked: document.alignment === Qt.AlignRight
    }
    Action {
        id: alignJustifyAction
        onTriggered: document.alignment = Qt.AlignJustify
        checkable: true
        checked: document.alignment === Qt.AlignJustify
    }

    Action {
        id: boldAction
        iconName: "format-text-bold"
        onTriggered: document.bold = !document.bold
        checkable: true
        checked: document.bold
    }

    Action {
        id: italicAction
        iconName: "format-text-italic"
        onTriggered: document.italic = !document.italic
        checked: document.italic
    }
    Action {
        id: underlineAction
        iconName: "format-text-underline"
        onTriggered: document.underline = !document.underline
        checkable: true
        checked: document.underline
    }


    ColorDialog {
        id: colorDialog
        color: "black"
    }


    Rectangle{
        id: textEditorMenu
        border.width: 1
        border.color: Constants.darkThemeColor

        height: 40
        width: parent.width


        Row{
            spacing: 10

            anchors.left: parent.left
            anchors.leftMargin: 10

            anchors.fill: parent
            width: parent.width
            height: parent.height


            ComboBox {
                id: fontFamilyComboBox
                implicitWidth: 150
                model: Qt.fontFamilies()
                property bool special : false
                anchors.verticalCenter: parent.verticalCenter
                onActivated: {
                    if (special == false || index != 0) {
                        document.fontFamily = textAt(index)
                    }
                }

            }

            ComboBox {
                id: fontSizeComboBox
                implicitWidth: 50
                model: fontSizes
                property bool special : false
                anchors.verticalCenter: parent.verticalCenter
                onActivated:  {
                    document.fontSize = fontSizes.get(currentIndex).size
                }
            }

            Button{
                width: 30
                height: parent.height - 16
                anchors.verticalCenter: parent.verticalCenter
                Text{
                    text: "B"
                    font.bold: true
                    anchors.centerIn: parent
                }
                action: boldAction
            }

            Button{
                width: 30
                height: parent.height - 16
                anchors.verticalCenter: parent.verticalCenter
                Text{
                    text: "I"
                    font.italic: true
                    anchors.centerIn: parent
                }
                action: italicAction
            }

            Button{
                width: 30
                height: parent.height - 16
                anchors.verticalCenter: parent.verticalCenter
                Text{
                    text: "U"
                    font.underline: true
                    anchors.centerIn: parent
                }
                action: underlineAction
            }

            Rectangle{
                id: colorBox
                width: 30
                height: parent.height - 16
                anchors.verticalCenter: parent.verticalCenter
                color: colorDialog.color;


                MouseArea{
                    anchors.fill: parent
                    onClicked: colorDialog.open()
                }
            }



            Button{
                width: 30
                height: parent.height - 16
                anchors.verticalCenter: parent.verticalCenter
                Image{
                    width: 18
                    height: 18
                    source: "/Images/icons/align-left.png"
                    anchors.centerIn: parent
                }
                action: alignLeftAction
            }


            Button{
                width: 30
                height: parent.height - 16
                anchors.verticalCenter: parent.verticalCenter
                Image{
                    width: 18
                    height: 18
                    source: "/Images/icons/align-center.png"
                    anchors.centerIn: parent
                }
                action: alignCenterAction
            }

            Button{
                width: 30
                height: parent.height - 16
                anchors.verticalCenter: parent.verticalCenter
                Image{
                    width: 18
                    height: 18
                    source: "/Images/icons/align-right.png"
                    anchors.centerIn: parent
                }
                action: alignRightAction
            }

            Button{
                width: 30
                height: parent.height - 16
                anchors.verticalCenter: parent.verticalCenter
                Image{
                    width: 18
                    height: 18
                    source: "/Images/icons/align-justify.png"
                    anchors.centerIn: parent
                }
                action: alignJustifyAction
            }


            Button{
                width: 30
                height: parent.height - 16
                anchors.verticalCenter: parent.verticalCenter
                Image{
                    width: 18
                    height: 18
                    source: "/Images/icons/attach-link.png"
                    anchors.centerIn: parent
                }
            }
        }


    }

    Rectangle{
        width: parent.width
        height: parent.height - textEditorMenu.height
        anchors.top: textEditorMenu.bottom
        anchors.topMargin: 10
        border.width: 1
        border.color: Constants.darkThemeColor

        TextArea {
            Accessible.name: "document"
            id: textArea
            frameVisible: false
            width: parent.width
            height: parent.height
            anchors.top: parent.top
            baseUrl: "qrc:/"
            text: document.text
            textFormat: Qt.RichText
            Component.onCompleted: forceActiveFocus()
            backgroundVisible: false
        }

        MessageDialog {
            id: errorDialog
        }

        DocumentHandlerModel {
            id: document
            target: textArea
            cursorPosition: textArea.cursorPosition
            selectionStart: textArea.selectionStart
            selectionEnd: textArea.selectionEnd
            textColor: colorDialog.color
            onFontFamilyChanged: {
                var index = Qt.fontFamilies().indexOf(document.fontFamily)
                if (index === -1) {
                    fontFamilyComboBox.currentIndex = 0
                    fontFamilyComboBox.special = true
                } else {
                    fontFamilyComboBox.currentIndex = index
                    fontFamilyComboBox.special = false
                }
            }
            onError: {
                errorDialog.text = message
                errorDialog.visible = true
            }
            onTextColorChanged: {
                colorBox.color = colorDialog.color
            }


        }

    }
}
