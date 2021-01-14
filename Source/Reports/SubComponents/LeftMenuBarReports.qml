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
    height: parent.height - 50
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
        }
        ListElement{
            icon: "area.png"
            chartHtml:"AreaChart.html"
            name:"area"
            activeChart: false
        }
        ListElement{
            icon: "line_chart.png"
            chartHtml:"bar.html"
            activeChart: false
        }
        ListElement{
            icon: "combination_chart.png"
            activeChart: false
            chartHtml:"bar.html"
        }
        ListElement{
            icon: "heatmap.png"
            chartHtml:"bar.html"
            activeChart: false
        }
        ListElement{
            icon: "scatter_plot.png"
            chartHtml:"bar.html"
            activeChart: false
        }
        ListElement{
            icon: "waterfall.png"
            chartHtml:"bar.html"
            activeChart: false
        }
        ListElement{
            icon: "pie_chart.png"
            chartHtml:"bar.html"
            activeChart: false
        }
        ListElement{
            icon: "donut.png"
            chartHtml:"bar.html"
            activeChart: false
        }
        ListElement{
            icon: "radar.png"
            chartHtml:"bar.html"
            activeChart: false
        }
        ListElement{
            icon: "sunburst.png"
            chartHtml:"bar.html"
            activeChart: false
        }
        ListElement{
            icon: "nightingales_rose.png"
            activeChart: false
            chartHtml:"bar.html"
        }
        ListElement{
            icon: "chord_diagram.png"
            chartHtml:"bar.html"
            activeChart: false
        }
        ListElement{
            icon: "funnel.png"
            chartHtml:"bar.html"
            activeChart: false
        }
        ListElement{
            icon: "tree_chart.png"
            chartHtml:"bar.html"
            activeChart: false
        }
        ListElement{
            icon: "force_directed.png"
            chartHtml:"bar.html"
            activeChart: false
        }
        ListElement{
            icon: "sankey.png"
            chartHtml:"bar.html"
            elementHeight: 24
            activeChart: false
        }
        ListElement{
            icon: "tree_map.png"
            chartHtml:"bar.html"
            elementHeight: 24
            activeChart: false
        }
        ListElement{
            icon: "pivot.png"
            chartHtml:"bar.html"
            activeChart: false
        }
        ListElement{
            icon: "table.png"
            chartHtml:"bar.html"
            elementWidth: 30
            activeChart: false
        }
        ListElement{
            icon: "condegram.png"
            chartHtml:"bar.html"
            activeChart: false
        }
        ListElement{
            icon: "map.png"
            chartHtml:"bar.html"
            elementHeight: 22
            elementWidth:40
            activeChart: false
        }
        ListElement{
            icon: "gauge_chart.png"
            chartHtml:"bar.html"
            elementHeight: 22
            elementWidth:30
            activeChart: false
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

    function getChart(chartHtml,index){
        loadchart("../Charts/"+chartHtml);
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
                Image{
                    source:"/Images/icons/charts/"+icon
                    anchors.centerIn: parent
                    height: elementHeight ? elementHeight : imageHeight
                    width: elementWidth ? elementWidth : imageWidth
                }
                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked:  getChart(chartHtml,index)
                }
            }

        }
    }
}


