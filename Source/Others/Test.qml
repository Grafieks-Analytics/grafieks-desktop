import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Shapes 1.15

import com.grafieks.singleton.constants 1.0

import "../MainSubComponents"

Rectangle {

    // I have noticed that when you convert rich text to normal string,
    // some non printable characters like carriage return are not convereted to proper string, like \r\n
    // Hence the console is unable to print them properly and displays '?'
    // I have converted it to HEX and checked. It Works

    // You might need to work on HEX and do the needful operation

    function onTextChanging(){
        let str = xText.getText(0, xText.text.length)

        let arr = [];
        for (var i = 0; i < str.length; i++) {
            arr[i] = ("00" + str.charCodeAt(i).toString(16)).slice(-4);
            console.log("Char", ("00" + str.charCodeAt(i).toString(16)).slice(-4))
        }
        console.log("The hex string is", "\\u" + arr.join("\\u"));

        // To Convert back to normal string
        // console.log(unescape(str.replace(/\\/g, "%"))
    }


    TextEdit{
        id: xText
        height:300
        width: 500
        textFormat:TextEdit.RichText
        onTextChanged: onTextChanging()
    }
}
