const d3 = require("d3");
const CONSTANTS = require("../constants");

const drawMarker = (svg, dataValues, stroke, fill) => {
    const markerShapeConfig = CONSTANTS.markerShapeConfig;
    const { markerShape = CONSTANTS.defaultValues.markerShape, filledStatus = true } = grafieks.plotConfiguration;

    const { initialCircleRadius, initialBoxDimension } = CONSTANTS.defaultValues;

    let xScale = grafieks.utils.xScale;
    let yScale = grafieks.utils.yScale;

    if (grafieks.plotConfiguration.isHorizontalGraph) {
        xScale = grafieks.utils.yScale;
        yScale = grafieks.utils.xScale;
    }

    svg.selectAll(".dot")
        .data(dataValues)
        .enter()
        .append(markerShape == "none" ? "rect" : markerShape)
        .attr("stroke", fill)
        .attr("class", markerShape)
        .attr("class", "visualPlotting marker-shape")
        .attr("fill", filledStatus ? fill : "none")
        .attr(markerShapeConfig[markerShape] && markerShapeConfig[markerShape].xPositionAttrName, function (d, i) {
            this.setAttribute("data-value-x1", d[0]);
            this.setAttribute("data-value-y1", d[1]);

            return xScale(d[0]) + xScale.bandwidth() / 2;
        })
        .attr(markerShapeConfig[markerShape] && markerShapeConfig[markerShape].yPositionAttrName, function (d) {
            const yValue = yScale(d[1]);
            let value = yValue;

            if (markerShape == CONSTANTS.markerShapes.RECT) {
                value -= initialBoxDimension / 2;
            } else {
                value -= initialCircleRadius / 2 - 1;
            }

            return value;
        })
        .attr("r", markerShape == "none" ? 0 : initialCircleRadius)
        .attr("height", markerShape == "none" ? 0 : initialBoxDimension)
        .attr("width", markerShape == "none" ? 0 : initialBoxDimension)
        .attr("points", function (d, i) {
            var x1 = xScale(d[0]);
            return x1;
        });
};

const drawMarkerForMultiLine = (svg, dataValues, stroke, legendsData) => {
    const markerShapeConfig = CONSTANTS.markerShapeConfig;
    const {
        markerShape = CONSTANTS.defaultValues.markerShape,
        d3colorPalette = CONSTANTS.d3ColorPalette,
        filledStatus = true
    } = grafieks.plotConfiguration;

    const { initialCircleRadius, initialBoxDimension } = CONSTANTS.defaultValues;

    let xScale = grafieks.utils.xScale;
    let yScale = grafieks.utils.yScale;

    if (grafieks.plotConfiguration.isHorizontalGraph) {
        xScale = grafieks.utils.yScale;
        yScale = grafieks.utils.xScale;
    }

    const color = d3.scaleOrdinal().domain(legendsData).range(d3colorPalette);

    svg.selectAll(".dot")
        .data(dataValues)
        .enter()
        .append(markerShape == "none" ? "rect" : markerShape)
        .attr("stroke", function (d) {
            return color(d[1]);
        })
        .attr("class", markerShape)
        .attr("class", "visualPlotting marker-shape")
        .attr("fill", function (d) {
            if (!filledStatus) return "none";
            return color(d[1]);
        })
        .attr(markerShapeConfig[markerShape] && markerShapeConfig[markerShape].xPositionAttrName, function (d, i) {
            this.setAttribute("data-value-x1", d[0]);
            this.setAttribute("data-value-x2", d[1]);
            this.setAttribute("data-value-y1", d[2]);
            return xScale(d[0]) + xScale.bandwidth() / 2;
        })
        .attr(markerShapeConfig[markerShape] && markerShapeConfig[markerShape].yPositionAttrName, function (d) {
            const yValue = yScale(d[2]);
            let value = yValue;

            if (markerShape == CONSTANTS.markerShapes.RECT) {
                value -= initialBoxDimension / 2;
            } else {
                value -= initialCircleRadius / 2 - 1;
            }

            return value;
        })
        .attr("r", markerShape == "none" ? 0 : initialCircleRadius)
        .attr("height", markerShape == "none" ? 0 : initialBoxDimension)
        .attr("width", markerShape == "none" ? 0 : initialBoxDimension)
        .attr("points", function (d, i) {
            var x1 = xScale(d[0]);
            return x1;
        });
};

module.exports = {
    drawMarker,
    drawMarkerForMultiLine
};
