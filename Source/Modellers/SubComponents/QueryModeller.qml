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



    //    function to onTextFormatSqlKeyword
    function onTextFormatSqlKeyword(event, newText){
        event.accepted = false
        let finalQueryString = this.processText(newText)
        let cursorPosition = textEditQueryModeller.cursorPosition


        textEditQueryModeller.text = finalQueryString
        textEditQueryModeller.insert(cursorPosition, " ")
        textEditQueryModeller.cursorPosition = cursorPosition

        // Save the plain query for execution
        DSParamsModel.setTmpSql(GeneralParamsModel.returnPlainTextFromHtml(textEditQueryModeller.text))

    }

    function processText(newText){

        var finalQueryString = ""
        var lineItemElementArray = []
        var arraySqlKeyword =["SELECT","FROM","WHERE"]

        var headerString = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN" "http://www.w3.org/TR/REC-html40/strict.dtd"><html><head><meta name="qrichtext" content="1" /><style type="text/css">p, li { white-space: pre-wrap; }</style></head><body style=" font-family:\'MS Shell Dlg 2\'; font-size:7.8pt; font-weight:400; font-style:normal;">'
        var footerString = '</body></html>'
        var startString = '<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">'
        var endString = '</p>'

        finalQueryString = headerString

        var elems = newText.match(/<p [^>]+>(.*?)<\/p>/g)
        elems.forEach((item, index) => {
                          finalQueryString += startString
                          lineItemElementArray[index] = GeneralParamsModel.returnPlainTextFromHtml(item).split(" ")
                          lineItemElementArray[index].forEach((innerItem, innerIndex) => {
                                                                  if(arraySqlKeyword.indexOf(innerItem.toUpperCase()) > -1){
                                                                      finalQueryString += "<span style='color:"+Constants.grafieksGreenColor+";'>"+innerItem+"</span> ";
                                                                  } else{
                                                                      finalQueryString += innerItem + " "
                                                                  }
                                                              })
                          finalQueryString +=endString
                      })
        finalQueryString += footerString;

        return finalQueryString;
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

    Flickable {
        id: flickArea
        width: parent.width - toolSeperator1.width
        height: parent.height
        anchors.left: toolSeperator1.right
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.HorizontalFlick
        interactive: true
        function ensureVisible(r) {
            if (contentX >= r.x)
                contentX = r.x;
            else if (contentX+width <= r.x+r.width)
                contentX = r.x+r.width-width;
            if (contentY >= r.y)
                contentY = r.y;
            else if (contentY+height <= r.y+r.height)
                contentY = r.y+r.height-height;
        }

        TextEdit {
            id: textEditQueryModeller
            textFormat:TextEdit.RichText
            anchors.left: toolSeperator1.right
            width: parent.width - toolSeperator1.width
            padding: 10
            Keys.onReleased: onTextFormatSqlKeyword(event, text)
            focus: true
            wrapMode: TextEdit.Wrap
            onCursorRectangleChanged: flickArea.ensureVisible(cursorRectangle)
            selectionColor:Constants.grafieksLightGreenColor;
            selectByKeyboard: true
            selectByMouse: true
        }

    }


    // Page Design Ends
    /***********************************************************************************************************************/


}
