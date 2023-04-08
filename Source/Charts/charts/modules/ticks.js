const d3 = require("d3");
const CONSTANTS = require("../constants");
const { isHorizontalGraph } = require("../utils");

const updateHorizontalLeftValue = (tickText) => {
    const tickNodes = tickText.nodes();
    const tickNodeLength = tickNodes.length;

    let barsWidth = 0;
    let maxLength = CONSTANTS.defaultValues.maxRotationMargin;
    let tempMaxLength = 0;

    for (var i = 0; i < tickNodeLength; i++) {
        const tick = tickNodes[i];
        const textLength = tick.getComputedTextLength();
        if (textLength > tempMaxLength) {
            tempMaxLength = textLength;
        }
    }

    if (tempMaxLength < maxLength) {
        maxLength = tempMaxLength;
    }

    barsWidth += maxLength;

    grafieks.chartsConfig.margins.horizontalLeft = barsWidth;
};

const isTickTextOverflowing = () => {
    if (isTickExceptionalChart()) {
        return;
    }
    /*
        Here we check if the tick text is overflowing the rotating margin.
        - tick length should not exceed xAxiis length
    */
    let className = ".x-axis .tick text";
    const isHorizontalGraphBool = isHorizontalGraph();
    if (isHorizontalGraphBool) {
        className = ".y-axis .tick text";
    }
    const tickText = d3.selectAll(className);
    const tickNodes = tickText.nodes();
    const tickNodeLength = tickNodes.length;

    if (isHorizontalGraphBool) {
        updateHorizontalLeftValue(tickText);
        return;
    }

    if (grafieks.plotConfiguration.chartName == CONSTANTS.HEAT_MAP) {
        updateHorizontalLeftValue(d3.selectAll(".y-axis .tick text"));
    }

    const xScale = window.grafieks.utils.xScale;
    let isOverflowing = false;
    let rotatingMargin = grafieks.chartsConfig.margins.rotatingMargin;
    let barsWidth = xScale.bandwidth && xScale.bandwidth();

    for (var i = 0; i < tickNodeLength; i++) {
        const tick = tickNodes[i];
        const textLength = tick.getComputedTextLength();
        if (rotatingMargin < textLength) {
            rotatingMargin = Math.min(textLength, CONSTANTS.defaultValues.maxRotationMargin);
        }
        if (isOverflowing) {
            continue;
        }
        if (textLength > barsWidth) {
            isOverflowing = true;
        }
    }
    if (isOverflowing) {
        grafieks.chartsConfig.margins.rotatingMargin = rotatingMargin - 5;
    }
    return isOverflowing;
};

const getClippedTickText = (tick, tickNodeLength) => {
    const text = tick.innerHTML;
    const singleLetterLength = tickNodeLength / text.length;
    if (isHorizontalGraph()) {
        const totalEligibleCharacters = Math.floor(grafieks.chartsConfig.margins.horizontalLeft / singleLetterLength);
        if (text.length - totalEligibleCharacters > 3) {
            return text.substr(0, totalEligibleCharacters + 2) + "...";
        }
        return text;
    }
    const totalEligibleCharacters = Math.floor(grafieks.chartsConfig.margins.rotatingMargin / singleLetterLength);
    // If the text is longer than the total eligible characters, then we need to clip the text
    if (text.length - totalEligibleCharacters > 3) {
        return text.substr(0, totalEligibleCharacters + 2) + "...";
    }
    // if (text.length - totalEligibleCharacters > 0) {
    //     return text.substr(0, totalEligibleCharacters - 1) + "...";
    // }
    return text;
};

const isTickExceptionalChart = () => {
    const chartName = window.grafieks.plotConfiguration.chartName;
    if (CONSTANTS.TICKS.EXCEPTIONAL_CHARTS.indexOf(chartName) > -1) {
        return true;
    }
    return false;
};

const modifyAndHideTicks = () => {
    if (isTickExceptionalChart()) {
        return;
    }
    let className = ".x-axis .tick text";
    if (isHorizontalGraph()) {
        className = ".y-axis .tick text";
    }
    const tickTexts = d3.selectAll(className).nodes();
    const bandwidth = window.grafieks.utils.xScale.bandwidth || window.grafieks.utils.yScale.bandwidth;
    const barsWidth = bandwidth();

    tickTexts.forEach((tick, i) => {
        const verticalTickWidth = tick.getBBox().height;
        // if barsWidth > verticalTickWidth => Tick is eligible to be shown;
        // Calculate the space when a tick will not collide with other ticks = i % Math.floor(verticalTickWidth / barsWidth)
        // Remove all the other ticks which are coming in between this space.
        // i % Math.floor(verticalTickWidth / barsWidth) != 0 => Tick is not eligible to be shown; because it will overlap with other ticks
        if (barsWidth < verticalTickWidth && i % Math.floor(verticalTickWidth / barsWidth) != 0) {
            tick.remove();
            return;
        }
        // To check if the tick is overlapping, width of vertical tick (height of the tick)
        const tickNodeLength = tick.getComputedTextLength();
        if (tickNodeLength > grafieks.chartsConfig.margins.rotatingMargin) {
            tick.innerHTML = getClippedTickText(tick, tickNodeLength);
        }
    });
};

const getHorizontalLeftValue = () => {
    let barsWidth = CONSTANTS.chartsMargins.left - 20;
    let maxLength = CONSTANTS.chartsMargins.horizontalLeft;
    let tempMaxLength = 0;
    for (var i = 0; i < tickNodeLength; i++) {
        const tick = tickNodes[i];
        const textLength = tick.getComputedTextLength();
        if (textLength > tempMaxLength) {
            tempMaxLength = textLength;
        }
    }

    if (tempMaxLength < maxLength) {
        maxLength = tempMaxLength;
    }
    barsWidth += maxLength;

    return barsWidth;
};

module.exports = {
    isTickTextOverflowing,
    modifyAndHideTicks,
    getHorizontalLeftValue
};
