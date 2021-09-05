const constants = {
    chartTitles: {
        waterfallChart: "Waterfall Chart",
    },
    redColor: "#E15759",
    yellowColor: "#EDC949",
    greenColor: "#59A14F",
    chartType: {
        FIT_WIDTH: "FitWidth",
        STANDARD: "Standard",
        FIT_HEIGHT: "FitHeight",
    },
    cureveType: {
        CARDINAL: "curveCardinal",
        LINEAR: "curveLinear",
        BASIS: "curveBasis",
        OPEN_BASIS: "curveBasisOpen",
        BUNDLE: "curveBundle",
    },
    markerShapes: {
        CIRCLE: "circle",
        RECT: "rect",
    },
    chartMargins: {
        top: 20,
        left: 70,
        right: 20,
        bottom: 80,
    },
};

const defaultD3Config = {
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
        "#17becf",
    ],
    defaultPaddingInner: 0.25,
    defaultMarkerShape: constants.markerShapes.RECT,
    initialCircleRadius: 3,
    onHoverCircleRadius: 7,
    initialBoxDimension: 6,
    onHoverBoxDimension: 8,
    defaultLineCurve: constants.cureveType.LINEAR,
    innerRadius: 150,
    defaultTimeParseFormat: "%d-%m-%Y",
    defaultSpace: 30,
    dateFormat: "%Y",
    defaultMarkerStatus: false,
    chartType: constants.chartType.FIT_WIDTH,
    // chartType: constants.chartType.STANDARD,
    horizontalChartType: constants.chartType.STANDARD,
    // horizontalChartType: constants.chartType.FIT_HEIGHT,
    standardThresholdWidth: 100,
    standardThresholdHeight: 100,
    fontSize: 12,
    fontFamily: "MS Sans Serif",
    fontColor: "black",
    defaultLegendConfig: {
        legendStatus: true,
        legendPosition: "bottom",
    },
    defaultlabelConfig: {
        labelStatus: false,
    },
    defaultGridConfig: {
        gridStatus: true,
    },
};
const markerShapeConfig = {
    circle: {
        xPositionAttrName: "cx",
        yPositionAttrName: "cy",
    },
    rect: {
        xPositionAttrName: "x",
        yPositionAttrName: "y",
    },
    polygon: {
        xPositionAttrName: "x",
        yPositionAttrName: "y",
    },
};
