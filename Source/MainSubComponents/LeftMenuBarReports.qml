/****************************************************************************
**
** Copyright (C) 2019 Grafieks.
** Contact: https://grafieks.com/
**
** Left Menubar for New Reports
**
****************************************************************************/

import QtQuick 2.11
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4


import "../../Constants.js" as Constants

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
                source:"../../Images/icons/charts/Bar_30.png"
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill:parent
                onClicked: {
                    rectangle_left.loadchart("../Charts/bar.html")
                }
            }
        }

        Rectangle{
            id: line_chart
            width: parent.width
            height: 30
            color: Constants.themeColor

            Image{
                source:"../../Images/icons/charts/Line_30.png"
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill:parent
                onClicked: {
                    rectangle_left.loadchart("../Charts/line.html")
                }
            }
        }

        Rectangle{
            id: area_chart
            width: parent.width
            height: 30
            color: Constants.themeColor

            Image{
                source:"../../Images/icons/charts/Area_30.png"
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill:parent
                onClicked: {
                    rectangle_left.loadchart("../Charts/area.html")
                }
            }
        }

        Rectangle{
            id: donout_chart
            width: parent.width
            height: 30
            color: Constants.themeColor

            Image{
                source:"../../Images/icons/charts/Doughnut_30.png"
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill:parent
                onClicked: {
//                    rectangle_left.loadchart("../Charts/line.html")
                }
            }
        }

        Rectangle{
            id: pie_chart
            width: parent.width
            height: 30
            color: Constants.themeColor

            Image{
                source:"../../Images/icons/charts/Pie_30.png"
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill:parent
                onClicked: {
                    rectangle_left.loadchart("../Charts/pie.html")
                }
            }
        }

        Rectangle{
            id: funner_chart
            width: parent.width
            height: 30
            color: Constants.themeColor

            Image{
                source:"../../Images/icons/charts/Funnel_30.png"
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill:parent
                onClicked: {
//                    rectangle_left.loadchart("../Charts/line.html")
                }
            }
        }

        Rectangle{
            id: gauge_chart
            width: parent.width
            height: 30
            color: Constants.themeColor

            Image{
                source:"../../Images/icons/charts/Gauge_30.png"
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill:parent
                onClicked: {
//                    rectangle_left.loadchart("../Charts/line.html")
                }
            }
        }

        Rectangle{
            id: radar_chart
            width: parent.width
            height: 30
            color: Constants.themeColor

            Image{
                source:"../../Images/icons/charts/Radar_30.png"
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill:parent
                onClicked: {
                    rectangle_left.loadchart("../Charts/radar.html")
                }
            }
        }


        Rectangle{
            id: candlestick_chart
            width: parent.width
            height: 30
            color: Constants.themeColor

            Image{
                source:"../../Images/icons/charts/CandleStick_30.png"
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill:parent
                onClicked: {
//                    rectangle_left.loadchart("../Charts/line.html")
                }
            }
        }

        Rectangle{
            id: sankey_chart
            width: parent.width
            height: 30
            color: Constants.themeColor

            Image{
                source:"../../Images/icons/charts/Sankey_30.png"
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill:parent
                onClicked: {
//                    rectangle_left.loadchart("../Charts/line.html")
                }
            }
        }

        Rectangle{
            id: heatmap_chart
            width: parent.width
            height: 30
            color: Constants.themeColor

            Image{
                source:"../../Images/icons/charts/HeatMap_30.png"
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill:parent
                onClicked: {
//                    rectangle_left.loadchart("../Charts/line.html")
                }
            }
        }

        Rectangle{
            id: map_chart
            width: parent.width
            height: 30
            color: Constants.themeColor

            Image{
                source:"../../Images/icons/charts/Map_30.png"
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill:parent
                onClicked: {
//                    rectangle_left.loadchart("../Charts/line.html")
                }
            }
        }



        Rectangle{
            id: scatter_chart
            width: parent.width
            height: 30
            color: Constants.themeColor

            Image{
                source:"../../Images/icons/charts/ScatterPlot_30.png"
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill:parent
                onClicked: {
                    rectangle_left.loadchart("../Charts/scatter.html")
                }
            }
        }

        Rectangle{
            id: tree_chart
            width: parent.width
            height: 30
            color: Constants.themeColor

            Image{
                source:"../../Images/icons/charts/Tree_30.png"
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill:parent
                onClicked: {
                    rectangle_left.loadchart("../Charts/tree.html")
                }
            }
        }

        Rectangle{
            id: treemap_chart
            width: parent.width
            height: 30
            color: Constants.themeColor

            Image{
                source:"../../Images/icons/charts/TreeMap_30.png"
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill:parent
                onClicked: {
                    rectangle_left.loadchart("../Charts/tree-map.html")
                }
            }
        }

        Rectangle{
            id: chord_chart
            width: parent.width
            height: 30
            color: Constants.themeColor

            Image{
                source:"../../Images/icons/charts/Chord_30.png"
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill:parent
                onClicked: {
//                    rectangle_left.loadchart("../Charts/line.html")
                }
            }
        }

        Rectangle{
            id: sunburst_chart
            width: parent.width
            height: 30
            color: Constants.themeColor

            Image{
                source:"../../Images/icons/charts/Sunburst_30.png"
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill:parent
                onClicked: {
                    rectangle_left.loadchart("../Charts/sunburst.html")
                }
            }
        }

        Rectangle{
            id: nightigalerose_chart
            width: parent.width
            height: 30
            color: Constants.themeColor

            Image{
                source:"../../Images/icons/charts/NightingaleRose_30.png"
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill:parent
                onClicked: {
//                    rectangle_left.loadchart("../Charts/line.html")
                }
            }
        }

        Rectangle{
            id: forcedirected_chart
            width: parent.width
            height: 30
            color: Constants.themeColor

            Image{
                source:"../../Images/icons/charts/ForceDirected_30.png"
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill:parent
                onClicked: {
//                    rectangle_left.loadchart("../Charts/line.html")
                }
            }
        }

        Rectangle{
            id: table_chart
            width: parent.width
            height: 30
            color: Constants.themeColor

            Image{
                source:"../../Images/icons/charts/Table_30.png"
                anchors.centerIn: parent
            }
        }
    }
}


