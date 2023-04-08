const d3 = require("d3");
const CONSTANTS = require("../constants");

const { isElementInViewport } = require("../utils");

const formTooltipRow = (heading, value) => {
    if (!isNaN(value)) {
        value = (+value).toFixed(2);
    }
    return `<div class="tooltip-row">
                <span class="tooltip-heading">${heading}:</span>
                <span class="tooltip-value">${value}</span>
            </div>`;
};

const getToolTopValues = (element) => {
    const dataValues = element.dataset;
    const dataLabels = window.grafieks.dataUtils.dataLabels;
    let tooltipHtmlValue = [];
    const { toolTip = {} } = window.grafieks.plotConfiguration;
    let { textColumn1: xLabelName, textColumn2: yLabelName, textColumn3: colorByName } = toolTip;

    switch (window.grafieks.plotConfiguration.chartName) {
        case CONSTANTS.DONUT_CHART:
        case CONSTANTS.PIE_CHART:
        case CONSTANTS.HORIZONTAL_BAR_CHART:
        case CONSTANTS.BAR_CHART:
        case CONSTANTS.LINE_CHART:
        case CONSTANTS.AREA_CHART:
        case CONSTANTS.HORIZONTAL_LINE_CHART:
        case CONSTANTS.HORIZONTAL_AREA_CHART:

        case CONSTANTS.RADAR_CHART:
            if (!xLabelName) {
                xLabelName = dataLabels[0];
            }
            if (!yLabelName) {
                yLabelName = dataLabels[1];
            }
            tooltipHtmlValue.push(formTooltipRow(xLabelName, dataValues.valueX1));
            tooltipHtmlValue.push(formTooltipRow(yLabelName, dataValues.valueY1));
            break;
        case CONSTANTS.HORIZONTAL_STACKED_BAR_CHART:
        case CONSTANTS.STACKED_BAR_CHART:
        case CONSTANTS.MULTIPLE_LINE_CHART:
        case CONSTANTS.MULTIPLE_AREA_CHART:
            if (!xLabelName) {
                xLabelName = dataLabels[0];
            }
            if (!yLabelName) {
                yLabelName = dataLabels[1];
            }
            if (!colorByName) {
                colorByName = dataLabels[2];
            }
            tooltipHtmlValue.push(formTooltipRow(xLabelName, dataValues.valueX1));
            tooltipHtmlValue.push(formTooltipRow(colorByName, dataValues.valueX2));
            tooltipHtmlValue.push(formTooltipRow(yLabelName, dataValues.valueY1));
            break;
        case CONSTANTS.HEAT_MAP:
            if (!xLabelName) {
                xLabelName = dataLabels[0];
            }
            if (!yLabelName) {
                yLabelName = dataLabels[1];
            }
            if (!colorByName) {
                colorByName = dataLabels[2];
            }
            tooltipHtmlValue.push(formTooltipRow(xLabelName, dataValues.valueX1));
            tooltipHtmlValue.push(formTooltipRow(yLabelName, dataValues.valueY1));
            tooltipHtmlValue.push(formTooltipRow(colorByName, dataValues.value));
            break;
        case CONSTANTS.SCATTER_CHART:
            if (!xLabelName) {
                xLabelName = dataLabels[0];
            }
            if (!yLabelName) {
                yLabelName = dataLabels[1];
            }

            if (!colorByName) {
                colorByName = dataLabels[2];
            }

            tooltipHtmlValue.push(formTooltipRow(xLabelName, dataValues.valueX1));
            tooltipHtmlValue.push(formTooltipRow(yLabelName, dataValues.valueY1));
            if (colorByName) {
                tooltipHtmlValue.push(formTooltipRow(colorByName, dataValues.valueX2));
            }

            break;
        case CONSTANTS.WATERFALL_CHART:
            if (!xLabelName) {
                xLabelName = dataLabels[0];
            }
            if (!yLabelName) {
                yLabelName = dataLabels[1];
            }
            tooltipHtmlValue.push(formTooltipRow(xLabelName, dataValues.valueX1));
            tooltipHtmlValue.push(formTooltipRow(yLabelName, dataValues.valueY1));
            break;
        case CONSTANTS.SUNBURST_CHART:
            xLabelName = dataValues.valueXLabel;
            yLabelName = dataValues.valueYLabel;
            if (!(xLabelName == "undefined" && dataValues.valueX1 == yLabelName)) {
                tooltipHtmlValue.push(formTooltipRow(xLabelName, dataValues.valueX1));
            }
            tooltipHtmlValue.push(formTooltipRow(yLabelName, dataValues.valueY1));
            break;
        case CONSTANTS.GROUP_BAR_CHART:
        case CONSTANTS.HORIZONTAL_GROUP_BAR_CHART:
            if (!xLabelName) {
                xLabelName = dataLabels[0];
            }
            if (!yLabelName) {
                yLabelName = dataLabels[2];
            }
            if (!colorByName) {
                colorByName = dataLabels[1];
            }
            tooltipHtmlValue.push(formTooltipRow(xLabelName, dataValues.valueX1));
            tooltipHtmlValue.push(formTooltipRow(colorByName, dataValues.valueX2));
            tooltipHtmlValue.push(formTooltipRow(yLabelName, dataValues.valueY1));
    }

    return tooltipHtmlValue.join("");
};

const setTooltipHandler = () => {
    // Show tooltip on mouseover
    // Move this to function and move it to utils

    const tooltip = d3.select(".tooltip");
    tooltip.append("span").attr("class", "leftArrow");
    tooltip.append("div").attr("class", "tooltip-text");
    tooltip.append("span").attr("class", "rightArrow");

    d3.selectAll(".visualPlotting")
        .on("mouseout", function () {
            d3.select(".tooltip").style("display", "none");
            d3.selectAll(".visualPlotting").style("opacity", 1);
        })
        .on("mouseover mousemove", function (event) {
            d3.select(".tooltip").style("display", "block");

            // Get the x and y values for the mouse position
            const pointers = d3.pointer(event, this);
            let [xpos, ypos] = pointers;
            let topValue = 0,
                leftValue = 0;

            const { chartName } = grafieks.plotConfiguration;

            if (
                chartName == CONSTANTS.HORIZONTAL_STACKED_BAR_CHART ||
                chartName == CONSTANTS.STACKED_BAR_CHART ||
                chartName == CONSTANTS.WATERFALL_CHART ||
                chartName == CONSTANTS.GROUP_BAR_CHART
            ) {
                const parentElement = this.parentElement;
                const matrix = window.getComputedStyle(parentElement).transform;
                const matrixValues = matrix.match(/matrix.*\((.+)\)/)[1].split(", ");

                xpos += +matrixValues[4] || 0;
            }

            if (grafieks.plotConfiguration.isAxisBasedChart) {
                topValue = ypos - 30 + (window.grafieks.legend.topMargin || 0);
                leftValue = xpos + 20 + (window.grafieks.legend.leftMargin || 0);
            }

            if (
                chartName == CONSTANTS.RADAR_CHART ||
                chartName == CONSTANTS.PIE_CHART ||
                chartName == CONSTANTS.DONUT_CHART ||
                chartName == CONSTANTS.SUNBURST_CHART ||
                chartName == CONSTANTS.HORIZONTAL_GROUP_BAR_CHART
            ) {
                topValue = event.clientY - 30;
                leftValue = event.clientX + 20;
                xpos = event.clientX;
                ypos = event.clientY + 20;
            }

            if (topValue < 0) {
                topValue = 0;
            }

            if (leftValue < 0) {
                leftValue = 0;
            }

            // Set the tooltip position
            d3.select(".tooltip")
                .style("opacity", 1)
                .style("top", topValue + "px")
                .style("left", leftValue + "px");

            d3.select(".tooltip .leftArrow").style("display", "block");
            d3.select(".tooltip .rightArrow").style("display", "none");

            // Get the tooltip values
            // Based on chart names
            const tooltipValue = getToolTopValues(this);

            // Set the tooltip text
            d3.select(".tooltip .tooltip-text").html(tooltipValue);

            const tooltipBox = d3.select(".tooltip").node();
            tooltipBox.style.right = null;
            tooltipBox.style.bottom = null;

            // Check if tooltip is in viewport
            const tooltipNode = d3.select(".tooltip").node();
            const { status: inViewStatus, boundingRects } = isElementInViewport(tooltipNode);
            if (!inViewStatus && boundingRects.right > (window.innerWidth || document.documentElement.clientWidth)) {
                d3.select(".tooltip .leftArrow").style("display", "none");
                d3.select(".tooltip .rightArrow").style("display", "block");

                const toolTipRight = window.innerWidth - xpos - (window.grafieks.legend.leftMargin || 0);

                tooltipBox.style.right = toolTipRight + 16 + "px";
                tooltipBox.style.left = null;
            }
            if (!inViewStatus && boundingRects.bottom > (window.innerHeight || document.documentElement.clientHeight)) {
                tooltipBox.style.bottom = "0px";
                tooltipBox.style.top = null;
            }

            // Fade all the other lines
            d3.selectAll(".visualPlotting").style("opacity", 0.3);
            // Mark the current line
            d3.select(this).style("opacity", 1);
        });
};

module.exports = { setTooltipHandler };
