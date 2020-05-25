/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Data/SubComponents
** Query Modeller
**
****************************************************************************/

import QtQuick 2.11
import QtQuick.Controls 2.4

import com.grafieks.singleton.constants 1.0

Item{

    height:parent.height
    width: parent.width


    ToolSeparator{
        id: tool_sep1
        anchors.top:parent.top
        anchors.topMargin: -7
        height:parent.height  + 7
        padding: 15
        width: 30
        contentItem: Rectangle {
            implicitWidth: parent.vertical ? 1 : 24
            implicitHeight: parent.vertical ? 24 : 1
            color: Constants.themeColor
        }

        background: Rectangle{
            color: Constants.themeColor
        }

        Column{
            id: query_numbers_column
            topPadding: 17
            leftPadding: 12

            Text {
                text:  "1"
            }

            Text {
                text:  "2"
            }

            Text {
                text:  "3"
            }
        }

    }

    TextEdit{
        id: textedit_querymodeller
        anchors.left: tool_sep1.right
        height:parent.height
        width: parent.width - tool_sep1.width
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


}
