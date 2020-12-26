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

    signal loadchart(string chartname)


    property int imageRectangleHeight: 32;
    property int imageHeight: 32;
    property int imageWidth: 32;


    /***********************************************************************************************************************/
    // LIST MODEL STARTS

    ListModel{
        id: allCharts
        ListElement{
            icon: "bar_chart.png"
            chartHtml:"BarChartArrayInput.html"
        }
        ListElement{
            icon: "area.png"
            chartHtml:"AreaChart.html"
        }
        ListElement{
            icon: "line_chart.png"
            chartHtml:"bar.html"
        }
        ListElement{
            icon: "combination_chart.png"
            chartHtml:"bar.html"
        }
        ListElement{
            icon: "heatmap.png"
            chartHtml:"bar.html"
        }
        ListElement{
            icon: "scatter_plot.png"
            chartHtml:"bar.html"
        }
        ListElement{
            icon: "waterfall.png"
            chartHtml:"bar.html"
        }
        ListElement{
            icon: "pie_chart.png"
            chartHtml:"bar.html"
        }
        ListElement{
            icon: "donut.png"
            chartHtml:"bar.html"
        }
        ListElement{
            icon: "radar.png"
            chartHtml:"bar.html"
        }
        ListElement{
            icon: "sunburst.png"
            chartHtml:"bar.html"
        }
        ListElement{
            icon: "nightingales_rose.png"
            chartHtml:"bar.html"
        }
        ListElement{
            icon: "chord_diagram.png"
            chartHtml:"bar.html"
        }
        ListElement{
            icon: "funnel.png"
            chartHtml:"bar.html"
        }
        ListElement{
            icon: "tree_chart.png"
            chartHtml:"bar.html"
        }
        ListElement{
            icon: "force_directed.png"
            chartHtml:"bar.html"
        }
        ListElement{
            icon: "sankey.png"
            chartHtml:"bar.html"
            elementHeight: 24
        }
        ListElement{
            icon: "tree_map.png"
            chartHtml:"bar.html"
            elementHeight: 24
        }
        ListElement{
            icon: "pivot.png"
            chartHtml:"bar.html"
        }
        ListElement{
            icon: "table.png"
            chartHtml:"bar.html"
            elementWidth: 30
        }
        ListElement{
            icon: "condegram.png"
            chartHtml:"bar.html"

        }
        ListElement{
            icon: "map.png"
            chartHtml:"bar.html"
            elementHeight: 22
            elementWidth:40
        }
        ListElement{
            icon: "gauge_chart.png"
            chartHtml:"bar.html"
            elementHeight: 22
            elementWidth:30
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
                color: Constants.themeColor
                Image{
                    source:"/Images/icons/charts/"+icon
                    anchors.centerIn: parent
                    height: elementHeight ? elementHeight : imageHeight
                    width: elementWidth ? elementWidth : imageWidth
                }
                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked:  loadchart("../Charts/"+chartHtml)
                    onPressed:  parent.color = "white"
                    onReleased:   parent.color = Constants.themeColor
                    onEntered:  parent.color = Constants.hoverThemeColor
                    onExited: parent.color = Constants.themeColor
                }
            }

        }
    }
}


