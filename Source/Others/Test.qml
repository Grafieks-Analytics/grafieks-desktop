import QtQuick 2.15

Rectangle {

    function onTextChanging(){
        console.log(GeneralParamsModel.returnPlainTextFromHtml(xText.text))
    }

    TextEdit{
        id: xText
        height:300
        width: 500
        textFormat:TextEdit.RichText
        onTextChanged: onTextChanging()
    }
}
