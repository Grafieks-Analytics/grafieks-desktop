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