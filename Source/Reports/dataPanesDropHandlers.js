function onDropAreaEntered(element, elementName) {
    element.border.width = Constants.dropActiveBorderWidth;
}

function onDropAreaExited(element) {
    element.border.width = Constants.dropEligibleBorderWidth;
}

function alreadyExists(elementsList, element) {
    if (elementsList.includes(element)) {
        return true;
    }
    return false;
}

function xAxisDropEligible(itemType) {
    var xAxisColumns = getAxisColumnNames(Constants.xAxisName);
    var yAxisColumns = getAxisColumnNames(Constants.yAxisName);

    if (xAxisColumns.length === allowedXAxisDataPanes) {
        return false;
    }

    switch (chartTitle) {
        case Constants.lineChartTitle:
        case Constants.areaChartTitle:
        case Constants.barChartTitle:
            if (!yAxisColumns.length && !xAxisColumns.length) {
                return true;
            }
            if (itemType && itemType.toLowerCase() == "numerical") {
                return false;
            }
            return true;
        case Constants.horizontalLineChartTitle:
        case Constants.horizontalAreaChartTitle:
        case Constants.horizontalBarChartTitle:
            if (!yAxisColumns.length && !xAxisColumns.length) {
                return true;
            }
            if (itemType && itemType.toLowerCase() != "numerical") {
                return false;
            }
            return true;
        case Constants.tableTitle:
            console.log("Table tile", itemType);
            if (
                !xAxisColumns.length &&
                (itemType && itemType.toLowerCase()) == "numerical"
            ) {
                return false;
            }
            return true;
        case Constants.treeChartTitle:
        case Constants.radarChartTitle:
        case Constants.sunburstChartTitle:
            if ((itemType && itemType.toLowerCase()) != "categorical") {
                return false;
            }
            return true;

        case Constants.donutChartTitle:
        case Constants.pieChartTitle:
        case Constants.waterfallChartTitle:
            if ((itemType && itemType.toLowerCase()) == "numerical") {
                return false;
            }
            return true;
        case Constants.pivotTitle:
            if ((itemType && itemType.toLowerCase()) == "numerical") {
                return false;
            }
            return true;
        case Constants.heatMapChartTitle:
            if ((itemType && itemType.toLowerCase()) == "numerical") {
                return false;
            }
            return true;

        case Constants.scatterChartTitle:
            if ((itemType && itemType.toLowerCase()) == "numerical") {
                return true;
            }
            return false;
        case Constants.kpiTitle:
            if ((itemType && itemType.toLowerCase()) == "numerical") {
                return true;
            }
            return false;
    }

    const multiChart = true;
    if (multiChart) {
        return true;
    }
    return false;
}

function yAxisDropEligible(itemName, itemType) {
    var yAxisColumns = getAxisColumnNames(Constants.yAxisName);
    var xAxisColumns = getAxisColumnNames(Constants.xAxisName);
    const multiChart = true;
    // Check if condition more data pills can be added or not';
    if (yAxisColumns.length === allowedYAxisDataPanes) {
        return false;
    }

    switch (chartTitle) {
        case Constants.lineChartTitle:
        case Constants.areaChartTitle:
        case Constants.barChartTitle:
            if (!yAxisColumns.length && !xAxisColumns.length) {
                return true;
            }
            if (itemType && itemType.toLowerCase() != "numerical") {
                return false;
            }
            return true;
        case Constants.horizontalLineChartTitle:
        case Constants.horizontalAreaChartTitle:
        case Constants.horizontalBarChartTitle:
            if (!yAxisColumns.length && !xAxisColumns.length) {
                return true;
            }
            if (itemType && itemType.toLowerCase() == "numerical") {
                return false;
            }
            return true;

        case Constants.sunburstChartTitle:
        case Constants.treeChartTitle:
        case Constants.radarChartTitle:
            if ((itemType && itemType.toLowerCase()) != "numerical") {
                return false;
            }
            return true;

        case Constants.donutChartTitle:
        case Constants.pieChartTitle:
        case Constants.waterfallChartTitle:
            if ((itemType && itemType.toLowerCase()) != "numerical") {
                return false;
            }
            return true;
        case Constants.pivotTitle:
            if ((itemType && itemType.toLowerCase()) == "numerical") {
                return false;
            }
            return true;
        case Constants.heatMapChartTitle:
            if ((itemType && itemType.toLowerCase()) == "numerical") {
                return false;
            }
            return true;

        case Constants.scatterChartTitle:
            if ((itemType && itemType.toLowerCase()) == "numerical") {
                return true;
            }
            return false;
    }

    if (multiChart) {
        return true;
    }
    return false;
}

function row3AxisDropEligible(itemName, itemType) {
    var row3Columns = getAxisColumnNames(Constants.row3Name);
    const multiChart = true;
    // Check if condition more data pills can be added or not';
    if (row3Columns.length === allowedRow3AxisDataPanes) {
        return false;
    }
    if (
        chartTitle == Constants.pivotTitle &&
        itemType &&
        itemType.toLowerCase() != "numerical"
    ) {
        return false;
    }
    if (multiChart) {
        return true;
    }
    return false;
}

function row4AxisDropEligible(itemName, itemType) {
    var row4Columns = getAxisColumnNames(Constants.row4Name);
    // Check if condition more data pills can be added or not';
    if (row4Columns.length === 1) {
        return false;
    }
    return true;
}

/**
 *
 * @param {*} element is xAxisRectangle | yAxisRectangle | row3 | row4
 * @param {*} axis is xAxis | yAxis | row3 | row4
 * @returns
 *
 *
 *
 */

// TODO: Refactor this function
function onDropAreaDropped(element, axis) {
    row3Active = null; // Todo: Check why row3Active is being set to null
    var xAxisColumns = getAxisColumnNames(Constants.xAxisName);
    var yAxisColumns = getAxisColumnNames(Constants.yAxisName);

    // lastPickedDataPaneElementProperties has data pane element properties
    var itemType = lastPickedDataPaneElementProperties.itemType;
    var tableValue = lastPickedDataPaneElementProperties.tableValue;

    // Change the color of axis to normal from active (green);
    element.border.width = Constants.dropEligibleBorderWidth;
    element.border.color = Constants.themeColor;

    // Item name can be picked from lastPickedDataPaneElementProperties.lastPicked
    // Changed ReportParamsModel.itemName to lastPickedDataPaneElementProperties.itemName
    var itemName = lastPickedDataPaneElementProperties.itemName;

    if (axis === Constants.xAxisName) {
        if (!xAxisDropEligible(itemType)) {
            // Red color
            return;
        }
        xAxisListModel.append({
            itemName: itemName,
            tableValue: tableValue,
            droppedItemType: itemType,
            dateFormat: Constants.yearFormat,
        });
        xAxisColumns.push(itemName);
    } else if (axis === Constants.yAxisName) {
        if (!yAxisDropEligible(itemName, itemType)) {
            // Red color
            return;
        }

        console.log("Y Axis itemType", itemType, itemName);
        yAxisListModel.append({
            itemName: itemName,
            tableValue: tableValue,
            droppedItemType: itemType,
            dateFormat: Constants.yearFormat,
        });
        yAxisColumns.push(itemName);
    } else if (axis == Constants.row3Name) {
        if (!row3AxisDropEligible(itemName, itemType)) {
            // Red color
            return;
        }
        console.log(itemType, "Adding it to values?");
        valuesListModel.append({
            itemName: itemName,
            tableValue: tableValue,
            droppedItemType: itemType,
            dateFormat: Constants.yearFormat,
        });
    } else {
        // Gauge
        if (!row3AxisDropEligible(itemName, itemType)) {
            return;
        }
        console.log(itemType, "Adding for gauge?");
        valuesListModel.append({
            itemName: itemName,
            tableValue: tableValue,
            droppedItemType: itemType,
            dateFormat: Constants.yearFormat,
        });
    }

    // To Make group chart: Make sure to have 2 xAxisValueColumn and 1 yAxisColumn

    if (
        getAxisColumnNames(Constants.xAxisName).length > 1 &&
        getAxisColumnNames(Constants.yAxisName).length &&
        (chartTitle === Constants.barChartTitle ||
            chartTitle === Constants.stackedBarChartTitle)
    ) {
        chartTitle = Constants.groupBarChartTitle;
        return;
    }

    if (
        getAxisColumnNames(Constants.yAxisName).length > 1 &&
        getAxisColumnNames(Constants.xAxisName).length &&
        (chartTitle === Constants.horizontalBarChartTitle ||
            chartTitle === Constants.horizontalStackedBarChartTitle)
    ) {
        chartTitle = Constants.horizontalBarGroupedChartTitle;
        return;
    }

    reDrawChart();
}
