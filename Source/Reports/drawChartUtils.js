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
        xAxisColumns.length > 0 ||
        yAxisColumns.length > 0 ||
        (xAxisColumns.length > 0 && row3Columns.length > 0) ||
        (yAxisColumns.length > 0 && row3Columns.length > 0)
    ) {
        console.log("Pivot is eliigble");
        return true;
    }
    return false;
}

// TODO: Refactor this function
function drawChart() {
    var xAxisColumns = getAxisColumnNames(Constants.xAxisName);
    var yAxisColumns = getAxisColumnNames(Constants.yAxisName);
    var row3Columns = getAxisColumnNames(Constants.row3Name);

    var xAxisColumnDetails = getDataPaneAllDetails(Constants.xAxisName);
    var yAxisColumnDetails = getDataPaneAllDetails(Constants.yAxisName);
    var row3ColumnDetails = getDataPaneAllDetails(Constants.row3Name);

    // If WebEngine is loading => Return
    // [TODO] - Check if we need to call it recursively? Or this is being called from loadRequest handler
    if (ChartsWebViewHandler.isWebEngineLoading()) {
        return;
    }

    d3PropertyConfig.yAxisConfig = d3PropertyConfig.yAxisConfig || {};
    d3PropertyConfig.yAxisConfig.yaxisStatus = !!yAxisLabelStatus;

    d3PropertyConfig.xAxisConfig = d3PropertyConfig.xAxisConfig || {};
    d3PropertyConfig.xAxisConfig.xaxisStatus = !!xAxisLabelStatus;

    if (
        (xAxisColumns.length && yAxisColumns.length) ||
        (xAxisColumns.length &&
            (chartTitle == Constants.tableTitle ||
                chartTitle == Constants.kpiTitle)) ||
        (chartTitle == Constants.gaugeChartTitle && isGaugeChart()) || // Condition for Gauge Chart
        (chartTitle == Constants.pivotTitle && isPivotChart()) // Condition for Pivot Chart
    ) {
        var xAxisColumnNamesArray = Array.from(xAxisColumns);
        var yAxisColumnNamesArray = Array.from(yAxisColumns);

        console.log("Chart Title - Draw Chart Function - ", chartTitle);
        var colorByColumnName = colorByData[0] && colorByData[0].columnName;

        // TODO: To scale (When adding more charts)
        // Make sure to pass the values as keys in options and key-values pair
        // Can a single function

        switch (chartTitle) {
            case Constants.horizontalBarChartTitle:
                console.log("Horizontal BAR");
                ChartsModel.getBarChartValues(
                    reportIdMain,
                    0,
                    Constants.reportScreen,
                    yAxisColumns[0],
                    xAxisColumns[0]
                );
                break;
            case Constants.barChartTitle:
                console.log("BAR CLICKED", xAxisColumns[0]);
                ChartsModel.getBarChartValues(
                    reportIdMain,
                    0,
                    Constants.reportScreen,
                    xAxisColumns[0],
                    yAxisColumns[0]
                );
                break;
            case Constants.horizontalStackedBarChartTitle:
                ChartsModel.getStackedBarChartValues(
                    reportIdMain,
                    0,
                    Constants.reportScreen,
                    colorByColumnName,
                    xAxisColumns[0],
                    yAxisColumns[0]
                );
                break;
            case Constants.stackedBarChartTitle:
                console.log("Stacked bar chart!");
                ChartsModel.getStackedBarChartValues(
                    reportIdMain,
                    0,
                    Constants.reportScreen,
                    colorByColumnName,
                    yAxisColumns[0],
                    xAxisColumns[0]
                );
                break;
            case Constants.horizontalBarGroupedChartTitle:
                console.log(
                    "horizontalBarGroupedChart chart!",
                    yAxisColumns[0],
                    xAxisColumns[0],
                    yAxisColumns[1]
                );
                var [category, subcategory] = getAxisColumnNames(
                    Constants.yAxisName
                );
                if (
                    colorByColumnName &&
                    (colorByColumnName == category ||
                        colorByColumnName == subcategory)
                ) {
                    d3PropertyConfig["options"] = {
                        groupBarChartColorBy:
                            colorByColumnName == subcategory
                                ? "subcategory"
                                : "category",
                    };
                } else {
                    delete d3PropertyConfig["options"];
                    colorListModel.clear();
                    colorByData = [];
                }
                ChartsModel.getNewGroupedBarChartValues(
                    reportIdMain,
                    0,
                    Constants.reportScreen,
                    yAxisColumns[0],
                    xAxisColumns[0],
                    yAxisColumns[1]
                );
                break;
            case Constants.groupBarChartTitle:
                var [category, subcategory] = getAxisColumnNames(
                    Constants.xAxisName
                );
                if (
                    colorByColumnName &&
                    (colorByColumnName == category ||
                        colorByColumnName == subcategory)
                ) {
                    d3PropertyConfig["options"] = {
                        groupBarChartColorBy:
                            colorByColumnName == subcategory
                                ? "subcategory"
                                : "category",
                    };
                } else {
                    delete d3PropertyConfig["options"];
                    colorListModel.clear();
                    colorByData = [];

                    ReportParamsModel.setItemType(null);
                    ReportParamsModel.setLastDropped(null);
                }
                console.log(
                    "Grouped bar chart!",
                    xAxisColumns[0],
                    yAxisColumns[0],
                    xAxisColumns[1]
                );
                ChartsModel.getNewGroupedBarChartValues(
                    reportIdMain,
                    0,
                    Constants.reportScreen,
                    xAxisColumns[0],
                    yAxisColumns[0],
                    xAxisColumns[1]
                );

                ReportParamsModel.setItemType(null);
                ReportParamsModel.setLastDropped(null);
                break;
            case Constants.areaChartTitle:
                console.log("AREA CLICKED");
                // Area - xAxis(String), yAxis(String)
                ChartsModel.getAreaChartValues(
                    reportIdMain,
                    0,
                    Constants.reportScreen,
                    xAxisColumns[0],
                    yAxisColumns[0]
                );
                break;
            case Constants.horizontalAreaChartTitle:
                ChartsModel.getAreaChartValues(
                    reportIdMain,
                    0,
                    Constants.reportScreen,
                    yAxisColumns[0],
                    xAxisColumns[0]
                );
                break;
            case Constants.stackedAreaChartTitle:
            case Constants.multipleAreaChartTitle:
                console.log("Stacked Area Chart");
                console.log("Colour By columnName", colorByColumnName);
                ChartsModel.getMultiLineChartValues(
                    reportIdMain,
                    0,
                    Constants.reportScreen,
                    xAxisColumns[0],
                    yAxisColumns[0],
                    colorByColumnName
                );
                break;
            case Constants.multipleHorizontalAreaChartTitle:
                console.log("Stacked Area Chart");
                console.log("Colour By columnName", colorByColumnName);
                ChartsModel.getMultiLineChartValues(
                    reportIdMain,
                    0,
                    Constants.reportScreen,
                    yAxisColumns[0],
                    xAxisColumns[0],
                    colorByColumnName
                );
                break;
            case Constants.lineChartTitle:
                console.log("LINE CLICKED");
                // Line - xAxis(String), yAxis(String)
                ChartsModel.getLineChartValues(
                    reportIdMain,
                    0,
                    Constants.reportScreen,
                    xAxisColumns[0],
                    yAxisColumns[0],
                    "Sum"
                );
                // Line Bar - xAxis(String), yAxis(String)
                //                dataValues =  ChartsModel.getLineBarChartValues("state", "id", "population");
                break;
            case Constants.horizontalLineChartTitle:
                console.log(Constants.horizontalLineChartTitle, "CLICKED");
                ChartsModel.getLineChartValues(
                    reportIdMain,
                    0,
                    Constants.reportScreen,
                    yAxisColumns[0],
                    xAxisColumns[0],
                    "Sum"
                );
                break;
            case Constants.multiLineChartTitle:
                console.log(Constants.multiLineChartTitle, "CLICKED");
                ChartsModel.getMultiLineChartValues(
                    reportIdMain,
                    0,
                    Constants.reportScreen,
                    xAxisColumns[0],
                    yAxisColumns[0],
                    colorByColumnName
                );
                break;
            case Constants.horizontalMultiLineChartTitle:
                console.log(chartTitle, "CLICKED");
                ChartsModel.getMultiLineChartValues(
                    reportIdMain,
                    0,
                    Constants.reportScreen,
                    yAxisColumns[0],
                    xAxisColumns[0],
                    colorByColumnName
                );
                break;
            case Constants.pieChartTitle:
            case Constants.donutChartTitle:
                console.log("DONUT/PIE CLICKED");
                ChartsModel.getPieChartValues(
                    reportIdMain,
                    0,
                    Constants.reportScreen,
                    xAxisColumns[0],
                    yAxisColumns[0],
                    "Sum"
                );
                break;
            case Constants.funnelChartTitle:
                console.log("FUNNEL CLICKED");
                ChartsModel.getFunnelChartValues(
                    reportIdMain,
                    0,
                    Constants.reportScreen,
                    xAxisColumns[0],
                    yAxisColumns[0],
                    "Sum"
                );
                break;
            case Constants.radarChartTitle:
                console.log("RADAR CLICKED");
                ChartsModel.getRadarChartValues(
                    reportIdMain,
                    0,
                    Constants.reportScreen,
                    xAxisColumns[0],
                    yAxisColumns[0]
                );
                break;
            case Constants.scatterChartTitle:
                console.log("SCATTER CLICKED");
                if (!colorByColumnName) {
                    ChartsModel.getScatterChartNumericalValues(
                        reportIdMain,
                        0,
                        Constants.reportScreen,
                        xAxisColumns[0],
                        yAxisColumns[0]
                    );
                    break;
                }
                // profit category sales
                // sales profit category
                // profit sales category
                ChartsModel.getScatterChartValues(
                    reportIdMain,
                    0,
                    Constants.reportScreen,
                    xAxisColumns[0],
                    yAxisColumns[0],
                    colorByColumnName
                );
                break;
            case Constants.treeChartTitle:
                console.log("TREECHART CLICKED");
                ChartsModel.getTreeChartValues(
                    reportIdMain,
                    0,
                    Constants.reportScreen,
                    xAxisColumnNamesArray,
                    yAxisColumns[0],
                    "Sum"
                );
                break;
            case Constants.treeMapChartTitle:
                ChartsModel.getTreeMapChartValues(
                    reportIdMain,
                    0,
                    Constants.reportScreen,
                    xAxisColumnNamesArray,
                    yAxisColumns[0],
                    "Sum"
                );
                break;
            case Constants.heatMapChartTitle:
                console.log("HEATMAP CLICKED");
                if (!colorByColumnName) {
                    break;
                }
                console.log(
                    xAxisColumns[0],
                    yAxisColumns[0],
                    colorByColumnName
                );
                ChartsModel.getHeatMapChartValues(
                    reportIdMain,
                    0,
                    Constants.reportScreen,
                    xAxisColumns[0],
                    colorByColumnName,
                    yAxisColumns[0]
                );
                break;
            case Constants.sunburstChartTitle:
                console.log("SUNBURST CLICKED");
                ChartsModel.getSunburstChartValues(
                    reportIdMain,
                    0,
                    Constants.reportScreen,
                    xAxisColumnNamesArray,
                    yAxisColumns[0],
                    "Sum"
                );
                break;
            case Constants.waterfallChartTitle:
                console.log("WATERFALL CLICKED");
                ChartsModel.getWaterfallChartValues(
                    reportIdMain,
                    0,
                    Constants.reportScreen,
                    xAxisColumns[0],
                    yAxisColumns[0],
                    "Sum"
                );
                console.log("Waterfall Data values", dataValues);
                break;
            case Constants.gaugeChartTitle:
                var row3ColumnsArray = Array.from(row3Columns);
                console.log("GAUGE CLICKED");
                console.log("row3ColumnsArray", row3ColumnsArray);

                var greenValue = +input1Field.text;
                var yellowValue = +input2Field.text;
                var redValue = +input3Field.text;
                optionalParams[chartTitle] = {
                    greenValue,
                    yellowValue,
                    redValue,
                };

                ChartsModel.getGaugeChartValues(
                    reportIdMain,
                    0,
                    Constants.reportScreen,
                    row3ColumnsArray[0],
                    greenValue,
                    yellowValue,
                    redValue
                );
                break;
            case Constants.sankeyChartTitle:
                console.log("SANKEY CLICKED");
                ChartsModel.getSankeyChartValues(
                    reportIdMain,
                    0,
                    Constants.reportScreen,
                    xAxisColumns[0],
                    xAxisColumns[1],
                    yAxisColumns[0]
                );
                break;
            case Constants.kpiTitle:
                console.log("KPI CLICKED");
                ChartsModel.getKPIChartValues(
                    reportIdMain,
                    0,
                    Constants.reportScreen,
                    xAxisColumns[0]
                );
                break;
            case Constants.tableTitle:
                console.log("TABLE CLICKED");
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
                console.log(
                    "Date Values",
                    JSON.stringify(dateConversionOptions)
                );

                dateConversionOptions = JSON.stringify(dateConversionOptions);
                // dateConversionOptions = '[{"itemName": "Ship Date", "itemType": "Date", "dateFormat": "Year", "separator" : "/"}, {"itemName": "Order Date", "itemType": "Date", "dateFormat": "Year,month", "separator" : "/"}]'
                ChartsModel.getTableChartValues(
                    reportIdMain,
                    0,
                    Constants.reportScreen,
                    nonMeasures,
                    measures,
                    dateConversionOptions
                );
                break;
            case Constants.pivotTitle:
                console.log("PIVOT CLICKED");
                console.log("row3Columns", row3Columns);
                var row3ColumnsArray = Array.from(row3Columns);

                var xAxisColumnDetails = getDataPaneAllDetails(
                    Constants.xAxisName
                );
                var yAxisColumnDetails = getDataPaneAllDetails(
                    Constants.yAxisName
                );

                var tempDataValues = [
                    ...xAxisColumnDetails,
                    ...yAxisColumnDetails,
                ];
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

                dateConversionOptions = JSON.stringify(dateConversionOptions);
                // Temporary running function
                ChartsModel.getPivotChartValues(
                    reportIdMain,
                    0,
                    Constants.reportScreen,
                    [...xAxisColumnNamesArray, ...yAxisColumnNamesArray],
                    row3ColumnsArray,
                    dateConversionOptions,
                    [
                        xAxisColumnNamesArray,
                        yAxisColumnNamesArray,
                        row3ColumnsArray,
                    ]
                );

                /*

                [
                    {
                        itemName: "Order Date",
                        itemType: "Date"
                        dateFormat: "%Y",
                        qtDateFormat: "YYYY"
                    }
                    {
                        itemName: "Order Date",
                        itemType: "Categorical"
                        dateFormat: "%Y",
                        qtDateFormat: "YYYY"
                    }
                ]


                // Change required
                // Group the dates according to date format and sum the values.
                // Values can be multiple so we will have to sum all of the values
                // Passing column name and type

                var nonValueColumnNames = [ ...xAxisColumnDetails, ...yAxisColumnDetails ];
                var valuesColumns = row3ColumnDetails;
                ChartsModel.getPivotChartValues(nonValueColumnNames, valuesColumns,'Sum');

                */

                break;
        }
        if (!dataValues) {
            return;
        }

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

// TODO: Refactor this function
function reDrawChart() {
    // Check if the chart is horizontal
    // set isHorizontalGraph true
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

    if (
        chartTitle == Constants.tableTitle ||
        chartTitle == Constants.kpiTitle
    ) {
        if (xAxisColumns.length > 0) {
            console.log(xAxisColumns);
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

    console.log("Calling draw chart.. Hurrrayy!!");
    drawChart();
}

function drawChartAfterReceivingSignal(dataValues) {
    if (webEngineView.loading) {
        return;
    }

    var xAxisColumnDetails = getDataPaneAllDetails(Constants.xAxisName);
    var yAxisColumnDetails = getDataPaneAllDetails(Constants.yAxisName);
    var row3ColumnDetails = getDataPaneAllDetails(Constants.row3Name);

    ColorPalleteHandler.setD3ColorPallete(dataValues);

    d3PropertyConfig["dataColumns"] = {
        xAxisColumnDetails,
        yAxisColumnDetails,
        row3ColumnDetails,
        colorByData,
    };

    d3PropertyConfig.chartName = chartTitle;
    console.log(dataValues);
    ChartsWebViewHandler.startPlottingChart(dataValues, d3PropertyConfig);
}
