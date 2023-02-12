var allChartsConfig = [
    {
        icon: "bar_chart.png",
        activeChart: true,
        title: "Bar Chart",
        xAxisLabelName: "X Axis",
        yAxisLabelName: "Y Axis",
        yAxisVisible: true,
        lineTypeChartVisible: false,
        maxDropOnXAxis: 2,
        maxDropOnYAxis: 1,
        mainCustomizations: "Properties,Legend,Reference Line,Axis Size",
        subMenuCustomizations: "color by,tool tip,size,data label,grid line",
        colorByDropEligible: "categorical",
    },
    {
        icon: "area.png",
        chartHtml: "AreaChart.html",
        activeChart: false,
        title: "Area Chart",
        yAxisVisible: true,
        lineTypeChartVisible: false,
        maxDropOnXAxis: 1,
        maxDropOnYAxis: 1,
        mainCustomizations: "Properties,Legend,Reference Line,Axis Size",
        subMenuCustomizations:
            "color by,tool tip,size,data label,grid line,marker shape",
        colorByDropEligible: "categorical",
    },
    {
        icon: "line_chart.png",
        chartHtml: "LineChart.html",
        activeChart: false,
        title: "Line Chart",
        yAxisVisible: true,
        maxDropOnXAxis: 1,
        maxDropOnYAxis: 1,
        lineTypeChartVisible: true,
        mainCustomizations: "Properties,Legend,Reference Line,Axis Size",
        subMenuCustomizations:
            "color by,tool tip,size,data label,grid line,marker shape,line type",
        colorByDropEligible: "categorical",
    },
    {
        // icon: "combination_chart.png",
        icon: "combination_grey.png",
        activeChart: false,
        chartHtml: "bar.html",
        title: "Combination - Coming Soon",
        yAxisVisible: true,
        maxDropOnXAxis: 1,
        disabled: true,
        lineTypeChartVisible: true,
        mainCustomizations: "Properties,Legend,Reference Line,Axis Size",
        nonClickable: true,
        subMenuCustomizations: "color by,tool tip,size,data label,grid line",
        colorByDropEligible: "categorical",
    },
    {
        icon: "heatmap.png",
        chartHtml: "HeatmapChart.html",
        activeChart: false,
        title: "Heat Map",
        xAxisLabelName: "Categorical",
        yAxisLabelName: "Categorical",
        maxDropOnXAxis: 1,
        maxDropOnYAxis: 1,
        yAxisVisible: true,
        lineTypeChartVisible: false,
        mainCustomizations: "Properties,Legend,Reference Line",
        subMenuCustomizations: "color by,tool tip,size,data label,grid line",
        colorByDropEligible: "numerical",
    },
    {
        icon: "scatter_plot.png",
        chartHtml: "ScatterChart.html",
        activeChart: false,
        title: "Scatter Plot",
        yAxisVisible: true,
        maxDropOnXAxis: 1,
        maxDropOnYAxis: 1,
        lineTypeChartVisible: false,
        mainCustomizations: "Properties,Legend,Reference Line",
        subMenuCustomizations: "color by,tool tip,size,data label,grid line",
        colorByDropEligible: "categorical",
        xAxisLabelName: "Numerical",
        yAxisLabelName: "Numerical",
    },
    {
        icon: "waterfall.png",
        chartHtml: "WaterfallChart.html",
        activeChart: false,
        title: "Waterfall",
        yAxisVisible: true,
        maxDropOnXAxis: 1,
        maxDropOnYAxis: 1,
        lineTypeChartVisible: false,
        mainCustomizations: "Properties,Legend,Reference Line",
        subMenuCustomizations: "tool tip,size,data label,grid line",
    },
    {
        icon: "pie_chart.png",
        chartHtml: "PieChart.html",
        activeChart: false,
        title: "Pie Chart",
        xAxisLabelName: "Categorical",
        yAxisLabelName: "Numerical",
        maxDropOnXAxis: 1,
        maxDropOnYAxis: 1,
        yAxisVisible: false,
        lineTypeChartVisible: false,
        mainCustomizations: "Properties,Legend,Reference Line",
        subMenuCustomizations: "color by,tool tip,data label",
        colorByDropEligible: "",
    },
    {
        icon: "donut.png",
        chartHtml: "DoughnutChart.html",
        activeChart: false,
        title: "Donut Chart",
        xAxisLabelName: "Categorical",
        maxDropOnXAxis: 1,
        maxDropOnYAxis: 1,
        yAxisLabelName: "Numerical",
        yAxisVisible: false,
        lineTypeChartVisible: false,
        mainCustomizations: "Properties,Legend,Reference Line",
        subMenuCustomizations: "color by,tool tip,size,data label",
        colorByDropEligible: "",
    },
    {
        icon: "radar.png",
        chartHtml: "RadarChart.html",
        activeChart: false,
        xAxisLabelName: "Categorical",
        yAxisLabelName: "Numerical",
        title: "Radar",
        maxDropOnXAxis: 1,
        yAxisVisible: false,
        lineTypeChartVisible: false,
        mainCustomizations: "Properties,Legend,Reference Line",
        subMenuCustomizations: "color by,tool tip,size,data label,grid line",
        colorByDropEligible: "",
    },
    {
        icon: "sunburst.png",
        chartHtml: "SunburstChart.html",
        activeChart: false,
        title: "Sunburst",
        xAxisLabelName: "Categorical",
        yAxisLabelName: "Numerical",
        maxDropOnYAxis: 1,
        maxDropOnXAxis: 5,
        axisSettingsDisabled: true,
        yAxisVisible: false,
        lineTypeChartVisible: false,
        mainCustomizations: "Properties,Reference Line",
        subMenuCustomizations: "color by,tool tip,data label",
        colorByDropEligible: "",
    },
    //        ,{
    //            icon: "nightingales_rose.png"
    //            activeChart: false
    //            chartHtml:"bar.html"
    //            title:"Nightingale Rose"
    //            yAxisVisible: false
    //            lineTypeChartVisible: false
    //        }
    //        ,{
    //            icon: "chord_diagram.png"
    //            chartHtml:"ChordChart.html"
    //            activeChart: false
    //            title:"Chord Diagram"
    //            xAxisLabelName: "Source"
    //            yAxisLabelName: "Numerical"
    //            yAxisVisible: false
    //            lineTypeChartVisible: false
    //        }
    {
        icon: "funnel.png",
        chartHtml: "FunnelChart.html",
        activeChart: false,
        title: "Funnel Chart",
        yAxisVisible: false,
        maxDropOnXAxis: 1,
        maxDropOnYAxis: 1,
        xAxisLabelName: "Categorical",
        yAxisLabelName: "Numerical",
        axisSettingsDisabled: true,
        lineTypeChartVisible: false,
        mainCustomizations: "Properties,Legend,Reference Line",
        subMenuCustomizations:
            "color by,tool tip,size,data label,dynamic height,bottom pinch",
        colorByDropEligible: "",
    },
    {
        icon: "tree_chart.png",
        chartHtml: "TreeChart.html",
        activeChart: false,
        title: "Tree Chart",
        maxDropOnYAxis: 1,
        xAxisLabelName: "Categorical",
        yAxisLabelName: "Numerical",
        yAxisVisible: false,
        lineTypeChartVisible: false,
        mainCustomizations: "Properties,Reference Line",
        subMenuCustomizations: "tool tip,data label",
        colorByDropEligible: "",
    },
    // ,{
    //     icon: "force_directed.png"
    //     chartHtml:"bar.html"
    //     activeChart: false
    //     title:"Force Directed"
    //     mainCustomizations: "Properties,Legend,Reference Line"
    // }
    {
        // icon: "sankey.png",
        icon: "sankey_grey.png",
        chartHtml: "SankeyChart.html",
        elementHeight: 24,
        activeChart: false,
        disabled: true,
        title: "Sankey - Coming Soon",
        xAxisLabelName: "Source",
        yAxisLabelName: "Target",
        mainCustomizations: "Properties,Legend,Reference Line",
        colorByDropEligible: "",
        subMenuCustomizations: "color by,tool tip,size,data label,grid line",
    },
    {
        // icon: "tree_map.png",
        icon: "treemap_grey.png",
        chartHtml: "TreeMapChart.html",
        elementHeight: 24,
        activeChart: false,
        disabled: true,
        xAxisLabelName: "Categorical",
        yAxisLabelName: "Numerical",
        title: "Tree Map - Coming Soon",
        maxDropOnXAxis: 2,
        maxDropOnYAxis: 1,
        colorByDropEligible: "",
        mainCustomizations: "Properties,Legend,Reference Line",
        subMenuCustomizations: "color by,tool tip,size,data label",
    },
    //        ,{
    //            icon: "condegram.png"
    //            chartHtml:"bar.html"
    //            activeChart: false
    //            title:"Condegram"
    //        }
    {
        // icon: "map.png",
        icon: "geo_grey.png",
        chartHtml: "GeoChart.html",
        elementHeight: 22,
        elementWidth: 40,
        activeChart: false,
        disabled: true,
        xAxisLabelName: "Location",
        yAxisLabelName: "Numerical",
        title: "Map - Coming Soon",
        mainCustomizations: "Properties,Legend",
        nonClickable: true,
        colorByDropEligible: "",
        subMenuCustomizations: "color by,tool tip,size,data label,grid line",
    },
    {
        icon: "gauge_chart.png",
        chartHtml: "GaugeChart.html",
        elementHeight: 22,
        elementWidth: 30,
        activeChart: false,
        title: "Gauge Chart",
        mainCustomizations: "",
        subMenuCustomizations: "color by,tool tip,size,data label,grid line",
        axisSettingsDisabled: true,
        colorByDropEligible: "",
    },
    {
        icon: "pivot.png",
        chartHtml: "PivotTable.html",
        activeChart: false,
        title: "Pivot",
        xAxisLabelName: "Rows",
        yAxisLabelName: "Columns",
        maxDropOnXAxis: 5,
        maxDropOnYAxis: 5,
        maxDropOnRow3Axis: 5,
        themeVisible: true,
        mainCustomizations: "Properties,Total",
        colorByDropEligible: "",
        subMenuCustomizations: "pivot theme,grand total,row total,sub total",
        axisSettingsDisabled: true,
    },
    {
        icon: "table.png",
        chartHtml: "TableChart.html",
        xAxisLabelName: "Columns",
        yAxisLabelName: "Columns",
        elementWidth: 30,
        activeChart: false,
        maxDropOnXAxis: 5,
        title: "Table",
        mainCustomizations: "Total,Table Customization",
        subMenuCustomizations: "tool tip,size,data label,grand total",
        axisSettingsDisabled: true,
    },
    {
        icon: "kpi.png",
        chartHtml: "KPI.html",
        elementWidth: 30,
        elementHeight: 20,
        activeChart: false,
        title: "KPI",
        xAxisLabelName: "Values",
        mainCustomizations: "KPI Properties",
        subMenuCustomizations: "data label",
        axisSettingsDisabled: true,
    },
];

function setAllChartsModel() {
    var allKeys = [
        "icon",
        "chartHtml",
        "activeChart",
        "title",
        "xAxisLabelName",
        "yAxisLabelName",
        "yAxisVisible",
        "lineTypeChartVisible",
        "maxDropOnXAxis",
        "maxDropOnYAxis",
        "mainCustomizations",
        "subMenuCustomizations",
        "colorByDropEligible",
        "disabled",
        "nonClickable",
        "axisSettingsDisabled",
        "elementHeight",
        "elementWidth",
        "maxDropOnRow3Axis",
        "themeVisible",
    ];

    const imageHeight = 32;
    const imageWidth = 32;
    allChartsConfig.forEach((chartConfig) => {
        var chartObj = {};
        allKeys.forEach((key) => {
            switch (key) {
                case "elementHeight":
                    chartObj[key] = chartConfig[key] || imageHeight;
                    break;
                case "elementWidth":
                    chartObj[key] = chartConfig[key] || imageWidth;
                    break;
                default:
                    chartObj[key] = chartConfig[key];
            }
        });
        allCharts.append(chartObj);
    });
}

function initializeQmlChartConfig() {
    report_desiner_page.qmlChartConfig = {
        customizationsAvailable: Constants.defaultCustomizationsAvailable,
        subMenuCustomizationsAvailable:
            Constants.defaultSubMenuCustomizationsAvailable,
    };
}

function resetQmlChartConfig() {
    customizationsAvailable = Constants.defaultCustomizationsAvailable;
    subMenuCustomizationsAvailable =
        Constants.defaultSubMenuCustomizationsAvailable;

    allCharts.set(activeChartIndex, { activeChart: false });
    activeChartIndex = 0;
    allCharts.set(activeChartIndex, { activeChart: true });

    initializeQmlChartConfig();
}
