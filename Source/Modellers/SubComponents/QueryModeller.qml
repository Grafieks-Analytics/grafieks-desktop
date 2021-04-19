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
        //        textEditQueryModeller.text = "SELECT * FROM users WHERE users.id > 0"
        textEditQueryModeller.text = " SELECT * FROM users WHERE users.id > 0 "



    }

    function onTextEditorChanged(){
        console.log(textEditQueryModeller.text)
        // Set the Tmp SQL Query in C++
        DSParamsModel.setTmpSql(textEditQueryModeller.text.replace(/\n|\r/g, " "))
    }

    //    function to onTextFormatSqlKeyword
    function onTextFormatSqlKeyword(){

        var arraySqlKeyword =["SELECT","FROM","WHERE"]



        var formmattedData = textEditQueryModeller.text.replace(/text-indent:0px;\"\>/g,'text-indent:0px;">' )
        console.log("formmattedData"+formmattedData);
        var textArrayQueryNewLine = formmattedData.split("\n")
        var textArrayQueryOutputNewLine = []

//        console.log("textArrayQueryNewLine"+JSON.stringify(textArrayQueryNewLine))


        textArrayQueryNewLine.forEach((elementNew)=>{
                                          //  console.log("elementNew"+elementNew)


                                          var textArrayQuery = elementNew.split(' ')
//                                          var textArrayQuery = elementNew.split('text-indent:0px;\"\>')
//                                          textArrayQuery = elementNew.split(" ")
                                          var textArrayQueryOutput = []



                                          textArrayQuery.forEach((element)=>
                                                                 {
                                                                     console.log("element"+GeneralParamsModel.returnPlainTextFromHtml(element))
//                                                                     var a = element;
//                                                                     console.log("txt"+a.getText(0,10));
                                                                     //     console.log("element"+element.replace(/\n|\r/g, " "))

//                                                                     if(element.includes("SELECT")){
//                                                                         console.log("ravi123"+element)
////                                                                         textArrayQueryOutput.push("text-indent:0px;"><span style='color:"+Constants.grafieksGreenColor+"'>"+element+"</span>")
//                                                                         textArrayQueryOutput.push("<span style='color:"+Constants.grafieksGreenColor+"'>"+"SELECT"+"</span>")
//                                                                     }

                                                                     /*else*/ if( arraySqlKeyword.includes(element) )
                                                                     {
                                                                         console.log("ravi1234"+element)

                                                                         textArrayQueryOutput.push("<span style='color:"+Constants.grafieksGreenColor+"'>"+element+"</span>")
                                                                     }
                                                                     else{
                                                                         textArrayQueryOutput.push(element)
                                                                     }

                                                                 }

                                                                 )
                                          //                                           console.log("textArrayQueryOutput"+textArrayQueryOutput)


                                          textArrayQueryOutputNewLine.push(textArrayQueryOutput.join(" "))

                                      }
                                      )

        textEditQueryModeller.text=textArrayQueryOutputNewLine.join("\n")
        //        console.log("textArrayQueryOutputNewLine"+textArrayQueryOutputNewLine)

    }


    function onEditorLineCountChanged(){
        var lineCount = textEditQueryModeller.lineCount
        console.log("linecount"+totalLineCount);
        // Append line numbers on query modeller

        if(totalLineCount <= lineCount){
            console.log("yes")
            var content = totalLineCount + 1
            console.log("content"+content)
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
        wrapMode: TextEdit.WordWrap
        padding: 10

        textFormat:TextEdit.AutoText

        selectByMouse: true
        selectionColor:Constants.grafieksLightGreenColor;
        selectByKeyboard: true
        Keys.onReturnPressed: {

            onEnterKeyPressed(event)
        }

        onLineCountChanged: {
            onEditorLineCountChanged()
        }

        onTextChanged: {
            onTextEditorChanged()
            onTextFormatSqlKeyword()

        }

    }


    // Page Design Ends
    /***********************************************************************************************************************/


}
