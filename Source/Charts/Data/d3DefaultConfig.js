const constants = {
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
    d3ColorPalette: [
        "#8dd3c7",
        "#ffffb3",
        "#bebada",
        "#fb8072",
        "#80b1d3",
        "#fdb462",
        "#b3de69",
        "#fccde5",
        "#d9d9d9",
        "#bc80bd",
        "#ccebc5",
        "#ffed6f",
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
    // chartType: constants.chartType.FIT_WIDTH,
    chartType: constants.chartType.STANDARD,
    // horizontalChartType: constants.chartType.STANDARD,
    horizontalChartType: constants.chartType.FIT_HEIGHT,
    standardThresholdWidth: 100,
    standardThresholdHeight: 100,
    fontSize: 12,
    fontFamily: "MS Sans Serif",
    fontColor: "black",
    defaultLegendConfig: {
        legendStatus: false,
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
