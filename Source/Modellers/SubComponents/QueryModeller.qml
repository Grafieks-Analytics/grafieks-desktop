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

    property bool stateValue:false

    /***********************************************************************************************************************/
    // LIST MODEL STARTS


    // For line numbers
    ListModel {
        id: elementModel
        ListElement { content: "1"}
    }

    onStateValueChanged: {
        if(stateValue==false){
            // onTextFormatSqlKeyword()
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



    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    Component.onCompleted: {
        //        textEditQueryModeller.text = "SELECT * FROM users WHERE users.id > 0"
        textEditQueryModeller.text = "SELECT * FROM users WHERE users.id > 0 "



    }

    function onTextEditorChanged(){
//        console.log("TEXTED", textEditQueryModeller.text)

        // Set the Tmp SQL Query in C++
        DSParamsModel.setTmpSql(textEditQueryModeller.text.replace(/\n|\r/g, " "))
//        console.log("TEXTED", textEditQueryModeller.text.replace(/\n|\r/g, ""))
        if(!stateValue){
            onTextFormatSqlKeyword()
        }

    }

    //    function to onTextFormatSqlKeyword
    function onTextFormatSqlKeyword(){

        var arraySqlKeyword =["SELECT","FROM"]

        var textData = textEditQueryModeller.getText(0,textEditQueryModeller.text.length);
        console.log('textData',textEditQueryModeller.text.length, typeof textEditQueryModeller.text);
        textEditQueryModeller.cursorPosition = textEditQueryModeller.text.length

        textData = textData.replace(/?/g,'');
        var textArrayQueryNewLine = textData.split("<br/>");
        var textArrayQueryOutputNewLine = []

        console.log("textArrayQueryNewLine"+JSON.stringify(textArrayQueryNewLine))

        textArrayQueryNewLine.forEach((elementNew)=>{
                                          // console.log("elementNew"+elementNew)

                                          var textArrayQuery = elementNew.split(" ")
                                          var textArrayQueryOutput = []



                                          textArrayQuery.forEach((element)=>
                                                                 {
                                                                     // console.log("element"+element.replace(/\n|\r/g, " "))
                                                                     if( arraySqlKeyword.includes(element) )
                                                                     {
                                                                         textArrayQueryOutput.push("<span style='color:"+Constants.grafieksGreenColor+"'>"+element+"</span>")
                                                                     }
                                                                     else{
                                                                         textArrayQueryOutput.push(element)
                                                                     }
                                                                 }

                                                                 )
                                          // console.log("textArrayQueryOutput"+textArrayQueryOutput)


                                          textArrayQueryOutputNewLine.push(textArrayQueryOutput.join(" "))

                                      }
                                      )

        var finalOutput =textArrayQueryOutputNewLine.join("<br>")

        //        console.log('Final Output',finalOutput, typeof finalOutput);
        stateValue = true;
        textEditQueryModeller.text = returnPlainTextFromHtml(finalOutput);

        //        console.log("textArrayQueryOutputNewLine"+textArrayQueryOutputNewLine)

    }


    function onEditorLineCountChanged(){
        var lineCount = textEditQueryModeller.lineCount
        console.log(lineCount);
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
        console.log(textEditQueryModeller.lineCount)

        if(totalLineCount < lineCount){
            event.accepted = true
            textEditQueryModeller.text += "<br />"
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


    Column{
        id: queryNumbersColumn

        anchors.top:parent.top
        topPadding: 10
        leftPadding: 10
        height:parent.height  + 6

        Repeater {
            model: elementModel
            Text {
                text: content
                anchors.horizontalCenter: Text.AlignHCenter
            }
        }

    }

    ToolSeparator{
        id: toolSeperator1
        anchors.top:parent.top
        anchors.topMargin: - 6
        height:parent.height  + 6
        anchors.left: queryNumbersColumn.right
        anchors.leftMargin: 10
        padding: 15
        width: 1
        contentItem: Rectangle {
            implicitWidth: parent.vertical ? 3 : 24
            implicitHeight: parent.vertical ? 24 : 3
            color: Constants.darkThemeColor
        }

        background: Rectangle{
            color: Constants.darkThemeColor
        }

    }

    TextEdit{
        id: textEditQueryModeller
        anchors.left: toolSeperator1.right
        height:parent.height
        width: parent.width - toolSeperator1.width
        //        wrapMode: TextEdit.WordWrap
        padding: 10

        //        text: {
        //            if(textEditQueryModeller.WordWrap === "SELECT * FROM users WHERE users.id > 0"){
        //            color:"yellow"
        //            }
        //        }

        textFormat:TextEdit.RichText
        selectByMouse: true
        selectionColor:Constants.grafieksLightGreenColor;
        selectByKeyboard: true
        Keys.onReturnPressed: {
            onEnterKeyPressed(event)
        }

        onLineCountChanged: {
            onEditorLineCountChanged()
        }
        Keys.onPressed: {
            if (event.key === Qt.Key_Space) {
                stateValue=false
            }
        }
        onTextChanged: {
            onTextEditorChanged()
        }

    }


    // Page Design Ends
    /***********************************************************************************************************************/


}
