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
    property int activeChartIndex: 0;

    /***********************************************************************************************************************/
    // LIST MODEL STARTS

    ListModel{
        id: allCharts
        ListElement{
            icon: "bar_chart.png"
            chartHtml:"BarChartArrayInput.html"
            name: "bar"
            activeChart: true
            title: "Bar Chart"
            yAxisVisible: true
            lineTypeChartVisible: false
            maxDropOnXAxis: 2
            maxDropOnYAxis: 1
            mainCustomizations: "Properties,Legend,Reference Line,Axis Size"
        }
        ListElement{
            icon: "area.png"
            chartHtml:"AreaChart.html"
            name:"area"
            activeChart: false
            title: "Area Chart"
            yAxisVisible: true
            lineTypeChartVisible: false
            maxDropOnXAxis: 2
            maxDropOnYAxis: 1
            mainCustomizations: "Properties,Legend,Reference Line,Axis Size"
        }
        ListElement{
            icon: "line_chart.png"
            chartHtml:"LineChart.html"
            activeChart: false
            title: "Line Chart"
            yAxisVisible: true
            maxDropOnXAxis: 2
            maxDropOnYAxis: 1
            lineTypeChartVisible: true
            mainCustomizations: "Properties,Legend,Reference Line,Axis Size"
        }
        ListElement{
            icon: "combination_chart.png"
            activeChart: false
            chartHtml:"bar.html"
            title:"Combination - Coming Soon"
            yAxisVisible: true
            maxDropOnXAxis: 1
            lineTypeChartVisible: true
            mainCustomizations: "Properties,Legend,Reference Line,Axis Size"
            nonClickable: true
        }
        ListElement{
            icon: "heatmap.png"
            chartHtml:"HeatmapChart.html"
            activeChart: false
            title: "Heat Map"
            maxDropOnXAxis: 2
            maxDropOnYAxis: 1
            yAxisVisible: true
            lineTypeChartVisible: false
            mainCustomizations: "Properties,Legend,Reference Line"
        }
        ListElement{
            icon: "scatter_plot.png"
            chartHtml:"ScatterChart.html"
            activeChart: false
            title:"Scatter Plot"
            yAxisVisible: true
            lineTypeChartVisible: false
            mainCustomizations: "Properties,Legend,Reference Line"
        }
        ListElement{
            icon: "waterfall.png"
            chartHtml:"WaterfallChart.html"
            activeChart: false
            title:"Waterfall"
            yAxisVisible: true
            maxDropOnXAxis: 1
            maxDropOnYAxis: 1
            lineTypeChartVisible: false
            mainCustomizations: "Properties,Legend,Reference Line"
        }
        ListElement{
            icon: "pie_chart.png"
            chartHtml:"PieChart.html"
            activeChart: false
            title: "Pie Chart"
            xAxisLabelName: "Categorical"
            yAxisLabelName: "Numerical"
            maxDropOnXAxis: 1
            maxDropOnYAxis: 1
            yAxisVisible: false
            lineTypeChartVisible: false
            mainCustomizations: "Properties,Legend,Reference Line"
        }
        ListElement{
            icon: "donut.png"
            chartHtml:"DoughnutChart.html"
            activeChart: false
            title:"Donut Chart"
            xAxisLabelName: "Categorical"
            maxDropOnXAxis: 1
            maxDropOnYAxis: 1
            yAxisLabelName: "Numerical"
            yAxisVisible: false
            lineTypeChartVisible: false
            mainCustomizations: "Properties,Legend,Reference Line"
        }
        ListElement{
            icon: "radar.png"
            chartHtml:"RadarChart.html"
            activeChart: false
            xAxisLabelName: "Categorical"
            yAxisLabelName: "Numerical"
            title:"Radar"
            yAxisVisible: false
            lineTypeChartVisible: false
            mainCustomizations: "Properties,Legend,Reference Line"
        }
        ListElement{
            icon: "sunburst.png"
            chartHtml:"SunburstChart.html"
            activeChart: false
            title:"Sunburst"
            xAxisLabelName: "Categorical"
            yAxisLabelName: "Numerical"
            maxDropOnYAxis: 1
            yAxisVisible: false
            lineTypeChartVisible: false
            mainCustomizations: "Properties,Legend,Reference Line"
        }
//        ListElement{
//            icon: "nightingales_rose.png"
//            activeChart: false
//            chartHtml:"bar.html"
//            title:"Nightingale Rose"
//            yAxisVisible: false
//            lineTypeChartVisible: false
//        }
//        ListElement{
//            icon: "chord_diagram.png"
//            chartHtml:"ChordChart.html"
//            activeChart: false
//            title:"Chord Diagram"
//            xAxisLabelName: "Source"
//            yAxisLabelName: "Numerical"
//            yAxisVisible: false
//            lineTypeChartVisible: false
//        }
        ListElement{
            icon: "funnel.png"
            chartHtml:"FunnelChart.html"
            activeChart: false
            title: "Funnel Chart"
            yAxisVisible: false
            maxDropOnXAxis: 1
            maxDropOnYAxis: 1
            xAxisLabelName: "Categorical"
            yAxisLabelName: "Numerical"
            lineTypeChartVisible: false
            mainCustomizations: "Properties,Legend,Reference Line"
        }
        ListElement{
            icon: "tree_chart.png"
            chartHtml:"TreeChart.html"
            activeChart: false
            title:"Tree Chart"
            maxDropOnYAxis: 1
            xAxisLabelName: "Categorical"
            yAxisLabelName: "Numerical"
            yAxisVisible: false
            lineTypeChartVisible: false
            mainCustomizations: "Properties,Legend,Reference Line"
        }
        // ListElement{
        //     icon: "force_directed.png"
        //     chartHtml:"bar.html"
        //     activeChart: false
        //     title:"Force Directed"
        //     mainCustomizations: "Properties,Legend,Reference Line"
        // }
        ListElement{
            icon: "sankey.png"
            chartHtml:"SankeyChart.html"
            elementHeight: 24
            activeChart: false
            title:"Sankey"
            xAxisLabelName: "Source"
            yAxisLabelName: "Target"
            mainCustomizations: "Properties,Legend,Reference Line"
        }
        ListElement{
            icon: "tree_map.png"
            chartHtml:"TreeMapChart.html"
            elementHeight: 24
            activeChart: false
            xAxisLabelName: "Categorical"
            yAxisLabelName: "Numerical"
            title: "Tree Map"
            mainCustomizations: "Properties,Legend,Reference Line"
        }
//        ListElement{
//            icon: "condegram.png"
//            chartHtml:"bar.html"
//            activeChart: false
//            title:"Condegram"
//        }
        ListElement{
            icon: "map.png"
            chartHtml:"GeoChart.html"
            elementHeight: 22
            elementWidth:40
            activeChart: false
            xAxisLabelName: "Location"
            yAxisLabelName: "Numerical"
            title:"Map - Coming Soon"
            mainCustomizations: "Properties,Legend"
            nonClickable: true
        }
        ListElement{
            icon: "gauge_chart.png"
            chartHtml:"GaugeChart.html"
            elementHeight: 22
            elementWidth:30
            activeChart: false
            title:"Gauge Chart"
            mainCustomizations: "Properties,Legend,Reference Line"
        }
        ListElement{
            icon: "pivot.png"
            chartHtml:"PivotTable.html"
            activeChart: false
            title:"Pivot"
            xAxisLabelName: "Rows"
            yAxisLabelName: "Columns"
            themeVisible: true
            mainCustomizations: "Properties,Legend,Reference Line,Total"
        }
        ListElement{
            icon: "table.png"
            chartHtml:"TableChart.html"
            xAxisLabelName: "Columns"
            yAxisLabelName: "Columns"
            elementWidth: 30
            activeChart: false
            title:"Table"
            mainCustomizations: "Properties,Legend,Reference Line,Total"
        }
        ListElement{
            icon: "123.png"
            chartHtml:"bar.html"
            elementWidth: 30
            elementHeight: 20
            activeChart: false
            title:"KPI"
            mainCustomizations: "Properties,Legend,Reference Line"
        }
        ListElement{
            icon: "123.png"
            chartHtml:"bar.html"
            elementWidth: 30
            elementHeight: 20
            activeChart: false
            title:"Line Bar"
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



    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    Component.onCompleted: {

        // create all charts mapping from the list model
        // If any mapping is added please update 
        // New Reports.qml File in onChartTitleChanged function

        for(var i=0; i< allCharts.count; i++){
            var chartTitle = allCharts.get(i).title;

            console.log('Chart Title, Making Mapping',chartTitle)

            var maxDropOnXAxis = allCharts.get(i).maxDropOnXAxis;
            var maxDropOnYAxis = allCharts.get(i).maxDropOnYAxis;

            allChartsMapping[chartTitle] = {
                'maxDropOnXAxis': maxDropOnXAxis || -1,
                'maxDropOnYAxis': maxDropOnYAxis || -1,
            };

        }

        // Setting initial default values
        allowedXAxisDataPanes = 2;
        allowedYAxisDataPanes = 1;
    }

    function getChart(chartHtml,index,chartTitle,mainCustomizations){
        report_desiner_page.chartUrl = chartHtml;
        report_desiner_page.chartTitle = chartTitle;

        report_desiner_page.customizationsAvailable = mainCustomizations;
        
        var xAxisColumns = getAxisColumnNames(Constants.xAxisName);
        var yAxisColumns = getAxisColumnNames(Constants.yAxisName);

        if(chartTitle === Constants.barChartTitle){
            if(report_desiner_page.isHorizontalGraph){
                if(xAxisColumns.length === 1 && yAxisColumns.length === 1 && colorListModel.count == 0){
                    chartHtml = Constants.horizontalBarChartUrl;
//                    switchChart(Constants.horizontalBarChartTitle);
                }
                else if(xAxisColumns.length === 1 && yAxisColumns.length === 1 && colorListModel.count == 1){
                    chartHtml = Constants.horizontalStackedBarChartUrl;
                }else if(xAxisColumns.length === 1 && yAxisColumns.length === 2){
                    chartHtml = Constants.horizontalBarGroupedChartUrl;
                }
            }else{
                if(xAxisColumns.length === 1 && yAxisColumns.length === 1 && colorListModel.count === 1){
                    chartHtml = Constants.stackedBarChartUrl;
                }else if(xAxisColumns.length === 1 && yAxisColumns.length === 2){
                    chartHtml = Constants.barGroupedChartUrl;
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
                    console.log('Missed Horizontal Condition')
                }
            }else{
                if(xAxisColumns.length === 1 && yAxisColumns.length === 1 && colorListModel.count !== 0){
                    console.log('Debug: Loading multiline chart');
                    chartHtml = Constants.multiLineChartUrl;
                    // switchChart(Constants.multiLineChartTitle);
                }else{
                    console.log('Moving to line ????')
                }
            }
        }
        

        console.log(chartTitle);
        console.log('Loading Chart from LeftMenuBarReports.qml',chartHtml)
        loadchart("../Charts/"+chartHtml);

//        add toggle left menu


//        yAxisVisible  = allCharts.get(index).yAxisVisible;

        const yAxisLabelNameData = allCharts.get(index).yAxisLabelName;
        if(yAxisLabelNameData){
            yAxisLabelName = yAxisLabelNameData;
        }else{
            yAxisLabelName = Constants.yAxisName
        }

        const xAxisLabelNameData = allCharts.get(index).xAxisLabelName;
        if(xAxisLabelNameData){
            xAxisLabelName = xAxisLabelNameData;
        }else{
            xAxisLabelName = Constants.xAxisName
        }


        var chartObject = allCharts.get(index);

        lineTypeChartVisible = allCharts.get(index).lineTypeChartVisible;
        pivotThemeVisible = !!allCharts.get(index).themeVisible;

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
                color: activeChart ? Constants.darkThemeColor :Constants.themeColor
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
                    onClicked:  getChart(chartHtml,index,title,mainCustomizations)
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


