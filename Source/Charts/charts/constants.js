const chartNames = {
    BAR_CHART: "Bar Chart",
    HORIZONTAL_BAR_CHART: "Horizontal Bar Chart",
    STACKED_BAR_CHART: "Stacked Bar Chart",
    HORIZONTAL_STACKED_BAR_CHART: "Horizontal Stack Bar Chart",

    GROUP_BAR_CHART: "Grouped Bar Chart",
    HORIZONTAL_GROUP_BAR_CHART: "Horizontal Bar Grouped Chart",

    LINE_CHART: "Line Chart",
    HORIZONTAL_LINE_CHART: "Horizontal Line Chart",
    MULTIPLE_LINE_CHART: "Multi Line",
    HORIZONTAL_MULTIPLE_LINE_CHART: "Horizontal Multi Line",

    AREA_CHART: "Area Chart",
    HORIZONTAL_AREA_CHART: "Horizontal Area Chart",
    STACKED_AREA_CHART: "Stacked Area Chart",
    MULTIPLE_AREA_CHART: "Multiple Area Chart",
    HORIZONTAL_STACKED_AREA_CHART: "Multiple Horizontal Area Chart",

    PIE_CHART: "Pie Chart",
    DONUT_CHART: "Donut Chart",

    SCATTER_CHART: "Scatter Plot",
    HEAT_MAP: "Heat Map",
    WATERFALL_CHART: "Waterfall",

    TREE_CHART: "Tree Chart",
    TREEMAP_CHART: "Treemap Chart",

    SANKEY_CHART: "Sankey Chart",
    RADAR_CHART: "Radar",
    SUNBURST_CHART: "Sunburst",

    GAUGE_CHART: "Gauge Chart",
    PIVOT: "Pivot",
    TABLE: "Table",
    KPI_CHART: "KPI",
    FUNNEL_CHART: "Funnel Chart"
};

module.exports = {
    ...chartNames,
    axisBasedCharts: [
        chartNames.BAR_CHART,
        chartNames.LINE_CHART,
        chartNames.AREA_CHART,
        chartNames.STACKED_BAR_CHART,
        chartNames.STACKED_AREA_CHART,
        chartNames.MULTIPLE_LINE_CHART,
        chartNames.HORIZONTAL_BAR_CHART,
        chartNames.HORIZONTAL_LINE_CHART,
        chartNames.HORIZONTAL_AREA_CHART,
        chartNames.HORIZONTAL_STACKED_BAR_CHART,
        chartNames.HORIZONTAL_STACKED_AREA_CHART,
        chartNames.HORIZONTAL_MULTIPLE_LINE_CHART,
        chartNames.GROUP_BAR_CHART,
        chartNames.HORIZONTAL_GROUP_BAR_CHART,
        chartNames.MULTIPLE_AREA_CHART,
        chartNames.SCATTER_CHART,
        chartNames.HEAT_MAP,
        chartNames.WATERFALL_CHART
    ],

    horizontalCharts: [
        chartNames.HORIZONTAL_BAR_CHART,
        chartNames.HORIZONTAL_LINE_CHART,
        chartNames.HORIZONTAL_AREA_CHART,
        chartNames.HORIZONTAL_STACKED_BAR_CHART,
        chartNames.HORIZONTAL_STACKED_AREA_CHART,
        chartNames.HORIZONTAL_MULTIPLE_LINE_CHART,
        chartNames.HORIZONTAL_GROUP_BAR_CHART
    ],

    chartsMargins: { top: 20, right: 20, bottom: 30, left: 40, rotatingMargin: 0, horizontalLeft: 0 },

    d3SequentialDefaultTheme: ["#ffffff", "#08306b"],
    d3ColorPalette: [
        "#1f77b4",
        "#ff7f0e",
        "#2ca02c",
        "#d62728",
        "#9467bd",
        "#8c564b",
        "#e377c2",
        "#7f7f7f",
        "#bcbd22",
        "#17becf"
    ],

    curveType: {
        CARDINAL: "curveCardinal",
        LINEAR: "curveLinear",
        BASIS: "curveBasis",
        OPEN_BASIS: "curveBasisOpen",
        BUNDLE: "curveBundle"
    },

    markerShapes: {
        CIRCLE: "circle",
        RECT: "rect"
    },

    markerShapeConfig: {
        circle: {
            xPositionAttrName: "cx",
            yPositionAttrName: "cy"
        },
        rect: {
            xPositionAttrName: "x",
            yPositionAttrName: "y"
        },
        polygon: {
            xPositionAttrName: "x",
            yPositionAttrName: "y"
        },
        none: {
            xPositionAttrName: "x",
            yPositionAttrName: "y"
        }
    },

    labelFormat: {
        ROUND: "symbol",
        NONE: "none"
    },

    defaultValues: {
        fontSize: 12,
        fontFamily: "MS Sans Serif",
        fontColor: "black",

        gridStatus: true,
        legendStatus: false,
        labelStatus: false,

        legendWidth: 120,
        legendHeight: 30,
        maxRotationMargin: 70, // Maximum height allowed for ticks after rotation
        dataLabelFormat: "symbol",

        maxDistanceBetweenTicks: 18,
        maxDistanceBetweenLabels: 40,

        lineStrokeWidth: 3,

        labelConfig: {
            labelStatus: false
        },

        innerRadius: 0.75,

        initialCircleRadius: 3,
        onHoverCircleRadius: 7,
        initialBoxDimension: 6,
        onHoverBoxDimension: 8,

        markerShape: "circle"
    },

    LEGEND_POSITION: {
        TOP: "top",
        BOTTOM: "bottom",
        LEFT: "left",
        RIGHT: "right"
    },

    TICKS: {
        EXCEPTIONAL_CHARTS: [chartNames.SCATTER_CHART, chartNames.FUNNEL_CHART]
    },

    TICK_VERTICAL: "verticalTicks",
    TICK_HORIZONTAL: "horizontalTicks",

    WATERFALL: {
        COLORS: {
            positive: "#59a14f",
            negative: "#e15759",
            total: "#4e79a7"
        }
    },

    KPI: {
        STYLE: {
            value: {
                fontSize: 12,
                color: "#000",
                bold: false,
                italic: false,
                underline: false,
                fontFamily: "Arial"
            },
            label: {
                fontSize: 12,
                color: "#000",
                bold: false,
                italic: false,
                underline: false,
                fontFamily: "Arial"
            }
        }
    },

    FUNNEL: {
        defaultDynamicHeight: false,
        defaultBottomPinch: 1
    },

    TABEL: {
        defaultCellBorderStatus: true,
        defaultCellHoverStatus: true,
        defaultCompactStatus: false,
        defaultSearchStatus: true,
        defaultGrandTotalStatus: false,
        defaultRowAlternateStatus: true,
        defaultBatchsize: 50
    }
};
