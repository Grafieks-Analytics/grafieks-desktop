function clearValuesOnAddNewReport() {
    clearAllChartValues();
    switchChart(Constants.barChartTitle);
}

function setValuesOnEditReport(reportId) {
    ReportParamsModel.setLastDropped(null);

    // Setting the report title value to empty
    //        report_title_text.text = "";
    report_desiner_page.reportIdMain = reportId;

    // Clear all the list models
    xAxisListModel.clear();
    yAxisListModel.clear();
    colorListModel.clear();
    valuesListModel.clear();
    dataItemList.clear();

    var reportProperties = ReportParamsModel.getReport(reportIdMain);

    var xAxisColumnsReportData = JSON.parse(reportProperties.xAxisColumns);
    var yAxisColumnsReportData = JSON.parse(reportProperties.yAxisColumns);
    var row3ColumnsReportData = JSON.parse(reportProperties.row3Columns);
    var colorListModelData = JSON.parse(reportProperties.colorByDataColoumns);

    var qmlChartConfigValue = JSON.parse(reportProperties.qmlChartConfig);
    report_desiner_page.qmlChartConfig = qmlChartConfigValue;
    console.log("qmlChartConfig:debug", JSON.stringify(qmlChartConfig));
    report_desiner_page.customizationsAvailable =
        qmlChartConfigValue.customizationsAvailable;
    report_desiner_page.subMenuCustomizationsAvailable =
        qmlChartConfigValue.subMenuCustomizationsAvailable;

    allCharts.set(activeChartIndex, { activeChart: false });
    report_desiner_page.activeChartIndex = qmlChartConfigValue.activeChartIndex;
    allCharts.set(activeChartIndex, { activeChart: true });

    var chartTitleName = reportProperties.chartTitle;
    if (chartTitleName == Constants.gaugeChartTitle) {
        var optionalParams = JSON.parse(reportProperties.optionalConfig);
        var gaugeParams = optionalParams[Constants.gaugeChartTitle];
        input1Field.text = gaugeParams.greenValue;
        input2Field.text = gaugeParams.yellowValue;
        input3Field.text = gaugeParams.redValue;
    }

    // Update List Models
    for (var i = 0; i < xAxisColumnsReportData.length; i++) {
        xAxisListModel.append({
            itemName: xAxisColumnsReportData[i].itemName,
            tableValue: xAxisColumnsReportData[i].tableValue,
            droppedItemType: xAxisColumnsReportData[i].droppedItemType,
            dateFormat: xAxisColumnsReportData[i].dateFormat,
        });
    }
    for (var i = 0; i < yAxisColumnsReportData.length; i++) {
        yAxisListModel.append({
            itemName: yAxisColumnsReportData[i].itemName,
            tableValue: yAxisColumnsReportData[i].tableValue,
            droppedItemType: yAxisColumnsReportData[i].droppedItemType,
            dateFormat: yAxisColumnsReportData[i].dateFormat,
        });
    }
    for (var i = 0; i < row3ColumnsReportData.length; i++) {
        valuesListModel.append({
            itemName: row3ColumnsReportData[i].itemName,
            tableValue: row3ColumnsReportData[i].tableValue,
            droppedItemType: row3ColumnsReportData[i].droppedItemType,
        });
    }

    for (var i = 0; i < colorListModelData.length; i++) {
        // TODO:optimisation remove textValue
        colorListModel.append({
            textValue: colorListModelData[i].columnName,
            itemName: colorListModelData[i].columnName,
            tableValue: colorListModelData[i].tableValue,
        });
    }

    // Update Property Variables
    report_title_text.text = reportProperties.reportTitle;
    report_desiner_page.chartTitle = reportProperties.chartTitle;
    report_desiner_page.d3PropertyConfig = JSON.parse(
        reportProperties.d3PropertiesConfig
    );
    report_desiner_page.colorByData = JSON.parse(
        reportProperties.colorByDataColoumns
    );

    switchChart(reportProperties.chartTitle);

    var {
        compactStatus,
        searchStatus,
        rowAlternateStatus,
        rowWiseGrandTotal,
        totalSubTotalCheckStatus,
        columnWiseGrandTotal,
        labelFontStylings = {},
        valueFontStylings = {},
        xAxisConfig = {},
        yAxisConfig = {},
        toolTip = {},
        dataColumns = {},
    } = JSON.parse(reportProperties.d3PropertiesConfig) || {};
    console.log("Edit d3PropertyCondfig", JSON.stringify(d3PropertyConfig));

    if (rowAlternateStatus != undefined) {
        alternateRowsCheckStatus = rowAlternateStatus;
    }
    if (searchStatus != undefined) {
        searchCheckStatus = searchStatus;
    }
    if (compactStatus != undefined) {
        compactStatusCheckStatus = compactStatus;
    }

    if (rowWiseGrandTotal != undefined) {
        tableGrandTotalCheckStatus = rowWiseGrandTotal;
    }
    if (totalSubTotalCheckStatus != undefined) {
        totalSubTotalCheckStatus = totalSubTotalCheckStatus;
    }
    if (columnWiseGrandTotal != undefined) {
        totalRowTotalCheckStatus = columnWiseGrandTotal;
    }
    if (xAxisConfig.xaxisStatus != undefined) {
        xAxisLabelStatus = xAxisConfig.xaxisStatus;
        console.log("X Axis Label Status", xAxisLabelStatus);
    }
    if (yAxisConfig.yaxisStatus != undefined) {
        yAxisLabelStatus = yAxisConfig.yaxisStatus;
        console.log("Y Axis Label Status", yAxisLabelStatus);
    }

    var {
        bold: KPILabelBold,
        underline: KPILabelUnderline,
        italic: KPILabelItalic,
        fontFamily: fontFamilyValueKPILabel,
        fontSize: fontSizeValueKPILabel,
        dataLabelColorKpi,
    } = labelFontStylings;
    var {
        bold: KPIValueBold,
        underline: KPIValueUnderline,
        italic: KPIValueItalic,
        fontFamily: fontFamilyValueKPIValue,
        fontSize: fontSizeValueKPIValue,
        dataValueColorKpi,
    } = valueFontStylings;

    boldCheckKPILabelStatus = !!KPILabelBold;
    italicCheckKPILabelStatus = !!KPILabelItalic;
    underlineCheckKPILabelStatus = !!KPILabelUnderline;

    if (dataLabelColorKpi) {
        dataLabelDialogKpiColor = dataLabelColorKpi;
        dataLabelKpiColorBoxColor = dataLabelColorKpi;
    }

    boldCheckKPIValueStatus = !!KPIValueBold;
    italicCheckKPIValueStatus = !!KPIValueItalic;
    underlineCheckKPIValueStatus = !!KPIValueUnderline;

    if (dataValueColorKpi) {
        dataValueDialogKpiColor = dataValueColorKpi;
        dataValueKpiColorBoxColor = dataValueColorKpi;
    }

    var {
        xAxisColumnDetails = [],
        yAxisColumnDetails = [],
        colorByData = [],
    } = dataColumns;
    var allToolTips = Object.keys(toolTip);

    console.log("Debug: tooltip", allToolTips);

    var i = 0,
        k = 0;
    while (i < xAxisColumnDetails.length) {
        var obj = {
            itemName: xAxisColumnDetails[i].itemName,
            dataValue: toolTip["textColumn" + (i + 1)],
            textLabel: "textColumn" + (i + 1),
        };
        console.log("debug: tooltip", JSON.stringify(obj));
        tempXModel.append(obj);
        i++;
    }
    k = i;
    while (i < xAxisColumnDetails.length + yAxisColumnDetails.length) {
        var obj = {
            itemName: yAxisColumnDetails[i - k].itemName,
            dataValue: toolTip["textColumn" + (i + 1)],
            textLabel: "textColumn" + (i + 1),
        };
        console.log("debug: tooltip", JSON.stringify(obj));
        tempYModel.append(obj);
        i++;
    }
    k = i;
    while (
        i <
        xAxisColumnDetails.length +
            yAxisColumnDetails.length +
            colorByData.length
    ) {
        var obj = {
            itemName: colorByData[0].itemName,
            dataValue: toolTip["colorData"],
            textLabel: "textColumn" + (i + 1),
        };
        console.log("debug: tooltip", JSON.stringify(obj));
        tempColorByModel.append(obj);
        i++;
    }

    d3PropertyConfig.toolTip = toolTip;
    reDrawChart();
}

function addReport(titleName) {
    // Add report to dashboard
    //       if(!ReportParamsModel.editReportToggle || ReportParamsModel.editReportToggle  == "false" || ReportParamsModel.editReportToggle == "-1"){
    //            reportIdMain = generateReportId();
    //            ReportParamsModel.setReportId(reportIdMain);
    //       }

    addReportClicked = true;
    stacklayout_home.currentIndex = Constants.dashboardDesignerIndex;

    let currentDashboard = DashboardParamsModel.currentDashboard;

    // [Tag: Optimization]
    // We can create the object here and pass to cpp
    // to store in reportsMap

    // Save add the data in cpp
    // get the data in cpp and create an object

    // Check if report name exists or not
    // If name is not given add the name as Report "NUMBER"
    // Else is  not required (Case to set the value, because it is getting saved on key presses)
    if (typeof titleName === "undefined" || titleName.length <= 0) {
        var numberOfReports = ReportParamsModel.reportsCount();
        ReportParamsModel.setReportTitle("Report " + numberOfReports);
    } else {
        ReportParamsModel.setReportTitle(titleName);
    }

    ReportParamsModel.setChartType(chartTitle);
    ReportParamsModel.setChartTitle(chartTitle);
    ReportParamsModel.setD3PropertiesConfig(JSON.stringify(d3PropertyConfig));
    qmlChartConfig.activeChartIndex = activeChartIndex;
    qmlChartConfig.customizationsAvailable = customizationsAvailable;
    qmlChartConfig.subMenuCustomizationsAvailable =
        subMenuCustomizationsAvailable;
    ReportParamsModel.setQmlChartConfig(JSON.stringify(qmlChartConfig));
    ReportParamsModel.setOptionalConfig(JSON.stringify(optionalParams));
    ReportParamsModel.setChartUrl(report_desiner_page.chartUrl);
    ReportParamsModel.setXAxisColumns(
        JSON.stringify(getAxisModelAsJson(Constants.xAxisName))
    );
    ReportParamsModel.setYAxisColumns(
        JSON.stringify(getAxisModelAsJson(Constants.yAxisName))
    );
    ReportParamsModel.setRow3Columns(
        JSON.stringify(getAxisModelAsJson(Constants.row3Name))
    );
    ReportParamsModel.setColorByDataColoumns(JSON.stringify(colorByData));

    ReportParamsModel.addReport(reportIdMain);
    ChartsConfig.resetQmlChartConfig();

    // Reset after chart is added
    input1Field.text = "";
    input2Field.text = "";
    input3Field.text = "";
    isHorizontalGraph = false;

    chartTitle = Constants.barChartTitle;
    // chartUrl = Constants.barChartUrl;

    console.log("Editing Flag?", editReportFlag);
    // On Edit => Redraw Only Updated chart in Dashboard
    if (editReportFlag) {
        reDrawDashboardChart(reportIdMain);
    }
    editReportFlag = false;

    tempXModel.clear();
    tempYModel.clear();
    tempColorByModel.clear();

    // Setting it to -1 so that editReportToggle signal is called
    // After this editReportToggle is set to false
    // Gets called again which creates a new id and add it to map
    ReportParamsModel.setEditReportToggle("-1");

    // switchChart(Constants.barChartTitle);
}

function cancelReport() {
    // Back to dashboard
    GeneralParamsModel.setCurrentScreen(Constants.dashboardScreen);
    stacklayout_home.currentIndex = Constants.dashboardDesignerIndex;
    // ReportsDataModel.removeTmpChartData()

    if (addReportButton.text == Messages.addBtnTxt) {
        console.log("Deleting Report", reportIdMain);
        ReportParamsModel.deleteReport(reportIdMain, false);
    } else {
        ReportParamsModel.setEditReportToggle("0");
    }

    clearValuesOnAddNewReport();
    ChartsConfig.resetQmlChartConfig();

    input1Field.text = "";
    input2Field.text = "";
    input3Field.text = "";

    let currentDashboard = DashboardParamsModel.currentDashboard;
}
