const d3 = require("d3");

const CONSTANTS = require("../constants");

const utils = require("../utils");
const { sortDates } = require("../modules/dataTransformation");
const { drawMarkerForMultiLine } = require("../modules/markers");

const getTransformedDataValue = () => {
    const grafieks = window.grafieks;

    const data = grafieks.dataUtils.rawData || [];

    // Stack bar data structure
    // 1. Data Valuess [[sub-category, category, sales]] => TODO needs to be corrected
    // 2. Legend Data (The break downs) => Eg Sub-Categories
    // 3. X Axis Texts Or the domains for x axis => Category
    // 4. data labels => Category | Sub-Category | Sales

    let [dataValues = [], legendsData = [], dataLabels = []] = data;

    // Data columns has all the values of x-y axis and rows and values rows
    const { dataColumns } = grafieks.plotConfiguration;

    let json = {};
    let isKey1Date = false; // key1 is the cateogry || later on key2 can be added for sub category or color by split

    const { xAxisColumnDetails = [] } = dataColumns;
    let dateFormat = "%Y";

    if (xAxisColumnDetails[0].itemType == "Date") {
        isKey1Date = true;
        dateFormat = xAxisColumnDetails[0].dateFormat;
    }

    let uniqueKey = [];
    dataValues.forEach((d) => {
        // Index 1 is categry
        let key = d[0];
        if (isKey1Date) {
            key = utils.getDateFormattedData(key, dateFormat);
        }

        if (!json[key]) {
            json[key] = {};
        }

        const key2 = d[1];
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

    var responseData = [];

    response.forEach((d) => {
        var objectName = d.key;
        allKeys.forEach((key) => {
            responseData.push([objectName, key, d[key]]);
        });
    });

    return [responseData, allKeys, dataLabels, mainKeys];
};

const chartGeneration = (svg) => {
    const grafieks = window.grafieks;

    const data = grafieks.dataUtils.rawData || [];

    const [dataValues = [], legendsData = [], dataLabels = []] = data;
    const { dataColumns = {}, curveType = CONSTANTS.curveType.LINEAR, chartName } = grafieks.plotConfiguration;
    const { xAxisColumnDetails = [] } = dataColumns;

    let isDateTransforming = false;
    if (xAxisColumnDetails[0].itemType == "Date") {
        isDateTransforming = true;
    }

    grafieks.dataUtils.dataValues = dataValues;
    grafieks.dataUtils.dataLabels = dataLabels;

    grafieks.dataUtils.dataLabelValues = dataValues[1];

    grafieks.legend.data = legendsData;

    const { height } = grafieks.chartsConfig;

    const [transformedDataValues, splitKeys, dataLabelsTransformed, mainCategoryKeys] = getTransformedDataValue();

    const minValue = utils.getMinimumValue(transformedDataValues.map((d) => +d[2]));
    const maxValue = utils.getMaximumValue(transformedDataValues.map((d) => +d[2]));

    // Setting yScale
    const yDomain = [minValue, maxValue];
    const yRange = utils.getYRange();
    const yScale = utils.getYScale(yDomain, yRange);

    // Setting xScale

    const xDomain = mainCategoryKeys;
    const xRange = utils.getXRange();
    const xScale = utils.getXScale(xDomain, xRange);

    // Setting center line
    const center = d3.scaleLinear().range(xRange);
    const centerLine = d3.axisTop(center).ticks(0);

    const { d3colorPalette = CONSTANTS.d3ColorPalette } = grafieks.plotConfiguration;

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
    svg.append("g")
        .attr("class", "centerline")
        .attr("transform", "translate(0," + yScale(0) + ")")
        .call(centerLine.tickSize(0));

    const color = d3.scaleOrdinal().domain(legendsData).range(d3colorPalette);

    let line;
    if (chartName == CONSTANTS.MULTIPLE_AREA_CHART) {
        line = d3
            .area()
            .x(function (d) {
                return xScale(d[0]) + xScale.bandwidth() / 2;
            })
            .y1(function (d) {
                return yScale(+d[2]);
            })
            .y0(function (d) {
                return yScale(0);
            });
    } else {
        line = d3
            .line()
            .x(function (d) {
                return xScale(d[0]) + xScale.bandwidth() / 2;
            })
            .y(function (d) {
                return yScale(+d[2]);
            })
            .curve(d3[curveType]);
    }

    const entry = svg.selectAll(".line").data(splitKeys).enter();

    const stroke = CONSTANTS.defaultValues.lineStrokeWidth;
    entry
        .append("path")
        .attr("fill", function (d) {
            if (chartName == CONSTANTS.MULTIPLE_AREA_CHART) {
                return color(d);
            } else {
                return "none";
            }
        })
        .attr("stroke", function (d) {
            return color(d);
        })
        .style("opacity", chartName == CONSTANTS.MULTIPLE_AREA_CHART ? 0.7 : 1)
        .attr("stroke-width", stroke)
        .attr("class", "line")
        .attr("d", function (d) {
            const lineData = transformedDataValues.filter((dataRow) => {
                if (dataRow[1] == d) {
                    return true;
                }
                return false;
            });

            return line(lineData);
        });

    drawMarkerForMultiLine(svg, transformedDataValues, stroke, legendsData);

    return svg;
};
module.exports = chartGeneration;

/*

[
    [
        ["Furniture", "South", 117298.7109375],
        ["Furniture", "West", 252612.984375],
        ["Furniture", "Central", 163797.15625],
        ["Furniture", "East", 208291.125],
        ["Office Supplies", "South", 125651.3125],
        ["Office Supplies", "West", 220853.28125],
        ["Office Supplies", "Central", 167026.515625],
        ["Office Supplies", "East", 205516.15625],
        ["Technology", "South", 148771.828125],
        ["Technology", "West", 251991.546875],
        ["Technology", "Central", 170416.28125],
        ["Technology", "East", 264973.8125],
    ],
    ["South", "West", "Central", "East"],
    ["Category", "Sales", "Region"],
];


*/
