import QtQuick 2.0

import com.grafieks.singleton.constants 1.0
import "../../MainSubComponents"
import "./MiniSubComponents"

// TODO
// Add the custom values used in model
// axisType: To update the dateFormat -> This get the axis name

Rectangle{

    id: axisRectangle
    property var itemType: null;
    property var itemIndexId: null;
    property var axisType: null;
    property var dateFormatValue: null;

    property alias textValue: textbox.text
    property alias itemType: axisRectangle.itemType
    property alias itemIndexId: axisRectangle.itemIndexId
    property alias axisType: axisRectangle.axisType
    property alias dateFormatValue: axisRectangle.dateFormatValue
    

    height: ((parent && parent.height) - 10) || 0
    width: 200
    border.width: 1
    border.color: this.color
    radius: this.width/2
    z: 1000000

    Component.onCompleted: {
        console.log('Item Type',itemType, typeof(itemType));
        axisRectangle.color = itemType && itemType.toLowerCase() === 'numerical' ? Constants.defaultYAxisColor : Constants.defaultXAxisColor
        console.log('Index and Axis Name', itemIndexId, axisType, dateFormatValue);

        
        
    }

    function onDateFormatSelected(index){
        var dateFormat = dateCalculations.get(index).dateFormat;
        report_desiner_page.d3PropertyConfig['dateFormat'] = dateFormat;
        report_desiner_page.reDrawChart();

        switch(axisType){
            case Constants.xAxisName:
                xAxisListModel.setProperty(itemIndexId,'dateFormat',dateFormat);
                break;
            case Constants.yAxisName:
                yAxisListModel.setProperty(itemIndexId,'dateFormat',dateFormat);
                break;
        }
    }

    function getIndexValue(dateFormat){
        
        for(var i=0; i< dateCalculations.count; i++){
            console.log(i);
            var dateFormatModelValue = dateCalculations.get(i).dateFormat; 
            if(dateFormatModelValue === dateFormat){
                return i;
            }
        }

        console.log('Error in Axis DroppedRectangle, Getting Index');
        return 0;
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
        // [Tag: Future Release]
        // ListElement{
        //     calculationName:"Quarter"
        //     dateFormat: "%d-%m-%Y"
        // }

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
            Component.onCompleted: currentIndex = getIndexValue(dateFormatValue)
            font.pixelSize: Constants.fontReading
            anchors.centerIn: parent
            onCurrentIndexChanged: onDateFormatSelected(currentIndex)
        }

    }
}
