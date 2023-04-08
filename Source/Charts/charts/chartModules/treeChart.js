const d3 = require("d3");

const CONSTANTS = require("../constants");
const { getChartsDiv } = require("../utils");

// Collapse the node and all it's children
function collapse(d) {
    if (d.children) {
        d._children = d.children;
        d._children.forEach(collapse);
        d.children = null;
    }
}

function update(source) {
    let {
        d3colorPalette: d3colors = CONSTANTS.d3ColorPalette,
        labelConfig: { labelStatus = true } = {},
        dataLabelfontSize = CONSTANTS.defaultValues.fontSize,
        dataLabelfontFamily = CONSTANTS.defaultValues.fontFamily,
        dataLabelColor = CONSTANTS.defaultValues.fontColor
    } = grafieks.plotConfiguration;

    const margin = { top: 50, right: 50, bottom: 50, left: 50 },
        width = window.innerWidth - margin.left - margin.right,
        height = window.innerHeight - margin.top - margin.bottom;

    // declares a tree layout and assigns the size
    const treemap = d3.tree().size([height + 60, width]);

    // Assigns the x and y position for the nodes
    var data = treemap(root);

    // Compute the new tree layout.
    var nodes = data.descendants(),
        links = data.descendants().slice(1);

    // Normalize for fixed-depth.
    nodes.forEach(function (d) {
        d.y = d.depth * 180;
    });

    // ****************** Nodes section ***************************

    let i = 0,
        duration = 0;
    // Update the nodes...
    const svg = d3.select("svg g");
    var node = svg.selectAll("g.node").data(nodes, function (d) {
        return d.id || (d.id = ++i);
    });

    var maxDepth = 0;
    // Enter any new modes at the parent's previous position.
    var nodeEnter = node
        .enter()
        .append("g")
        .attr("class", "node")
        .attr("transform", function (d) {
            if (d.depth > maxDepth) {
                maxDepth = d.depth;
            }
            this.setAttribute("depth", d.depth);

            return "translate(" + source.y0 + "," + source.x0 + ")";
        })
        .attr("stroke-width", 1)
        .attr("stroke", d3colors[4])
        .on("click", click);

    // Add Circle for the nodes
    nodeEnter
        .append("circle")
        .attr("class", "node")
        .attr("r", 1e-6)
        .style("fill", function (d) {
            return d._children ? d3colors[1] : "#fff";
        });

    // Add labels for the nodes
    if (labelStatus) {
        nodeEnter
            .append("text")
            .attr("dy", ".35em")
            .attr("x", function (d) {
                return d.children || d._children ? -13 : 13;
            })
            .attr("text-anchor", function (d) {
                return d.children || d._children ? "end" : "start";
            })
            .text(function (d) {
                return d.data.name ? d.data.name + " : " + d.data.size : d.data.size;
            })
            .attr("stroke", "black")
            .attr("stroke-width", 0)
            .attr("fill", "black")
            .attr("font-family", dataLabelfontFamily)
            .attr("font-size", dataLabelfontSize)
            .attr("fill", dataLabelColor);
        // .attr("font-size", "10px")
        // .attr("font-family", "verdana");
    }

    // UPDATE
    var nodeUpdate = nodeEnter.merge(node);

    // Transition to the proper position for the node
    nodeUpdate
        .transition()
        .duration(duration)
        .attr("transform", function (d) {
            this.setAttribute("translate-y", d.x);
            return "translate(" + d.y + "," + d.x + ")";
        });

    // Update the node attributes and style
    nodeUpdate
        .select("circle.node")
        .attr("r", 10)
        .style("fill", function (d) {
            return d._children ? "lightsteelblue" : "#fff";
        })
        .attr("cursor", "pointer");

    // Remove any exiting nodes
    var nodeExit = node
        .exit()
        .transition()
        .duration(duration)
        .attr("transform", function (d) {
            return "translate(" + source.y + "," + source.x + ")";
        })
        .remove();

    // On exit reduce the node circles size to 0
    nodeExit.select("circle").attr("r", 1e-6);

    // On exit reduce the opacity of text labels
    nodeExit.select("text").style("fill-opacity", 1e-6);

    // ****************** links section ***************************

    // Update the links...
    var link = svg.selectAll("path.link").data(links, function (d) {
        return d.id;
    });

    // Enter any new links at the parent's previous position.
    var linkEnter = link
        .enter()
        .insert("path", "g")
        .attr("class", "link")
        .attr("d", function (d) {
            var o = { x: source.x0, y: source.y0 };
            return diagonal(o, o);
        });

    // UPDATE
    var linkUpdate = linkEnter.merge(link);

    // Transition back to the parent element position
    linkUpdate
        .transition()
        .duration(duration)
        .attr("d", function (d) {
            return diagonal(d, d.parent);
        });

    // Remove any exiting links
    var linkExit = link
        .exit()
        .transition()
        .duration(duration)
        .attr("d", function (d) {
            var o = { x: source.x, y: source.y };
            return diagonal(o, o);
        })
        .remove();

    // Store the old positions for transition.
    nodes.forEach(function (d) {
        d.x0 = d.x;
        d.y0 = d.y;
    });

    // Creates a curved (diagonal) path from parent to the child nodes
    function diagonal(s, d) {
        path = `M ${s.y} ${s.x}
        C ${(s.y + d.y) / 2} ${s.x},
          ${(s.y + d.y) / 2} ${d.x},
          ${d.y} ${d.x}`;

        return path;
    }

    // Toggle children on click.
    function click(d) {
        console.log({ d });
        if (d.children) {
            d._children = d.children;
            d.children = null;
        } else {
            d.children = d._children;
            d._children = null;
        }
        update(d);
    }
}

const chartGeneration = () => {
    const grafieks = window.grafieks;
    const rawData = grafieks.dataUtils.rawData || [];

    if (grafieks.legendConfig && grafieks.legend) {
        grafieks.legendConfig.legendStatus = false;
        grafieks.legend.data = [];
    }

    const [dataValues, dataLabel] = rawData;

    const margin = { top: 50, right: 50, bottom: 50, left: 50 },
        width = window.innerWidth - margin.left - margin.right,
        height = window.innerHeight - margin.top - margin.bottom;

    const chartsDiv = getChartsDiv();
    const svg = chartsDiv
        .append("svg")
        .attr("width", width + margin.right + margin.left)
        .attr("height", height + margin.top + margin.bottom)
        .append("g")
        .attr("transform", "translate(" + 150 + "," + margin.top + ")");

    // Assigns parent, children, height, depth
    root = d3.hierarchy(dataValues, function (d) {
        return d.children;
    });
    root.x0 = height / 2;
    root.y0 = 0;

    // Collapse after the second level
    // root.children.forEach(collapse);
    // root.each(collapse);
    // lables
    update(root);
    // console.log(labels);
    d3.selectAll("svg")
        .append("g")
        .attr("class", "labels")
        .selectAll("text")
        .data(dataLabel)
        .enter()
        .append("text")
        .attr("transform", (d, i) => {
            var nodeWidth = document.querySelector(".node").getBBox().width;
            return "translate(" + (nodeWidth - 30 + 180 * (i + 1) + 45) + "," + 20 + ")";
        })
        .text((d) => {
            return d;
        });

    setTimeout(function () {
        const svgNode = document.querySelector("svg");
        const widthSvgNode = document.querySelector(".charts-div svg g").getBBox().width;
        svgNode.setAttribute("width", widthSvgNode + 50);
    }, 0);
};

module.exports = chartGeneration;
