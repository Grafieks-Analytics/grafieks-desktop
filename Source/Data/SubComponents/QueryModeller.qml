import QtQuick 2.11
import QtQuick.Controls 2.4


Item{

    height:implicitHeight
    width: implicitWidth

    TextEdit{
        id: textedit_querymodeller
        height:430
        width: parent.width
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

    Rectangle{
        anchors.top:textedit_querymodeller.bottom
        anchors.left: parent.left
        anchors.leftMargin: 10

        Button{
            text:"Test Query"
        }
    }

}
