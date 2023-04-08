const d3 = require("d3");
const CONSTANTS = require("../constants");

const { getDistanceBetweenElements } = require("../utils");

function formatLabel(labelValue, labelFormat) {
    switch (labelFormat) {
        case "round":
            return Math.round(labelValue);
        case "comma":
            return Math.round(labelValue).toLocaleString("en-US");
        case "symbol":
            return d3.format(".3s")(labelValue);
        case "none":
            return labelValue;
        default:
            return Math.round(labelValue);
    }
}

function removeDataLabelsByDistance() {
    var labels = document.querySelectorAll(".data-label text, .data-label-text");
    var lastTickShown = labels[0];
    var lastTickShown1 = null;
    var lastTickShown2 = null;
    labels.forEach((label, i) => {
        if (!i) return;
        if (
            getDistanceBetweenElements(label, lastTickShown) < CONSTANTS.defaultValues.maxDistanceBetweenLabels ||
            (lastTickShown1 &&
                getDistanceBetweenElements(label, lastTickShown1) < CONSTANTS.defaultValues.maxDistanceBetweenLabels) ||
            (lastTickShown2 &&
                getDistanceBetweenElements(label, lastTickShown2) < CONSTANTS.defaultValues.maxDistanceBetweenLabels)
        ) {
            label.remove();
        } else {
            lastTickShown2 = lastTickShown1;
            lastTickShown1 = lastTickShown;
            lastTickShown = label;
        }
    });
}

const barChartDataLabel = (svg) => {
    const visualPlotting = svg.selectAll(".visualPlotting");
    const visualPlottingNodes = visualPlotting.nodes();

    const {
        dataLabelColor = CONSTANTS.defaultValues.fontColor,
        dataLabelfontFamily = CONSTANTS.defaultValues.fontFamily,
        dataLabelfontSize = CONSTANTS.defaultValues.fontSize
    } = grafieks.plotConfiguration;

    svg.append("g")
        .attr("class", "data-label")
        .selectAll("text")
        .data(grafieks.dataUtils.dataLabelValues)
        .join("text")
        .attr("class", "label-text")
        .attr("text-anchor", "middle")
        .attr("font-size", dataLabelfontSize)
        .attr("font-family", dataLabelfontFamily)
        .attr("fill", dataLabelColor)
        .attr("x", function (_, i) {
            return +visualPlottingNodes[i].getAttribute("x") + +visualPlottingNodes[i].getAttribute("width") / 2;
        })
        .attr("y", function (d, i) {
            let yPosition = +visualPlottingNodes[i].getAttribute("y") - 3;
            if (d < 0) {
                yPosition += +visualPlottingNodes[i].getAttribute("height") + 16;
            }
            return yPosition;
        })
        .text(function (dataLabelText) {
            return formatLabel(dataLabelText, CONSTANTS.defaultValues.dataLabelFormat);
        });
};

const horizontalBarChartDataLabel = (svg) => {
    const visualPlotting = svg.selectAll(".visualPlotting");
    const visualPlottingNodes = visualPlotting.nodes();

    const {
        dataLabelColor = CONSTANTS.defaultValues.fontColor,
        dataLabelfontFamily = CONSTANTS.defaultValues.fontFamily,
        dataLabelfontSize = CONSTANTS.defaultValues.fontSize
    } = grafieks.plotConfiguration;

    svg.append("g")
        .attr("class", "data-label")
        .selectAll("text")
        .data(grafieks.dataUtils.dataLabelValues)
        .join("text")
        .attr("class", "label-text")
        .attr("text-anchor", "middle")
        .attr("font-size", dataLabelfontSize)
        .attr("font-family", dataLabelfontFamily)
        .attr("fill", dataLabelColor)
        .attr("x", function (d, i) {
            let xPosition = +visualPlottingNodes[i].getAttribute("x") - 20;
            if (d > 0) {
                xPosition += +visualPlottingNodes[i].getAttribute("width") + 35;
            }
            return xPosition;
        })
        .attr("y", function (_, i) {
            return +visualPlottingNodes[i].getAttribute("y") + +visualPlottingNodes[i].getAttribute("height") / 2 + 4;
        })
        .text(function (dataLabelText) {
            return formatLabel(dataLabelText, CONSTANTS.defaultValues.dataLabelFormat);
        });
};

const stackedBarChartDataLabel = (svg) => {
    const visualPlotting = svg.selectAll(".visualPlotting");
    const visualPlottingNodes = visualPlotting.nodes();

    const {
        dataLabelColor = CONSTANTS.defaultValues.fontColor,
        dataLabelfontFamily = CONSTANTS.defaultValues.fontFamily,
        dataLabelfontSize = CONSTANTS.defaultValues.fontSize
    } = grafieks.plotConfiguration;

    svg.append("g")
        .attr("class", "data-label")
        .selectAll("text")
        .data(visualPlottingNodes)
        .join("text")
        .attr("class", "label-text")
        .attr("text-anchor", "middle")
        .attr("font-size", dataLabelfontSize)
        .attr("font-family", dataLabelfontFamily)
        .attr("fill", dataLabelColor)
        .attr("x", function (d) {
            let xPosition = +d.getAttribute("x");

            const parentElement = d.parentElement;
            const matrix = window.getComputedStyle(parentElement).transform;
            const matrixValues = matrix.match(/matrix.*\((.+)\)/)[1].split(", ");

            const boxWidth = +d.getAttribute("width");

            xPosition += boxWidth / 2;

            return (xPosition += +matrixValues[4] || 0);
        })
        .attr("y", function (d) {
            return +d.getAttribute("y") + +d.getAttribute("height") / 2 + 4;
        })
        .text(function (d, i) {
            const dataLabelText = d.dataset.valueY1;
            return formatLabel(dataLabelText, CONSTANTS.defaultValues.dataLabelFormat);
        });
};

const lineChartDataLabel = (svg) => {
    const visualPlotting = svg.selectAll(".visualPlotting");
    const visualPlottingNodes = visualPlotting.nodes();

    const {
        dataLabelColor = CONSTANTS.defaultValues.fontColor,
        dataLabelfontFamily = CONSTANTS.defaultValues.fontFamily,
        dataLabelfontSize = CONSTANTS.defaultValues.fontSize
    } = grafieks.plotConfiguration;

    svg.append("g")
        .attr("class", "data-label")
        .selectAll("text")
        .data(visualPlottingNodes)
        .join("text")
        .attr("class", "label-text")
        .attr("text-anchor", "middle")
        .attr("font-size", dataLabelfontSize)
        .attr("font-family", dataLabelfontFamily)
        .attr("fill", dataLabelColor)
        .attr("x", function (d) {
            return d.getBBox && d.getBBox().x;
        })
        .attr("y", function (d) {
            const dataLabelText = +d.dataset.valueY1;
            let yPosition = d.getBBox && d.getBBox().y - 5;
            if (dataLabelText < 0) {
                yPosition += 20;
            }
            return yPosition;
        })
        .text(function (d, i) {
            const dataLabelText = d.dataset.valueY1;
            return formatLabel(dataLabelText, CONSTANTS.defaultValues.dataLabelFormat);
        });
};

const waterfallDataLabel = (svg) => {
    const visualPlotting = svg.selectAll(".visualPlotting");
    const visualPlottingNodes = visualPlotting.nodes();

    const {
        dataLabelColor = CONSTANTS.defaultValues.fontColor,
        dataLabelfontFamily = CONSTANTS.defaultValues.fontFamily,
        dataLabelfontSize = CONSTANTS.defaultValues.fontSize
    } = grafieks.plotConfiguration;

    svg.append("g")
        .attr("class", "data-label")
        .selectAll("text")
        .data(visualPlottingNodes)
        .join("text")
        .attr("class", "label-text")
        .attr("text-anchor", "middle")
        .attr("font-size", dataLabelfontSize)
        .attr("font-family", dataLabelfontFamily)
        .attr("fill", dataLabelColor)
        .attr("x", function (d, i) {
            let xPosition = d.getBBox().x;
            const parentElement = d.parentElement;
            const matrix = window.getComputedStyle(parentElement).transform;
            const matrixValues = matrix.match(/matrix.*\((.+)\)/)[1].split(", ");

            const boxWidth = +d.getAttribute("width");

            xPosition += boxWidth / 2;

            return (xPosition += +matrixValues[4] || 0);
        })
        .attr("y", function (d, i) {
            let yPosition = +visualPlottingNodes[i].getAttribute("y") - 3;
            if (d < 0) {
                yPosition += +visualPlottingNodes[i].getAttribute("height") + 16;
            }
            return yPosition;
        })
        .text(function (d) {
            const dataLabelText = d.dataset.valueY1;
            return formatLabel(dataLabelText, CONSTANTS.defaultValues.dataLabelFormat);
        });
};

const heatmapDataLabels = (svg) => {
    const visualPlotting = svg.selectAll(".visualPlotting");
    const visualPlottingNodes = visualPlotting.nodes();

    const {
        dataLabelColor = CONSTANTS.defaultValues.fontColor,
        dataLabelfontFamily = CONSTANTS.defaultValues.fontFamily,
        dataLabelfontSize = CONSTANTS.defaultValues.fontSize
    } = grafieks.plotConfiguration;

    svg.append("g")
        .attr("class", "data-label")
        .selectAll("text")
        .data(visualPlottingNodes)
        .join("text")
        .attr("class", "label-text")
        .attr("text-anchor", "middle")
        .attr("font-size", dataLabelfontSize)
        .attr("font-family", dataLabelfontFamily)
        .attr("fill", dataLabelColor)
        .attr("x", function (d, i) {
            return +d.getAttribute("x") + +d.getAttribute("width") / 2;
        })
        .attr("y", function (d, i) {
            let yPosition = +d.getAttribute("y");
            const height = d.getBBox().height;
            return (yPosition += height / 2);
        })
        .text(function (d) {
            const dataLabelText = d.dataset.value;
            return formatLabel(dataLabelText, CONSTANTS.defaultValues.dataLabelFormat);
        });
};

const pieChartDataLabels = () => {
    const { radius } = grafieks.dataUtils;

    const {
        dataLabelColor = CONSTANTS.defaultValues.fontColor,
        dataLabelfontFamily = CONSTANTS.defaultValues.fontFamily,
        dataLabelfontSize = CONSTANTS.defaultValues.fontSize,
        labelConfig: { labelFormat } = {}
    } = grafieks.plotConfiguration;

    // Another arc that won't be drawn. Just for labels positioning
    let outerArcRadius = radius + 15;
    var outerArc = d3.arc().innerRadius(outerArcRadius).outerRadius(outerArcRadius);

    const arcs = grafieks.utils.arcs;

    arcs.append("text")
        .attr("class", "data-label-text")
        .attr("transform", function (d) {
            const pos = outerArc.centroid(d);
            return "translate(" + pos + ")";
        })
        .attr("dy", 5)
        .attr("font-size", dataLabelfontSize)
        .attr("font-family", dataLabelfontFamily)
        .attr("fill", dataLabelColor)
        .attr("text-anchor", "middle")
        .text(function (d) {
            return formatLabel(d.data, labelFormat);
        });
};

const setDataLabels = (svg) => {
    const { chartName } = grafieks.plotConfiguration;

    switch (chartName) {
        case CONSTANTS.BAR_CHART:
            barChartDataLabel(svg);
            break;
        case CONSTANTS.HORIZONTAL_BAR_CHART:
            horizontalBarChartDataLabel(svg);
            break;
        case CONSTANTS.HORIZONTAL_STACKED_BAR_CHART:
        case CONSTANTS.STACKED_BAR_CHART:
            stackedBarChartDataLabel(svg);
            break;
        case CONSTANTS.HORIZONTAL_AREA_CHART:
        case CONSTANTS.HORIZONTAL_LINE_CHART:
        case CONSTANTS.AREA_CHART:
        case CONSTANTS.LINE_CHART:
        case CONSTANTS.MULTIPLE_AREA_CHART:
        case CONSTANTS.MULTIPLE_LINE_CHART:
        case CONSTANTS.SCATTER_CHART:
            lineChartDataLabel(svg);
            break;
        case CONSTANTS.WATERFALL_CHART:
        case CONSTANTS.GROUP_BAR_CHART:
            waterfallDataLabel(svg);
            break;
        case CONSTANTS.HEAT_MAP:
            heatmapDataLabels(svg);
            break;
        case CONSTANTS.DONUT_CHART:
        case CONSTANTS.PIE_CHART:
            pieChartDataLabels(svg);
            break;
    }

    removeDataLabelsByDistance();
};

module.exports = {
    setDataLabels
};
