import QtQuick 2.15

Rectangle {

    function onTextChanging(){
        console.log(GeneralParamsModel.returnPlainTextFromHtml(xText.text))
    }

    Component.onCompleted: {
         console.log(GeneralParamsModel.returnPlainTextFromHtml(xText.text))
    }


    TextEdit{
        id: xText
        text:  qsTr("<!DOCTYPE html><html><body><h1 style='font-size:300%;'>This is a heading</h1><p style='font-size:160%;'>This is a paragraph.</p></body>
</html>
")
        height:300
        width: 500
        textFormat:TextEdit.RichText
        onTextChanged: onTextChanging()
    }
}
