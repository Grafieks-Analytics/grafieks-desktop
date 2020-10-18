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
            icon: "Bar Chart.png"
            chartHtml:"bar.html"
        }
        ListElement{
            icon: "Area Chart.png"
            chartHtml:"bar.html"
        }
        ListElement{
            icon: "Line Chart.png"
            chartHtml:"bar.html"
        }
        ListElement{
            icon: "Combination Chart (Line Bar).png"
            chartHtml:"bar.html"
        }
        ListElement{
            icon: "HeatMap.png"
            chartHtml:"bar.html"
        }
        ListElement{
            icon: "Scatter Plot.png"
            chartHtml:"bar.html"
        }
        ListElement{
            icon: "waterfall chart.png"
            chartHtml:"bar.html"
        }
        ListElement{
            icon: "Pie Chart.png"
            chartHtml:"bar.html"
        }
        ListElement{
            icon: "Donut Chart.png"
            chartHtml:"bar.html"
        }
        ListElement{
            icon: "Radar Chart.png"
            chartHtml:"bar.html"
        }
        ListElement{
            icon: "Sunburst.png"
            chartHtml:"bar.html"
        }
        ListElement{
            icon: "NightingaleRose.png"
            chartHtml:"bar.html"
        }
        ListElement{
            icon: "Chord Diagram.png"
            chartHtml:"bar.html"
        }
        ListElement{
            icon: "Funnel.png"
            chartHtml:"bar.html"
        }
        ListElement{
            icon: "tree 500 px.png"
            chartHtml:"bar.html"
        }
        ListElement{
            icon: "Force-Directed Graph.png"
            chartHtml:"bar.html"
        }
        ListElement{
            icon: "Sankey.png"
            chartHtml:"bar.html"
        }
        ListElement{
            icon: "Tree Map.png"
            chartHtml:"bar.html"
        }
        ListElement{
            icon: "Matrix.png"
            chartHtml:"bar.html"
        }
        ListElement{
            icon: "Table.png"
            chartHtml:"bar.html"
        }
        ListElement{
            icon: "Condegram Spiral.png"
            chartHtml:"bar.html"
        }
        ListElement{
            icon: "GEO.png"
            chartHtml:"bar.html"
        }
        ListElement{
            icon: "Gauge Chart.png"
            chartHtml:"bar.html"
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
                    height: imageHeight
                    width: imageWidth
                }
                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked:  rectangle_left.loadchart("../Charts/bar.html")
                    onPressed:  parent.color = "white"
                    onReleased:   parent.color = Constants.themeColor
                    onEntered:  parent.color = Constants.hoverThemeColor
                    onExited: parent.color = Constants.themeColor
                }
            }

        }
    }
}


