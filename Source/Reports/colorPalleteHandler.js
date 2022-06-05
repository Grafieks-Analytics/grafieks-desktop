/**
 * @param {string} dataValues => Actual data values for charts
 * @param {string} chartTitle => Title of the chart
 * @param {string} colorData => Color pallete for the chart
 * @param {string} dataItemList => List of color data items
 *
 * @description
 * This function is used to set the color pallete for different charts
 * Push colors to color data and editColor popup will set the colors values
 */

function setD3ColorPallete(dataValues) {
    switch (chartTitle) {
        case Constants.horizontalBarChartTitle:
        case Constants.barChartTitle:
        case Constants.areaChartTitle:
        case Constants.horizontalAreaChartTitle:
        case Constants.lineChartTitle:
        case Constants.horizontalLineChartTitle:
            colorData = (dataValues && [JSON.parse(dataValues)[1][0]]) || [];
            break;
        case Constants.horizontalStackedBarChartTitle:
        case Constants.stackedBarChartTitle:
        case Constants.stackedAreaChartTitle:
        case Constants.multipleAreaChartTitle:
        case Constants.multiLineChartTitle:
        case Constants.multipleHorizontalAreaChartTitle:
        case Constants.horizontalMultiLineChartTitle:
            var dataValuesTemp = dataValues && JSON.parse(dataValues);
            colorData = dataValuesTemp[1] || [];
            delete dataValuesTemp;
            break;
        case Constants.horizontalBarGroupedChartTitle:
            var [category, subcategory] = getAxisColumnNames(
                Constants.yAxisName
            );
            if (
                colorByColumnName &&
                (colorByColumnName == category ||
                    colorByColumnName == subcategory)
            ) {
                d3PropertyConfig.options = {
                    groupBarChartColorBy:
                        colorByColumnName == subcategory
                            ? "subcategory"
                            : "category",
                };
            } else {
                delete d3PropertyConfig.options;
                colorListModel.clear();
                colorByData = [];
            }
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
                d3PropertyConfig.options = {
                    groupBarChartColorBy:
                        colorByColumnName == subcategory
                            ? "subcategory"
                            : "category",
                };
            } else {
                delete d3PropertyConfig.options;
                colorListModel.clear();
                colorByData = [];
                ReportParamsModel.setItemType(null);
                ReportParamsModel.setLastDropped(null);
            }

            break;

        case Constants.pieChartTitle:
        case Constants.donutChartTitle:
            var dataValuesTemp = dataValues && JSON.parse(dataValues);
            colorData = Object.keys(dataValuesTemp[0]);
            delete dataValuesTemp;
            break;
        case Constants.funnelChartTitle:
            var dataValuesTemp = dataValues && JSON.parse(dataValues);
            colorData = dataValuesTemp[0].map((d) => d.key);
            delete dataValuesTemp;
            break;
        case Constants.radarChartTitle:
            var dataValuesTemp = dataValues && JSON.parse(dataValues);
            colorData = [dataValuesTemp[1][0]];
            delete dataValuesTemp;
            break;
        case Constants.scatterChartTitle:
            var dataValuesTemp = dataValues && JSON.parse(dataValues);
            colorData = dataValuesTemp[2];
            delete dataValuesTemp;
            break;
        default:
            console.log(chartTitle, "Clicked, but is a missed case");
    }
    if (!dataValues) {
        return;
    }

    // Appending list to select color
    dataItemList.clear();

    if (colorData && colorData.length) {
        colorData.forEach(function (element, index) {
            dataItemList.append({
                colorValue:
                    Constants.d3ColorPalette[
                        index % Constants.d3ColorPalette.length
                    ],
                dataItemName: element,
            });
        });
    }
}
