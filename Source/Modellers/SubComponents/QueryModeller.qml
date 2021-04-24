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
        //                textEditQueryModeller.text = "<h1>SELECT * FROM users WHERE users.id > 0</h1>"
                textEditQueryModeller.text = " SELECT * FROM users WHERE users.id > 0 "



    }

    function onTextEditorChanged(){
        //        console.log(textEditQueryModeller.text)
        // Set the Tmp SQL Query in C++
        //        DSParamsModel.setTmpSql(textEditQueryModeller.text.replace(/\n|\r/g, " "))
    }

    //    function to onTextFormatSqlKeyword
    function onTextFormatSqlKeyword(){


        console.log("textEditQueryModeller.text"+textEditQueryModeller.text);
        var finalQueryString = ""
        var lineItemElementArray = []
        var arraySqlKeyword =["SELECT","FROM","WHERE"]

        var headerString = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN" "http://www.w3.org/TR/REC-html40/strict.dtd"><html><head><meta name="qrichtext" content="1" /><style type="text/css">p, li { white-space: pre-wrap; }</style></head><body style=" font-family:\'MS Shell Dlg 2\'; font-size:7.8pt; font-weight:400; font-style:normal;">'
        var footerString = '</body></html>'
        var startString = '<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">'
        var endString = '</p>'

        finalQueryString = headerString

        var elems = textEditQueryModeller.text.match(/<p [^>]+>(.*?)<\/p>/g)
        elems.forEach((item, index) => {
                          finalQueryString += startString
                          lineItemElementArray[index] = GeneralParamsModel.returnPlainTextFromHtml(item).split(" ")
                          lineItemElementArray[index].forEach((innerItem, innerIndex) => {
                                                                  if(arraySqlKeyword.indexOf(innerItem.toUpperCase()) > -1){
                                                                      console.log("change"+innerItem)
                                                                      finalQueryString += "<span style='color:"+Constants.grafieksGreenColor+";'>"+innerItem+"</span> ";

                                                                      console.log("changeq"+finalQueryString)
                                                                  } else{
                                                                      finalQueryString += innerItem + " "
                                                                  }
                                                              })
                          finalQueryString +=endString
                      })
        finalQueryString += footerString;





        console.log( finalQueryString)

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
            model: textEditQueryModeller.lineCount
            Text {
                text: modelData + 1
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
        width: parent.width - toolSeperator1.width
        wrapMode: TextEdit.WordWrap
        padding: 10

        textFormat:TextEdit.RichText

        selectByMouse: true
        selectionColor:Constants.grafieksLightGreenColor;
        selectByKeyboard: true

        onTextChanged: {
            onTextEditorChanged()
            onTextFormatSqlKeyword()
        }

    }


    // Page Design Ends
    /***********************************************************************************************************************/


}
