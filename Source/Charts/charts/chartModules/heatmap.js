const d3 = require("d3");

const CONSTANTS = require("../constants");

const utils = require("../utils");

const { sortDates } = require("../modules/dataTransformation");

function transformData(dataValue) {
    var json = {};
    var isKey1Date = false;
    var isKey2Date = false;

    const { dataColumns } = grafieks.plotConfiguration;
    var { xAxisColumnDetails = [{}], yAxisColumnDetails = [{}] } = dataColumns;
    if (xAxisColumnDetails[0].itemType == "Date") {
        isKey1Date = true;
        dateFormat = xAxisColumnDetails[0].dateFormat;
    }
    if (yAxisColumnDetails[0].itemType == "Date") {
        isKey2Date = true;
        dateFormat1 = yAxisColumnDetails[0].dateFormat;
    }

    var uniqueKey1 = [];
    var uniqueKey2 = [];

    var response = [];

    dataValue.forEach((d) => {
        var key1 = d[0];
        var key2 = d[1];

        if (isKey1Date) {
            key1 = utils.getDateFormattedData(key1, dateFormat);
        }

        if (!json[key1]) {
            json[key1] = {};
        }

        if (isKey2Date) {
            key2 = utils.getDateFormattedData(key2, dateFormat1);
        }

        if (!json[key1][key2]) {
            json[key1][key2] = 0;
        }

        if (!uniqueKey1.includes(key1)) {
            uniqueKey1.push(key1);
        }

        if (!uniqueKey2.includes(key2)) {
            uniqueKey2.push(key2);
        }

        var value = d[2];
        json[key1][key2] += +value;
    });

    if (isKey1Date) {
        uniqueKey1 = sortDates(uniqueKey1, dateFormat);
    }
    if (isKey2Date) {
        uniqueKey2 = sortDates(uniqueKey2, dateFormat1);
    }

    uniqueKey1.forEach((key1) => {
        uniqueKey2.forEach((key2) => {
            if (json[key1][key2]) {
                response.push([key1, key2, json[key1][key2]]);
            }
        });
    });

    return [response, [uniqueKey1, uniqueKey2]];
}

const chartGeneration = (svg) => {
    const grafieks = window.grafieks;
    const { d3colorPalette = CONSTANTS.d3SequentialDefaultTheme, gridStatus = true } = grafieks.plotConfiguration;

    const { height } = grafieks.chartsConfig;

    const data = grafieks.dataUtils.rawData || [];

    const [dataValues = [], dataLabels = [], axisLabels = []] = data;

    grafieks.dataUtils.dataValues = dataValues;
    grafieks.dataUtils.dataLabels = [axisLabels[0], axisLabels[2], axisLabels[1]];

    const [transformedDataValues, [xAxisGroup, yAxisGroup]] = transformData(dataValues);

    const numericalValues = transformedDataValues.map((d) => d[2]);
    const minValue = utils.getMinimumValue(numericalValues);
    const maxValue = utils.getMaximumValue(numericalValues);

    grafieks.legend.data = [minValue, maxValue];

    const xDomain = xAxisGroup;
    const xRange = utils.getXRange();
    const xScale = utils.getXScale(xDomain, xRange);

    const yDomain = yAxisGroup;
    const yRange = utils.getYRange();
    const yScale = utils.getXScale(yDomain, yRange);

    // Exposing to utils, to be used in other places, like legend, tooltip, datalabels, axis etc.
    grafieks.utils.yScale = yScale;
    grafieks.utils.xScale = xScale;

    var myColor = d3
        .scaleLinear()
        .range([d3colorPalette[0], d3colorPalette[d3colorPalette.length - 1]])
        .domain(
            d3.extent(transformedDataValues, function (d) {
                return +d[2];
            })
        );

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
            .attr("transform", `translate(${chartsMargins.left + chartsMargins.horizontalLeft},0)`)
            .call(
                d3.axisLeft(grafieks.utils.yScale).tickSize(0) // To remove the tick marks (The dashed solid lines)
            )
            .selectAll("text");

        ticks.attr("font-size", yTickfontSize);
        ticks.attr("font-family", yTickfontFamily);
        ticks.attr("fill", yTickfontColor);

        return ticks;
    };

    svg.append("g").attr("class", "x-axis").call(xAxis.bind(this, {}));
    svg.append("g").attr("class", "y-axis").call(yAxis);

    svg.selectAll()
        .data(transformedDataValues)
        .enter()
        .append("rect")
        .attr("x", function (d) {
            this.setAttribute("data-value-x1", d[0]);
            this.setAttribute("data-value-y1", d[1]);
            this.setAttribute("data-value", d[2]);
            return xScale(d[0]);
        })
        .attr("y", function (d) {
            return yScale(d[1]);
        })
        .attr("width", xScale.bandwidth())
        .attr("height", yScale.bandwidth())
        .style("fill", function (d) {
            return myColor(d[2]);
        })
        .style("stroke-width", 0.5)
        .style("stroke", gridStatus ? "grey" : "none")
        .attr("class", function (d, i) {
            return "visualPlotting heatmap" + i;
        });

    return svg;
};

module.exports = chartGeneration;
