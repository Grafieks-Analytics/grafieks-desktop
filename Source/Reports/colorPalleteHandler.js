function setD3ColorPallete(dataValues) {
    /**
     * @param {string} dataValues => Actual data values for charts
     * @param {string} colorData => Color pallete for the chart
     * @param {string} dataItemList => List of color data items
     *
     * @description
     * This function is used to set the color pallete for different charts
     * Push colors to color data and editColor popup will set the colors values
     */

    colorData = JSON.parse(dataValues).legendsData || [];

    // Appending list to select color
    dataItemList.clear();

    if (colorData && colorData.length) {
        colorData.forEach(function (element, index) {
            dataItemList.append({
                colorValue:
                    Constants.d3ColorPalette[
                        index % Constants.d3ColorPalette.length
                    ],
                dataItemName: element,
            });
        });
    }
}
