function isDateFormat(date) {
    if (new Date(date) != "Invalid Date") {
        return true;
    }
    return false;
}
