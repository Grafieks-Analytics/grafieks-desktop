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

function isInMonth(value) {
    var shortMonths = [
        "jan",
        "feb",
        "mar",
        "apr",
        "may",
        "jun",
        "jul",
        "aug",
        "sept",
        "oct",
        "nov",
        "dec",
    ];
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
        "december",
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

function changeLabelPostionsAttributes(
    selectorTick,
    selectorLabel,
    attributeName
) {
    var value = getAttributesValues(selectorTick);
    var isFirstInitialValueSet = window["initialLabelPosition" + attributeName];
    if (!isFirstInitialValueSet) {
        window["initialLabelPosition" + attributeName] = d3
            .selectAll(selectorLabel)
            .attr(attributeName);

        window.isFirstInitialValueSet = true;
    }

    console.log(
        "window['initialLabelPosition' + attributeName]" +
            window["initialLabelPosition" + attributeName]
    );

    if (selectorLabel == ".y_label") {
        d3.selectAll(selectorLabel).attr(
            attributeName,
            +window["initialLabelPosition" + attributeName] - +value
        );
    } else if (selectorLabel == ".x_label") {
        d3.selectAll(selectorLabel).attr(
            attributeName,
            +window["initialLabelPosition" + attributeName] + +value
        );
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
    console.log(value);
    return value;
}

function setText(selector, textValue) {
    d3.selectAll(selector).text(textValue);
}

function setLabel(
    label = "xLabel",
    labelType = "x_label",
    x_tick_fontSize,
    y_tick_fontSize
) {
    console.log("x" + x_tick_fontSize);
    console.log("y" + y_tick_fontSize);
    svg = d3.select("svg");

    const margin = { top: 30, right: 30, bottom: 70, left: 60 },
        width = window.innerWidth - margin.left - margin.right - 10,
        height = window.innerHeight - margin.top - margin.bottom - 10;

    if (labelType == "x_label") {
        svg.append("text")
            .attr("class", labelType)
            .attr("text-anchor", "end")
            .text(label)
            .attr("x", width / 2 + 150)
            .attr("y", height + 60)
            .attr("class", labelType);
    } else {
        svg.append("text")
            .attr("class", labelType)
            .attr("text-anchor", "end")
            .text(label)
            .attr("y", 6)
            .attr("x", -height / 2)
            .attr("dy", ".75em")
            .attr("transform", "rotate(-90)");
    }
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
        if (dateFormat == "%m" || dateFormat == "%d") {
            dates = dates.reverse();
        }
    }

    return dates;
}

function clearChart() {
    d3.selectAll("#my_dataviz").html("");
    d3.selectAll("#yAxisDiv").html("");
    d3.selectAll("#xAxisDiv").html("");

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
        rgb = orig
            .replace(/\s/g, "")
            .match(/^rgba?\((\d+),(\d+),(\d+),?([^,\s)]+)?/i),
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
    d3.selectAll("#dashboardStyle").remove();
    if (opacity == 0 || opacity) {
        var rgb = hexToRgbNew(backgroundColor);
        var rgba = "rgba(" + rgb + "," + opacity + ")";
        console.log({ rgba });
        backgroundColor = rgba2hex(rgba);
    }
    var styleTag = document.createElement("style");
    styleTag.id = "dashboardStyle";
    styleTag.innerHTML =
        "#my_dataviz svg, #yAxisDiv, #xAxisDiv{ background-color: " +
        backgroundColor +
        " }";
    document.head.append(styleTag);
}
