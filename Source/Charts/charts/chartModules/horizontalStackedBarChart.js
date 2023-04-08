const d3 = require("d3");

const CONSTANTS = require("../constants");

const utils = require("../utils");
const { sortDates } = require("../modules/dataTransformation");

const getTransformedDataValue = () => {
    const grafieks = window.grafieks;

    const data = grafieks.dataUtils.rawData || [];

    // Stack bar data structure
    // 1. Data Valuess [[sub-category, category, sales]] => TODO needs to be corrected
    // 2. Legend Data (The break downs) => Eg Sub-Categories
    // 3. X Axis Texts Or the domains for x axis => Category
    // 4. data labels => Category | Sub-Category | Sales

    let [dataValues = [], legendsData = [], xAxisTextValues = [], dataLabels = []] = data;

    // Data columns has all the values of x-y axis and rows and values rows
    const { dataColumns } = grafieks.plotConfiguration;

    let json = {};
    let isKey1Date = false; // key1 is the cateogry || later on key2 can be added for sub category or color by split

    const { yAxisColumnDetails = [] } = dataColumns;
    let dateFormat = "%Y";

    if (yAxisColumnDetails[0].itemType == "Date") {
        isKey1Date = true;
        dateFormat = yAxisColumnDetails[0].dateFormat;
    }

    let uniqueKey = [];
    dataValues.forEach((d) => {
        // Index 1 is categry
        let key = d[1];
        if (isKey1Date) {
            key = utils.getDateFormattedData(d[1], dateFormat);
        }

        if (!json[key]) {
            json[key] = {};
        }

        const key2 = d[0];
        if (!uniqueKey.includes(key2)) {
            uniqueKey.push(key2);
        }

        const value = d[2];

        if (!json[key][key2]) {
            json[key][key2] = 0;
        }

        json[key][key2] += +value;
    });

    const allKeys = uniqueKey;

    let response = Object.keys(json).map((key) => {
        return { ...json[key], key };
    });

    let mainKeys = Object.keys(json);
    if (isKey1Date) {
        const sortedKeys = sortDates(Object.keys(json), dateFormat);
        mainKeys = sortedKeys;
        response = sortedKeys.map((d) => {
            return { ...json[d], key: d };
        });
    }

    return [response, allKeys, dataLabels, mainKeys];
};

const getMaximumValue = (transformedDataValues) => {
    return d3.max(transformedDataValues, function (d) {
        return d3.max(
            d.components.map((d1) => {
                return d1.y0;
            })
        );
    });
};

const getMinimumValue = (transformedDataValues) => {
    let minValue =
        d3.min(transformedDataValues, function (d) {
            return d3.min(
                d.components.map((d1) => {
                    return d1.y1;
                })
            );
        }) || 0;

    if (minValue > 0) {
        minValue = 0;
    }
    return minValue;
};

const chartGeneration = (svg) => {
    const grafieks = window.grafieks;

    const data = grafieks.dataUtils.rawData || [];

    const [dataValues = [], legendsData = [], xAxisTextValues = [], dataLabels = []] = data;
    const { dataColumns = {}, d3colorPalette = CONSTANTS.d3ColorPalette } = grafieks.plotConfiguration;
    const { yAxisColumnDetails = [] } = dataColumns;

    let isDateTransforming = false;
    if (yAxisColumnDetails[0].itemType == "Date") {
        isDateTransforming = true;
    }

    grafieks.dataUtils.dataValues = dataValues;
    grafieks.dataUtils.dataLabels = dataLabels;

    grafieks.dataUtils.dataLabelValues = dataValues[1];

    grafieks.legend.data = [dataLabels[0]];

    const { height } = grafieks.chartsConfig;

    const [transformedDataValues, splitKeys, dataLabelsTransformed, mainCategoryKeys] = getTransformedDataValue();

    grafieks.legend.data = splitKeys;

    // Adding components array to be used in for stacked bar chart
    transformedDataValues.forEach(function (d) {
        var y0_positive = 0;
        var y0_negative = 0;
        var mainKey = d.key;
        d.components = splitKeys.map(function (key) {
            if (d[key] >= 0) {
                return {
                    key,
                    mainKey,
                    y1: y0_positive,
                    y0: (y0_positive += d[key])
                };
            } else {
                return {
                    key,
                    mainKey,
                    y0: y0_negative,
                    y1: (y0_negative += d[key])
                };
            }
        });
    });

    const minValue = getMinimumValue(transformedDataValues);
    const maxValue = getMaximumValue(transformedDataValues);

    // Setting yScale
    const yDomain = isDateTransforming ? mainCategoryKeys : xAxisTextValues;
    const yRange = utils.getYRange();
    const yScale = utils.getYScale(yDomain, yRange);

    // Setting xScale
    const xDomain = [minValue, maxValue];
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

        const ticks = g
            .attr("transform", `translate(${chartsMargins.left + chartsMargins.horizontalLeft},0)`)
            .call(
                d3
                    .axisLeft(yScale)
                    .tickSize(0) // To remove the tick marks (The dashed solid lines)
                    .ticks(utils.getNumberOfTicks())
            )
            .selectAll("text");

        ticks.attr("font-size", xTickfontSize);
        ticks.attr("font-family", xTickfontFamily);
        ticks.attr("fill", xTickfontColor);

        return ticks;
    };

    const yAxis = (options = {}, g) => {
        const {
            yTickfontSize = CONSTANTS.defaultValues.fontSize,
            yTickfontFamily = CONSTANTS.defaultValues.fontFamily,
            yTickfontColor = CONSTANTS.defaultValues.fontColor
        } = window.grafieks.plotConfiguration;
        const chartsMargins = window.grafieks.chartsConfig.margins;

        let { textAnchor = "middle", translateY = height - chartsMargins.bottom } = options;
        // Adding rotating margin to xAxis so that when it is rotated things are visible fine
        const ticks = g
            .attr("transform", `translate(0,${translateY - (chartsMargins.rotatingMargin || 0)})`)
            .call(d3.axisBottom(xScale).tickSizeOuter(0).tickFormat(d3.format(".2s")))
            .selectAll("text");

        // If ticking config is vertical -> rotating the tick to 90 degrees
        if (grafieks.chartsConfig.ticksStyle == CONSTANTS.TICK_VERTICAL) {
            let yTickfontSizeTemp = yTickfontSize / 2;
            if (yTickfontSize < 16) {
                yTickfontSizeTemp -= 2;
            }
            ticks.attr("dx", "-.8em").attr("dy", `-0.${yTickfontSizeTemp}em`).attr("transform", "rotate(-90)");
            textAnchor = "end";
        }

        ticks.attr("text-anchor", textAnchor);
        ticks.attr("font-size", yTickfontSize);
        ticks.attr("font-family", yTickfontFamily);
        ticks.attr("fill", yTickfontColor);

        return ticks;
    };

    svg.append("g").attr("class", "x-axis").call(yAxis.bind(this, {}));
    svg.append("g").attr("class", "y-axis").call(xAxis.bind(this, {}));

    // Setting center line
    const center = d3.scaleLinear().range(yRange);
    const centerLine = d3.axisLeft(center).ticks(0);

    svg.append("g")
        .attr("class", "centerline")
        .attr("transform", "translate(0," + xScale(0) + ")")
        .call(centerLine.tickSize(0));

    const color = d3.scaleOrdinal().domain(legendsData).range(d3colorPalette);

    const margins = grafieks.chartsConfig.margins;

    const entry = svg
        .selectAll(".entry")
        .data(transformedDataValues)
        .enter()
        .append("g")
        .attr("class", "g")
        .attr("transform", function (d) {
            return "translate(0, 0)";
        });

    entry
        .selectAll("rect")
        .data(function (d) {
            return d.components;
        })
        .enter()
        .append("rect")
        .attr("class", "bar visualPlotting")
        .attr("height", yScale.bandwidth())
        .attr("y", function (d) {
            return yScale(d.mainKey);
        })
        .attr("x", function (d) {
            return xScale(d.y1);
        })
        .attr("width", function (d) {
            this.setAttribute("data-value-x1", d.mainKey);
            this.setAttribute("data-value-x2", d.key);

            var yValue = d.y0 - d.y1;
            if (d.y1 < 0) {
                yValue = d.y1 - d.y0;
            }
            this.setAttribute("data-value-y1", Math.round(yValue));

            return Math.abs(xScale(d.y0) - xScale(d.y1));
        })
        .style("fill", function (d) {
            return color(d.key);
        });

    return svg;
};
module.exports = chartGeneration;
