const utils = require("../utils");

const tableId = "example";

const defaultTableChartConfig = {
    defaultCellBorderStatus: true,
    defaultCellHoverStatus: true,
    defaultCompactStatus: false,
    defaultSearchStatus: true,
    defaultGrandTotalStatus: true,
    defaultRowAlternateStatus: true,
    defaultBatchsize: 50
};

function init() {
    utils.getChartsDiv().node().innerHTML = `<table id="${tableId}" class="ui celled table very compact">
                <thead></thead>
                <tbody></tbody>
                <tfoot></tfoot>
            </table>`;
}

function setCompact(compactStatus) {
    if (compactStatus) {
        document.querySelector("table").classList.add("compact");
    } else {
        document.querySelector("table").classList.remove("compact");
    }
}
function grandTotalStatus(totalStatus, hasNumerical) {
    if (totalStatus) {
        document.querySelectorAll(".tabulator-footer").forEach((e) => {
            e.style.display = "block";
        });
        setTimeout(function () {
            var totalFooter = document.querySelector(".tabulator-footer .tabulator-cell");
            if (totalFooter && hasNumerical) {
                totalFooter.innerHTML = "<b>Grand Total</b>";
            }
        }, 0);
    } else {
        document.querySelectorAll(".tabulator-footer").forEach((e) => {
            e.style.display = "none";
        });
    }
}

function addCellBorder() {
    document.querySelector("#cellBorderStyle") && document.querySelector("#cellBorderStyle").remove();
}

function removeCellBorder() {
    addCellBorder();
    var styleTag = document.createElement("style");
    styleTag.id = "cellBorderStyle";
    styleTag.innerHTML = " td{ border: 0 !important; }";
    document.head.appendChild(styleTag);
}

function removeHoverBackground() {
    document.querySelector("#cellHoverStyle") && document.querySelector("#cellHoverStyle").remove();
}

function addHoverBackground() {
    var styleTag = document.createElement("style");
    styleTag.id = "cellHoverStyle";
    styleTag.innerHTML = ".tabulator-row.tabulator-selectable:hover { background-color: #d9d9d988; }";
    document.head.appendChild(styleTag);
}

function removeRowAlternateColor() {
    document.querySelector("#alternateRow") && document.querySelector("#alternateRow").remove();
}

function addRowAlternateColor() {
    if (document.querySelector("#alternateRow")) {
        return;
    }
    var styleTag = document.createElement("style");
    styleTag.id = "alternateRow";
    styleTag.innerHTML = ".tabulator-row-odd { background-color: #d9d9d933; }";
    document.head.appendChild(styleTag);
}

const chartGeneration = () => {
    const data = grafieks.dataUtils.rawData;
    window.data = data;

    init();

    let {
        defaultCellBorderStatus,
        defaultCellHoverStatus,
        defaultCompactStatus,
        defaultSearchStatus,
        defaultRowAlternateStatus,
        defaultBatchsize,
        defaultGrandTotalStatus
    } = defaultTableChartConfig;

    let {
        cellBorderStatus = defaultCellBorderStatus,
        hoverStatus = defaultCellHoverStatus,
        compactStatus = defaultCompactStatus,
        searchStatus = defaultSearchStatus,
        rowAlternateStatus = defaultRowAlternateStatus,
        batchSize = defaultBatchsize,
        rowWiseGrandTotal: totalStatus = defaultGrandTotalStatus
    } = grafieks.plotConfiguration;

    if (!cellBorderStatus) {
        removeCellBorder();
    } else {
        addCellBorder();
    }

    if (hoverStatus) {
        addHoverBackground();
    } else {
        removeHoverBackground();
    }

    if (rowAlternateStatus) {
        addRowAlternateColor();
    } else {
        removeRowAlternateColor();
    }

    setCompact(compactStatus);

    var hasNumerical = false;

    var minMaxFilterEditor = function (cell, onRendered, success, cancel, editorParams) {
        var end;

        var container = document.createElement("span");

        //create and style inputs
        var start = document.createElement("input");
        start.setAttribute("type", "number");
        start.setAttribute("placeholder", "Min");

        start.style.padding = "4px";
        start.style.width = "50%";
        start.style.boxSizing = "border-box";

        start.value = cell.getValue();

        function buildValues() {
            success({
                start: start.value,
                end: end.value
            });
        }

        function keypress(e) {
            if (e.keyCode == 13) {
                buildValues();
            }

            if (e.keyCode == 27) {
                cancel();
            }
        }

        end = start.cloneNode();
        end.setAttribute("placeholder", "Max");

        start.addEventListener("change", buildValues);
        start.addEventListener("blur", buildValues);
        start.addEventListener("keydown", keypress);

        end.addEventListener("change", buildValues);
        end.addEventListener("blur", buildValues);
        end.addEventListener("keydown", keypress);

        container.appendChild(start);
        container.appendChild(end);

        return container;
    };

    //custom max min filter function
    function minMaxFilterFunction(headerValue, rowValue, rowData, filterParams) {
        //headerValue - the value of the header filter element
        //rowValue - the value of the column in this row
        //rowData - the data for the row being filtered
        //filterParams - params object passed to the headerFilterFuncParams property

        if (rowValue) {
            if (headerValue.start != "") {
                if (headerValue.end != "") {
                    return rowValue >= headerValue.start && rowValue <= headerValue.end;
                } else {
                    return rowValue >= headerValue.start;
                }
            } else {
                if (headerValue.end != "") {
                    return rowValue <= headerValue.end;
                }
            }
        }

        return true; //must return a boolean, true if it passes the filter.
    }

    var table = new Tabulator(`#${tableId}`, {
        layout: "fitColumns",
        height: "calc(100vh - 26px)",
        movableColumns: true,
        columns: data[2].map((d, i) => {
            var obj = { title: d, field: d };
            if (data[1][i] !== "") {
                console.log("Value", data[1][i]);
                obj["bottomCalc"] = "sum";

                if (searchStatus) {
                    obj.headerFilter = minMaxFilterEditor;
                    obj.headerFilterFunc = minMaxFilterFunction;
                    obj.headerFilterLiveFilter = false;
                }

                if (!hasNumerical) {
                    hasNumerical = true;
                }
            } else {
                if (searchStatus) {
                    obj.headerFilter = "input";
                }
            }
            return obj;
        })
    });

    setTimeout(function () {
        table.setData(data[0]);
        grandTotalStatus(totalStatus, hasNumerical);
    }, 0);
};

module.exports = chartGeneration;
