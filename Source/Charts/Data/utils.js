function isDateFormat(date) {
    if (typeof date == "string") {
        if (date.length < 6) {
            return false;
        }
    }
    if (new Date(date) != "Invalid Date") {
        return true;
    }
    return false;
}


function changeChartAttributes(selector, attributeName, attributeValue) {
  d3.selectAll(selector).attr(attributeName, attributeValue);
}

function setText(selector, textValue) {
    d3.selectAll(selector).text(textValue);
}

function setLabel(label = "xLabel", labelType = "x_label") {
  svg = d3.select("svg");

  const margin = { top: 30, right: 30, bottom: 70, left: 60 },
    width = window.innerWidth - margin.left - margin.right - 10,
    height = window.innerHeight - margin.top - margin.bottom - 10;

  if (labelType == "x_label") {
    svg
      .append("text")
      .attr("class", labelType)
      .attr("text-anchor", "end")
      .text(label)
      .attr("x", (width / 2)+150)
      .attr("y", height + 60)
      .attr("class", labelType);
  } else {
    svg
      .append("text")
      .attr("class", labelType)
      .attr("text-anchor", "end")
      .text(label)
      .attr("y", 6)
      .attr("x", -height/2)
      .attr("dy", ".75em")
      .attr("transform", "rotate(-90)");
  }
}


  