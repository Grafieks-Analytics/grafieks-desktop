const d3 = require("d3");

const CONSTANTS = require("../constants");

const addDataStyling = (fontStyling, textType, styleElementId) => {
    var {
        fontSize = CONSTANTS.defaultValues.fontSize,
        color = CONSTANTS.defaultValues.fontColor,
        fontStyle = CONSTANTS.defaultValues.fontStyle,
        fontFamily = CONSTANTS.defaultValues.fontFamily,
        bold,
        italic,
        underline,
        dataLabelColorKpi = CONSTANTS.defaultValues.fontColor,
        dataValueColorKpi = CONSTANTS.defaultValues.fontColor
    } = fontStyling;

    if (textType == "label") {
        window.dataLabelColorKpi = dataLabelColorKpi;
    } else {
        window.dataValueColorKpi = dataValueColorKpi;
    }

    var styleElement = document.getElementById(styleElementId);
    if (styleElement) {
        styleElement.remove();
    }
    styleElement = document.createElement("style");
    styleElement.id = styleElementId;
    styleElement.innerHTML = `
        .${textType} {
            font-size: ${fontSize}px;
            font-family: ${fontFamily};
            color: ${color};
            ${bold ? "font-weight: 700" : ""};
            ${italic ? "font-style: italic" : ""};
            ${underline ? "text-decoration: underline" : ""};
        }
    `;
    document.body.appendChild(styleElement);
};

const kpiChartGeneration = () => {
    const grafieks = window.grafieks;
    const data = grafieks.dataUtils.rawData || [];
    const [dataValue, dataLabel] = data[0];

    console.log(dataValue, dataLabel);

    const chartsDiv = d3.select(".charts-div");

    const { valueFontStylings = CONSTANTS.STYLE.KPI.value, labelFontStylings = CONSTANTS.STYLE.KPI.label } =
        grafieks.plotConfiguration;

    addDataStyling(valueFontStylings, "value", "valueStyling");
    addDataStyling(labelFontStylings, "label", "labelStyling");

    chartsDiv.html(`<div class="kpi-text-center"><div class="value"></div><div class="label text-center"></div></div>`);

    // d3.select(".value").text(Math.round(value)).style("color",dataValueColorKpi);
    d3.select(".value").text(d3.format(".3s")(dataValue)).style("color", dataValueColorKpi);
    d3.select(".label").text(dataLabel).style("color", dataLabelColorKpi);
};
module.exports = kpiChartGeneration;

// [[2297221.75,"Sales"]]
