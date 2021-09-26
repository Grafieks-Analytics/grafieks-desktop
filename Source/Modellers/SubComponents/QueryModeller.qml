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


    Connections{
        target: ConnectorsLoginModel

        function onLogout(){
            textEditQueryModeller.text = ""
        }
    }

    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS



    //    function to onTextFormatSqlKeyword
    function onTextFormatSqlKeyword(event, newText){
        event.accepted = false

        // Save the plain query for execution
        DSParamsModel.setTmpSql(newText)

        // This is for Data Preview Table (Important. Else while tying query GUI thread is blocked)
        // If set false, header wont generate in Preview
        DSParamsModel.setRunCalled(false);

        if(GeneralParamsModel.getDbClassification() === Constants.sqlType || GeneralParamsModel.getDbClassification() === Constants.accessType ){
            QueryModel.callSql(DSParamsModel.tmpSql)
        } else if(GeneralParamsModel.getDbClassification() === Constants.csvType || GeneralParamsModel.getDbClassification() === Constants.jsonType ){
            CSVJsonQueryModel.setQuery(DSParamsModel.tmpSql)
        }  else if(GeneralParamsModel.getDbClassification() === Constants.excelType){
            ExcelQueryModel.setQuery(DSParamsModel.tmpSql)
        } else{
            ForwardOnlyQueryModel.setQuery(DSParamsModel.tmpSql)
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



    Rectangle{
        height: queryModellerItem.height
        width: queryModellerItem.width
        y:-5

        Flickable {
            id: flickText

            width: queryModellerItem.width;
            height: queryModellerItem.height;
            contentWidth: textEditQueryModeller.paintedWidth
            contentHeight: textEditQueryModeller.paintedHeight
            clip: true
            flickableDirection: Flickable.VerticalFlick

            ScrollBar.vertical: ScrollBar {
                active: flickText.moving || !flickText.moving
            }
            function ensureVisible(r)
            {
                if (contentX >= r.x)
                    contentX = r.x;
                else if (contentX+width <= r.x+r.width)
                    contentX = r.x+r.width-width;
                if (contentY >= r.y)
                    contentY = r.y;
                else if (contentY+height <= r.y+r.height)
                    contentY = r.y+r.height-height;
            }

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
                        font.pointSize: Constants.fontReading
                    }
                }

            }

            ToolSeparator{
                id: toolSeperator1
                anchors.top:parent.top
                anchors.topMargin: - 6
                height:parent.height  + 60000
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

            TextEdit {
                id: textEditQueryModeller
                anchors.left: toolSeperator1.right
                width: flickText.width-10
                font.pointSize: Constants.fontReading
                padding: 10
                focus: true
                selectByMouse: true
                textFormat:TextEdit.PlainText
                wrapMode: TextEdit.WordWrap
                selectByKeyboard: true
                Keys.onReleased: onTextFormatSqlKeyword(event, text)
                selectionColor:Constants.grafieksLightGreenColor;
                onCursorRectangleChanged: flickText.ensureVisible(cursorRectangle);
            }
        }
    }
    // Page Design Ends
    /***********************************************************************************************************************/

}
