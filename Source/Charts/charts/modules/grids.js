const d3 = require("d3");
const CONSTANTS = require("../constants");
const { getNumberOfTicks, getAxisWidth, getYRange } = require("../utils");

const makeYaxisGridLines = (scale) => {
    return d3.axisLeft(scale).ticks(getNumberOfTicks()).tickSize(-getAxisWidth()).tickFormat(d3.format(".2s"));
};

const makeXaxisGridLines = (scale) => {
    const yRange = getYRange();
    return d3
        .axisBottom(scale)
        .tickSize(yRange[0] - yRange[1])
        .tickFormat("")
        .ticks(getNumberOfTicks());
};

const isExceptionChart = () => {
    const exceptionCharts = [CONSTANTS.HEAT_MAP];

    let { chartName } = grafieks.plotConfiguration;

    if (exceptionCharts.indexOf(chartName) > -1) {
        return true;
    }
    return false;
};

const setGrids = (svg) => {
    if (isExceptionChart()) {
        return;
    }

    const grafieks = window.grafieks;
    const chartsMargins = grafieks.chartsConfig.margins;

    let transformValue = `translate(${chartsMargins.left},0)`;
    let scale = makeYaxisGridLines(grafieks.utils.yScale);
    if (grafieks.plotConfiguration.isHorizontalGraph) {
        scale = makeXaxisGridLines(grafieks.utils.xScale);
        transformValue = `translate(0,${chartsMargins.top})`;
    }

    svg.append("g")
        .lower() // lower() Works like Prepend in jquery
        .attr("class", "grid")
        .attr("transform", transformValue)
        .style("stroke-width", "1")
        .call(scale);
};

module.exports = {
    setGrids
};
