const constants = {
    redColor: "#E15759",
    yellowColor: "#EDC949",
    greenColor: "#59A14F",
    chartType: {
        FIT_WIDTH: "FitWidth",
        STANDARD: "Standard",
    },
};

const defaultD3Config = {
    d3ColorPalette: "schemeSet3",
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
    standartThresholdWidth: 100,
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
