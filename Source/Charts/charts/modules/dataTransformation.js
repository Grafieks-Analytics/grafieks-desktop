const d3 = require("d3");
const CONSTANTS = require("../constants");
const { isHorizontalGraph, getDateFormattedData } = require("../utils");

const isDateFormat = (itemType) => {
    if (itemType === "Date") {
        return true;
    }
    return false;
};

function sortByMonth(arr, dateFormat) {
    var months = [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December"
    ];
    var shortMonths = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

    if (dateFormat == "%b") {
        months = shortMonths;
    }

    return arr.sort(function (a, b) {
        return months.indexOf(a) - months.indexOf(b);
    });
}

const sortDates = (datesArray, dateFormat) => {
    if (dateFormat == "%b" || dateFormat == "%B") {
        return sortByMonth(datesArray, dateFormat);
    }
    datesArray.sort(function (a, b) {
        if (dateFormat == "%d") {
            // Setting date value in accending order
            return +a - +b;
        }
        // Turn your strings into dates, and then subtract them
        // to get a value that is either negative, positive, or zero.
        return new Date(a) - new Date(b);
    });
    return datesArray;
};

const transformData = () => {
    const grafieks = window.grafieks;
    const { chartName, dataColumns: { xAxisColumnDetails = [], yAxisColumnDetails = [] } = {} } =
        grafieks.plotConfiguration;

    grafieks.flags.isDataTransformed = true;

    const data = grafieks.dataUtils.rawData;
    const [dataValues] = data;

    let transformedData, timeFormat, dates, xAxisData, yAxisData;
    let newDataSet = {};
    let dateFormat = "%Y";
    let sortedDates = [];

    switch (chartName) {
        case CONSTANTS.HORIZONTAL_BAR_CHART:
        case CONSTANTS.BAR_CHART:
            let itemType = xAxisColumnDetails[0].itemType;
            dateFormat = xAxisColumnDetails[0].dateFormat;

            if (isHorizontalGraph()) {
                itemType = yAxisColumnDetails[0].itemType;
                dateFormat = yAxisColumnDetails[0].dateFormat;
            }
            if (!isDateFormat(itemType)) {
                return;
            }

            timeFormat = d3.timeFormat(dateFormat);

            [xAxisData, yAxisData] = dataValues || [];
            xAxisData.forEach((d, i) => {
                const dateValue = timeFormat(new Date(d));
                if (!newDataSet[dateValue]) {
                    newDataSet[dateValue] = 0;
                }
                newDataSet[dateValue] += yAxisData[i];
            });

            dates = Object.keys(newDataSet);
            sortedDates = sortDates(dates, dateFormat);

            const values = sortedDates.map((d) => newDataSet[d]);

            transformedData = [sortedDates, values];

            grafieks.dataUtils.rawData[0] = transformedData;
            return;

        case CONSTANTS.LINE_CHART:
        case CONSTANTS.AREA_CHART:
        case CONSTANTS.WATERFALL_CHART:
            if (!isDateFormat(xAxisColumnDetails[0].itemType)) {
                return;
            }

            dateFormat = xAxisColumnDetails[0].dateFormat;
            timeFormat = d3.timeFormat(dateFormat);

            xAxisData = dataValues.map((d) => d[0]);
            yAxisData = dataValues.map((d) => d[1]);

            xAxisData.forEach((d, i) => {
                const dateValue = timeFormat(new Date(d));
                if (!newDataSet[dateValue]) {
                    newDataSet[dateValue] = 0;
                }
                newDataSet[dateValue] += yAxisData[i];
            });

            dates = Object.keys(newDataSet);
            sortedDates = sortDates(dates, dateFormat);

            transformedData = sortedDates.map((d) => [d, newDataSet[d]]);

            grafieks.dataUtils.rawData[0] = transformedData;

            return;
        case CONSTANTS.FUNNEL_CHART:
            if (!isDateFormat(xAxisColumnDetails[0].itemType)) {
                return;
            }
            dateFormat = xAxisColumnDetails[0].dateFormat;
            timeFormat = d3.timeFormat(dateFormat);

            xAxisData = dataValues.map((d) => d.label || d.key);
            yAxisData = dataValues.map((d) => d.value);

            xAxisData.forEach((d, i) => {
                const dateValue = timeFormat(new Date(d));
                if (!newDataSet[dateValue]) {
                    newDataSet[dateValue] = 0;
                }
                newDataSet[dateValue] += yAxisData[i];
            });

            dates = Object.keys(newDataSet);
            sortedDates = sortDates(dates, dateFormat);

            transformedData = sortedDates.map((key) => {
                return { label: key, value: newDataSet[key] };
            });

            grafieks.dataUtils.rawData[0] = transformedData;
            return;
        case CONSTANTS.PIE_CHART:
            if (!isDateFormat(xAxisColumnDetails[0].itemType)) {
                return;
            }
            dateFormat = xAxisColumnDetails[0].dateFormat;
            timeFormat = d3.timeFormat(dateFormat);

            const json = {};
            const uniqueKey = [];
            Object.keys(dataValues).forEach((d) => {
                const key = getDateFormattedData(d, dateFormat);
                if (!uniqueKey.includes(key)) {
                    uniqueKey.push(key);
                }

                if (!json[key]) {
                    json[key] = 0;
                }

                json[key] += dataValues[d];
            });

            transformedData = {};
            Object.keys(json).forEach((d) => {
                if (json[d] < 0) {
                    return;
                }
                transformedData[d] = json[d];
            });

            grafieks.dataUtils.rawData[0] = transformedData;
            return;
        default:
            return;
    }
};

module.exports = {
    transformData,
    sortDates
};
