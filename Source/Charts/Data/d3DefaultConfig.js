const defaultD3Config = {
    d3ColorPalette: "schemeSet3",
    defaultPaddingInner: 0.25,
    defaultMarkerShape: "circle",
    initialCircleRadius: 2,
    onHoverCircleRadius: 5,
    initialBoxDimension: 6,
    onHoverBoxDimension: 8,
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
};
