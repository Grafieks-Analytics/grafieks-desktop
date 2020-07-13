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

    id : queryModellerItem
    height:parent.height
    width: parent.width
    property int totalLineCount: 1


    // For line numbers
    ListModel {
        id: elementModel
        ListElement { content: "1"}
    }

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

            Repeater {
                model: elementModel
                Text { text: content;}
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

            if(lineCount < 25){
                event.accepted = true
                textedit_querymodeller.text += "\n"
                textedit_querymodeller.cursorPosition = textedit_querymodeller.text.length
                totalLineCount++

            }
        }

        onLineCountChanged: {
            // Append line numbers on query modeller
            if(totalLineCount <= lineCount){
                var content = totalLineCount +1
                elementModel.insert(totalLineCount, { "content": content.toString()})
            }

            // Remove line numbers on deleting query from the line
            else if(totalLineCount > lineCount){
                for(var i = totalLineCount; i > lineCount; i--){
                    var counter = i-1
                    elementModel.remove(counter)
                    totalLineCount--
                }
            }
        }

    }

}
