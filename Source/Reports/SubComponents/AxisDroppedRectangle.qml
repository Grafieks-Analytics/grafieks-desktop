import QtQuick 2.0

import com.grafieks.singleton.constants 1.0
import "../../MainSubComponents"
import "./MiniSubComponents"

Rectangle{

    id: axisRectangle
    property var itemType: null;

    property alias textValue: textbox.text
    property alias itemType: axisRectangle.itemType

    height: ((parent && parent.height) - 10) || 0
    width: 200
    border.width: 1
    border.color: this.color
    radius: this.width/2
    z: 1000000

    Component.onCompleted: {
        console.log('Item Type',itemType, typeof(itemType));
        axisRectangle.color = itemType.toLowerCase() === 'numerical' ? Constants.defaultYAxisColor : Constants.defaultXAxisColor
    }

    function onDateFormatSelected(index){
        var dateFormat = dateCalculations.get(index).dateFormat;
        report_desiner_page.d3PropertyConfig['dateFormat'] = dateFormat;
        report_desiner_page.reDrawChart();
    }

    ListModel{
        id: dateCalculations
        ListElement{
            calculationName:"Year"
            dateFormat: "%Y"
        }
        ListElement{
            calculationName:"Day"
            dateFormat: "%d"
        }
        ListElement{
            calculationName:"Month"
            dateFormat: "%b"
        }
        ListElement{
            calculationName:"Day-Month-Year"
            dateFormat: "%d %b %Y"
        }
        ListElement{
            calculationName:"Month & Year"
            dateFormat: "%b %Y"
        }
        ListElement{
            calculationName:"Quarter"
            dateFormat: "%d-%m-%Y"
        }

    }

    // Listmodel for combobox
    ListModel{
        id: numericalCalculations
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


    AxisItemMenuPopup{
        id: axisMenu
        rectIndex: index
    }

    MouseArea{
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: (mouse.button == Qt.RightButton) ? (axisMenu.visible = true) : null

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
        visible: (itemType && itemType.toLowerCase()) === 'date' ? true : false

        CustomComboBox{
            id: dateDropdown
            currentIndex: 0
            model: dateCalculations
            textRole: "calculationName"
            width: parent.width
            height: parent.height
            font.pixelSize: Constants.fontReading
            anchors.centerIn: parent
            onCurrentIndexChanged: onDateFormatSelected(currentIndex)
        }

    }
}
