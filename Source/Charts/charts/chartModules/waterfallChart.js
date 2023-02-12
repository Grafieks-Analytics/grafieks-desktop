const d3 = require("d3");

const CONSTANTS = require("../constants");

const utils = require("../utils");

function waterfallData(data) {
    let cumulativeValue = 0;
    data = data.map((d, i) => {
        return { label: d[0], value: +d[1] };
    });
    data.forEach((d) => {
        d.start = cumulativeValue;
        cumulativeValue += d.value;
        d.end = cumulativeValue;
        d.class = d.value >= 0 ? "positive" : "negative";
    });
    data.push({
        label: "Total",
        end: cumulativeValue,
        start: 0,
        class: "total",
        value: cumulativeValue
    });
    return data;
}

const waterfallChartGeneration = (svg) => {
    const grafieks = window.grafieks;

    const data = grafieks.dataUtils.rawData || [];

    const [dataValues = [], dataLabels = []] = data;

    grafieks.dataUtils.dataValues = dataValues;
    grafieks.dataUtils.dataLabels = dataLabels;

    grafieks.dataUtils.dataLabelValues = dataValues[1];

    grafieks.legend.data = ["Increase", "Decrease", "Total"];

    const { height } = grafieks.chartsConfig;

    const waterfallDataValues = waterfallData(dataValues);

    const numericalValues = waterfallDataValues.map((d) => d.value);
    const minValue = utils.getMinimumValue(numericalValues);
    const maxValue = utils.getMaximumValue(numericalValues);

    // Setting yScale
    const yDomain = [minValue, maxValue];
    const yRange = utils.getYRange();
    const yScale = utils.getYScale(yDomain, yRange);

    // Setting xScale
    const xDomain = waterfallDataValues.map((d) => d.label); // Map the text values for x axis
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

    const bar = svg
        .selectAll(".bar")
        .data(waterfallDataValues)
        .enter()
        .append("g")
        .attr("class", (d) => "xBar bar " + d.class)
        .attr("transform", function (d) {
            // console.log(this)
            return "translate(" + xScale(d.label) + ",0)";
        });

    bar.append("rect")
        .attr("class", (d) => "visualPlotting rect bar " + d.class)
        .attr("y", function (d) {
            this.setAttribute("data-value-x1", d.label);
            this.setAttribute("data-value-y1", d.value);
            return yScale(Math.max(d.start, d.end));
        })
        .attr("height", (d) => Math.abs(yScale(d.start) - yScale(d.end)))
        .attr("width", xScale.bandwidth());

    return svg;
};
module.exports = waterfallChartGeneration;
