function getSavedAxisColumnNames(axisName) {
    var model = null;
    const reportProperties = ReportParamsModel.getReport(reportId);
    switch (axisName) {
        case Constants.xAxisName:
            var xAxisListModel = JSON.parse(reportProperties.d3PropertiesConfig)
                .dataColumns.xAxisColumnDetails;
            model = xAxisListModel;
            break;
        case Constants.yAxisName:
            var yAxisListModel = JSON.parse(reportProperties.d3PropertiesConfig)
                .dataColumns.yAxisColumnDetails;
            model = yAxisListModel;
            break;
        case Constants.row3Name:
            model = JSON.parse(reportProperties.d3PropertiesConfig).dataColumns
                .row3ColumnDetails;
            break;
    }
    if (!model) {
        return [];
    }
    var columnsName = [];
    for (var i = 0; i < model.length; i++) {
        columnsName.push(model[i].tableValue);
    }
    return columnsName;
}

function isGaugeChart() {
    var row3Columns = getAxisColumnNames(Constants.row3Name);
    if (
        row3Columns.length &&
        isNumber(input1Field.text) &&
        isNumber(input2Field.text) &&
        isNumber(input3Field.text)
    ) {
        return true;
    }
    return false;
}

function isPivotChart() {
    var xAxisColumns = getAxisColumnNames(Constants.xAxisName);
    var yAxisColumns = getAxisColumnNames(Constants.yAxisName);
    var row3Columns = getAxisColumnNames(Constants.row3Name);
    if (
        row3Columns.length &&
        (xAxisColumns.length > 0 || yAxisColumns.length > 0)
    ) {
        console.log("Pivot is eliigble");
        return true;
    }
    return false;
}

function isKpiValid() {
    var xAxisColumnDetails = getDataPaneAllDetails(Constants.xAxisName);
    if (
        xAxisColumnDetails.length &&
        xAxisColumnDetails[0].itemType.toLowerCase() == "numerical"
    ) {
        return true;
    }
    return false;
}

// TODO: Refactor this function
function drawChart() {
    var xAxisColumnDetails = getDataPaneAllDetails(Constants.xAxisName);
    var yAxisColumnDetails = getDataPaneAllDetails(Constants.yAxisName);
    var row3ColumnDetails = getDataPaneAllDetails(Constants.row3Name);

    // If WebEngine is loading => Return
    // TODO - Check if we need to call it recursively? Or this is being called from loadRequest handler
    if (ChartsWebViewHandler.isWebEngineLoading()) {
        return;
    }

    ChartsWebViewHandler.clearChartValue();

    d3PropertyConfig.yAxisConfig = d3PropertyConfig.yAxisConfig || {};
    d3PropertyConfig.yAxisConfig.yaxisStatus = !!yAxisLabelStatus;

    d3PropertyConfig.xAxisConfig = d3PropertyConfig.xAxisConfig || {};
    d3PropertyConfig.xAxisConfig.xaxisStatus = !!xAxisLabelStatus;

    if (
        (xAxisColumnDetails.length && yAxisColumnDetails.length) ||
        (xAxisColumnDetails.length &&
            (chartTitle == Constants.tableTitle ||
                chartTitle == Constants.kpiTitle)) ||
        (chartTitle == Constants.gaugeChartTitle && isGaugeChart()) || // Condition for Gauge Chart
        (chartTitle == Constants.pivotTitle && isPivotChart()) // Condition for Pivot Chart
    ) {
        console.log("Chart Title - Draw Chart Function - ", chartTitle);
        if (colorByData.length) {
            colorByData[0].itemName =
                colorByData[0] && colorByData[0].columnName;
        }

        const chartsObject = {
            xAxisObject: xAxisColumnDetails,
            yAxisObject: yAxisColumnDetails,
            row3AxisObject: row3ColumnDetails,
            colorByObject: colorByData,
        };

        if (chartTitle == Constants.gaugeChartTitle) {
            var greenValue = input1Field.text;
            var yellowValue = input2Field.text;
            var redValue = input3Field.text;
            optionalParams[chartTitle] = {
                greenValue,
                yellowValue,
                redValue,
            };
            chartsObject.optionalParams = optionalParams;
        }

        if (chartTitle == Constants.pivotTitle) {
            var tempDataValues = [...xAxisColumnDetails, ...yAxisColumnDetails];

            var xAxisColumns = getAxisColumnNames(Constants.xAxisName);
            var yAxisColumns = getAxisColumnNames(Constants.yAxisName);
            var row3Columns = getAxisColumnNames(Constants.row3Name);

            var xAxisColumnNamesArray = Array.from(xAxisColumns);
            var yAxisColumnNamesArray = Array.from(yAxisColumns);
            var row3ColumnsArray = Array.from(row3Columns);

            var categoricalValues = [
                ...xAxisColumnNamesArray,
                ...yAxisColumnNamesArray,
            ];

            var measuresArray = Array.from(row3Columns);

            console.log(tempDataValues);

            var dateConversionOptions = tempDataValues
                .filter((d) => {
                    if (d.itemType.toLowerCase() == "date") {
                        return true;
                    }
                    return false;
                })
                .map((d) => {
                    var format = d.dateFormat;
                    switch (format) {
                        case "%Y":
                            format = "Year";
                            break;
                        case "%d":
                            format = "Day";
                            break;
                        case "%b":
                            format = "month";
                            break;
                        case "%d %b %Y":
                            format = "day,month,year";
                            break;
                        case "%b %Y":
                            format = "month,year";
                            break;
                        default:
                            format = "Year";
                            break;
                    }
                    return {
                        itemName: d.itemName,
                        itemType: d.itemType,
                        dateFormat: format,
                        separator: " ",
                    };
                });

            optionalParams[chartTitle] = {
                dateConversionOptions: JSON.stringify(dateConversionOptions),
                categoricalValues,
                measuresArray,
                row3Columns: [
                    xAxisColumnNamesArray,
                    yAxisColumnNamesArray,
                    row3ColumnsArray,
                ],
            };
            chartsObject.optionalParams = optionalParams;
            chartsObject.xAxisObject = tempDataValues;

            console.log("Charts Object - pivot", JSON.stringify(chartsObject));
        }

        if (chartTitle == Constants.tableTitle) {
            var nonMeasures = xAxisColumnDetails
                .filter((d) => {
                    if (d.itemType.toLowerCase() != "numerical") {
                        return true;
                    }
                    return false;
                })
                .map((d) => d.itemName);
            var measures = xAxisColumnDetails
                .filter((d) => {
                    if (d.itemType.toLowerCase() == "numerical") {
                        return true;
                    }
                    return false;
                })
                .map((d) => d.itemName);
            var dateConversionOptions = xAxisColumnDetails
                .filter((d) => {
                    if (d.itemType.toLowerCase() == "date") {
                        return true;
                    }
                    return false;
                })
                .map((d) => {
                    var format = d.dateFormat;
                    switch (format) {
                        case "%Y":
                            format = "Year";
                            break;
                        case "%d":
                            format = "Day";
                            break;
                        case "%b":
                            format = "month";
                            break;
                        case "%d %b %Y":
                            format = "day,month,year";
                            break;
                        case "%b %Y":
                            format = "month,year";
                            break;
                        default:
                            format = "Year";
                            break;
                    }
                    return {
                        itemName: d.itemName,
                        itemType: d.itemType,
                        dateFormat: format,
                        separator: " ",
                    };
                });

            optionalParams[chartTitle] = {
                measures,
                nonMeasures,
                dateConversionOptions: JSON.stringify(dateConversionOptions),
            };
            chartsObject.optionalParams = optionalParams;
        }

        ChartsModel.getChartWiseData(
            reportIdMain,
            0,
            Constants.reportScreen,
            chartTitle,
            chartsObject
        );

        return;
    }

    ChartsWebViewHandler.clearChartValue();
}

function checkHorizontalGraph() {
    if (!horizontalChartList.includes(chartTitle)) {
        console.log("Chart does not have horizontal title... returning");
        return;
    }
    var xAxisType =
        xAxisListModel.count &&
        xAxisListModel.get(0).droppedItemType.toLowerCase();
    var yAxisType =
        yAxisListModel.count &&
        yAxisListModel.get(0).droppedItemType.toLowerCase();

    console.log("Debug::", xAxisType, yAxisType);

    if (
        xAxisType == "numerical" ||
        yAxisType == "date" ||
        yAxisType == "categorical"
    ) {
        console.log("Debug:: Graph is horizontal", isHorizontalGraph);
        isHorizontalGraph = true;
    } else if (
        yAxisType == "numerical" ||
        xAxisType == "date" ||
        xAxisType == "categorical"
    ) {
        console.log("Debug:: Graph is not horizontal");
        isHorizontalGraph = false;
    }
}

// Clear the chart defaults
function clearChartValue() {
    webEngineView.runJavaScript(
        "window.grafieks && window.grafieks.utils.clearChart();" +
            "if(window.grafieks && grafieks.dataUtils && grafieks.dataUtils.rawData){ grafieks.dataUtils.rawData = [] }"
    );
}

// TODO: Refactor this function
function reDrawChart() {
    // Check if the chart is horizontal
    // set isHorizontalGraph true
    clearChartValue();
    checkHorizontalGraph();

    var xAxisColumns = getAxisColumnNames(Constants.xAxisName);
    var yAxisColumns = getAxisColumnNames(Constants.yAxisName);
    var row3Columns = getAxisColumnNames(Constants.row3Name);

    if (chartTitle == Constants.gaugeChartTitle && isGaugeChart()) {
        drawChart();
        return;
    }

    if (chartTitle == Constants.pivotTitle) {
        if (isPivotChart()) {
            drawChart();
        }
        return;
    }

    if (chartTitle == Constants.tableTitle) {
        if (xAxisColumns.length > 0) {
            drawChart();
        }
        return;
    }

    if (chartTitle == Constants.kpiTitle) {
        if (xAxisColumns.length > 0 && isKpiValid()) {
            drawChart();
        }
        return;
    }

    // Check graph type for redrawing
    // If length = 1 and type of chart is
    // 1. Grouped Bar Chart and no Colour By is there => Bar chart
    // 2. Grouped Bar Chart and Colour By Present => Stacked Bar Chart

    if (xAxisColumns.length === 1 && yAxisColumns.length === 1) {
        // Condition for horizontal bar graph;
        if (isHorizontalGraph) {
            allowedXAxisDataPanes = 1;
            allowedYAxisDataPanes = 2;

            switch (chartTitle) {
                case Constants.barChartTitle:
                    if (colorByData.length) {
                        switchChart(Constants.horizontalStackedBarChartTitle);
                        break;
                    }
                    // chartUrl = Constants.horizontalBarChartUrl;
                    // webEngineView.url = Constants.baseChartUrl + chartUrl;
                    chartTitle = Constants.horizontalBarChartTitle;
                    break;
                case Constants.lineChartTitle:
                    console.log(Constants.lineChartTitle);
                    if (colorByData.length) {
                        console.log("Changeing to Horizontal Multi Line");
                        switchChart(Constants.horizontalMultiLineChartTitle);
                        break;
                    }
                    switchChart(Constants.horizontalLineChartTitle);
                    break;
                case Constants.areaChartTitle:
                    console.log(Constants.areaChartTitle);
                    if (colorByData.length) {
                        console.log("Changeing to Horizontal Stack Area");
                        switchChart(Constants.multipleHorizontalAreaChartTitle);
                        break;
                    }
                    switchChart(Constants.horizontalAreaChartTitle);
                    break;
                case Constants.horizontalBarGroupedChartTitle:
                    if (colorByData.length) {
                        switchChart(Constants.horizontalStackedBarChartTitle);
                        break;
                    }
                    switchChart(Constants.horizontalBarChartTitle);
                    break;
                case Constants.horizontalMultiLineChartTitle:
                    if (colorByData.length) {
                        break;
                    }
                    switchChart(Constants.horizontalLineChartTitle);
                    break;
                case Constants.horizontalAreaChartTitle:
                    if (colorByData.length) {
                        switchChart(Constants.multipleHorizontalAreaChartTitle);
                        break;
                    }
                    break;
                case Constants.multipleHorizontalAreaChartTitle:
                    if (colorByData.length) {
                        break;
                    }
                    switchChart(Constants.horizontalAreaChartTitle);
                    break;
                default:
                    console.log(
                        "Debug:",
                        "Horizontal Graph Missed condition",
                        chartTitle
                    );
            }
        } else {
            if (chartTitle === Constants.barChartTitle && colorByData.length) {
                console.log("Change to stacked bar chart");
                switchChart(Constants.stackedBarChartTitle);
            } else if (
                chartTitle === Constants.groupBarChartTitle &&
                !colorByData.length
            ) {
                console.log(
                    "Redraw Function - Check which graph to be plotted here"
                );
                // chartUrl = Constants.barChartUrl;
                // webEngineView.url = Constants.baseChartUrl + chartUrl;
                chartTitle = Constants.barChartTitle;
            } else if (
                chartTitle === Constants.groupBarChartTitle &&
                colorByData.length
            ) {
                switchChart(Constants.stackedBarChartTitle);
            } else if (
                chartTitle === Constants.areaChartTitle &&
                colorByData.length
            ) {
                switchChart(Constants.multipleAreaChartTitle);
            } else if (
                chartTitle === Constants.lineChartTitle &&
                colorByData.length
            ) {
                switchChart(Constants.multiLineChartTitle);
            } else if (
                chartTitle === Constants.multipleAreaChartTitle &&
                !colorByData.length
            ) {
                switchChart(Constants.areaChartTitle);
            }
        }
    }

    drawChart();
}

function drawChartAfterReceivingSignal(dataValues) {
    if (webEngineView.loading) {
        return;
    }
    lastDataValues = dataValues;

    var xAxisColumnDetails = getDataPaneAllDetails(Constants.xAxisName);
    var yAxisColumnDetails = getDataPaneAllDetails(Constants.yAxisName);
    var row3ColumnDetails = getDataPaneAllDetails(Constants.row3Name);

    d3PropertyConfig["dataColumns"] = {
        xAxisColumnDetails,
        yAxisColumnDetails,
        row3ColumnDetails,
        colorByData,
    };

    d3PropertyConfig.chartName = chartTitle;
    console.log("Data Received, Sent for drawing", dataValues);
    ChartsWebViewHandler.startPlottingChart(dataValues, d3PropertyConfig);
}
