import QtQuick 2.11
import QtQuick.Controls 2.4

import "../../../Constants.js" as Constants

Item{

    height:parent.height
    width: parent.width

    TextEdit{
        id: textedit_querymodeller
        height:parent.height
        width: parent.width - sub_rectangle.width - tool_sep1.width
        wrapMode: TextEdit.WordWrap
        padding: 10

        Keys.onReturnPressed: {
            console.log(lineCount)

            if(lineCount < 15){
                event.accepted = true
                textedit_querymodeller.text += "\n"
                textedit_querymodeller.cursorPosition = textedit_querymodeller.text.length
            }
        }
    }

    ToolSeparator{
        id: tool_sep1
        anchors.left: textedit_querymodeller.right
        anchors.top:parent.top
        anchors.topMargin: -7
        height:parent.height  + 7
        padding: 0

        contentItem: Rectangle {
            implicitWidth: parent.vertical ? 1 : 24
            implicitHeight: parent.vertical ? 24 : 1
            color: Constants.themeColor
        }


    }

    Rectangle{
        id: sub_rectangle
        anchors.left: tool_sep1.right
        height: parent.height
        width: 165

        Button{
            id: text_query_btn
            anchors.left: parent.left
            anchors.leftMargin: 10
            text:"Test Query"
        }
    }

}
