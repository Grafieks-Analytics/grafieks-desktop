const d3 = require("d3");

const CONSTANTS = require("../constants");
const { setLengend } = require("../modules/legend");
const { setDataLabels } = require("../modules/datalabels");
const { getSvg } = require("../utils");

const chartGeneration = () => {
    const grafieks = window.grafieks;
    const data = grafieks.dataUtils.rawData || [];
    const [dataValues, dataLabels] = data;

    const {
        dataColumns: { xAxisColumnDetails = [] } = {},
        chartName,
        d3colorPalette = CONSTANTS.d3ColorPalette,
        labelConfig: { labelStatus = CONSTANTS.defaultValues.labelStatus } = {},
        innerRadius = CONSTANTS.defaultValues.innerRadius
    } = grafieks.plotConfiguration;

    if (xAxisColumnDetails[0].itemType == "Date") {
        isDateTransforming = true;
    }

    grafieks.dataUtils.dataValues = dataValues;
    grafieks.dataUtils.dataLabels = dataLabels;

    const legendsData = Object.keys(dataValues);
    grafieks.legend.data = legendsData;

    setLengend();

    const width = window.innerWidth - (grafieks.legend.leftMargin || grafieks.legend.rightMargin || 0);
    const height = window.innerHeight - (grafieks.legend.topMargin || 0);

    let radius = Math.min(width, height) / 2;
    if (labelStatus) {
        radius = radius * 0.7;
    } else {
        radius = radius * 0.85;
    }

    grafieks.dataUtils.radius = radius;

    const translateSvgTop = 0;
    const translateSvgLeft = 0;

    const svg = getSvg();
    let g = svg
        .append("g")
        .attr("transform", "translate(" + (width / 2 + translateSvgLeft) + "," + (height / 2 + translateSvgTop) + ")");

    // Creating Pie generator
    // No sorting
    var pie = d3.pie().sort(null);

    // Creating arc
    var arc = d3
        .arc()
        .innerRadius(function () {
            let innerRadiusValue = (chartName == CONSTANTS.PIE_CHART ? 0 : innerRadius) * 80;
            if (innerRadiusValue >= radius) {
                innerRadiusValue = radius / 2;
            }
            return innerRadiusValue;
        })
        .outerRadius(radius);

    const keys = Object.keys(dataValues);
    // Grouping different arcs
    var arcs = g
        .selectAll("arc")
        .data(pie(Object.values(dataValues)))
        .enter()
        .append("g");

    // Arcs will be used in data labels -> To append labels
    grafieks.utils.arcs = arcs;

    // Appending path
    arcs.append("path")
        .attr("fill", function (_, i) {
            return d3colorPalette[i % d3colorPalette.length];
        })
        .attr("class", function (data, i) {
            let { data: value } = data;
            this.setAttribute("data-value-x1", keys[i]);
            this.setAttribute("data-value-y1", value);
            return "visualPlotting";
        })
        .attr("d", arc);

    const chartsDiv = d3.select(".charts-div");
    chartsDiv.node().appendChild(svg.node());

    // Set data labels
    if (labelStatus) {
        setDataLabels(svg);
    }
};
module.exports = chartGeneration;
