import QtQuick 2.0

import com.grafieks.singleton.constants 1.0
import "../../MainSubComponents"

Rectangle{

    property alias textValue: textbox.text

    height: parent.height - 10
    width: 200
    border.width: 1
    border.color: this.color
    radius: this.width/2


    // Listmodel for combobox
    ListModel{
        id: calculations

        ListElement{
            calculationName:"Count"
            calculationType: "string"
            calculationCompareValue : "count"
        }
        ListElement{
            calculationName:"Count (Distinct)"
            calculationType: "string"
            calculationCompareValue : "countdistinct"
        }
        ListElement{
            calculationName:"Minimum"
            calculationType: "string"
            calculationCompareValue : "minimum"
        }
        ListElement{
            calculationName:"Maximum"
            calculationType: "string"
            calculationCompareValue : "maximum"
        }
        ListElement{
            calculationName:"Sum"
            calculationType: "number"
            calculationCompareValue : "sum"
        }
        ListElement{
            calculationName:"Average"
            calculationType: "number"
            calculationCompareValue : "average"
        }
        ListElement{
            calculationName:"Median"
            calculationType: "number"
            calculationCompareValue : "median"
        }
        ListElement{
            calculationName:"Count"
            calculationType: "number"
            calculationCompareValue : "count"
        }
        ListElement{
            calculationName:"Count (Distinct)"
            calculationType: "number"
            calculationCompareValue : "countdistinct"
        }
        ListElement{
            calculationName:"Minimum"
            calculationType: "number"
            calculationCompareValue : "minimum"
        }
        ListElement{
            calculationName:"Maximum"
            calculationType: "number"
            calculationCompareValue : "maximum"
        }
        ListElement{
            calculationName:"Percentile"
            calculationType: "number"
            calculationCompareValue : "percentile"
        }
        ListElement{
            calculationName:"Std. Dev"
            calculationType: "number"
            calculationCompareValue : "stddev"
        }
        ListElement{
            calculationName:"Std. Dev (Pop.)"
            calculationType: "number"
            calculationCompareValue : "stddevpop"
        }
        ListElement{
            calculationName:"Variance"
            calculationType: "number"
            calculationCompareValue : "variance"
        }
        ListElement{
            calculationName:"Variance (Pop.)"
            calculationType: "number"
            calculationCompareValue : "variancepop"
        }
    }

    Text {
        id: textbox
        anchors.verticalCenter: parent.verticalCenter
        x: 15
        width: parent.width - functionRectangle.width - this.x - 5
        elide: Text.ElideRight
        font.pixelSize: Constants.fontCategoryHeaderSmall
    }
    Rectangle{
        id: functionRectangle
        anchors.right: parent.right
        anchors.rightMargin: 5
        height: parent.height - 10
        anchors.top: parent.top
        anchors.topMargin: 5
        width: 80
        color: Constants.whiteColor
        radius: 10

        CustomComboBox{
            id: wildcardDropdown
            currentIndex: 0
            model: calculations
            textRole: "calculationName"
            width: parent.width
            height: parent.height
            font.pixelSize: Constants.fontReading
            anchors.centerIn: parent
        }

    }
}