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

    const { xAxisColumnDetails = [] } = dataColumns;
    let dateFormat = "%Y";

    if (xAxisColumnDetails[0].itemType == "Date") {
        isKey1Date = true;
        dateFormat = xAxisColumnDetails[0].dateFormat;
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
    const { dataColumns = {} } = grafieks.plotConfiguration;
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
    const yDomain = [minValue, maxValue];
    const yRange = utils.getYRange();
    const yScale = utils.getYScale(yDomain, yRange);

    // Setting xScale

    const xDomain = isDateTransforming ? mainCategoryKeys : xAxisTextValues;
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

    const entry = svg
        .selectAll(".entry")
        .data(transformedDataValues)
        .enter()
        .append("g")
        .attr("class", "g")
        .attr("transform", function (d) {
            return "translate(" + xScale(d.key) + ", 0)";
        });

    entry
        .selectAll("rect")
        .data(function (d) {
            return d.components;
        })
        .enter()
        .append("rect")
        .attr("class", "bar visualPlotting")
        .attr("width", xScale.bandwidth())
        .attr("y", function (d) {
            return yScale(d.y0);
        })
        .attr("height", function (d) {
            this.setAttribute("data-value-x1", d.mainKey);
            this.setAttribute("data-value-x2", d.key);

            var yValue = d.y0 - d.y1;
            if (d.y1 < 0) {
                yValue = d.y1 - d.y0;
            }
            this.setAttribute("data-value-y1", Math.round(yValue));

            return Math.abs(yScale(d.y0) - yScale(d.y1));
        })
        .style("fill", function (d) {
            return color(d.key);
        });

    return svg;
};
module.exports = chartGeneration;

/*
    [[["Bookcases","Furniture",114880.0078125],["Bookcases","Office Supplies",0],["Bookcases","Technology",0],["Chairs","Furniture",328449.21875],["Chairs","Office Supplies",0],["Chairs","Technology",0],["Labels","Furniture",0],["Labels","Office Supplies",12486.3125],["Labels","Technology",0],["Tables","Furniture",206965.5625],["Tables","Office Supplies",0],["Tables","Technology",0],["Storage","Furniture",0],["Storage","Office Supplies",223843.703125],["Storage","Technology",0],["Furnishings","Furniture",91705.3046875],["Furnishings","Office Supplies",0],["Furnishings","Technology",0],["Art","Furniture",0],["Art","Office Supplies",27118.76953125],["Art","Technology",0],["Phones","Furniture",0],["Phones","Office Supplies",0],["Phones","Technology",330006.6875],["Binders","Furniture",0],["Binders","Office Supplies",203413],["Binders","Technology",0],["Appliances","Furniture",0],["Appliances","Office Supplies",107532.1328125],["Appliances","Technology",0],["Paper","Furniture",0],["Paper","Office Supplies",78479.1953125],["Paper","Technology",0],["Accessories","Furniture",0],["Accessories","Office Supplies",0],["Accessories","Technology",167380.234375],["Envelopes","Furniture",0],["Envelopes","Office Supplies",16476.404296875],["Envelopes","Technology",0],["Fasteners","Furniture",0],["Fasteners","Office Supplies",3024.280029296875],["Fasteners","Technology",0],["Supplies","Furniture",0],["Supplies","Office Supplies",46673.5390625],["Supplies","Technology",0],["Machines","Furniture",0],["Machines","Office Supplies",0],["Machines","Technology",189238.53125],["Copiers","Furniture",0],["Copiers","Office Supplies",0],["Copiers","Technology",149528.015625]],["Bookcases","Chairs","Labels","Tables","Storage","Furnishings","Art","Phones","Binders","Appliances","Paper","Accessories","Envelopes","Fasteners","Supplies","Machines","Copiers"],["Furniture","Office Supplies","Technology"],["Category","Sales","Sub-Category"]]
*/
/*
    [
        [
            ["South", "Furniture", 117298.7109375],
            ["South", "Office Supplies", 125651.3125],
            ["South", "Technology", 148771.828125],
            ["West", "Furniture", 252612.984375],
            ["West", "Office Supplies", 220853.28125],
            ["West", "Technology", 251991.546875],
            ["Central", "Furniture", 163797.15625],
            ["Central", "Office Supplies", 167026.515625],
            ["Central", "Technology", 170416.28125],
            ["East", "Furniture", 208291.125],
            ["East", "Office Supplies", 205516.15625],
            ["East", "Technology", 264973.8125],
        ],  // Data 
        ["South", "West", "Central", "East"], // Sub Groups
        ["Furniture", "Office Supplies", "Technology"], // Groups
        ["Category", "Sales", "Region"],
    ];

*/
