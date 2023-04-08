const d3 = require("d3");

const gauge = function (container, configuration) {
    var that = {};
    var config = {
        size: 100,
        clipWidth: window.innerWidth,
        clipHeight: window.innerHeight,
        ringInset: 20,
        ringWidth: 20,

        pointerWidth: 10,
        pointerTailLength: 5,
        pointerHeadLengthPercent: 0.9,

        minValue: 0,
        maxValue: 20,

        minAngle: -90,
        maxAngle: 90,

        transitionMs: 750,

        majorTicks: 3,
        labelFormat: d3.format(".1s"),
        labelInset: 30,

        arcColorFn: d3.interpolateHsl(d3.rgb("#b3de69"), d3.rgb("#fccde5"))
    };
    var range = undefined;
    var r = undefined;
    var pointerHeadLength = undefined;
    var value = 0;

    var svg = undefined;
    var arc = undefined;
    var scale = undefined;
    var ticks = undefined;
    var tickData = undefined;
    var pointer = undefined;

    function deg2rad(deg) {
        return (deg * Math.PI) / 180;
    }

    function newAngle(d) {
        var ratio = scale(d);
        var newAngle = config.minAngle + ratio * range;
        return newAngle;
    }

    function configure(configuration) {
        var prop = undefined;
        for (prop in configuration) {
            config[prop] = configuration[prop];
        }

        range = config.maxAngle - config.minAngle;
        r = config.size / 2;
        pointerHeadLength = Math.round(r * config.pointerHeadLengthPercent);

        // a linear scale that maps domain values to a percent from 0..1
        scale = d3.scaleLinear().range([0, 1]).domain([config.minValue, config.maxValue]);

        ticks = scale.ticks(config.majorTicks);
        console.log("ticks", ticks);

        const { maxValue, redValue, yellowValue } = config;

        tickData = [redValue / maxValue, (yellowValue - redValue) / maxValue, (maxValue - yellowValue) / maxValue];
        var covered = 0;

        arc = d3
            .arc()
            .innerRadius(r - config.ringWidth - config.ringInset)
            .outerRadius(r - config.ringInset)
            .startAngle(function (d, i) {
                var ratio = covered;
                covered += d;
                return deg2rad(config.minAngle + ratio * range);
            })
            .endAngle(function (d, i) {
                return deg2rad(config.minAngle + covered * range);
            });
    }
    that.configure = configure;

    function centerTranslation() {
        let yPos = window.innerHeight * 0.1;
        return "translate(" + (r + 15) + "," + (r + yPos) + ")";
    }

    function isRendered() {
        return svg !== undefined;
    }
    that.isRendered = isRendered;

    function render(newValue) {
        svg = d3
            .select(container)
            .append("svg:svg")
            .attr("class", "gauge")
            .attr("width", config.clipWidth + 20)
            .attr("height", config.clipHeight + 20);

        var centerTx = centerTranslation();

        var arcs = svg.append("g").attr("class", "arc").attr("transform", centerTx);

        const constants = { redColor: "#E15759", yellowColor: "#EDC949", greenColor: "#59A14F" };

        arcs.selectAll("path")
            .data(tickData)
            .enter()
            .append("path")
            .attr("class", function (d, i) {
                switch (i) {
                    case 0:
                        return "red";
                    case 1:
                        return "yellow";
                    case 2:
                        return "green";
                }
            })
            .attr("fill", function (d, i) {
                switch (i) {
                    case 0:
                        return constants.redColor;
                    case 1:
                        return constants.yellowColor;
                    case 2:
                        return constants.greenColor;
                }
            })
            .attr("d", arc);

        var lg = svg.append("g").attr("class", "gaugeLabel").attr("transform", centerTx);

        const { maxValue, redValue, yellowValue } = config;

        ticks = [ticks[0], redValue, yellowValue, maxValue];
        console.log("ticks", ticks);

        lg.selectAll("text")
            .data(ticks)
            .enter()
            .append("text")
            .attr("transform", function (d, i) {
                var ratio = scale(d);
                var newAngle = config.minAngle + ratio * range;
                console.log(d, ratio, newAngle);
                if (!i) {
                    this.setAttribute("x", config.labelInset - r);
                    this.setAttribute("y", 25);
                    // this.setAttribute('tick-position', 'start')
                    return null;
                }
                if (i == ticks.length - 1) {
                    this.setAttribute("x", config.labelInset + r + 10);
                    this.setAttribute("tick-position", "end");
                    this.setAttribute("class", "lastTick");
                    return null;
                }
                return "rotate(" + newAngle + ") translate(0," + (config.labelInset - r - 20) + ")";
            })
            .text(config.labelFormat);

        var endTicks = document.querySelectorAll("[tick-position]");
        endTicks.forEach((tick) => {
            console.log(tick);
            if (tick.getAttribute("tick-position") == "end") {
                var xPositon = +tick.getAttribute("x");
                var width = tick.getBBox().width;
                tick.setAttribute("x", xPositon - width - 60);
                tick.setAttribute("y", 25);
            }
        });

        var lineData = [
            [config.pointerWidth / 2, 0],
            [0, -pointerHeadLength],
            [-(config.pointerWidth / 2), 0],
            [0, config.pointerTailLength],
            [config.pointerWidth / 2, 0]
        ];
        var pointerLine = d3.line().curve(d3.curveMonotoneX);
        var pg = svg.append("g").data([lineData]).attr("class", "pointer").attr("transform", centerTx);

        pointer = pg
            .append("path")
            .attr("d", pointerLine /*function(d) { return pointerLine(d) +'Z';}*/)
            .attr("transform", "rotate(" + config.minAngle + ")");

        update(newValue === undefined ? 0 : newValue);
    }
    that.render = render;

    var numberFormat = d3.format(".1s");

    function getTopValue() {
        var element = document.querySelector(".lastTick");
        return element.getBoundingClientRect().top;
    }

    function update(newValue, gaugeSize, newConfiguration) {
        const data = grafieks.dataUtils.rawData || [];
        var label = data[1];

        d3.select("#x")
            .attr("class", "gaugeDataLabel")
            .style("top", `${getTopValue()}px`)
            .html(
                `<div class="columnWiseCenter"><div class="value">${numberFormat(
                    newValue
                )}</div><div class="gaugeLabel text-center">${label}</div></div>`
            );
        if (newConfiguration !== undefined) {
            configure(newConfiguration);
        }
        var ratio = scale(newValue);
        var newAngle = config.minAngle + ratio * range;
        pointer
            .transition()
            .duration(config.transitionMs)
            // .ease("elastic")
            .attr("transform", "rotate(" + newAngle + ")");
    }
    that.update = update;

    configure(configuration);

    return that;
};

const gaugeChartGeneration = () => {
    const grafieks = window.grafieks;
    const data = grafieks.dataUtils.rawData || [];

    const [maxValue, yellowValue, redValue, readingValue] = data[0];

    const chartsDiv = document.querySelector(".charts-div");
    const gaugeChartDiv = document.createElement("div");
    gaugeChartDiv.id = "gaugeChart";
    chartsDiv.appendChild(gaugeChartDiv);

    const gaugeChartTextDiv = document.createElement("div");
    gaugeChartTextDiv.id = "x";
    gaugeChartDiv.appendChild(gaugeChartTextDiv);

    let gaugeSize = Math.min(window.innerWidth, window.innerHeight);
    if (gaugeSize > 600) {
        gaugeSize = 600;
    }

    var powerGauge = gauge("#gaugeChart", {
        size: gaugeSize,
        clipWidth: gaugeSize,
        clipHeight: gaugeSize,
        ringWidth: gaugeSize / 6,
        maxValue,
        yellowValue,
        redValue,
        transitionMs: 1000
    });
    powerGauge.render();

    function updateReadings(value, gaugeSize) {
        powerGauge.update(value, gaugeSize);
    }

    updateReadings(readingValue, gaugeSize);
};
module.exports = gaugeChartGeneration;
