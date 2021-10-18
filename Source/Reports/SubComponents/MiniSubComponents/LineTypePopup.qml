import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents";
import "../MiniSubComponents";

Popup {

    property int shapeWidth: 20
    property int shapeHeight: 20

    width: 160
    height: 90
    x: 10
    modal: false
    visible: false

    ListModel{
        id: lineTypeModel
        ListElement{
            lineType: "Smooth Line"
            d3LineCurve: 'curveBasis'
        }
        ListElement{
            lineType: "Straight Line"
            d3LineCurve : 'curveLinear'
        }
    }

    background: Rectangle{
        color: Constants.whiteColor
        border.color: Constants.darkThemeColor
    }

    
   Connections{
        target: ReportParamsModel

        function onEditReportToggleChanged(reportId){
            if(reportId=="-1"){
                 return;
            }
            if(reportId != "false"){
                var reportProperties = ReportParamsModel.getReport(reportIdMain);
                setOldValues(reportProperties)
            }
            else{
                resetAllValues();
            }
        }
    }
    
    function resetAllValues(){
        lineTypeBox.currentIndex = lineTypeBox.find("Smooth Line");
    }

    function setOldValues(reportProperties){
        var d3PropertiesConfig = JSON.parse(reportProperties.d3PropertiesConfig);
        var { curveType  } = d3PropertiesConfig || {};
        if(curveType){
            lineTypeBox.currentIndex = lineTypeBox.find(curveType);
        }
    }


    function onLineTypeSelected(curve){
        d3PropertyConfig.curveType = lineTypeBox.currentValue;
        reDrawChart();
    }

    Rectangle{
        anchors.fill: parent

        Column{
            anchors.fill: parent
            spacing: 10

            Rectangle{
                height: 20
                width: parent.width
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("Select Line")
                }
            }

            Rectangle{
                height: 30
                width: parent.width
                CustomComboBox{
                    id: lineTypeBox
                    model: lineTypeModel
                    textRole: "lineType"
                    valueRole: "d3LineCurve"
                    width: parent.width-2*leftMargin
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: leftMargin
                    anchors.top: parent.top
                    onCurrentValueChanged: onLineTypeSelected()
                }

            }


        }

    }
}
