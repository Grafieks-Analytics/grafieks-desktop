const d3 = require("d3");
const CONSTANTS = require("../constants");

const isLegendExceptionChart = () => {
    const exceptionCharts = [CONSTANTS.RADAR_CHART, CONSTANTS.TREE_CHART];

    let { chartName } = grafieks.plotConfiguration;

    if (exceptionCharts.indexOf(chartName) > -1) {
        return true;
    }
    return false;
};

const heatmapCustomLegend = (colors, legendData) => {
    const { legendConfig: { legendPosition = CONSTANTS.LEGEND_POSITION.RIGHT } = {} } =
        window.grafieks.plotConfiguration;

    const [minValue, maxValue] = legendData || [0, 0];
    const color1 = "#fff";
    const color2 = colors[colors.length - 1];

    let boxHeight = Math.min(window.innerHeight * 0.8, 300);
    let boxWidth = 15;

    let degree = 180;
    let outerClassSuffix = "Vertical";
    if (legendPosition == "top" || legendPosition == "bottom") {
        outerClassSuffix = "Horizontal";
        degree = 45;
        boxHeight = 30;
        boxWidth = Math.min(window.innerWidth * 0.5, 200);
    }
    return `<div class="gradientLegendFlexBox${outerClassSuffix}" style="height: ${boxHeight}px">
        <div class="minMaxValue text-center"> ${minValue} </div>
        <div class="gradientLegendInnerBox" style="width: ${boxWidth}px; background-image: linear-gradient(${degree}deg,${color1},${color2});">
        </div>
        <div class="minMaxValue text-center"> ${maxValue.toFixed(2)} </div>
    </div>`;
};

const getLegendDataHtml = () => {
    const legendData = window.grafieks.legend.data || [];
    let { d3colorPalette, chartName } = grafieks.plotConfiguration;

    if (chartName == CONSTANTS.WATERFALL_CHART) {
        d3colorPalette = Object.values(CONSTANTS.WATERFALL.COLORS);
    } else if (chartName == CONSTANTS.HEAT_MAP && !d3colorPalette) {
        // Add Condition for legend color
        d3colorPalette = CONSTANTS.d3SequentialDefaultTheme;
    } else if (!d3colorPalette) {
        d3colorPalette = CONSTANTS.d3ColorPalette;
    }

    if (chartName == CONSTANTS.HEAT_MAP) {
        return heatmapCustomLegend(d3colorPalette, legendData);
    }

    const legendHtml = legendData
        .map((legend, i) => {
            const color = d3colorPalette[i % d3colorPalette.length];
            return `<div class="legend-column"> 
                        <div class="legendBox" style="background: ${color}"></div> 
                        <span>
                            ${legend}
                        </span>
                    </div>`;
        })
        .join("");
    return legendHtml;
};

const updateLegendPosition = (legendPosition) => {
    const setJustifyContent = (element, value) => {
        element.style["justify-content"] = value;
    };

    /**
     * When position is left or right if window height is more than the scrollHeight
     * Or When position is top or bottom if window width is more than the scrollWidth
     * Add justify content center
     * Else remove justify content center
     */
    if (legendPosition == CONSTANTS.LEGEND_POSITION.LEFT || legendPosition == CONSTANTS.LEGEND_POSITION.RIGHT) {
        const legendOuterBox = document.querySelector(".legend .outerLegendDivVertical");
        const legendBoxHeight = legendOuterBox.scrollHeight;
        if (window.innerHeight > legendBoxHeight) {
            // Add justfy content center
            setJustifyContent(legendOuterBox, "center");
        } else {
            // Remove justify content center
            setJustifyContent(legendOuterBox, null);
        }
    } else {
        const legendOuterBox = document.querySelector(".legend .outerLegendDivHorizontal");
        const legendBoxWidth = legendOuterBox.scrollWidth;
        if (window.innerWidth > legendBoxWidth) {
            // Add justfy content center
            setJustifyContent(legendOuterBox, "center");
        } else {
            // Remove justify content center
            setJustifyContent(legendOuterBox, null);
        }
    }
};

const setLengend = () => {
    if (isLegendExceptionChart()) {
        return;
    }

    const {
        legendConfig: {
            legendStatus = CONSTANTS.defaultValues.legendStatus,
            legendPosition = CONSTANTS.LEGEND_POSITION.RIGHT
        } = {}
    } = window.grafieks.plotConfiguration;

    if (legendStatus) {
        // Adding Legend in legend placeholder
        var legend = d3.select(".legend").node();
        var legendContentOuterDiv = document.createElement("div");

        switch (legendPosition) {
            case CONSTANTS.LEGEND_POSITION.RIGHT:
                d3.select(".legend")
                    .attr("data-align", "horizontal")
                    .style("top", "0px")
                    .style("right", "0px")
                    .style("bottom", null)
                    .style("left", null)
                    .style("height", "100%")
                    .style("width", CONSTANTS.defaultValues.legendWidth + "px");

                grafieks.legend.topMargin = 0;
                grafieks.legend.leftMargin = 0;
                grafieks.legend.rightMargin = CONSTANTS.defaultValues.legendWidth;

                legendContentOuterDiv.className = "outerLegendDivVertical";
                legendContentOuterDiv.innerHTML = getLegendDataHtml();

                break;
            case CONSTANTS.LEGEND_POSITION.LEFT:
                d3.select(".legend")
                    .attr("data-align", "horizontal")
                    .style("top", "0px")
                    .style("right", null)
                    .style("bottom", null)
                    .style("left", "0px")
                    .style("height", "100%")
                    .style("width", CONSTANTS.defaultValues.legendWidth + "px");

                grafieks.legend.topMargin = 0;
                grafieks.legend.leftMargin = 100;
                grafieks.legend.rightMargin = 0;

                legendContentOuterDiv.className = "outerLegendDivVertical";
                legendContentOuterDiv.innerHTML = getLegendDataHtml();

                break;
            case CONSTANTS.LEGEND_POSITION.TOP:
                d3.select(".legend")
                    .attr("data-align", "vertical")
                    .style("top", "0px")
                    .style("right", null)
                    .style("bottom", null)
                    .style("left", null)
                    .style("height", CONSTANTS.defaultValues.legendHeight + "px")
                    .style("width", "100%");

                legendContentOuterDiv.className = "outerLegendDivHorizontal";
                legendContentOuterDiv.innerHTML = getLegendDataHtml();

                grafieks.legend.topMargin = CONSTANTS.defaultValues.legendHeight;
                grafieks.legend.leftMargin = 0;
                grafieks.legend.rightMargin = 0;

                break;
            case CONSTANTS.LEGEND_POSITION.BOTTOM:
                d3.select(".legend")
                    .attr("data-align", "vertical")
                    .style("top", null)
                    .style("right", null)
                    .style("bottom", "0px")
                    .style("left", null)
                    .style("height", CONSTANTS.defaultValues.legendHeight + "px")
                    .style("width", "100%");

                legendContentOuterDiv.className = "outerLegendDivHorizontal";
                legendContentOuterDiv.innerHTML = getLegendDataHtml();

                grafieks.legend.topMargin = 0;
                grafieks.legend.leftMargin = 0;
                grafieks.legend.rightMargin = 0;
                break;
        }

        legend.appendChild(legendContentOuterDiv);

        // Update position on the basis of scroll position
        updateLegendPosition(legendPosition);
    } else {
        grafieks.legend.topMargin = 0;
        grafieks.legend.leftMargin = 0;
        grafieks.legend.rightMargin = 0;
    }

    d3.select(".main-div")
        .style("margin-left", grafieks.legend.leftMargin + "px")
        .style("margin-top", grafieks.legend.topMargin + "px");
};

module.exports = {
    setLengend
};
