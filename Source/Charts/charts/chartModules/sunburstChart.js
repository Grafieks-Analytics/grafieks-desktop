const d3 = require("d3");

const CONSTANTS = require("../constants");

const chartGeneration = () => {
    const grafieks = window.grafieks;
    const rawData = grafieks.dataUtils.rawData || [];
    const [dataValues, dataLabel] = rawData;
    window.grafieks.legend.data = [];

    let {
        d3colorPalette = CONSTANTS.d3ColorPalette,
        labelConfig = CONSTANTS.defaultValues.labelConfig,
        dataLabelfontSize = CONSTANTS.defaultValues.fontSize,
        dataLabelfontFamily = CONSTANTS.defaultValues.fontFamily,
        dataLabelColor = CONSTANTS.defaultValues.fontColor
    } = grafieks.plotConfiguration;

    let { labelStatus } = labelConfig;

    const margin = { top: 50, right: 50, bottom: 50, left: 50 },
        width = window.innerWidth - margin.left - margin.right,
        height = window.innerHeight - margin.top - margin.bottom;

    maxRadius = Math.min(width, height) / 2;

    const x = d3
        .scaleLinear()
        .range([0, 2 * Math.PI])
        .clamp(true);

    const y = d3.scaleSqrt().range([maxRadius * 0.1, maxRadius]);

    const color = d3.scaleOrdinal(d3colorPalette);

    const partition = d3.partition();

    const arc = d3
        .arc()
        .startAngle((d) => x(d.x0))
        .endAngle((d) => x(d.x1))
        .innerRadius((d) => Math.max(0, y(d.y0)))
        .outerRadius((d) => Math.max(0, y(d.y1)));

    const middleArcLine = (d) => {
        const halfPi = Math.PI / 2;
        const angles = [x(d.x0) - halfPi, x(d.x1) - halfPi];
        const r = Math.max(0, (y(d.y0) + y(d.y1)) / 2);

        const middleAngle = (angles[1] + angles[0]) / 2;
        const invertDirection = middleAngle > 0 && middleAngle < Math.PI; // On lower quadrants write text ccw
        if (invertDirection) {
            angles.reverse();
        }

        const path = d3.path();
        path.arc(0, 0, r, angles[0], angles[1], invertDirection);
        return path.toString();
    };

    const textFits = (d) => {
        const CHAR_SPACE = 6;

        const deltaAngle = x(d.x1) - x(d.x0);
        const r = Math.max(0, (y(d.y0) + y(d.y1)) / 2);
        const perimeter = r * deltaAngle;

        return d.data.name.length * CHAR_SPACE < perimeter;
    };

    const chartsDiv = d3.select(".charts-div");
    const svg = chartsDiv.append("svg").attr("viewBox", `${-width / 2} ${-(height / 2) - 5} ${width} ${height + 40}`);

    // TODO: Collapse slices
    // svg.on("click", (event) => focusOn(event)); // Reset zoom on canvas click

    let data = d3.hierarchy(dataValues);
    data.sum((d) => d.size);

    const slice = svg.selectAll("g.slice").data(partition(data).descendants());

    slice.exit().remove();

    const newSlice = slice
        .enter()
        .append("g")
        .attr("class", "slice")
        .on("click", (event) => {
            // TODO: Collapse slices
            // console.log(event);
            // event.stopPropagation();
            // focusOn(event);
        });

    newSlice
        .append("path")
        .attr("class", function (d, i) {
            this.setAttribute("data-value-x-label", d.data.label);
            this.setAttribute("data-value-y-label", dataLabel[dataLabel.length - 1]);
            this.setAttribute("data-value-x1", d.data.name);
            this.setAttribute("data-value-y1", d.data.size);
            return "main-arc visualPlotting";
        })
        .style("fill", (d) => color((d.children ? d : d.parent).data.name))
        .attr("d", arc);

    newSlice
        .append("path")
        .attr("class", "hidden-arc")
        .attr("id", (_, i) => `hiddenArc${i}`)
        .attr("d", middleArcLine);

    const text = newSlice.append("text").attr("display", (d) => (textFits(d) ? null : "none"));

    if (labelStatus) {
        text.append("textPath")
            .attr("startOffset", "50%")
            .attr("xlink:href", (_, i) => `#hiddenArc${i}`)
            // .text((d) => labelFormatSet(d.data.name, labelFormat))
            .text((d) => d.data.name)
            .attr("font-family", dataLabelfontFamily)
            .attr("font-size", dataLabelfontSize)
            .attr("fill", dataLabelColor);
    }

    function focusOn(d = { x0: 0, x1: 1, y0: 0, y1: 1 }) {
        // Reset to top-level if no data point specified

        const transition = svg
            .transition()
            .duration(750)
            .tween("scale", () => {
                const xd = d3.interpolate(x.domain(), [d.x0, d.x1]),
                    yd = d3.interpolate(y.domain(), [d.y0, 1]);
                return (t) => {
                    x.domain(xd(t));
                    y.domain(yd(t));
                };
            });

        transition.selectAll("path.main-arc").attrTween("d", (d) => () => arc(d));

        transition.selectAll("path.hidden-arc").attrTween("d", (d) => () => middleArcLine(d));

        transition.selectAll("text").attrTween("display", (d) => () => textFits(d) ? null : "none");

        moveStackToFront(d);

        function moveStackToFront(elD) {
            svg.selectAll(".slice")
                .filter((d) => d === elD)
                .each(function (d) {
                    this.parentNode.appendChild(this);
                    if (d.parent) {
                        moveStackToFront(d.parent);
                    }
                });
        }
    }
};

module.exports = chartGeneration;
