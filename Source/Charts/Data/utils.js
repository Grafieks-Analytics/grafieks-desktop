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

function setFontFamily(className, fontFamily) {
    d3.selectAll(className).attr("font-family", fontFamily);
}
