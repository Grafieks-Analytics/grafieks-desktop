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

    Column{

        id: leftmenu_col
        width: parent.width
        spacing: 4


        Rectangle{
            id: bar_chart
            width: parent.width
            height: 30
            color: Constants.themeColor

            Image{
                source:"/Images/icons/charts/Bar_30.png"
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill:parent
                hoverEnabled: true
                onClicked: {
                    rectangle_left.loadchart("../Charts/bar.html")
                }

                onPressed: {
                    bar_chart.color = "white"
                }
                onReleased:  {
                    bar_chart.color = Constants.themeColor
                }

                onEntered: {
                    bar_chart.color = Constants.hoverThemeColor
                }
                onExited: {
                    bar_chart.color = Constants.themeColor
                }
            }
        }

        Rectangle{
            id: line_chart
            width: parent.width
            height: 30
            color: Constants.themeColor

            Image{
                source:"/Images/icons/charts/Line_30.png"
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill:parent
                hoverEnabled: true
                onClicked: {
                    rectangle_left.loadchart("../Charts/line.html")
                }
                onPressed: {
                    line_chart.color = "white"
                }
                onReleased:  {
                    line_chart.color = Constants.themeColor
                }

                onEntered: {
                    line_chart.color = Constants.hoverThemeColor
                }
                onExited: {
                    line_chart.color = Constants.themeColor
                }
            }
        }

        Rectangle{
            id: area_chart
            width: parent.width
            height: 30
            color: Constants.themeColor

            Image{
                source:"/Images/icons/charts/Area_30.png"
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill:parent
                hoverEnabled: true
                onClicked: {
                    rectangle_left.loadchart("../Charts/area.html")
                }

                onPressed: {
                    area_chart.color = "white"
                }
                onReleased:  {
                    area_chart.color = Constants.themeColor
                }

                onEntered: {
                    area_chart.color = Constants.hoverThemeColor
                }
                onExited: {
                    area_chart.color = Constants.themeColor
                }
            }
        }

        Rectangle{
            id: donout_chart
            width: parent.width
            height: 30
            color: Constants.themeColor

            Image{
                source:"/Images/icons/charts/Doughnut_30.png"
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill:parent
                hoverEnabled: true
                onClicked: {
//                    rectangle_left.loadchart("../Charts/line.html")
                }

                onPressed: {
                    donout_chart.color = "white"
                }
                onReleased:  {
                    donout_chart.color = Constants.themeColor
                }

                onEntered: {
                    donout_chart.color = Constants.hoverThemeColor
                }
                onExited: {
                    donout_chart.color = Constants.themeColor
                }
            }
        }

        Rectangle{
            id: pie_chart
            width: parent.width
            height: 30
            color: Constants.themeColor

            Image{
                source:"/Images/icons/charts/Pie_30.png"
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill:parent
                hoverEnabled: true
                onClicked: {
                    rectangle_left.loadchart("../Charts/pie.html")
                }

                onPressed: {
                    pie_chart.color = "white"
                }
                onReleased:  {
                    pie_chart.color = Constants.themeColor
                }

                onEntered: {
                    pie_chart.color = Constants.hoverThemeColor
                }
                onExited: {
                    pie_chart.color = Constants.themeColor
                }
            }
        }

        Rectangle{
            id: funnel_chart
            width: parent.width
            height: 30
            color: Constants.themeColor

            Image{
                source:"/Images/icons/charts/Funnel_30.png"
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill:parent
                hoverEnabled: true
                onClicked: {
//                    rectangle_left.loadchart("../Charts/line.html")
                }

                onPressed: {
                    funnel_chart.color = "white"
                }
                onReleased:  {
                    funnel_chart.color = Constants.themeColor
                }

                onEntered: {
                    funnel_chart.color = Constants.hoverThemeColor
                }
                onExited: {
                    funnel_chart.color = Constants.themeColor
                }
            }
        }

        Rectangle{
            id: gauge_chart
            width: parent.width
            height: 30
            color: Constants.themeColor

            Image{
                source:"/Images/icons/charts/Gauge_30.png"
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill:parent
                hoverEnabled: true
                onClicked: {
//                    rectangle_left.loadchart("../Charts/line.html")
                }

                onPressed: {
                    gauge_chart.color = "white"
                }
                onReleased:  {
                    gauge_chart.color = Constants.themeColor
                }

                onEntered: {
                    gauge_chart.color = Constants.hoverThemeColor
                }
                onExited: {
                    gauge_chart.color = Constants.themeColor
                }
            }
        }

        Rectangle{
            id: radar_chart
            width: parent.width
            height: 30
            color: Constants.themeColor

            Image{
                source:"/Images/icons/charts/Radar_30.png"
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill:parent
                hoverEnabled: true
                onClicked: {
                    rectangle_left.loadchart("../Charts/radar.html")
                }

                onPressed: {
                    radar_chart.color = "white"
                }
                onReleased:  {
                    radar_chart.color = Constants.themeColor
                }

                onEntered: {
                    radar_chart.color = Constants.hoverThemeColor
                }
                onExited: {
                    radar_chart.color = Constants.themeColor
                }
            }
        }


        Rectangle{
            id: candlestick_chart
            width: parent.width
            height: 30
            color: Constants.themeColor

            Image{
                source:"/Images/icons/charts/CandleStick_30.png"
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill:parent
                hoverEnabled: true
                onClicked: {
//                    rectangle_left.loadchart("../Charts/line.html")
                }

                onPressed: {
                    candlestick_chart.color = "white"
                }
                onReleased:  {
                    candlestick_chart.color = Constants.themeColor
                }

                onEntered: {
                    candlestick_chart.color = Constants.hoverThemeColor
                }
                onExited: {
                    candlestick_chart.color = Constants.themeColor
                }
            }
        }

        Rectangle{
            id: sankey_chart
            width: parent.width
            height: 30
            color: Constants.themeColor

            Image{
                source:"/Images/icons/charts/Sankey_30.png"
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill:parent
                hoverEnabled: true
                onClicked: {
//                    rectangle_left.loadchart("../Charts/line.html")
                }

                onPressed: {
                    sankey_chart.color = "white"
                }
                onReleased:  {
                    sankey_chart.color = Constants.themeColor
                }

                onEntered: {
                    sankey_chart.color = Constants.hoverThemeColor
                }
                onExited: {
                    sankey_chart.color = Constants.themeColor
                }
            }
        }

        Rectangle{
            id: heatmap_chart
            width: parent.width
            height: 30
            color: Constants.themeColor

            Image{
                source:"/Images/icons/charts/HeatMap_30.png"
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill:parent
                hoverEnabled: true
                onClicked: {
//                    rectangle_left.loadchart("../Charts/line.html")
                }

                onPressed: {
                    heatmap_chart.color = "white"
                }
                onReleased:  {
                    heatmap_chart.color = Constants.themeColor
                }

                onEntered: {
                    heatmap_chart.color = Constants.hoverThemeColor
                }
                onExited: {
                    heatmap_chart.color = Constants.themeColor
                }
            }
        }

        Rectangle{
            id: map_chart
            width: parent.width
            height: 30
            color: Constants.themeColor

            Image{
                source:"/Images/icons/charts/Map_30.png"
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill:parent
                hoverEnabled: true
                onClicked: {
//                    rectangle_left.loadchart("../Charts/line.html")
                }

                onPressed: {
                    map_chart.color = "white"
                }
                onReleased:  {
                    map_chart.color = Constants.themeColor
                }

                onEntered: {
                    map_chart.color = Constants.hoverThemeColor
                }
                onExited: {
                    map_chart.color = Constants.themeColor
                }
            }
        }



        Rectangle{
            id: scatter_chart
            width: parent.width
            height: 30
            color: Constants.themeColor

            Image{
                source:"/Images/icons/charts/ScatterPlot_30.png"
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill:parent
                hoverEnabled: true
                onClicked: {
                    rectangle_left.loadchart("../Charts/scatter.html")
                }

                onPressed: {
                    scatter_chart.color = "white"
                }
                onReleased:  {
                    scatter_chart.color = Constants.themeColor
                }

                onEntered: {
                    scatter_chart.color = Constants.hoverThemeColor
                }
                onExited: {
                    scatter_chart.color = Constants.themeColor
                }
            }
        }

        Rectangle{
            id: tree_chart
            width: parent.width
            height: 30
            color: Constants.themeColor

            Image{
                source:"/Images/icons/charts/Tree_30.png"
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill:parent
                hoverEnabled: true
                onClicked: {
                    rectangle_left.loadchart("../Charts/tree.html")
                }

                onPressed: {
                    tree_chart.color = "white"
                }
                onReleased:  {
                    tree_chart.color = Constants.themeColor
                }

                onEntered: {
                    tree_chart.color = Constants.hoverThemeColor
                }
                onExited: {
                    tree_chart.color = Constants.themeColor
                }
            }
        }

        Rectangle{
            id: treemap_chart
            width: parent.width
            height: 30
            color: Constants.themeColor

            Image{
                source:"/Images/icons/charts/TreeMap_30.png"
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill:parent
                hoverEnabled: true
                onClicked: {
                    rectangle_left.loadchart("../Charts/tree-map.html")
                }

                onPressed: {
                    treemap_chart.color = "white"
                }
                onReleased:  {
                    treemap_chart.color = Constants.themeColor
                }

                onEntered: {
                    treemap_chart.color = Constants.hoverThemeColor
                }
                onExited: {
                    treemap_chart.color = Constants.themeColor
                }
            }
        }

        Rectangle{
            id: chord_chart
            width: parent.width
            height: 30
            color: Constants.themeColor

            Image{
                source:"/Images/icons/charts/Chord_30.png"
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill:parent
                hoverEnabled: true
                onClicked: {
//                    rectangle_left.loadchart("../Charts/line.html")
                }

                onPressed: {
                    chord_chart.color = "white"
                }
                onReleased:  {
                    chord_chart.color = Constants.themeColor
                }

                onEntered: {
                    chord_chart.color = Constants.hoverThemeColor
                }
                onExited: {
                    chord_chart.color = Constants.themeColor
                }
            }
        }

        Rectangle{
            id: sunburst_chart
            width: parent.width
            height: 30
            color: Constants.themeColor

            Image{
                source:"/Images/icons/charts/Sunburst_30.png"
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill:parent
                hoverEnabled: true
                onClicked: {
                    rectangle_left.loadchart("../Charts/sunburst.html")
                }

                onPressed: {
                    sunburst_chart.color = "white"
                }
                onReleased:  {
                    sunburst_chart.color = Constants.themeColor
                }

                onEntered: {
                    sunburst_chart.color = Constants.hoverThemeColor
                }
                onExited: {
                    sunburst_chart.color = Constants.themeColor
                }
            }
        }

        Rectangle{
            id: nightigalerose_chart
            width: parent.width
            height: 30
            color: Constants.themeColor

            Image{
                source:"/Images/icons/charts/NightingaleRose_30.png"
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill:parent
                hoverEnabled: true
                onClicked: {
//                    rectangle_left.loadchart("../Charts/line.html")
                }

                onPressed: {
                    nightigalerose_chart.color = "white"
                }
                onReleased:  {
                    nightigalerose_chart.color = Constants.themeColor
                }

                onEntered: {
                    nightigalerose_chart.color = Constants.hoverThemeColor
                }
                onExited: {
                    nightigalerose_chart.color = Constants.themeColor
                }
            }
        }

        Rectangle{
            id: forcedirected_chart
            width: parent.width
            height: 30
            color: Constants.themeColor

            Image{
                source:"/Images/icons/charts/ForceDirected_30.png"
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill:parent
                hoverEnabled: true
                onClicked: {
//                    rectangle_left.loadchart("../Charts/line.html")
                }

                onPressed: {
                    forcedirected_chart.color = "white"
                }
                onReleased:  {
                    forcedirected_chart.color = Constants.themeColor
                }

                onEntered: {
                    forcedirected_chart.color = Constants.hoverThemeColor
                }
                onExited: {
                    forcedirected_chart.color = Constants.themeColor
                }
            }
        }

        Rectangle{
            id: table_chart
            width: parent.width
            height: 30
            color: Constants.themeColor

            Image{
                source:"/Images/icons/charts/Table_30.png"
                anchors.centerIn: parent
            }
        }
    }
}


