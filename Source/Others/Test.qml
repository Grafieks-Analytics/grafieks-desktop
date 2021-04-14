import QtQuick 2.15

Rectangle {

    function onTextChanging(){
        let str = xText.getText(0, xText.text.length)
        console.log(str)

        var arr1 = [];
        for (var n = 0, l = str.length; n < l; n ++)
        {
            var hex = Number(str.charCodeAt(n)).toString(16);
            arr1.push(hex);
        }
        console.log(arr1)
    }

    TextEdit{
        id: xText
        height:300
        width: 500
        textFormat:TextEdit.RichText
        onTextChanged: onTextChanging()
    }
}
