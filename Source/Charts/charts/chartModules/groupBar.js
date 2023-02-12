const d3 = require("d3");

const CONSTANTS = require("../constants");

const utils = require("../utils");
const { sortDates } = require("../modules/dataTransformation");

const getTransformedDataValue = () => {
    const grafieks = window.grafieks;

    const data = grafieks.dataUtils.rawData || [];

    let [dataValues = [], legendsData = [], dataLabels = []] = data;

    // Data columns has all the values of x-y axis and rows and values rows
    const { dataColumns } = grafieks.plotConfiguration;

    let json = {};
    let isKey1Date = false; // key1 is the cateogry || later on key2 can be added for sub category or color by split
    let isKey2Date = false;

    const { xAxisColumnDetails = [] } = dataColumns;
    let dateFormat = "%Y";

    if (xAxisColumnDetails[0].itemType == "Date") {
        isKey1Date = true;
        dateFormat = xAxisColumnDetails[0].dateFormat;
    }

    if (xAxisColumnDetails[1].itemType == "Date") {
        isKey2Date = true;
        dateFormat = xAxisColumnDetails[1].dateFormat;
    }

    if (!isKey1Date && !isKey2Date) {
        return data;
    }

    var globalKeys = [];
    var transformedDataValue = {};

    dataValues.forEach((d) => {
        var currentData = d;

        var category = d.mainCategory;
        if (isKey1Date) {
            category = utils.getDateFormattedData(d.mainCategory, dateFormat);
        }
        // console.log(category);
        if (!transformedDataValue[category]) {
            transformedDataValue[category] = {};
        }
        var originalData = transformedDataValue[category];

        var allKeys = [...Object.keys(originalData), ...Object.keys(currentData)];

        allKeys = allKeys
            .filter((d) => {
                if (d != "mainCategory") {
                    return d;
                }
            })
            .filter(utils.getUniqueArrayValues);

        globalKeys.push(...allKeys);

        allKeys.forEach((d) => {
            originalData[d] = (originalData[d] || 0) + (currentData[d] || 0);
        });
        transformedDataValue[category] = {
            ...originalData,
            mainCategory: category
        };
    });

    if (isKey1Date) {
        var sortedKeys = sortDates(Object.keys(transformedDataValue), dateFormat);
        transformedDataValue = sortedKeys.map((key) => {
            return transformedDataValue[key];
        });
    } else {
        transformedDataValue = Object.keys(transformedDataValue).map((key) => {
            return transformedDataValue[key];
        });
    }

    globalKeys = globalKeys.filter(utils.getUniqueArrayValues);
    var mainCategoryData = transformedDataValue.map((d) => d.mainCategory);

    return [transformedDataValue, [globalKeys, mainCategoryData], dataLabels];
};

const getMaximumValue = (transformedDataValues, splitKeys) => {
    let maxValue = d3.max(transformedDataValues, (d) => d3.max(splitKeys, (k) => d && d[k]));
    if (maxValue < 0) {
        maxValue = 0;
    }
    return maxValue;
};

const getMinimumValue = (transformedDataValues, splitKeys) => {
    let minValue = d3.min(transformedDataValues, (d) => d3.min(splitKeys, (k) => d && d[k]));
    if (minValue > 0) {
        minValue = 0;
    }
    return minValue;
};

const chartGeneration = (svg) => {
    const grafieks = window.grafieks;

    const data = grafieks.dataUtils.rawData || [];

    const [dataValues = [], legendsData = [], dataLabels = []] = data;

    const {
        dataColumns = {},
        options: { groupBarChartColorBy } = {},
        d3colorPalette = CONSTANTS.d3ColorPalette
    } = grafieks.plotConfiguration;
    const { xAxisColumnDetails = [] } = dataColumns;

    let isDateTransforming = false;
    if (xAxisColumnDetails[0].itemType == "Date" || xAxisColumnDetails[1].itemType == "Date") {
        isDateTransforming = true;
    }

    grafieks.dataUtils.dataValues = dataValues;
    grafieks.dataUtils.dataLabels = dataLabels;

    grafieks.dataUtils.dataLabelValues = dataValues[1];

    const { height } = grafieks.chartsConfig;

    const [transformedDataValues, [splitKeys, mainCategoryKeys], dataLabelsTransformed] = getTransformedDataValue();

    window.grafieks.dataUtils.dataLabels = dataLabelsTransformed;
    grafieks.legend.data = !groupBarChartColorBy
        ? [dataLabelsTransformed[0]]
        : groupBarChartColorBy == "category"
        ? mainCategoryKeys
        : splitKeys;

    const minValue = getMinimumValue(transformedDataValues, splitKeys);
    const maxValue = getMaximumValue(transformedDataValues, splitKeys);

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

    const color = d3
        .scaleOrdinal()
        .domain(groupBarChartColorBy == "category" ? mainCategoryKeys : splitKeys)
        .range(d3colorPalette);

    function getBars(d, all_keys) {
        const bars = [];
        all_keys.forEach((k) => {
            if (d && d[k]) {
                bars.push({
                    name: k,
                    value: d[k],
                    data: d,
                    mainCategory: d.mainCategory
                });
            }
        });
        return bars;
    }

    function groupOffset(d, all_keys) {
        const groupElementsCount = all_keys.reduce((acc, k) => (d && d.hasOwnProperty(k) ? (acc += 1) : acc), 0),
            allElementsCount = all_keys.length,
            groupWidth = xScale.bandwidth(),
            x_offset = ((1 - groupElementsCount / allElementsCount) * groupWidth) / 2;

        return x_offset;
    }

    svg.selectAll(".groups")
        .data(transformedDataValues)
        .enter()
        .append("g")
        .attr("class", "mainCategory")
        .each(function (group_data) {
            const bar_data = getBars(group_data, splitKeys),
                x_offset = groupOffset(group_data, splitKeys),
                group_keys = bar_data.map((d) => d.name);

            xScale1 = d3
                .scaleBand()
                .domain(group_keys)
                .range([0, xScale.bandwidth() - x_offset * 2]);

            d3.select(this)
                .attr("transform", (d) => `translate(${xScale(d && d.mainCategory) + x_offset},0)`)
                .selectAll(".bar")
                .data(bar_data)
                .enter()
                .append("rect")
                .attr("class", "bar visualPlotting")
                .attr("fill", function (d) {
                    this.setAttribute("data-value-x1", d.mainCategory);
                    this.setAttribute("data-value-x2", d.name);
                    this.setAttribute("data-value-y1", d.value);

                    if (groupBarChartColorBy == "category") {
                        return color(d.data.mainCategory);
                    }
                    if (groupBarChartColorBy == "subcategory") {
                        return color(d.name);
                    }
                    return d3colorPalette[0];
                })
                .attr("x", (d) => xScale1(d.name))
                .attr("y", (d) => {
                    if (d.value < 0) {
                        return yScale(0);
                    }
                    return yScale(d.value);
                })
                .attr("width", xScale1.bandwidth())
                .attr("height", (d) => {
                    var heightValue = Math.abs(yScale(0) - yScale(Math.abs(d.value)));
                    if (!heightValue) {
                        heightValue = 1;
                    }
                    return heightValue;
                });
        });

    return svg;
};
module.exports = chartGeneration;

/*
[
    [
        {
            "Central": 163797.16380000004,
            "East": 208291.20400000009,
            "South": 117298.6840000001,
            "West": 252612.7435000003,
            "mainCategory": "Furniture"
        },
        {
            "Central": 167026.41500000027,
            "East": 205516.0549999999,
            "South": 125651.31299999992,
            "West": 220853.24900000007,
            "mainCategory": "Office Supplies"
        },
        {
            "Central": 170416.3119999999,
            "East": 264973.9810000003,
            "South": 148771.9079999999,
            "West": 251991.83199999997,
            "mainCategory": "Technology"
        }
    ],
    [
        ["South", "West", "Central", "East"],
        ["Furniture", "Office Supplies", "Technology"]
    ],
    ["Category", "Region", "Sales"]
]


*/
