const constants = {
    redColor: "#E15759",
    yellowColor: "#EDC949",
    greenColor: "#59A14F",
    chartType: {
        FIT_WIDTH: "FitWidth",
        STANDARD: "Standard",
        FIT_HEIGHT: "FitHeight",
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
    defaultMarkerShape: "circle",
    initialCircleRadius: 2,
    onHoverCircleRadius: 5,
    initialBoxDimension: 6,
    onHoverBoxDimension: 8,
    defaultLineCurve: "curveCardinal",
    innerRadius: 150,
    defaultTimeParseFormat: "%d-%m-%Y",
    defaultSpace: 30,
    dateFormat: "%Y",
    chartType: constants.chartType.FIT_WIDTH,
    horizontalChartType: constants.chartType.STANDARD,
    standardThresholdWidth: 100,
    standardThresholdHeight: 100,

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
