const d3 = require("d3");

const CONSTANTS = require("../constants");

const { getPageWidth, getPageHeight } = require("../utils");

function setAxisLabels() {
    let {
        // font size
        xTickfontSize = CONSTANTS.defaultValues.fontSize,
        yTickfontSize = CONSTANTS.defaultValues.fontSize,
        // font family
        xTickfontFamily = CONSTANTS.defaultValues.fontFamily,
        yTickfontFamily = CONSTANTS.defaultValues.fontFamily,
        // font color
        xTickfontColor = CONSTANTS.defaultValues.fontColor,
        yTickfontColor = CONSTANTS.defaultValues.fontColor
    } = grafieks.plotConfiguration;

    d3.selectAll(".axisLabel")
        .style("font-size", xTickfontSize)
        .style("font-family", xTickfontFamily)
        .attr("fill", xTickfontColor);

    d3.selectAll(".axis text")
        .style("font-size", yTickfontSize)
        .style("font-family", yTickfontFamily)
        .attr("fill", yTickfontColor);
}

function RadarChart(id, data, options) {
    var cfg = {
        w: 600, //Width of the circle
        h: 600, //Height of the circle
        margin: { top: 20, right: 20, bottom: 20, left: 20 }, //The margins of the SVG
        levels: 3, //How many levels or inner circles should there be drawn
        maxValue: 0, //What is the value that the biggest circle will represent
        labelFactor: 1.25, //How much farther than the radius of the outer circle should the labels be placed
        wrapWidth: 60, //The number of pixels after which a label needs to be given a new line
        opacityArea: 0.35, //The opacity of the area of the blob
        dotRadius: 4, //The size of the colored circles of each blog
        opacityCircles: 0.1, //The opacity of the circles of each blob
        strokeWidth: 2, //The width of the stroke around each blob
        roundStrokes: false, //If true the area and stroke will follow a round path (cardinal-closed)
        color: d3.schemeCategory10 //Color function
    };

    // console.log(options)
    // console.log(label)
    //Put all of the options into a variable called cfg
    if ("undefined" !== typeof options) {
        for (var i in options) {
            if ("undefined" !== typeof options[i]) {
                cfg[i] = options[i];
            }
        } //for i
    } //if

    console.log(cfg);
    //If the supplied maxValue is smaller than the actual one, replace by the max in the data
    var maxValue = Math.max(
        cfg.maxValue,
        d3.max(data, function (i) {
            return d3.max(
                i.map(function (o) {
                    return o.value;
                })
            );
        })
    );
    var minValue = Math.min(
        0,
        d3.min(data, function (i) {
            return d3.min(
                i.map(function (o) {
                    return o.value;
                })
            );
        })
    );

    var allAxis = data[0].map(function (i, j) {
            return i.axis;
        }), //Names of each axis
        total = allAxis.length, //The number of different axes
        radius = Math.min(cfg.w / 2, cfg.h / 2), //Radius of the outermost circle
        angleSlice = (Math.PI * 2) / total; //The width in radians of each "slice"

    var chartDomain = Math.max(Math.abs(minValue), Math.abs(maxValue));

    //Scale for the radius
    var rScale = d3.scaleLinear().range([0, radius]).domain([-chartDomain, chartDomain]);

    /*********************************************************/
    /**********  Create the container SVG and g **************/
    /*********************************************************/

    //Remove whatever chart with the same id/class was present before
    d3.select(id).select("svg").remove();

    //Initiate the radar chart SVG
    var svg = d3
        .select(id)
        .append("svg")
        .attr("width", cfg.w + cfg.margin.left + cfg.margin.right)
        .attr("height", cfg.h + cfg.margin.top + cfg.margin.bottom)
        .attr("class", "radar" + id);
    //Append a g element
    var g = svg
        .append("g")
        .attr("transform", "translate(" + (cfg.w / 2 + cfg.margin.left) + "," + (cfg.h / 2 + cfg.margin.top) + ")");

    /*********************************************************/
    /**************** Draw the Circular grid *****************/
    /*********************************************************/

    //Wrapper for the grid & axes
    var axisGrid = g.append("g").attr("class", "axisWrapper");
    //Draw the background circles
    axisGrid
        .selectAll(".levels")
        .data(d3.range(1, cfg.levels + 1).reverse())
        .enter()
        .append("circle")
        .attr("class", "gridCircle")
        .attr("r", function (d, i) {
            return (radius / cfg.levels) * d;
        })
        .style("fill", "#fff")
        .style("stroke", "lightgrey")
        .style("fill-opacity", cfg.opacityCircles);

    //Text indicating at what % each level is
    axisGrid
        .selectAll(".axisLabel")
        .data(d3.range(1, cfg.levels + 1).reverse())
        .enter()
        .append("text")
        .attr("class", "axisLabel")
        .attr("x", 4)
        .attr("y", function (d) {
            return (-d * radius) / cfg.levels;
        })
        .attr("dy", "0.4em")
        .style("font-size", "10px")
        .attr("fill", "#737373")
        .text(function (d, i) {
            // return Format((maxValue * d) / cfg.levels);
            if (minValue < 0) {
                if (i < cfg.levels / 2) {
                    return Math.round((chartDomain * (d - i)) / cfg.levels);
                }
                if (i == cfg.levels / 2) {
                    return 0;
                }
                return Math.round(-((chartDomain * (i - d)) / cfg.levels));
            }
            return Math.round((chartDomain * d) / cfg.levels);
        });

    /////////////////////////////////////////////////////////
    //////////////////// Draw the axes //////////////////////
    /////////////////////////////////////////////////////////

    //Create the straight lines radiating outward from the center
    var axis = axisGrid.selectAll(".axis").data(allAxis).enter().append("g").attr("class", "axis");
    //Append the lines
    axis.append("line")
        .attr("x1", 0)
        .attr("y1", 0)
        .attr("x2", function (d, i) {
            return rScale(chartDomain * 1.1) * Math.cos(angleSlice * i - Math.PI / 2);
        })
        .attr("y2", function (d, i) {
            return rScale(chartDomain * 1.1) * Math.sin(angleSlice * i - Math.PI / 2);
        })
        .attr("class", "line");

    //Append the labels at each axis
    axis.append("text")
        // .attr("class", "legend")
        .style("font-size", "10px")
        .attr("text-anchor", "middle")
        .attr("dy", "0.35em")
        .attr("x", function (d, i) {
            return rScale(chartDomain * cfg.labelFactor) * Math.cos(angleSlice * i - Math.PI / 2);
        })
        .attr("y", function (d, i) {
            return rScale(chartDomain * cfg.labelFactor) * Math.sin(angleSlice * i - Math.PI / 2);
        })
        .text(function (d) {
            return d;
        })
        .call(wrap, cfg.wrapWidth);

    /////////////////////////////////////////////////////////
    ///////////// Draw the radar chart blobs ////////////////
    /////////////////////////////////////////////////////////

    //The radial line function
    var radarLine = d3
        .lineRadial()
        .curve(d3.curveCardinalClosed)
        .radius(function (d) {
            return rScale(d.value);
        })
        .angle(function (d, i) {
            return i * angleSlice;
        });

    if (cfg.roundStrokes) {
        radarLine.curve(d3.curveCardinalClosed);
    }

    //Create a wrapper for the blobs
    var blobWrapper = g.selectAll(".radarWrapper").data(data).enter().append("g").attr("class", "radarWrapper");

    //Append the backgrounds
    blobWrapper
        .append("path")
        .attr("class", "radarArea")
        .attr("d", function (d, i) {
            return radarLine(d);
        })
        .style("fill", function (d, i) {
            return cfg.color(i);
        })
        .style("fill-opacity", cfg.opacityArea);

    //Create the outlines
    blobWrapper
        .append("path")
        .attr("class", "radarStroke")
        .attr("d", function (d, i) {
            return radarLine(d);
        })
        .style("stroke", function (d, i) {
            return cfg.color(i);
        })
        .style("fill", "none");

    //Append the circles
    blobWrapper
        .selectAll(".radarCircle")
        .data(function (d, i) {
            return d;
        })
        .enter()
        .append("circle")
        .attr("class", "radarCircle")
        .attr("r", cfg.dotRadius)
        .attr("cx", function (d, i) {
            if (d.value < 0) {
                return rScale(d.value) * Math.cos(angleSlice * i + Math.PI / 2);
            }
            return rScale(d.value) * Math.cos(angleSlice * i - Math.PI / 2);
        })
        .attr("cy", function (d, i) {
            if (d.value < 0) {
                return rScale(d.value) * Math.sin(angleSlice * i + Math.PI / 2);
            }
            return rScale(d.value) * Math.sin(angleSlice * i - Math.PI / 2);
        })
        .style("fill", function (d, i, j) {
            return cfg.color(j);
        })
        .style("fill-opacity", 0.8);

    /////////////////////////////////////////////////////////
    //////// Append invisible circles for tooltip ///////////
    /////////////////////////////////////////////////////////

    //Wrapper for the invisible circles on top
    var blobCircleWrapper = g
        .selectAll(".radarCircleWrapper")
        .data(data)
        .enter()
        .append("g")
        .attr("class", "radarCircleWrapper");

    //Append a set of invisible circles on top for the mouseover pop-up
    blobCircleWrapper
        .selectAll(".radarInvisibleCircle")
        .data(function (d, i) {
            return d;
        })
        .enter()
        .append("circle")
        .attr("class", "radarInvisibleCircle visualPlotting")
        .attr("r", 10)
        .attr("cx", function (d, i) {
            console.log(d);
            this.setAttribute("data-value-x1", d.axis);
            this.setAttribute("data-value-y1", d.value);
            if (d.value < 0) {
                return rScale(d.value) * Math.cos(angleSlice * i + Math.PI / 2);
            }
            return rScale(d.value) * Math.cos(angleSlice * i - Math.PI / 2);
        })
        .attr("cy", function (d, i) {
            if (d.value < 0) {
                return rScale(d.value) * Math.sin(angleSlice * i + Math.PI / 2);
            }
            return rScale(d.value) * Math.sin(angleSlice * i - Math.PI / 2);
        })
        .style("fill", "none")
        .style("pointer-events", "all");

    /////////////////////////////////////////////////////////
    /////////////////// Helper Function /////////////////////
    /////////////////////////////////////////////////////////

    //Taken from http://bl.ocks.org/mbostock/7555321
    //Wraps SVG text
    function wrap(text, width) {
        text.each(function () {
            var text = d3.select(this),
                words = text.text().split(/\s+/).reverse(),
                word,
                line = [],
                lineNumber = 0,
                lineHeight = 1.4, // ems
                y = text.attr("y"),
                x = text.attr("x"),
                dy = parseFloat(text.attr("dy")),
                tspan = text
                    .text(null)
                    .append("tspan")
                    .attr("x", x)
                    .attr("y", y)
                    .attr("dy", dy + "em");

            while ((word = words.pop())) {
                line.push(word);
                tspan.text(line.join(" "));
                if (tspan.node().getComputedTextLength() > width) {
                    line.pop();
                    tspan.text(line.join(" "));
                    line = [word];
                    tspan = text
                        .append("tspan")
                        .attr("x", x)
                        .attr("y", y)
                        .attr("dy", ++lineNumber * lineHeight + dy + "em")
                        .text(word);
                }
            }
        });
    } //wrap
} //RadarChart

const chartGeneration = () => {
    const data = grafieks.dataUtils.rawData;

    let [dataValues = [], dataLabels = []] = data;
    dataValues = [dataValues];

    grafieks.dataUtils.dataValues = dataValues;
    grafieks.dataUtils.dataLabels = dataLabels;

    let { d3colorPalette = CONSTANTS.d3ColorPalette } = grafieks.plotConfiguration;

    const margin = { top: 100, right: 100, bottom: 100, left: 100 };
    const width = window.innerWidth - margin.left - margin.right - 20;
    const height = window.innerHeight - margin.top - margin.bottom - 20;

    const color = d3.scaleOrdinal().range(d3colorPalette);

    radius = Math.min(width / 2, height / 2);

    if (window.innerWidth < 700 || window.innerHeight < 700) {
        radius = Math.min(width, height);
    }

    if (radius < 0) {
        radius = 2;
    }

    var radarChartOptions = {
        w: width,
        h: height,
        margin,
        maxValue: 0,
        levels: 6,
        roundStrokes: true,
        color: color,
        radius
    };

    RadarChart(".charts-div", dataValues, radarChartOptions);
    setAxisLabels();
};

module.exports = chartGeneration;
