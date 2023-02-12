const d3 = require("d3");

const CONSTANTS = require("../constants");

const utils = require("../utils");

const { drawMarker } = require("../modules/markers");

const lineChartGeneration = (svg) => {
    const grafieks = window.grafieks;

    const data = grafieks.dataUtils.rawData || [];

    const [dataValues = [], dataLabels = []] = data;

    grafieks.dataUtils.dataValues = dataValues;
    grafieks.dataUtils.dataLabels = dataLabels;

    grafieks.dataUtils.dataLabelValues = dataValues[1];

    grafieks.legend.data = [dataLabels[0]];

    const { height } = grafieks.chartsConfig;

    const numericalValues = dataValues.map((d) => d[1]);
    const minValue = utils.getMinimumValue(numericalValues);
    const maxValue = utils.getMaximumValue(numericalValues);

    // Setting yScale
    const yDomain = [minValue, maxValue];
    const yRange = utils.getYRange();
    const yScale = utils.getYScale(yDomain, yRange);

    // Setting xScale
    const xDomain = dataValues.map((d) => d[0]); // Map the text values for x axis
    const xRange = utils.getXRange();
    const xScale = utils.getXScale(xDomain, xRange);

    // Exposing to utils, to be used in other places, like legend, tooltip, datalabels, axis etc.
    grafieks.utils.yScale = yScale;
    grafieks.utils.xScale = xScale;

    const xAxis = (options = {}, g) => {
        const {
            xTickfontSize = CONSTANTS.defaultValues.fontSize,
            xTickfontFamily = CONSTANTS.defaultValues.fontFamily,
            xTickfontColor = CONSTANTS.defaultValues.fontColor
        } = window.grafieks.plotConfiguration;
        const chartsMargins = window.grafieks.chartsConfig.margins;
        let { textAnchor = "middle", translateY = height - chartsMargins.bottom } = options;
        // Adding rotating margin to xAxis so that when it is rotated things are visible fine
        const ticks = g
            .attr("transform", `translate(0,${translateY - (chartsMargins.rotatingMargin || 0)})`)
            .call(d3.axisBottom(grafieks.utils.xScale).tickSizeOuter(0))
            .selectAll("text");

        // If ticking config is vertical -> rotating the tick to 90 degrees
        if (grafieks.chartsConfig.ticksStyle == CONSTANTS.TICK_VERTICAL) {
            let xTickfontSizeTemp = xTickfontSize / 2;
            if (xTickfontSize < 16) {
                xTickfontSizeTemp -= 2;
            }
            ticks.attr("dx", "-.8em").attr("dy", `-0.${xTickfontSizeTemp}em`).attr("transform", "rotate(-90)");
            textAnchor = "end";
        }

        ticks.attr("text-anchor", textAnchor);
        ticks.attr("font-size", xTickfontSize);
        ticks.attr("font-family", xTickfontFamily);
        ticks.attr("fill", xTickfontColor);

        return ticks;
    };

    const yAxis = (g) => {
        const chartsMargins = window.grafieks.chartsConfig.margins;

        const {
            yTickfontSize = CONSTANTS.defaultValues.fontSize,
            yTickfontFamily = CONSTANTS.defaultValues.fontFamily,
            yTickfontColor = CONSTANTS.defaultValues.fontColor
        } = window.grafieks.plotConfiguration;

        const ticks = g
            .attr("transform", `translate(${chartsMargins.left},0)`)
            .call(
                d3
                    .axisLeft(grafieks.utils.yScale)
                    .tickSize(0) // To remove the tick marks (The dashed solid lines)
                    .ticks(utils.getNumberOfTicks())
                    .tickFormat(d3.format(".2s"))
            )
            .selectAll("text");

        ticks.attr("font-size", yTickfontSize);
        ticks.attr("font-family", yTickfontFamily);
        ticks.attr("fill", yTickfontColor);

        return ticks;
    };

    svg.append("g").attr("class", "x-axis").call(xAxis.bind(this, {}));
    svg.append("g").attr("class", "y-axis").call(yAxis);

    const {
        chartName,
        d3colorPalette = CONSTANTS.d3ColorPalette,
        curveType = CONSTANTS.curveType.LINEAR
    } = grafieks.plotConfiguration;

    let line;
    let fill = "none";

    if (chartName == CONSTANTS.AREA_CHART) {
        line = d3
            .area()
            .x(function (d, i) {
                // this.setAttribute("data-value-x", d[0]);
                // this.setAttribute("data-value-y", d[1]);
                // console.log(d);
                return xScale(d[0]) + xScale.bandwidth() / 2;
            })
            .y1(function (d) {
                return yScale(d[1]);
            })
            .y0(function (d) {
                return yScale(0);
            });

        fill = d3colorPalette[0];
    } else {
        line = d3
            .line()
            .x(function (d, i) {
                // this.setAttribute("data-value-x", d[0]);
                // this.setAttribute("data-value-y", d[1]);
                // console.log(d);
                return xScale(d[0]) + xScale.bandwidth() / 2;
            })
            .y(function (d) {
                return yScale(d[1]);
            })
            .curve(d3[curveType]);
    }

    const lineStroke = CONSTANTS.defaultValues.lineStrokeWidth;
    svg.append("path")
        .attr("class", "line") // Assign a class for styling
        .attr("d", line(dataValues)) // 11. Calls the line generator
        .attr("stroke", d3colorPalette[0])
        .attr("stroke-width", lineStroke)
        .attr("fill", fill)
        .attr("transform", "translate(0,0)");

    drawMarker(svg, dataValues, lineStroke, d3colorPalette[0]);

    return svg;
};
module.exports = lineChartGeneration;
