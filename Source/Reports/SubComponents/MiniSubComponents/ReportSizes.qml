import QtQuick 2.15
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

Column{



    property int leftMargin: 15

    property int spacingColorList: 5
    property int colorBoxHeight: 20
    property int colorListTopMargin: 5
    property int editImageSize: 16

    spacing: 4

    /***********************************************************************************************************************/
    // LIST MODEL STARTS


    ListModel{
        id: chartSizeSelectBoxModel
        ListElement{
            chartSize: "Fit Width"
            chartSizeValue: "FitWidth"
            configName: "chartType"
        }
        ListElement{
            chartSize: "Fit Height"
            chartSizeValue: "FitHeight"
            configName: "chartType"
        }
        ListElement{
            chartSize: "Standard"
            chartSizeValue: "Standard"
            configName: "Standard"
        }
    }


    // LIST MODEL ENDS
    /***********************************************************************************************************************/


    /***********************************************************************************************************************/
    // SIGNALS STARTS



    // SIGNALS ENDS
    /***********************************************************************************************************************/



    /***********************************************************************************************************************/
    // Connections Starts


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
        chartSizeSelectBox.currentIndex = chartSizeSelectBox.find('Fit Width');
    }

    function setOldValues(reportProperties){
        
        var d3PropertiesConfig = JSON.parse(reportProperties.d3PropertiesConfig);
        var { chartType } = d3PropertiesConfig;

        if(chartType){
            switch(chartType){
                case "FitWidth":
                    chartType = "Fit Width";
                    break;
                case "FitHeight":
                    chartType = "Fit Height";
                    break;
            }
            chartSizeSelectBox.currentIndex = chartSizeSelectBox.find(chartType);
        }

    }
    

    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS


    function onChartSizeChanged(value){
        switch(value){
        case "FitWidth":
        case "FitHeight":
        case "Standard":
            d3PropertyConfig.chartType = value;
            qmlChartConfig.chartType = value;
            break;
        }

        clearChartValue();
        reDrawChart();
    }


    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts


    // Show Legend Starts

    Rectangle{

        height: 50
        width: 150

        Rectangle{
            width: parent.width
            height: 30
            anchors.verticalCenter: parent.verticalCenter

            CustomComboBox{
                id: chartSizeSelectBox
                model: chartSizeSelectBoxModel
                textRole: "chartSize"
                valueRole: "chartSizeValue"
                width: parent.width-2*leftMargin
                height: 30
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: leftMargin
                anchors.top: parent.top
                onCurrentValueChanged: onChartSizeChanged(currentValue)
            }

        }

    }

    // Show Legends Ends



}
