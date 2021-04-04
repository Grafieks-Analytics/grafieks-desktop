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

function changeLabelPostionsAttributes(selectorTick,selectorLabel, attributeName) {
  var value = getAttributesValues(selectorTick);
  var isFirstInitialValueSet = window[initialLabelPosition + attributeName];
  if (!isFirstInitialValueSet)
  {
    window[initialLabelPosition + attributeName] = d3
      .selectAll(selectorLabel)
      .attr(attributeName);
    
    window.isFirstInitialValueSet=true;
    }
   
  d3.selectAll(selectorLabel).attr(
    attributeName,
    (+window[initialLabelPosition + attributeName]) + +value
  );
}

// function getLabelPosition(selectorLabel , axis) {
//    var value = d3
//      .selectAll(selectorLabel)
//      .attr(attributeName, +attributeValue + +value);
//   value = value.getBoundingClientRect().height;
//   console.log(value);
//   return value;
// }



function getAttributesValues(selector) {
  // var value = d3.selectAll(selector).attr(attributeName);
  
  var value = document.querySelector(selector);
  if (!value) {
    return false;
  }
   value = value.getBoundingClientRect().height;
  console.log(value);
  return value;
}

function setText(selector, textValue) {
    d3.selectAll(selector).text(textValue);
}

function setLabel(
  label = "xLabel",
  labelType = "x_label",
  x_tick_fontSize,
  y_tick_fontSize
) {

  console.log("x"+x_tick_fontSize);
  console.log("y"+y_tick_fontSize);
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
      .attr("x", width / 2 + 150)
      .attr("y", height + 60)
      .attr("class", labelType);
  } else {
    svg
      .append("text")
      .attr("class", labelType)
      .attr("text-anchor", "end")
      .text(label)
      .attr("y", 6)
      .attr("x", -height / 2)
      .attr("dy", ".75em")
      .attr("transform", "rotate(-90)");
  }
}


  
