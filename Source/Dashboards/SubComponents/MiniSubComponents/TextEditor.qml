import QtQuick 2.2
import QtQuick.Controls
import QtQuick.Layouts 
import QtQuick.Dialogs 
//import QtQuick.Window 2.1
import io.qt.examples.texteditor 1.0
import com.grafieks.singleton.constants 1.0

Rectangle{
    id: textEditor
    width: parent.width
    height: parent.height

    color: Constants.themeColor

    property alias widgetReportId: textEditor.reportId
    property alias widgetDashboardId : textEditor.dashboardId

    property var reportId;
    property var dashboardId

    onDashboardIdChanged: {
        if(GeneralParamsModel.isWorkbookInEditMode()){
            let dashboardId = textEditor.dashboardId
            let reportId = textEditor.reportId

            const textDocumentParams = DashboardParamsModel.getTextReportParametersMap(dashboardId, reportId)
            document.setText(textDocumentParams.text)
            document.setBold(textDocumentParams.bold)
            document.setTextColor(textDocumentParams.color)
            document.setBackgroundColor(textDocumentParams.backgroundColor)
            document.setFontFamily(textDocumentParams.fontFamily)
            document.setFontSize(textDocumentParams.fontSize)
            document.setItalic(textDocumentParams.italic)
            document.setUnderline(textDocumentParams.underline)

            containerTextArea.color = textDocumentParams.backgroundColor
        }
    }


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

            var fileName
            var currentDashboard = DashboardParamsModel.currentDashboard
            var currentReport = DashboardParamsModel.currentReport
            if(GeneralParamsModel.isWorkbookInEditMode() === false){

                let fileToken = GeneralParamsModel.getFileToken()
                fileName = dashboardId + "_" + reportId + "_" + fileToken
            } else {
                fileName = DashboardParamsModel.getDashboardWidgetUrl(dashboardId, reportId)
            }

            if(currentDashboard === dashboardId && currentReport === reportId){
                document.backgroundColor = color
                document.saveTmpFile(fileName)
                containerTextArea.color = color
            }
        }
    }


    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    Component.onCompleted: {

    }

    function copyText(){
        textArea.copy()
    }

    function slotSaveDocToHtml(){

        var fileName
        var dashboardId = DashboardParamsModel.currentDashboard
        var reportId = DashboardParamsModel.currentReport

        if(GeneralParamsModel.isWorkbookInEditMode() === false){

            let fileToken = GeneralParamsModel.getFileToken()
            fileName = dashboardId + "_" + reportId + "_" + fileToken
        } else {
            fileName = DashboardParamsModel.getDashboardWidgetUrl(dashboardId, reportId)
        }

        document.saveTmpFile(fileName)
        DashboardParamsModel.setDashboardReportUrl(dashboardId, reportId, fileName)


        // Save other params
        const textDocumentParams = {
            "text" : textArea.getText(0, document.text.length),
            "bold" : document.bold,
            "alignment" : document.alignment,
            "italic" : document.italic,
            "underline" : document.underline,
            "color" : colorDialog.selectedColor,
            "backgroundColor" : document.backgroundColor,
            "fontFamily" : document.fontFamily,
            "fontSize" : document.fontSize
        }

        DashboardParamsModel.setTextReportParametersMap(dashboardId, reportId, textDocumentParams)

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
         icon.name: "format-text-bold"
         onTriggered: document.bold = !document.bold
         checkable: true
         checked: document.bold
     }

     Action {
         id: italicAction
         icon.name: "format-text-italic"
         onTriggered: document.italic = !document.italic
         checked: document.italic
     }
     Action {
         id: underlineAction
         icon.name: "format-text-underline"
         onTriggered: document.underline = !document.underline
         checkable: true
         checked: document.underline
     }


     ColorDialog {
         id: colorDialog
          modality: Qt.WindowModal 
          title: "Choose a color"
         selectedColor: documentColor.color
        onAccepted:setTextColor(selectedColor)
     }
      Rectangle {
        id: documentColor
        color:"black"
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
                model: ["Arial", "Arial Black", "Calibri", "Cambria", "Comic Sans MS", "Courier", "Franklin Gothic", "Georgia", "Impact", "Lucida Console", "Luminari", "Tahoma", "Times New Roman", "Trebuchet MS", "Verdana"]
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
                border.color:"black"
                color: colorDialog.selectedColor;


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
        id: containerTextArea
        width: parent.width
        height: parent.height - textEditorMenu.height
        anchors.top: textEditorMenu.bottom
        anchors.topMargin: 10
        border.width: 1
        border.color: Constants.darkThemeColor

        TextArea {
            id: textArea
            Accessible.name: "document"

            // frameVisible: false
            width: parent.width
            height: parent.height
            anchors.top: parent.top
             baseUrl: "qrc:/"
            text: document.text
            textFormat: Qt.RichText
            Component.onCompleted: forceActiveFocus()
            // backgroundVisible: false

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
            textColor: colorDialog.selectedColor
            onFontFamilyChanged: {
                var index = ["Arial", "Arial Black", "Calibri", "Cambria", "Comic Sans MS", "Courier", "Franklin Gothic", "Georgia", "Impact", "Lucida Console", "Luminari", "Tahoma", "Times New Roman", "Trebuchet MS", "Verdana"].indexOf(document.fontFamily)
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
                colorBox.color = colorDialog.selectedColor
            }


        }

    }
}
