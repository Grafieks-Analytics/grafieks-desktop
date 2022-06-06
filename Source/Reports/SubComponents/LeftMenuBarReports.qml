/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** MainSubComponents
** Left Menu Bar
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0
import "../chartsConfig.js" as ChartsConfig

Rectangle{
    id: rectangle_left
    color: Constants.themeColor
    height: parent.height - 30
    width: 60
    z:100

    signal loadchart(string chartname)


    property int imageRectangleHeight: 32;
    property int imageHeight: 32;
    property int imageWidth: 32;

    property string selectedChart: "bar"

    /***********************************************************************************************************************/
    // LIST MODEL STARTS

    


    // LIST MODEL ENDS
    /***********************************************************************************************************************/


    /***********************************************************************************************************************/
    // SIGNALS STARTS



    // SIGNALS ENDS
    /***********************************************************************************************************************/



    /***********************************************************************************************************************/
    // Connections Starts



    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    Component.onCompleted: {

        // create all charts mapping from the list model
        // If any mapping is added please update 
        // New Reports.qml File in onChartTitleChanged function

        ChartsConfig.setAllChartsModel();

        for(var i=0; i< allCharts.count; i++){
            var chartTitle = allCharts.get(i).title;

            console.log('Chart Title, Making Mapping',chartTitle)

            var maxDropOnXAxis = allCharts.get(i).maxDropOnXAxis;
            var maxDropOnYAxis = allCharts.get(i).maxDropOnYAxis;
            var maxDropOnRow3Axis = allCharts.get(i).maxDropOnRow3Axis;

            var colorByDropEligible = allCharts.get(i).colorByDropEligible;
            var axisSettingsDisabled = !!allCharts.get(i).axisSettingsDisabled;

            var mainCustomizations = !!allCharts.get(i).mainCustomizations;
            var subMenuCustomizations = !!allCharts.get(i).subMenuCustomizations;

           var disabled = !!allCharts.get(i).disabled;
            allChartsMapping[chartTitle] = {
                'maxDropOnXAxis': maxDropOnXAxis || -1,
                'maxDropOnYAxis': maxDropOnYAxis || -1,
                'maxDropOnRow3Axis': maxDropOnRow3Axis || -1,
                disabled,
                colorByDropEligible,
                axisSettingsDisabled,
                mainCustomizations,
                subMenuCustomizations
            };

        }

        // Setting initial default values
        allowedXAxisDataPanes = 2;
        allowedYAxisDataPanes = 1;
    }

   function getChart(chartHtml,index,chartTitle,mainCustomizations, subMenuCustomizations=""){
        if(allChartsMapping[chartTitle].disabled){
            return
        }
        report_desiner_page.previousChartTitle = report_desiner_page.chartTitle;
        report_desiner_page.chartTitle = chartTitle;

        report_desiner_page.customizationsAvailable = mainCustomizations;
        report_desiner_page.subMenuCustomizationsAvailable = subMenuCustomizations;
        
        var xAxisColumns = getAxisColumnNames(Constants.xAxisName);
        var yAxisColumns = getAxisColumnNames(Constants.yAxisName);

        if(chartTitle === Constants.barChartTitle){
            if(report_desiner_page.isHorizontalGraph){
                if(xAxisColumns.length === 1 && yAxisColumns.length === 1 && colorListModel.count == 0){
                    chartTitle = Constants.horizontalBarChartTitle;
                }
                else if(xAxisColumns.length === 1 && yAxisColumns.length === 1 && colorListModel.count == 1){
                    chartTitle = Constants.horizontalStackedBarChartTitle;
                }else if(xAxisColumns.length === 1 && yAxisColumns.length === 2){
                    chartTitle = Constants.horizontalBarGroupedChartTitle;
                }
            }else{
                if(xAxisColumns.length === 1 && yAxisColumns.length === 1 && colorListModel.count === 1){
                    chartTitle = Constants.stackedBarChartTitle;
                }else if(xAxisColumns.length === 1 && yAxisColumns.length === 2){
                    chartTitle = Constants.barGroupedChartTitle;
                }
            }
        }
        else if(chartTitle === Constants.areaChartTitle){
            if(report_desiner_page.isHorizontalGraph){
                if(xAxisColumns.length === 1 && yAxisColumns.length === 1 && colorListModel.count == 0){
                    chartHtml = Constants.horizontalAreaChartUrl;
//                    switchChart(Constants.horizontalBarChartTitle);
                }
                else if(xAxisColumns.length === 1 && yAxisColumns.length === 1 && colorListModel.count == 1){
                    chartHtml = Constants.multipleHorizontalAreaChartUrl;
                }else{
                    console.log('missed horizontal area case');
                }
            }else{
                if(xAxisColumns.length === 1 && yAxisColumns.length === 1 && colorListModel.count === 1){
                    chartHtml = Constants.multipleAreaChartUrl;
                }else{
                    console.log('missed area case',chartHtml);
                }
            }
        }
        else if(chartTitle === Constants.lineChartTitle){
            if(report_desiner_page.isHorizontalGraph){
                if(xAxisColumns.length === 1 && yAxisColumns.length === 1 && colorListModel.count == 0){
                    chartHtml = Constants.horizontalLineChartUrl;
                }else if(xAxisColumns.length === 1 && yAxisColumns.length === 1 && colorListModel.count == 1){
                    chartHtml = Constants.horizontalMultiLineChartUrl;
                    console.log('Horizontal Chart Load');
                }else{
                    // chartHtml = Constants.horizontalLineChartUrl; // Added on last day
                    console.log('Missed Horizontal Condition ---> Making it horizontal line chart!')
                }
            }else{
                if(xAxisColumns.length === 1 && yAxisColumns.length === 1 && colorListModel.count !== 0){
                    console.log('Debug: Loading multiline chart');
                    chartHtml = Constants.multiLineChartUrl;
                    // switchChart(Constants.multiLineChartTitle);
                }
            }
        }
        

//        add toggle left menu


//        yAxisVisible  = allCharts.get(index).yAxisVisible;

        const yAxisLabelNameData = allCharts.get(index).yAxisLabelName;
        yAxisLabelName = yAxisLabelNameData ? yAxisLabelNameData: Constants.yAxisName; 

        const xAxisLabelNameData = allCharts.get(index).xAxisLabelName;
        xAxisLabelName = xAxisLabelNameData ? xAxisLabelNameData: Constants.xAxisName;
        
        // Setting line chart visibilities at global level
        lineTypeChartVisible = allCharts.get(index).lineTypeChartVisible;
        pivotThemeVisible = !!allCharts.get(index).themeVisible;

        makeChartActive(index)
    }

    function makeChartActive(index){
        allCharts.set(activeChartIndex,{activeChart: false})
        activeChartIndex = index;
        allCharts.set(index,{activeChart: true})
    }

    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts



    Column{

        id: leftmenu_col
        width: parent.width
        spacing: 10
        z:100

        ListView{
            height: allCharts.count * 40
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            model: allCharts
            spacing: 2.5
            interactive: false
            delegate: Rectangle{
                width: parent.width
                height: imageRectangleHeight
                color: activeChart ? Constants.darkThemeColor : Constants.themeColor
                property bool displayToolTipVisible: false
                Image{
                    source:"/Images/icons/charts/"+icon
                    anchors.centerIn: parent
                    height: elementHeight ? elementHeight : imageHeight
                    width: elementWidth ? elementWidth : imageWidth
                }
                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked:  getChart(chartHtml,index,title,mainCustomizations,subMenuCustomizations) // When chart is clicked from the right side, Chart is switched 
                    onEntered: displayToolTipVisible=true
                    onExited: displayToolTipVisible=false
                }
                ToolTip.delay: Constants.tooltipShowTime
                ToolTip.timeout: Constants.tooltipHideTime
                ToolTip.visible: displayToolTipVisible
                ToolTip.text: qsTr(title)

            }

        }
    }
}


