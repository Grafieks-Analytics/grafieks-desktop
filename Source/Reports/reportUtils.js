function makeElementDropIneligible(element) {
    element.border.color = "transparent";
    element.border.width = Constants.dropInActiveBorderWidth;
}

function makeElementDropEligible(element) {
    element.border.color = Constants.grafieksLightGreenColor;
    element.border.width = Constants.dropEligibleBorderWidth;
}

function checkAndMakeElementDropEligible(axisStatus, element) {
    if (axisStatus) {
        makeElementDropEligible(element);
    } else {
        makeElementDropIneligible(element);
    }
}

function checkAllValuesOfType(array, type) {
    var flag = true;
    for (let index = 0; index < array.length; index++) {
        const element = array[index];
        if (element.itemType && element.itemType.toLowerCase() != type) {
            flag = false;
        }
    }
    return flag;
}

// TODO: Combine this in a single function
function allNumericalValues(details) {
    var flag = true;
    console.log("detail", JSON.stringify(details));
    details.forEach((detail) => {
        if (detail.itemType && detail.itemType.toLowerCase() != "numerical") {
            flag = false;
        }
    });
    if (flag) {
        return true;
    }
    return false;
}

function allCategoricalValues(details) {
    var flag = true;
    console.log("detail", JSON.stringify(details));
    details.forEach((detail) => {
        console.log("detail", detail);
        if (detail.itemType && detail.itemType.toLowerCase() != "categorical") {
            flag = false;
        }
    });
    if (flag) {
        return true;
    }
    return false;
}

function allNonMeasures(details) {
    var flag = true;
    console.log("detail", JSON.stringify(details));
    details.forEach((detail) => {
        console.log("detail", detail);
        if (detail.itemType && detail.itemType.toLowerCase() == "numerical") {
            flag = false;
        }
    });
    if (flag) {
        return true;
    }
    return false;
}

function allDateValues(details) {
    console.log("detail", JSON.stringify(details));
    var flag = true;
    details.forEach((detail) => {
        if (detail.itemType && detail.itemType.toLowerCase() != "date") {
            flag = false;
        }
    });
    if (flag) {
        return true;
    }
    return false;
}

// On Loading NewReport.qml Component
function onNewReportComponentLoad() {
    // Flags to set the droppable axis colors according to chart's eligibility
    xaxisActive = false;
    yaxisActive = false;
    ReportParamsModel.colorByActive = false;
    row3Active = false;
    row4Active = false;

    // Clearing xAxisListModel and yAxisListModel if any
    // Might be possible that this is getting called once
    // Check if can be removed [TAG: Optimization]
    // TODO: AFTER REFACTORING --> Removed clearing of model -> Check and confirm before push
    // xAxisListModel.clear();
    // yAxisListModel.clear();

    initializeQmlChartConfig();

    // TODO: Move this array to config / Constant
    // Pushing all the horiontal type chart
    horizontalChartList.push(
        Constants.barChartTitle,
        Constants.stackedBarChartTitle,
        Constants.groupBarChartTitle,
        Constants.horizontalBarChartTitle,
        Constants.horizontalStackedBarChartTitle,
        Constants.horizontalBarGroupedChartTitle,
        Constants.lineChartTitle,
        Constants.horizontalLineChartTitle,
        Constants.multiLineChartTitle,
        Constants.horizontalMultiLineChartTitle,
        Constants.areaChartTitle,
        Constants.horizontalAreaChartTitle,
        Constants.multipleAreaChartTitle,
        Constants.multipleHorizontalAreaChartTitle
    );
}

function onChartTitleChanged() {
    console.log("Chart Title Changed", chartTitle);

    if (d3PropertyConfig.toolTip) {
        console.log(
            "debug: tooltip deleting because of chart change",
            JSON.stringify(d3PropertyConfig.toolTip)
        );
        delete d3PropertyConfig.toolTip;
        tempXModel.clear();
        tempYModel.clear();
        tempColorByModel.clear();
    }

    // Charts Mapping
    // Basically these are the basic configs
    // Having Max Allowed Values for now
    if (!allChartsMapping[chartTitle]) {
        allChartsMapping[chartTitle] = {};
    }
    const chartDetailsConfig = allChartsMapping[chartTitle];
    const {
        maxDropOnXAxis = 2,
        maxDropOnYAxis = 2,
        maxDropOnRow3Axis = 0,
    } = chartDetailsConfig || {
        maxDropOnXAxis: allowedXAxisDataPanes,
        maxDropOnYAxis: allowedYAxisDataPanes,
    };

    var xAxisColumns = getAxisColumnNames(Constants.xAxisName);
    var yAxisColumns = getAxisColumnNames(Constants.yAxisName);
    var row3Columns = getAxisColumnNames(Constants.row3Name);

    var xAxisColumnDetails = getDataPaneAllDetails(Constants.xAxisName);
    var yAxisColumnDetails = getDataPaneAllDetails(Constants.yAxisName);
    var row3ColumnDetails = getDataPaneAllDetails(Constants.row3Name);

    xAxisLabelName = allChartsMapping[chartTitle].xAxisLabelName
        ? allChartsMapping[chartTitle].xAxisLabelName
        : Constants.xAxisName;
    yAxisLabelName = allChartsMapping[chartTitle].yAxisLabelName
        ? allChartsMapping[chartTitle].yAxisLabelName
        : Constants.yAxisName;
    valuesLabelName = allChartsMapping[chartTitle].row3Name
        ? allChartsMapping[chartTitle].row3Name
        : "Values";

    // check if maximum drop is less than in config?
    // if less then remove all the extra values
    // else no change -> Plot the graph

    var dataValuesRemoved = false;
    if (maxDropOnXAxis > 0 && maxDropOnXAxis < xAxisColumns.length) {
        xAxisColumns = xAxisColumns.splice(0, maxDropOnXAxis);
        ReportParamsModel.setXAxisColumns(xAxisColumns);
        xAxisListModel.remove(
            maxDropOnXAxis,
            xAxisListModel.count - maxDropOnXAxis
        );
        dataValuesRemoved = true;
    }

    if (maxDropOnYAxis > 0 && maxDropOnYAxis < yAxisColumns.length) {
        yAxisColumns = yAxisColumns.splice(0, maxDropOnYAxis);
        ReportParamsModel.setYAxisColumns(yAxisColumns);
        yAxisListModel.remove(
            maxDropOnYAxis,
            yAxisListModel.count - maxDropOnYAxis
        );
        dataValuesRemoved = true;
    }

    if (maxDropOnRow3Axis > 0 && maxDropOnRow3Axis < row3Columns.length) {
        row3Columns = row3Columns.splice(0, maxDropOnYAxis);
        ReportParamsModel.setRow3Columns(row3Columns);
        valuesListModel.remove(
            maxDropOnYAxis,
            valuesListModel.count - maxDropOnRow3Axis
        );
        dataValuesRemoved = true;
    }

    allowedXAxisDataPanes = maxDropOnXAxis;
    allowedYAxisDataPanes = maxDropOnYAxis;
    allowedRow3AxisDataPanes = maxDropOnRow3Axis;

    // change axis on the basis of chart title
    // Updating the Row visible here => Sanky charts can have 3 rows
    // where we can drop the columns

    // Optimization Can be done => call switch function here to change the graph
    switch (chartTitle) {
        case Constants.sankeyTitle:
            row3Visible = true;
            xAxisVisible = true;
            yAxisVisible = true;
            row4Visible = false;
            break;
        case Constants.pivotTitle:
            if (
                !(
                    allCategoricalValues(xAxisColumnDetails) ||
                    allDateValues(xAxisColumnDetails)
                )
            ) {
                xAxisListModel.clear();
            }
            if (
                !(
                    allCategoricalValues(yAxisColumnDetails) ||
                    allDateValues(yAxisColumnDetails)
                )
            ) {
                yAxisListModel.clear();
            }

            row3Visible = true;
            xAxisVisible = true;
            yAxisVisible = true;
            row4Visible = false;
            pivotThemeVisible = true;

            xAxisLabelName = "Rows";
            yAxisLabelName = "Columns";
            valuesLabelName = "Values";

            break;
        case Constants.tableTitle:
            var xAxisColumnDetails = getDataPaneAllDetails(Constants.xAxisName);
            if (checkAllValuesOfType(xAxisColumnDetails, "numerical")) {
                xAxisListModel.clear();
            }
            yAxisVisible = false;
            xAxisVisible = true;
            row3Visible = false;
            row4Visible = false;
            xAxisLabelName = "Columns";
            break;
        case Constants.gaugeChartTitle:
            row4Visible = true;
            xAxisVisible = false;
            yAxisVisible = false;
            row3Visible = false;
            break;
        case Constants.kpiTitle:
            if (!checkAllValuesOfType(xAxisColumnDetails, "numerical")) {
                xAxisListModel.clear();
            }
            yAxisVisible = false;
            xAxisVisible = true;
            row3Visible = false;
            row4Visible = false;
            xAxisLabelName = "Values";
            break;

        case Constants.barChartTitle:
        case Constants.lineChartTitle:
        case Constants.areaChartTitle:
            if (
                previousChartTitle == Constants.scatterChartTitle ||
                previousChartTitle == Constants.kpiTitle ||
                previousChartTitle == Constants.heatMapChartTitle ||
                previousChartTitle == Constants.tableTitle
            ) {
                if (!allNonMeasures(xAxisColumnDetails)) {
                    xAxisListModel.clear();
                }

                if (!checkAllValuesOfType(yAxisColumnDetails, "numerical")) {
                    yAxisListModel.clear();
                }

                clearColorByList();
            }
            xAxisVisible = true;
            yAxisVisible = true;
            row3Visible = false;
            row4Visible = false;
            xAxisLabelName = Constants.xAxisName;
            yAxisLabelName = Constants.yAxisName;
            break;
        case Constants.pieChartTitle:
        case Constants.donutChartTitle:
            xAxisLabelName = "Categorical";
            yAxisLabelName = "Numerical";
            if (!allNonMeasures(xAxisColumnDetails)) {
                xAxisListModel.clear();
            }

            if (!checkAllValuesOfType(yAxisColumnDetails, "numerical")) {
                yAxisListModel.clear();
            }

            clearColorByList();
            xAxisVisible = true;
            yAxisVisible = true;
            row3Visible = false;
            row4Visible = false;
            break;
        case Constants.radarChartTitle:
        case Constants.sunburstChartTitle:
        case Constants.treeChartTitle:
        case Constants.waterfallChartTitle:

        case Constants.multiLineChartTitle:
        case Constants.multipleAreaChartTitle:
        case Constants.groupBarChartTitle:
        case Constants.stackedBarChartTitle:
            if (!allNonMeasures(xAxisColumnDetails)) {
                xAxisListModel.clear();
            }

            if (!checkAllValuesOfType(yAxisColumnDetails, "numerical")) {
                yAxisListModel.clear();
            }

            clearColorByList();
            xAxisVisible = true;
            yAxisVisible = true;
            row3Visible = false;
            row4Visible = false;

            break;
        case Constants.horizontalBarChartTitle:
        case Constants.horizontalLineChartTitle:
        case Constants.horizontalAreaChartTitle:
        case Constants.horizontalBarGroupedChartTitle:
        case Constants.multipleHorizontalAreaChartTitle:
        case Constants.horizontalMultiLineChartTitle:
        case Constants.horizontalStackedBarChartTitle:
            if (
                !(
                    allCategoricalValues(yAxisColumnDetails) ||
                    allDateValues(yAxisColumnDetails)
                )
            ) {
                yAxisColumnDetails.clear();
            }

            if (!checkAllValuesOfType(xAxisColumnDetails, "numerical")) {
                xAxisListModel.clear();
            }

            xAxisVisible = true;
            yAxisVisible = true;
            row3Visible = false;
            row4Visible = false;

            break;
        case Constants.heatMapChartTitle:
            if (
                !(
                    allCategoricalValues(xAxisColumnDetails) ||
                    allDateValues(xAxisColumnDetails)
                )
            ) {
                xAxisListModel.clear();
            }

            if (
                !(
                    allCategoricalValues(yAxisColumnDetails) ||
                    allDateValues(yAxisColumnDetails)
                )
            ) {
                yAxisListModel.clear();
            }

            clearColorByList();

            xAxisVisible = true;
            yAxisVisible = true;
            row3Visible = false;
            row4Visible = false;
            break;
        case Constants.scatterChartTitle:
            if (!checkAllValuesOfType(xAxisColumnDetails, "numerical")) {
                xAxisListModel.clear();
            }

            if (!checkAllValuesOfType(yAxisColumnDetails, "numerical")) {
                yAxisListModel.clear();
            }

            clearColorByList();
            xAxisVisible = true;
            yAxisVisible = true;
            row3Visible = false;
            row4Visible = false;
            break;

        default:
            xAxisVisible = true;
            yAxisVisible = true;
            row3Visible = false;
            row4Visible = false;
            clearColorByList();
    }

    if (chartTitle == Constants.sunburstChartTitle) {
        allowedXAxisDataPanes = 5;
    }
    reDrawChart();
}

/**
 * if horizontal graph changed is true then check if the loaded chart has horizontal graph, if is does then change to horizontal graph
 * Eg: Line chart was selected and you drop numerical value on x-axis => this isHorizontalGraphChanged will be true and it will switch the chart to horizontal graph
 */

function onIsHorizontalGraphChanged() {
    console.log("Horizontal Bar Flag Changed, Cuurent Chart is", chartTitle);

    if (isHorizontalGraph) {
        allowedXAxisDataPanes = 1;
        allowedYAxisDataPanes = 2;

        switch (chartTitle) {
            case Constants.stackedBarChartTitle:
                switchChart(Constants.horizontalStackedBarChartTitle);
                break;
            case Constants.barChartTitle:
                switchChart(Constants.horizontalBarChartTitle);
                break;
            case Constants.multiLineChartTitle:
                allowedYAxisDataPanes = 1;
                switchChart(Constants.horizontalMultiLineChartTitle);
                break;
            case Constants.lineChartTitle:
                allowedYAxisDataPanes = 1;
                switchChart(Constants.horizontalLineChartTitle);
                break;
            case Constants.multipleAreaChartTitle:
                allowedYAxisDataPanes = 1;
                switchChart(Constants.multipleHorizontalAreaChartTitle);
                break;
            case Constants.areaChartTitle:
                allowedYAxisDataPanes = 1;
                switchChart(Constants.horizontalAreaChartTitle);
                break;
            default:
                console.log(
                    "Missed condition in isHorizontalGraph change horizontal"
                );
        }
    } else {
        // Changing the maximum values allowed (This will be the only case bar graphs )
        allowedXAxisDataPanes = 2;
        allowedYAxisDataPanes = 1;

        switch (chartTitle) {
            case Constants.horizontalBarChartTitle:
                switchChart(Constants.barChartTitle);
                break;
            case Constants.horizontalStackedBarChartTitle:
                switchChart(Constants.stackedBarChartTitle);
                break;
            case Constants.horizontalLineChartTitle:
                allowedXAxisDataPanes = 1;
                console.log("Switching to line chart");
                switchChart(Constants.lineChartTitle);
                break;
            case Constants.horizontalMultiLineChartTitle:
                allowedXAxisDataPanes = 1;
                switchChart(Constants.multiLineChartTitle);
                break;
            case Constants.horizontalAreaChartTitle:
                allowedXAxisDataPanes = 1;
                switchChart(Constants.areaChartTitle);
                break;
            case Constants.multipleHorizontalAreaChartTitle:
                allowedXAxisDataPanes = 1;
                switchChart(Constants.multipleAreaChartTitle);
                break;
            case Constants.pivotTitle:
                allowedRow3AxisDataPanes = 5;
                break;
            default:
                console.log(
                    "Missed condition in isHorizontalGraph change veritcal"
                );
        }
    }
}
