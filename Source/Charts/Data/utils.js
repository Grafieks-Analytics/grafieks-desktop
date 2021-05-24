function isDateFormat(date) {
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

function sortDates(dateDataset, dateFormat) {
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
    // dates = newDataSet.sort();
    // console.log(newDataSet);
    // console.log(dates);
    dates = dates.map((d) => {
        return d3.timeFormat(dateFormat)(new Date(d));
    });

    if (
        dateFormat == "%b" ||
        dateFormat == "%m" ||
        dateFormat == "%B" ||
        dateFormat == "%d"
    ) {
        dates = dates.reverse();
    }
    console.log(dates);
    return dates;
}

function clearChart() {
    d3.selectAll("#my_dataviz").html("");
    d3.selectAll("#yAxisDiv").html("");
    d3.selectAll("#xAxisDiv").html("");
}
