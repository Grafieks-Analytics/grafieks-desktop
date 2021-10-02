import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

Row{
    id:toolTipRow
     property alias textValue: xAxisToolTipLabelText.text
     property var textLabel1: ""
     property alias textLabel: toolTipRow.textLabel1
    width:500
    height:50

    Column{
         Rectangle{
                    id:xAxisToolTipLabel
                    height:30
                    width:200
                    Text {
                        id:xAxisToolTipLabelText
                        }

         }

    }
    Column{
         Rectangle{
                id:toolTipEdit
                height:25
                width:200

                
      

                TextField{
                    id:toolTipText
                    width: 200
                    selectByMouse: true
                    height:25
                    cursorVisible: true
                 
       
                    placeholderText: textValue
                    background: Rectangle{
                        border.width: 1
                        border.color:Constants.borderBlueColor


                    }
                    onTextChanged: {
                        var obj = d3PropertyConfig.toolTip || {}
                        obj[textLabel1]=toolTipText.text;
                        d3PropertyConfig.toolTip=obj;
                        // console.log("textlabel1"+textLabel1)
                        console.log(JSON.stringify(d3PropertyConfig.toolTip))
                        reDrawChart();

                    }
                    
                }
            }

    }
}
