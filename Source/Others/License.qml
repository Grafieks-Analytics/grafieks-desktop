import QtQuick 2.15
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0
import com.grafieks.singleton.messages 1.0
import "../MainSubComponents"


Popup {
    id: licensePopup
    x: parent.width/2 - 500
    y: parent.height/2 - 400
    width: 1000
    height: 800
    modal: true
    focus: true

    property var appInfo;

    Component.onCompleted: {
        appInfo = GeneralParamsModel.getAppInfo()
    }




    //   Rectangle{
    //      width:parent.width
    //         height:parent.height
    //       color:"red"
    //        Flickable {
    //         contentHeight: parent.height
    //         contentWidth:800
    //         ScrollBar.vertical: ScrollBar { }
    // //  clip: true
    //             flickableDirection: Flickable.VerticalFlick

    //             // ScrollBar.vertical: ScrollBar {
    //             //     active: flickText.moving || !flickText.moving
    //             // }



    ListView{
        width:parent.width
        height:parent.height-50
        model:1
        // anchors.padding:50
        ScrollBar.vertical: ScrollBar { }
        clip:true
        delegate:Row{
            width:parent.width-50

            Text{
                width:parent.width

                id: header2
                wrapMode: "WordWrap"
                text: Messages.oth_lic_mainText
                font.pointSize: 8
                font.family: Constants.fontDefault
                anchors.top: header1.bottom
                anchors.topMargin:17
                textFormat:Qt.RichText

            }  }
        
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
            licensePopup.close()
        }
        background:Rectangle{
            height:parent.height
            width:parent.width
            color:Constants.buttonHoverColor
        }
    }
    //  }
    //    }




}
