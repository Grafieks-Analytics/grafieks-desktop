// On loading the page
// This function is called on every state change of webEngineView
function onGrafieksChartPageLoaded(loadRequest) {
    if (loadRequest.status === WebEngineLoadRequest.LoadFailedStatus) {
        console.log("Page Loading Failed: Error", JSON.stringify(loadRequest));
        return;
    }
    reDrawChart();
}

// Clear the chart defaults
function clearChartValue() {
    webEngineView.runJavaScript(
        "window.grafieks && window.grafieks.utils.clearChart(); " +
            "if(window.grafieks && grafieks.dataUtils && grafieks.dataUtils.rawData){ grafieks.dataUtils.rawData = [] }"
    );
}

function isWebEngineLoading() {
    return webEngineView.loading;
}

function updateChart(d3PropertyConfig) {
    console.log(
        "[Updatde " + d3PropertyConfig.chartName + "] d3PropertyConfig : ",
        chartTitle,
        JSON.stringify(d3PropertyConfig)
    );
    if (d3PropertyConfig.chartName != chartTitle) {
        delete d3PropertyConfig.chartName;
        clearChartValue();
        return;
    }

    // In case of update, we take data from window
    // get data from window => grafieks.dataUtils.rawData
    // pass updated d3Config from qml => This value is saved in the frontend
    // grafieks.drawChart(grafieks.dataUtils.rawData, d3PropertyConfig)

    var runScriptString =
        "window.grafieks && window.grafieks.utils.clearChart();" +
        "window.grafieks && grafieks.drawChart(grafieks.dataUtils.rawData," +
        JSON.stringify(d3PropertyConfig) +
        ");";

    webEngineView.runJavaScript(runScriptString);
}

function startPlottingChart(dataValues, d3PropertyConfig) {
    console.log(
        "[Plotting ",
        d3PropertyConfig.chartName + "] d3PropertyConfig",
        JSON.stringify(d3PropertyConfig)
    );

    // When we start plotting,
    // Clear the chart
    // Set the dataTransformed flag to false ==> So that date wala thing is transformed again
    // Pass the new data values to the frontend
    // frontend stores it in window => grafieks.dataUtils.rawData
    // pass updated d3Config from qml => This value is also saved in grafieks.plotConfiguration

    var runScriptString =
        "window.grafieks && grafieks.utils.clearChart(); " + // Clear Chart
        "grafieks.flags.isDataTransformed = false;" + // Set Data Transformed to false
        "grafieks.drawChart(" +
        dataValues +
        "," +
        JSON.stringify(d3PropertyConfig) +
        "); ";

    webEngineView.runJavaScript(runScriptString);
}
