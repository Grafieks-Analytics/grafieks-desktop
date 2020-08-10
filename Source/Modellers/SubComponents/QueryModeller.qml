/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Data/SubComponents
** Query Modeller
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0

Item{

    id : queryModellerItem
    height:parent.height
    width: parent.width
    property int totalLineCount: 1
    property int lineCount: 30


    /***********************************************************************************************************************/
    // LIST MODEL STARTS


    // For line numbers
    ListModel {
        id: elementModel
        ListElement { content: "1"}
    }


    // LIST MODEL ENDS
    /***********************************************************************************************************************/


    /***********************************************************************************************************************/
    // SIGNALS STARTS



    // SIGNALS ENDS
    /***********************************************************************************************************************/



    /***********************************************************************************************************************/
    // Connections Starts



    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    Component.onCompleted: {
        textEditQueryModeller.text = "SELECT * FROM users WHERE id > 0"
    }

    function onTextEditorChanged(){
        console.log(textEditQueryModeller.text)
        // Set the Tmp SQL Query in C++
        QueryModel.setTmpSql(textEditQueryModeller.text.replace(/\n|\r/g, ""))

    }


    function onEditorLineCountChanged(){

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

    function onEnterKeyPressed(event){

        console.log('enter pressed')

        if(totalLineCount < lineCount){
            event.accepted = true
            textEditQueryModeller.text += "\n"
            textEditQueryModeller.cursorPosition = textEditQueryModeller.text.length
            totalLineCount++

        }
    }

    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts

    ToolSeparator{
        id: toolSeperator1
        anchors.top:parent.top
        anchors.topMargin: - 6
        height:parent.height  + 6
        anchors.left: left_menubar.right
        anchors.leftMargin: 30
        padding: 15
        width: 30
        contentItem: Rectangle {
            implicitWidth: parent.vertical ? 3 : 24
            implicitHeight: parent.vertical ? 24 : 3
            color: Constants.darkThemeColor
        }

        background: Rectangle{
            color: Constants.themeColor
        }

        Column{
            id: queryNumbersColumn
            topPadding: 17
            leftPadding: 12

            Repeater {
                model: elementModel
                Text { text: content;}
            }

        }

    }

    TextEdit{
        id: textEditQueryModeller
        anchors.left: toolSeperator1.right
        height:parent.height
        width: parent.width - toolSeperator1.width
        wrapMode: TextEdit.WordWrap
        padding: 10

        Keys.onReturnPressed: {

            onEnterKeyPressed(event)
        }

        onLineCountChanged: {
            onEditorLineCountChanged()
        }

        onTextChanged: {
            onTextEditorChanged()
        }

    }


    // Page Design Ends
    /***********************************************************************************************************************/


}
