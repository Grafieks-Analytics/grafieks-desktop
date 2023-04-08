// const orb = require("orb");
const { getChartsDiv } = require("../utils");

function setTopLeftColumnThemeColor(theme) {
    var themeCss = "";
    switch (theme) {
        case "flower":
            themeCss = `.custom-left-top-menu td{
                border-left: 0.5px solid #d3a4e3;
                border-top: 0.5px solid #d3a4e3;
            }`;
            break;
        case "black":
            themeCss = `.custom-left-top-menu td{
                border-left: 0.5px solid #7f7f7f;
                border-top: 0.5px solid #7f7f7f;
            }`;
            break;
        case "white":
            themeCss = `.custom-left-top-menu td{
            border-left: 0.5px solid #e6e6e6;
            border-top: 0.5px solid #e6e6e6;
        }`;
            break;
        case "red":
            themeCss = `.custom-left-top-menu td{
                border-left: 0.5px solid #e395a3;
                border-top: 0.5px solid #e395a3;
            }`;
            break;

        case "green":
            themeCss = `.custom-left-top-menu td{
                border-left: 0.5px solid #9fda8b;
                border-top: 0.5px solid #9fda8b;
            }`;
            break;

        case "orange":
            themeCss = `.custom-left-top-menu td{
                    border-left: 0.5px solid #efb48c;
                    border-top: 0.5px solid #efb48c;
                }`;
            break;
        default:
            themeCss = `.custom-left-top-menu td{
                border-left: 0.5px solid #addfee;
                border-top: 0.5px solid #addfee;
            }`;
    }
    var themeColor = document.getElementById("themeId");
    if (themeColor) {
        themeColor.remove();
    }
    var themeStyleTag = document.createElement("style");
    themeStyleTag.id = "themeId";
    themeStyleTag.innerHTML = themeCss;
    document.head.append(themeStyleTag);
}

function refreshData() {
    pgridwidget.refreshData(window.demo.data);
}

function changeTheme() {
    pgridwidget.changeTheme("bootstrap");
}

function exportToExcel(anchor) {
    document.querySelector(".export-xls").click();
    // anchor.href = orb.export(pgridwidget);
    // return true;
}

function changeThemeColour(themeColor) {
    config.theme = themeColor.toLowerCase();
    pivotChartGeneration();
}

function clipLetters(td) {
    var width = td.style.width;
    width = +width.substr(0, width.length - 2);
    var clientWidth = td.clientWidth;
    console.log({ width, clientWidth });
    if (clientWidth > width) {
        console.log("Clipping..");
        // single character width = total width / length of character
        var singleCharacterLength = parseInt(clientWidth / td.innerText.length);
        var maxAllowedCharacters = parseInt(width / singleCharacterLength);

        var subString = td.getAttribute("data-text").substr(0, maxAllowedCharacters - 4);
        console.log(singleCharacterLength);
        subString += "...";
        td.innerText = subString;
    }
}

const pivotChartGeneration = () => {
    const grafieks = window.grafieks;
    grafieks.utils.changeThemeColour = changeThemeColour;
    const data = grafieks.dataUtils.rawData || [];
    const [dataSource, totalRows, fieldsTemp, rowColumnsValues] = data;

    const [rows, columns, dataKeys] = rowColumnsValues;

    const {
        columnWiseGrandTotal,
        rowWiseGrandTotal,
        subTotalVisible,
        pivotTheme = "blue"
    } = grafieks.plotConfiguration;

    const chartsDiv = getChartsDiv();
    const element = document.createElement("div");
    element.id = "pivotDiv";
    chartsDiv.node().append(element);

    const fields = fieldsTemp.map((d, i) => {
        return { name: i.toString(), caption: d };
    });

    let defaultConfig = {
        canMoveFields: false,
        dataHeadersLocation: "columns",
        theme: "blue",
        toolbar: {
            visible: true
        },
        subTotal: {
            visible: true,
            collapsed: false,
            collapsible: false
        }
    };

    config = {
        ...defaultConfig,
        width: window.innerWidth - 20,
        height: window.innerHeight + 40,
        dataSource,
        fields,
        theme: pivotTheme.toLowerCase(),
        grandTotal: {
            rowsvisible: !!rowWiseGrandTotal,
            columnsvisible: !!columnWiseGrandTotal
        },
        subTotal: {
            visible: !!subTotalVisible,
            collapsed: false,
            collapsible: false
        },
        rows,
        columns,
        data: dataKeys
    };

    console.log(data);

    pgridwidget = new orb.pgridwidget(config);
    pgridwidget.render(element);

    const { theme } = config;

    setTopLeftColumnThemeColor(theme);

    var outerTableBody = document.querySelector("table tbody");
    var menuFieldDataRow0 = outerTableBody.children[1];
    menuFieldDataRow0.style.display = "none";

    var menuFieldDataRow = outerTableBody.children[2];
    // time to clear it
    var menuFieldDataFirstCloumn = menuFieldDataRow.firstElementChild;

    var innerValues = menuFieldDataFirstCloumn.querySelectorAll("div");
    var dataValues = [];
    Array.from(innerValues).forEach((element) => {
        if (!element.innerText || element.className.includes("drp-trgt")) {
            return;
        }
        dataValues.push(element.innerText.trim());
    });
    var widthPercentage = (1 / dataValues.length) * 100;
    var tableHtml = "";

    var innerTableColumns = document.querySelector(".rows-cntr .inner-table tbody");
    var headerColumns = innerTableColumns.firstElementChild.children;
    var widths = Array.from(headerColumns).map((d) => {
        return d.clientWidth;
    });

    dataValues.forEach((d, i) => {
        tableHtml +=
            "<td class='header-st custom-tds' data-text='" + d + "' style='width: " + widths[i] + "px'>" + d + "</td>";
    });

    tableHtml =
        "<table class='ord-" +
        theme +
        " custom-left-top-menu' style='width: 100%;'><tr class='orb'>" +
        tableHtml +
        "</tr></table>";

    menuFieldDataFirstCloumn.innerHTML = tableHtml;

    var tds = document.querySelectorAll(".custom-tds");
    Array.from(tds).forEach((td) => {
        clipLetters(td);
    });

    document.querySelector(".custom-left-top-menu").style.height = menuFieldDataFirstCloumn.clientHeight + 0.72 + "px";

    var innerTableContainerColumns = document.querySelector(".columns-cntr");
    var tableColumns = innerTableContainerColumns.firstElementChild;
    var tableParentColumns = innerTableContainerColumns.parentElement;

    var innerTableContainerData = document.querySelector(".data-cntr");
    var tableData = innerTableContainerData.firstElementChild;
    var tableParentData = innerTableContainerData.parentElement;

    var columnWidth = innerTableContainerColumns.style.width;
    columnWidth = columnWidth && columnWidth.replace("px", "");

    var customTopWidth = document.querySelector(".custom-left-top-menu tr").clientWidth;

    if (+columnWidth + customTopWidth + 36 < window.innerWidth) {
        console.log("Setting widths!");
        innerTableContainerColumns.style.width = "100%";
        tableColumns.style.width = "100%";
        tableParentColumns.style.width = "100%";

        innerTableContainerData.style.width = "100%";
        tableData.style.width = "100%";
        tableParentData.style.width = "100%";
    }
};

module.exports = pivotChartGeneration;

/*

[
    [
        ["Furniture", "South", 117298.71875],
        ["Office Supplies", "West", 220853.265625],
        ["Office Supplies", "South", 125651.3125],
        ["Furniture", "West", 252612.984375],
        ["Technology", "West", 251991.546875],
        ["Office Supplies", "Central", 167026.515625],
        ["Furniture", "East", 208291.125],
        ["Office Supplies", "East", 205516.15625],
        ["Technology", "Central", 170416.28125],
        ["Furniture", "Central", 163797.15625],
        ["Technology", "East", 264973.8125],
        ["Technology", "South", 148771.828125]
    ],
    ["", "", 2297221.75],
    ["Category", "Region", "Sales"],
    [["Category"], ["Region"], ["Sales"]]
]


*/
