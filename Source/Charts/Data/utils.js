function isDateFormat(date) {
    var initialPart = date && date.toString().split("-");
    if (isNaN(initialPart)) {
        // initialPart
        // if (!isInMonth(initialPart)) {
        //     return false;
        // }
    }

    if (typeof date == "number") {
        return false;
    }
    if (typeof date == "string") {
        if (date.length < 6) {
            return false;
        }
    }
    if (new Date(date) != "Invalid Date") {
        return true;
    }
    return false;
}

function arraySum(arr) {
    return arr.reduce((a, b) => a + b, 0);
}

function isInMonth(value) {
    var shortMonths = ["jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sept", "oct", "nov", "dec"];
    var fullMonths = [
        "january",
        "february",
        "march",
        "april",
        "may",
        "june",
        "july",
        "august",
        "september",
        "october",
        "november",
        "december"
    ];

    value = value && value.toString().toLowerCase();
    if (value && (shortMonths.includes(value) || fullMonths.includes(value))) {
        return true;
    }

    return false;
}

function getDateFormattedData(dateValue, dateFormat) {
    return d3.timeFormat(dateFormat)(new Date(dateValue));
}

function getUniqueArrayValues(value, index, self) {
    return self.indexOf(value) === index;
}

function changeChartAttributes(selector, attributeName, attributeValue) {
    d3.selectAll(selector).attr(attributeName, attributeValue);
}

function changeLabelPostionsAttributes(selectorTick, selectorLabel, attributeName) {
    var value = getAttributesValues(selectorTick);
    var isFirstInitialValueSet = window["initialLabelPosition" + attributeName];
    if (!isFirstInitialValueSet) {
        window["initialLabelPosition" + attributeName] = d3.selectAll(selectorLabel).attr(attributeName);

        window.isFirstInitialValueSet = true;
    }

    console.log("window['initialLabelPosition' + attributeName]" + window["initialLabelPosition" + attributeName]);

    if (selectorLabel == ".y_label") {
        d3.selectAll(selectorLabel).attr(attributeName, +window["initialLabelPosition" + attributeName] - +value);
    } else if (selectorLabel == ".x_label") {
        d3.selectAll(selectorLabel).attr(attributeName, +window["initialLabelPosition" + attributeName] + +value);
    }
}

// function getLabelPosition(selectorLabel , axis) {
//    var value = d3
//      .selectAll(selectorLabel)
//      .attr(attributeName, +attributeValue + +value);
//   value = value.getBoundingClientRect().height;
//   console.log(value);
//   return value;
// }

function getAttributesValues(selector) {
    // var value = d3.selectAll(selector).attr(attributeName);

    var value = document.querySelector(selector);
    if (!value) {
        return false;
    }
    value = value.getBoundingClientRect().height;
    return value;
}

function setText(selector, textValue) {
    d3.selectAll(selector).text(textValue);
}

function setLabel(label = "xLabel", labelType = "x_label", svg, y_pos, x_tick_fontSize, y_tick_fontSize) {
    // debugger;
    const margin = { top: 30, right: 30, bottom: 70, left: 60 };
    if (document.querySelector("#my_dataviz svg").clientWidth > document.documentElement.clientWidth) {
        width = document.querySelector("#my_dataviz").clientWidth;
    } else {
        width = document.querySelector("#my_dataviz svg").clientWidth;
    }
    d3.selectAll("#xAxisLabelId").style("width", width + "px");
    d3.selectAll("#xAxisLabelId").style("margin-left", "72px");
    height = document.querySelector("#yAxisDiv").clientHeight;
    heightXLabelId = document.querySelector("#xAxisLabelId").clientHeight;
    // heightYLabelId = 250;
    if (document.querySelector("#my_dataviz svg g g.grid") != null) {
        if (document.querySelector("#my_dataviz svg g g.grid").getBoundingClientRect().height < 600) {
            heightYLabelId = document.querySelector("#my_dataviz svg g g.grid").getBoundingClientRect().height;
        } else {
            heightYLabelId = document.querySelector("#my_dataviz").clientHeight;
        }
    } else {
        heightYLabelId = document.querySelector("#my_dataviz").clientHeight;
    }

    widthXLabelId = document.querySelector("#xAxisLabelId").clientWidth;

    if (labelType == "x_label") {
        svg.append("text")
            .attr("class", labelType)
            .attr("text-anchor", "start")
            .text(label)
            .attr("x", (widthXLabelId - 72) / 2 - label.length / 2)
            .attr("y", heightXLabelId / 2 + xLabelfontSize / 2)
            .attr("font-size", xLabelfontSize)
            .attr("font-family", xLabelfontFamily)
            .attr("font-weight", xboldLabel ? "bold" : "regular")
            .attr("font-style", xitalicLabel ? "italic" : "regular")
            .attr("fill", xLabelfontColor)
            .attr("class", labelType);
    } else {
        svg.append("text")
            .attr("class", labelType)
            .attr("text-anchor", "middle")
            .text(label)
            .attr("y", 5)
            .attr("font-size", yLabelfontSize)
            .attr("font-family", yLabelfontFamily)
            .attr("font-weight", yboldLabel ? "bold" : "regular")
            .attr("font-style", yitalicLabel ? "italic" : "regular")
            .attr("fill", yLabelfontColor)
            .attr("x", -(heightYLabelId / 2) + (label.length - 5) / 2)
            .attr("dy", ".75em")
            .attr("position", "fixed")
            .attr("transform", "rotate(-90)");
    }
}

function sortDatesArray(dates, dateFormat, isHorizontalGraph) {
    var parseTime = d3.timeParse(dateFormat);
    var newDataSet = dates.map((d) => {
        return new Date(parseTime(d)).getTime();
    });

    dates = newDataSet.sort(function (a, b) {
        // Turn your strings into dates, and then subtract them
        // to get a value that is either negative, positive, or zero.
        return new Date(a) - new Date(b);
    });

    dates = dates.map((d) => {
        var formattedDate = d3.timeFormat(dateFormat)(new Date(d));
        return formattedDate;
    });

    if (dateFormat == "%d") {
        dates = dates.sort(function (a, b) {
            return a - b;
        });
    }

    if (isHorizontalGraph) {
        dates = dates.reverse();
    }

    return dates;
}

function sortDates(dateDataset, dateFormat, isHorizontalGraph) {
    var parseTime = d3.timeParse(dateFormat);
    var dates = Object.keys(dateDataset);
    var newDataSet = [];
    dates.forEach((d) => {
        d = new Date(parseTime(d)).getTime();
        newDataSet.push(d);
    });
    dates = newDataSet.sort(function (a, b) {
        // Turn your strings into dates, and then subtract them
        // to get a value that is either negative, positive, or zero.
        return new Date(a) - new Date(b);
    });
    dates = dates.map((d) => {
        var formattedDate = d3.timeFormat(dateFormat)(new Date(d));
        return formattedDate;
    });

    if (dateFormat == "%d") {
        dates = dates.sort(function (a, b) {
            return a - b;
        });
    }

    if (isHorizontalGraph) {
        dates = dates.reverse();
    }

    return dates;
}

function clearChart() {
    if (!window.d3) {
        console.log("d3 not available skipping");
        return;
    }
    //pivot table has id rr -> [Tag: Refactor]
    // Change this later to my_dataviz
    d3.selectAll("#rr").html("");
    d3.selectAll("#my_dataviz").html("");
    d3.selectAll("#yAxisDiv").html("");
    d3.selectAll("#xAxisDiv").html("");
    d3.selectAll("#xAxisLabelId").html("");

    if (window.extraHeight) {
        window.extraHeight = 0;
    }
}

function rgbToHex(r, g, b) {
    return "#" + ((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1);
}

function hexToRgbNew(hex) {
    hex = hex.substr(1);
    var arrBuff = new ArrayBuffer(4);
    var vw = new DataView(arrBuff);
    vw.setUint32(0, parseInt(hex, 16), false);
    var arrByte = new Uint8Array(arrBuff);

    return arrByte[1] + "," + arrByte[2] + "," + arrByte[3];
}

function rgba2hex(orig) {
    var a,
        rgb = orig.replace(/\s/g, "").match(/^rgba?\((\d+),(\d+),(\d+),?([^,\s)]+)?/i),
        alpha = ((rgb && rgb[4]) || "").trim(),
        hex = rgb
            ? (rgb[1] | (1 << 8)).toString(16).slice(1) +
              (rgb[2] | (1 << 8)).toString(16).slice(1) +
              (rgb[3] | (1 << 8)).toString(16).slice(1)
            : orig;

    if (alpha !== "") {
        a = alpha;
    } else {
        a = "01";
    }
    // multiply before convert to HEX
    a = ((a * 255) | (1 << 8)).toString(16).slice(1);
    hex = hex + a;

    return "#" + hex;
}

function setSvgBackground(backgroundColor, opacity) {
    if (window.d3) {
        d3.selectAll("#dashboardStyle").remove();
    }
    if (opacity == 0 || opacity) {
        var rgb = hexToRgbNew(backgroundColor);
        var rgba = "rgba(" + rgb + "," + opacity + ")";
        backgroundColor = rgba2hex(rgba);
    }
    var styleTag = document.createElement("style");
    styleTag.id = "dashboardStyle";
    styleTag.innerHTML = "body, #my_dataviz svg, #yAxisDiv, #xAxisDiv{ background-color: " + backgroundColor + " }";
    document.head.append(styleTag);
}

function setXAxisTicksDistance(distanceValue = "1em") {
    d3.selectAll(".x-axis text").attr("dy", distanceValue);
}

function clearStyle() {
    if (!window.d3) {
        console.log("d3 not available skipping");
        return;
    }
    d3.selectAll("#xAxisDiv").attr("style", null);
    d3.selectAll("#xAxisLabelId").attr("style", null);
    d3.selectAll("#my_dataviz").attr("style", null);
    d3.selectAll("#mainChartWindow").attr("style", null);
    d3.selectAll("#legend").attr("style", null);
    console.log("clear");
}

function removeAxisTicks(axis = "xAxis", dataValues, range, options = {}) {
    selector = ".x-axis text";
    range = range ? range : dataValues.length;

    const { chartTitle } = options;

    if (axis === "yAxis") {
        selector = ".y-axis text";
    }

    var dataLabels = [];
    if (constants.chartTitles.waterfallChart == chartTitle) {
        dataLabels = document.querySelectorAll(".bar text");
    }

    // Remove Text in case they are large in number
    var allXAxisTexts = document.querySelectorAll(selector);
    range = allXAxisTexts.length;

    for (var i = 0; i < allXAxisTexts.length - 1; i++) {
        if (!Math.floor(range * 0.02)) {
            break;
        }

        if (i % Math.floor(range * 0.04) != 0) {
            allXAxisTexts[i].remove();
            if (constants.chartTitles.waterfallChart == chartTitle) {
                dataLabels[i].remove();
            }
            continue;
        }
    }
}

function createBatches(array, chunk_size) {
    return Array(Math.ceil(array.length / chunk_size))
        .fill()
        .map((_, index) => index * chunk_size)
        .map((begin) => array.slice(begin, begin + chunk_size));
}

function sortArraysOfObjectByValue(array, valueKey) {
    return array.sort(function (a, b) {
        return b[valueKey] - a[valueKey];
    });
}
function labelFormatSet(labelValue, labelFormat) {
    switch (labelFormat) {
        case "round":
            return Math.round(labelValue);
            break;
        case "comma":
            return Math.round(labelValue).toLocaleString("en-US");
            break;
        case "symbol":
            //  if (labelValue > 999 && labelValue < 1000000) {
            //      return (labelValue / 1000).toFixed(1) + "K"; // convert to K for number from > 1000 < 1 million
            //  } else if (labelValue > 1000000) {
            //      return (labelValue / 1000000).toFixed(1) + "M"; // convert to M for number from > 1 million
            //  } else if (labelValue < 900) {
            //      return labelValue; // if value < 1000, nothing to do
            //  }
            return d3.format(".3s")(labelValue);
            // return numeral(labelValue).format("0 a");
            break;
        case "currency":
            return numeral(labelValue).format("$0,0.00");
            break;
        case "percentage":
            return numeral(labelValue).format("0%");
            break;
        case "none":
            return labelValue;
            break;
        default:
            return Math.round(labelValue);
    }
}

// Main
// Open this function when in production
(function () {
    // [Tag: Mandatory]
    oncontextmenu = function () {
        // return false;
    };
})();

// ui fix functions
function setStandardTickWidths(barWidth = 40) {
    var a = document.querySelectorAll(".x-axis .tick text");

    for (var i = 0; i < a.length; i++) {
        var singleCharacterLength = a[i].getBBox().width / a[i].innerHTML.length;
        var numOfCharacters = Math.floor(barWidth / singleCharacterLength);

        var tick = a[i];

        var tickWidth = tick && tick.getBBox().width;
        if (tickWidth > barWidth) {
            // console.log("Length is long", numOfCharacters);
            var tickValue = tick.innerHTML;
            tickValue = tickValue && tickValue.substr(0, numOfCharacters - 3) + "...";
            // console.log(tickValue);
            tick.innerHTML = tickValue;
        }
    }
}
function setXaxisWidth() {
    var allYAxisTicks = document.querySelectorAll(".x-axis .tick text");
    var maxWidth = 0;
    for (var i = 0; i < allYAxisTicks.length; i++) {
        var tick = allYAxisTicks[i];
        var width = tick && tick.getBBox().width;
        if (width > maxWidth) {
            maxWidth = width;
        }
    }

    extraHeightWorked = true;
    maxWidth = maxWidth < 100 ? maxWidth : 100;
    if(window.innerHeight < 400){
        extraHeight = Math.min(maxWidth, window.innerHeight/8);
    }else{
        extraHeight = maxWidth;
    }

    d3.select(".x-axis").attr("text-anchor", "right");
    d3.selectAll(".x-axis text")
        .attr("transform", "rotate(-90)")
        .attr("dy", "0.3em")
        .attr("text-anchor", "end")
        // .attr("x", "-" + (maxWidth + 3))
        .attr("x", "-" + 10)
        // .attr("font-size", fontSize)
        .attr("y", "8");
}
function setYaxisWidth(margin) {
    var allYAxisTicks = document.querySelectorAll(".y-axis .tick");
    var maxWidth = 72;
    for (var i = 0; i < allYAxisTicks.length; i++) {
        var tick = allYAxisTicks[i];
        var width = tick && tick.getBBox().width + 25;
        if (width > maxWidth) {
            maxWidth = width;
        }
    }

    var yAxisDiv = document.querySelector("#yAxisDiv svg");

    yAxisDiv.setAttribute("width", maxWidth);
    yAxisDiv.setAttribute("transform", "translate(" + (maxWidth - margin.left) + "," + 0 + ")");
}
function make_x_gridlines(x) {
    return d3.axisBottom(x).ticks(8).tickSizeOuter(0);
}

function make_y_gridlines(y) {
    return d3.axisLeft(y).ticks(yaxisTicks);
}
// legend
function legendGenerate(legendStatus, legendPosition, yAxisWidth, width, margin, height, data) {
    if(!data){
        data = [window.data[1][0]];
    }
    var legendElement = document.querySelector("#legend");
    var legendHeight = legendElement.offsetHeight;
    var legendWidth = legendElement.offsetWidth;
    if (legendStatus) {
        d3.select("#legend").html("");

        d3.select("#legend")
            .append("p")
            .html(xAxisLabel + "&nbsp;")
            .style("font-weight", "bold")
            .style("margin", "auto")
            .style("position", "sticky");

        d3.select("#legend")
            .selectAll("div")
            .data(data)
            .enter()
            .append("div")
            .html((d, i) => {
                return (
                    '<div style="width: 15px; height: 15px; margin-top:2px; background: ' +
                    d3Colors[i % d3Colors.length] +
                    ';">  </div>' +
                    "<span style='margin-left: 5px; max-width: 160px'>" +
                    d +
                    "</span>"
                );
            })
            .style("display", "flex")
            .style("padding", "2px");
    }
    if (legendStatus) {
        if (legendHeight < document.querySelector("html").offsetHeight) {
            // topPosition = "calc(50vh - " + legendHeight / 2 + "px)";
            topPosition = "50%";
        } else {
            topPosition = 0;
        }
        rightPosition = "calc(50vw - " + legendWidth / 2 + "px)";

        //  var widthOld = (document.querySelector("#my_dataviz").clientWidth) ;
        var widthOld = document.querySelector("html").clientWidth - 72;
        var heightOld = document.querySelector("html").clientHeight;

        // legendElement.style.padding = "10px";
        legendElement.style.border = "1px solid black";

        switch (legendPosition) {
            case "left":
                d3.select("#legend")
                    .attr("style", null)
                    .style("top", topPosition)
                    .style("right", "auto")
                    // .style("bottom", "auto")
                    .style("left", "0px")
                    // .style("right", "5px")
                    .style("display", "block")
                    .style("max-height", "100vh")
                    .style("overflow", "auto")
                    .style("border", "none")
                    .style("transform", "translateY(-50%)")
                    .style("position", "fixed");
                d3.selectAll("#legend div span")
                    .style("max-width", "160px")
                    .style("white-space", "nowrap")
                    .style("overflow", "hidden")
                    .style("text-overflow", "ellipsis");

                var legendWidth = legendElement.offsetWidth;
                // margin.left += 100;
                // width -= 100;
                // d3.select("#my_dataviz svg").attr("width", width + margin.left + margin.right);

                d3.select("#mainChartWindow").attr("style", null);

                d3.select("#mainChartWindow").style("width", widthOld - legendWidth + yAxisWidth);
                d3.select("#mainChartWindow").style("margin-left", legendWidth + "px");
                d3.select("#xAxisLabelId").style("bottom", 20);

                break;
            case "top":
                d3.select("#mainChartWindow").attr("style", null);
                margin.top += 50;
                height -= 50;
                y_pos_x_label = 57;
                d3.select("#legend")
                    .attr("style", null)
                    .style("top", "10px")
                    .style("right", rightPosition)
                    .style("bottom", "auto")
                    .style("left", "auto")
                    .style("display", "flex")
                    .style("max-width", "99vw")
                    .style("overflow", "auto")
                    .style("border", "none");
                d3.selectAll("#legend div span")
                    .style("max-width", "160px")
                    .style("white-space", "nowrap")
                    .style("overflow", "hidden")
                    .style("text-overflow", "ellipsis");
                d3.select("#xAxisLabelId").style("bottom", 20);

                // d3.selectAll("#legend div").style(
                //     "padding",
                //     "2px 4px"
                // );
                break;
            case "bottom":
                height -= 50; // use legend client height
                margin.bottom += 10;
                var legendWidth = legendElement.offsetWidth;
                y_pos_x_label = 20;

                d3.select("#xAxisLabelId").style("bottom", "60px");
                d3.select("#mainChartWindow").attr("style", null);

                // d3.select("#mainChartWindow").style("width", width);
                //  d3.select("#mainChartWindow").style("height",heightOld-80 );
                d3.select("#mainChartWindow").style("margin-left", 0);
                d3.select("#legend")
                    .attr("style", null)
                    .style("top", "auto")
                    .style("right", rightPosition)
                    .style("bottom", "0px")
                    // .style("left", margin.left + "px")
                    .style("display", "flex")
                    .style("max-width", "99vw")
                    .style("overflow", "auto")
                    .style("border", "none");

                d3.selectAll("#legend div span")
                    .style("max-width", "160px")
                    .style("white-space", "nowrap")
                    .style("overflow", "hidden")
                    .style("text-overflow", "ellipsis");
                break;
            // For Right Legened
            case "right":
            default:
                // width -= 220;
                // d3.select("#my_dataviz").style("width", width + margin.left + margin.right);
                var legendWidth = legendElement.offsetWidth;

                d3.select("#legend")
                    .attr("style", null)
                    .style("right", "0px")
                    .style("left", "auto")
                    .style("position", "fixed")
                    .style("top", topPosition)
                    .style("max-height", "100vh")
                    .style("transform", "translateY(-50%)")
                    .style("overflow", "auto")
                    .style("border", "none")
                    .style("bottom", "auto")
                    .style("display", "block");
                d3.selectAll("#legend div span")
                    .style("max-width", "160px")
                    .style("white-space", "nowrap")
                    .style("overflow", "hidden")
                    .style("text-overflow", "ellipsis");

                d3.select("#mainChartWindow").attr("style", null);
                d3.select("#mainChartWindow").style("width", widthOld - legendWidth + yAxisWidth - 10);
                d3.select("#mainChartWindow").style("margin-left", 0);
                d3.select("#xAxisLabelId").style("bottom", 20);
        }
    }
}

// tooltip
function tooltipGenerate(xpos, ypos, xValue, yValue, legendHeightTop, d, toolTip, legendWidthLeft) {
    d3.select("#tooltip")
        // .style("left", xpos + "px")
        // .style("left", xpos -500+ "px")
        .style("top", ypos - 22 + legendHeightTop + "px")
        .style("display", "block")
        // .text(dataset[i]);
        .html(function () {
            var textValue = d.y0 - d.y1;
            if (d.y1 < 0) {
                textValue = d.y1 - d.y0;
            }

            return (
                "<div class='arrowTooltip'></div>" +
                "<span style='color:grey;''>" +
                toolTip.textColumn1 +
                ":&nbsp;&nbsp;" +
                "</span>" +
                "<span style='float: right;'>" +
                xValue +
                "</span>" +
                "<br/> <br/>" +
                "<span style='color:grey;''>" +
                toolTip.textColumn2 +
                ":" +
                "</span>" +
                "<span style='float: right;margin-left: 15px;'>" +
                Math.round(yValue) +
                "</span>"
            );
        });
    var scrollVal = document.querySelector("#my_dataviz").scrollLeft;

    if (xpos - scrollVal > document.documentElement.clientWidth - document.querySelector("#tooltip").clientWidth) {
        d3.select("#tooltip").style(
            "left",
            xpos - scrollVal - document.querySelector("#tooltip").clientWidth - 10 + legendWidthLeft + "px"
        );

        d3.select(".arrowTooltip")
            //  document.querySelector("#tooltip:before")
            // .style("height","50px";"width","50px";"background-color","red";")

            .attr(
                "style",
                "border: solid; border-color: white transparent; border-width: 12px 6px 0 6px; content: '';right: -12px; transform: rotate(-90deg)!important;bottom: 22px; position: absolute;"
            );
    } else {
        d3.select("#tooltip").style("left", xpos - scrollVal + 12 + legendWidthLeft + "px");

        d3.select(".arrowTooltip").attr(
            "style",
            "border: solid; border-color: white transparent; border-width: 12px 6px 0 6px; content: '';left: -12px; transform: rotate(90deg)!important;bottom: 22px; position: absolute;"
        );
    }
}

// ticks customisation
function XAxisTicksConfig(xTickfontSize, xTickfontFamily, xboldTick, xitalicTick, xTickfontColor) {
    d3.selectAll(".x-axis text")
        .attr("font-size", xTickfontSize)
        .attr("font-family", xTickfontFamily)
        .attr("font-weight", xboldTick ? "bold" : "regular")
        .attr("font-style", xitalicTick ? "italic" : "regular")
        .attr("fill", xTickfontColor)
        .attr("y", 6);
}
function YAxisTicksConfig(yTickfontSize, yTickfontFamily, yboldTick, yitalicTick, yTickfontColor) {
    d3.selectAll(".y-axis text")
        .attr("font-size", yTickfontSize)
        .attr("font-family", yTickfontFamily)
        .attr("font-weight", yboldTick ? "bold" : "regular")
        .attr("font-style", yitalicTick ? "italic" : "regular")
        .attr("fill", yTickfontColor);
}
// data label
function dataLabel(svg, xAxis, yScale, dataset, labelFormat) {
    svg.append("g")
        .call(xAxis.tickSize(0))
        .attr("class", "axis label")
        // .attr("font-family", xDataLabelfontFamily)
        .attr("font-family", dataLabelfontFamily)
        .attr("font-size", dataLabelfontSize);

    // .attr("transform", "translate(0,0)");
    var labelSelector = document.querySelectorAll(".axis.label text");

    d3.select(".axis.label path").remove();

    labelSelector.forEach((label, i) => {
        var labelValue = label.textContent;

        var labelYPosition = yScale(data[0][1][i]);

        label.setAttribute("y", labelYPosition - 12);
        label.setAttribute("fill", dataLabelColor);
        label.textContent = labelFormatSet(dataset[i], labelFormat);
        var dataLabelLimit = height - window.innerHeight / 8;
        // if(window.innerWidth < 600 || window.innerHeight < 300){
        //     dataLabelLimit = 20;
        // }

        label.setAttribute("display", labelYPosition > dataLabelLimit ? "none" : "");
    });
}
function dataLabelLineChart(svg, xAxis, yScale, dataset, labelFormat) {
    svg.append("g")
        .call(xAxis.tickSize(0))
        .attr("class", "axis label")
        // .attr("font-family", xDataLabelfontFamily)
        .attr("font-family", dataLabelfontFamily)
        .attr("font-size", dataLabelfontSize);

    // .attr("transform", "translate(0,0)");
    var labelSelector = document.querySelectorAll(".axis.label text");

    d3.select(".axis.label path").remove();

    labelSelector.forEach((label, i) => {
        var labelValue = label.textContent;

        var labelYPosition = yScale(dataset[i][1]);

        label.setAttribute("y", labelYPosition + 13);
        label.setAttribute("fill", dataLabelColor);
        label.textContent = labelFormatSet(dataset[i][1], labelFormat);
        var dataLabelLimit = height - window.innerHeight / 8;
        // if(window.innerWidth < 600 || window.innerHeight < 300){
        //     dataLabelLimit = 20;
        // }

        label.setAttribute("display", labelYPosition > dataLabelLimit ? "none" : "");
    });
}

function removeOverlappingValues() {
    var labels = document.querySelectorAll(".label .tick text");
    var lastTickShown = labels[0];
    labels.forEach((label, i) => {
        if (!i) return;
        if (isElementsOverlapping(label, lastTickShown)) {
            label.remove();
        } else {
            lastTickShown = label;
        }
    });
}

function removeDataLabels() {
    // removeOverlappingValues();
    removeDataLabelsByDistance();
}

function removeDataLabelsByDistance() {
    var labels = document.querySelectorAll(".label .tick text");
    var lastTickShown = labels[0];
    var lastTickShown1 = null;
    var lastTickShown2 = null;
    labels.forEach((label, i) => {
        if (!i) return;
        if (
            getDistanceBetweenElements(label, lastTickShown) < 40 ||
            (lastTickShown1 && getDistanceBetweenElements(label, lastTickShown1) < 40) ||
            (lastTickShown2 && getDistanceBetweenElements(label, lastTickShown2) < 40)
        ) {
            label.remove();
        } else {
            lastTickShown2 = lastTickShown1;
            lastTickShown1 = lastTickShown;
            lastTickShown = label;
        }
    });
}

const getDistance = (x1, x2, y1, y2) => {
    return Math.sqrt(Math.pow(x1 - x2, 2) + Math.pow(y1 - y2, 2));
};

const getDistanceBetweenElements = (rect1, rect2) => {
    rect1 = rect1.getClientRects()[0];
    rect2 = rect2.getClientRects()[0];
    let { x: x1, y: y1, width: width1, height: height1 } = rect1;
    x1 = x1 + width1 / 2;
    y1 = y1 + height1 / 2;

    let { x: x2, y: y2, width: width2, height: height2 } = rect2;
    x2 = x2 + width2 / 2;
    y2 = y2 + height2 / 2;

    const distanceValue = getDistance(x1, x2, y1, y2);
    return distanceValue;
};

const isElementsOverlapping = (rect1, rect2) => {
    rect1 = rect1.getClientRects()[0];
    rect2 = rect2.getClientRects()[0];
    return !(
        rect1.right < rect2.left ||
        rect1.left > rect2.right ||
        rect1.bottom < rect2.top ||
        rect1.top > rect2.bottom
    );
};
