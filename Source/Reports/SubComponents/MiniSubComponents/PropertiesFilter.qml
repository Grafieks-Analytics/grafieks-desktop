import QtQuick 2.15
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0

import "../../SubComponents"
import "../../../MainSubComponents"

Column{

    id: propertiesFilter
    width:150

    property int leftMargin: 15

    property int spacingColorList: 5
    property int colorBoxHeight: 20
    property int colorListTopMargin: 5
    property int editImageSize: 16
    property bool colorByActive: ReportParamsModel.colorByActive;

    spacing: 4
    z: 10

    property var tooltipVisible: !!report_desiner_page.subMenuCustomizationsAvailable.includes('tool tip');
    property var colorByComponentVisible: !!report_desiner_page.subMenuCustomizationsAvailable.includes('color by');
    property var sizeVisible: !!report_desiner_page.subMenuCustomizationsAvailable.includes('size');
    property var markerShapeVisible: !!report_desiner_page.subMenuCustomizationsAvailable.includes('marker shape');
    property var dataLabelVisible: !!report_desiner_page.subMenuCustomizationsAvailable.includes('data label');
    property var gridLineVisible: !!report_desiner_page.subMenuCustomizationsAvailable.includes('grid line');
    property var dynamicheightVisible: !!report_desiner_page.subMenuCustomizationsAvailable.includes('dynamic height');
    property var bottomPinchVisible: !!report_desiner_page.subMenuCustomizationsAvailable.includes('bottom pinch');

    // Needs to be updated
    property var pivotThemeVisible2: !!report_desiner_page.subMenuCustomizationsAvailable.includes('pivot theme');
    property var lineTypeVisible2: !!report_desiner_page.subMenuCustomizationsAvailable.includes('line type');

    property var droppedColorType: null;

    /***********************************************************************************************************************/
    // LIST MODEL STARTS



    ListModel{
        id: fonts
        ListElement{
            fontName:"Default"
        }
    }

    // LIST MODEL ENDS
    /***********************************************************************************************************************/


    /***********************************************************************************************************************/
    // SIGNALS STARTS



    // SIGNALS ENDS
    /***********************************************************************************************************************/



    /***********************************************************************************************************************/
    // Connections Starts


   Connections{
        target: ReportParamsModel

        function onEditReportToggleChanged(reportId){
            if(reportId=="-1"){
                 return;
            }
            if(reportId != "false"){
                var reportProperties = ReportParamsModel.getReport(reportIdMain);
                setOldValues(reportProperties)
            }
            else{
                resetAllValues();
            }
        }
    }
    
    function resetAllValues(){

        bottomPinchValue.text = "1";
        dynamicHeightCheckbox.checked = false;
        gridLineStatus.checked = true

    }

    function setOldValues(reportProperties){
        
        var qmlChartConfigProperties = JSON.parse(reportProperties.qmlChartConfig);
        var { bottomPinch, dynamicHeight, gridLineStatus :gridLineStatusValue  } = qmlChartConfigProperties || {};

        if(bottomPinch){
            bottomPinchValue.text = bottomPinch;
        }

        dynamicHeightCheckbox.checked = !!dynamicHeight;
        gridLineStatus.checked = gridLineStatusValue == false ?  false: true;
        

    }

    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    onColorByActiveChanged: {
        if(colorByActive){
            allParameter.border.color = Constants.grafieksLightGreenColor;
            allParameter.border.width = Constants.dropEligibleBorderWidth;;
        }else{
            allParameter.border.color = Constants.themeColor;
            allParameter.border.width = Constants.dropActiveBorderWidth;
        }
    }


    Component.onCompleted: {

        ReportParamsModel.colorByActive = false;
        allParameter.border.color =  Constants.themeColor
        allParameter.border.width =  2


    }


    function onDropAreaEntered(element){
        element.border.width = Constants.dropActiveBorderWidth;
        if(!isDropEligible()){
            element.border.color = Constants.redColor
            return
        }
        element.border.color = Constants.grafieksLightGreenColor
    }

    function onDropAreaExited(element){
        element.border.width = Constants.dropEligibleBorderWidth;
        if(!isDropEligible()){
            element.border.color = Constants.themeColor
            return
        }
    }

    function onDropAreaDropped(element){
        element.border.width = Constants.dropEligibleBorderWidth

        var itemType = ReportParamsModel.itemType;
        var itemName = ReportParamsModel.itemName;
        droppedColorType = itemType.toLowerCase();
 

        if(!isDropEligible()){
            element.border.color = Constants.themeColor
            return;
        }

        colorByData.push({ columnName: itemName, itemType: itemType });
        colorListModel.append({textValue: itemName,itemName:itemName})

        ReportParamsModel.setLastDropped(itemType);

        switch(report_desiner_page.chartTitle){
        case Constants.barChartTitle:
            switchChart(Constants.stackedBarChartTitle)
            break;
        case Constants.horizontalBarChartTitle:
            switchChart(Constants.horizontalStackedBarChartTitle)
            break;
        case Constants.areaChartTitle:
            switchChart(Constants.multipleAreaChartTitle)
            break;
        case Constants.horizontalAreaChartTitle:
            switchChart(Constants.multipleHorizontalAreaChartTitle)
            break;
        case Constants.lineChartTitle:
            switchChart(Constants.multiLineChartTitle)
            break;
        case Constants.horizontalLineChartTitle:
            switchChart(Constants.horizontalMultiLineChartTitle)
        case Constants.horizontalBarGroupedChartTitle:
        case Constants.groupBarChartTitle:
            var [category, subcategory] =  getAxisColumnNames(Constants.xAxisName);
            d3PropertyConfig['options'] = { groupBarChartColorBy: itemName == subcategory ? 'subcategory' : 'category'  }
            reDrawChart();
            break;
        default:
            reDrawChart();
        }

        return;

    }

    function isDropEligible(){

        var itemType = ReportParamsModel.itemType;
        var itemName = ReportParamsModel.itemName;
        const chartDetailsConfig = allChartsMapping[chartTitle];
        let { colorByDropEligible = "" } = chartDetailsConfig || "";

        // Add Color by eligibble for dynamic changing graphs
        switch(report_desiner_page.chartTitle){
            case Constants.horizontalBarChartTitle:
            case Constants.groupBarChartTitle:
            case Constants.horizontalBarGroupedChartTitle:
            case Constants.horizontalAreaChartTitle:
                colorByDropEligible = "categorical";    

        }
        
        colorByDropEligible = colorByDropEligible.split(',');
        if(!colorByDropEligible.includes(itemType.toLowerCase())){
            return false;
        }
        
        if(report_desiner_page.chartTitle==Constants.groupBarChartTitle){
            var xAxisValidNames = getAxisColumnNames(Constants.xAxisName);
            if(xAxisValidNames.includes(itemName)){
                return true;
            }
            return false;
        }

        var lastDropped = ReportParamsModel.lastDropped;
        if(!lastDropped){
            return true;
        }
        if(lastDropped !== itemType){
            return false;
        }
        if(itemType.toLowerCase() === "numerical"){
            return true;
        }
        return false;
    }

    function onDropAreaPositionChanged(drag){
        console.log('Position change!!');
    }

    function openEditColorPopup(){
        editColorPopup.visible = true
    }


    function resizePaddingInner(value, actualValue){
        d3PropertyConfig.paddingInner = value;
        d3PropertyConfig.innerRadius = (1-value);        
        //        console.log("value"+value);
        qmlChartConfig.sizePopupValue = actualValue;
        updateChart();
    }


    function showGrid(checked){
        var gridConfig = d3PropertyConfig.gridConfig || {};
        gridConfig['gridStatus'] = checked;
        d3PropertyConfig.gridConfig = gridConfig;
        qmlChartConfig.gridLineStatus = checked;
        updateChart();
    }

    function toggleDynamicheight(checked){
        d3PropertyConfig.dynamicHeight = checked;
        qmlChartConfig.dynamicHeight = checked;
        updateChart();
    }

    function updateBottomPinchValue(){
        if(bottomPinchValue.text){
            if(+bottomPinchValue.text < 0){
                return;
            }
            d3PropertyConfig.bottomPinch = +bottomPinchValue.text;
        }
        qmlChartConfig.bottomPinch = bottomPinchValue.text;
        updateChart();
    }

    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts


    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts


    // Color By Component Starts
    
    Rectangle {
        id: colorByComponents
        height: allParameter.height + colorByText.height + 2*colorListTopMargin
        visible: colorByComponentVisible
        // visible: false
        width: parent.width
        Text {
            id: colorByText
            x: leftMargin
            anchors.top: parent.top
            anchors.topMargin: 5
            font.pixelSize: Constants.fontCategoryHeaderSmall
            text: "Color By"
        }
        Image {
            height: editImageSize
            width: editImageSize
            source: "/Images/icons/Edit_20.png"
            anchors.top: parent.top
            anchors.topMargin: 5
            anchors.right: parent.right
            anchors.rightMargin: leftMargin

            MouseArea{
                anchors.fill: parent
                onClicked: openEditColorPopup()
            }
        }

        Rectangle{
            id: allParameter

            width: parent.width-2*leftMargin
            height: !colorListModel.count ? 30 : (colorList.height + 5 * colorListModel.count)
            x:leftMargin
            anchors.top: colorByText.bottom
            anchors.topMargin: colorListTopMargin

            border.color: Constants.themeColor
            border.width: 1

            DropArea {
                id: dropArea
                height: parent.height
                width: parent.width
                onEntered:  onDropAreaEntered(parent)
                onExited:  onDropAreaExited(parent)
                onDropped: onDropAreaDropped(parent)

            }

            // list view for dropped colors
            ListView{
                id: colorList
                height: colorListModel.count*colorBoxHeight + spacingColorList
                width: parent.width-10
                x:5
                anchors.top: parent.top
                anchors.topMargin: 5
                model: colorListModel
                spacing: spacingColorList
                delegate: Rectangle{
                    height: colorBoxHeight
                    width: parent.width
                    color: droppedColorType != "numerical" ? Constants.defaultCategoricalColor : Constants.defaultNumericalColor; 
                    border.width: 1
                    border.color: "#CDE6FF"

                    ColorByMenuOption{
                        id: colorByOptions
                    }

                    Text {
                        id: colorByTextItem
                        text: textValue
                        anchors.centerIn: parent
                        width: parent.width - 10
                        elide: Text.ElideRight
                        font.pixelSize: Constants.fontCategoryHeaderSmall
                    }
                    MouseArea{
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked: (mouse.button & Qt.RightButton) ? colorByOptions.visible = true : null
                    }
                }
            }
            // list view ends!


        }
    }


    // Color By Component Ends



    // Tool tip starts
    Rectangle{

        height: 20
        width: parent.width
        
        visible: tooltipVisible

        Rectangle{
            anchors.fill: parent

            Text {
                text: qsTr("Tool Tip")
                anchors.left: parent.left
                anchors.leftMargin: leftMargin
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: Constants.fontCategoryHeaderSmall
            }

            Image {
                height: editImageSize
                width: editImageSize
                source: "/Images/icons/Edit_20.png"
                anchors.right: parent.right
                anchors.rightMargin: leftMargin
                anchors.verticalCenter: parent.verticalCenter
            }
            MouseArea{
                anchors.fill: parent
                onClicked: toolTipPopup.visible = true
            }

        }

    }
    // Tool tip Ends


    // Size starts
    Rectangle{

        height: 20
        width: parent.width
        visible: sizeVisible


        Rectangle{
            anchors.fill: parent

            SizePopup{
                id: sizePopup
            }

            Text {
                text: qsTr("Size")
                anchors.left: parent.left
                anchors.leftMargin: leftMargin
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: Constants.fontCategoryHeaderSmall
            }

            Image {
                height: editImageSize
                width: editImageSize
                source: "/Images/icons/Edit_20.png"
                anchors.right: parent.right
                anchors.rightMargin: leftMargin
                anchors.verticalCenter: parent.verticalCenter
                MouseArea{
                    anchors.fill: parent
                    onClicked: sizePopup.visible = true
                }
            }

        }

    }
    // Size Ends


    // Marker Shape starts
    Rectangle{

        height: 20
        width: parent.width
        visible: markerShapeVisible

        Rectangle{
            anchors.fill: parent

            MarkerShapePopup{
                id: markerShapePopup
                x: parent.width - 10
            }

            Text {
                text: qsTr("Marker Shape")
                anchors.left: parent.left
                anchors.leftMargin: leftMargin
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: Constants.fontCategoryHeaderSmall
            }

            Image {
                height: editImageSize
                width: editImageSize
                source: "/Images/icons/Edit_20.png"
                anchors.right: parent.right
                anchors.rightMargin: leftMargin
                anchors.verticalCenter: parent.verticalCenter
                MouseArea{
                    anchors.fill: parent
                    onClicked: markerShapePopup.visible = true
                }
            }

        }

    }
    // Marker Shape Ends



    // Label starts
    Rectangle{

        height: 20
        width: parent.width
        visible: dataLabelVisible

        Rectangle{
            anchors.fill: parent

            LabelPopup{
                id: labelShapePopup
                x: parent.width - 10
            }

            Text {
                text: qsTr("Data Label")
                anchors.left: parent.left
                anchors.leftMargin: leftMargin
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: Constants.fontCategoryHeaderSmall
            }

            Image {
                height: editImageSize
                width: editImageSize
                source: "/Images/icons/Edit_20.png"
                anchors.right: parent.right
                anchors.rightMargin: leftMargin
                anchors.verticalCenter: parent.verticalCenter
            }
            MouseArea{
                anchors.fill: parent
                onClicked: labelShapePopup.visible = true
            }

        }

    }
    // Label Ends

    // Line Type starts
    Rectangle{

        height: 20
        width: parent.width
        visible: lineTypeVisible2

        Rectangle{
            anchors.fill: parent

            LineTypePopup{
                id: lineTypePopup
                x: parent.width - 10
            }

            Text {
                text: qsTr("Line Type")
                anchors.left: parent.left
                anchors.leftMargin: leftMargin
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: Constants.fontCategoryHeaderSmall
            }

            Image {
                height: editImageSize
                width: editImageSize
                source: "/Images/icons/Edit_20.png"
                anchors.right: parent.right
                anchors.rightMargin: leftMargin
                anchors.verticalCenter: parent.verticalCenter
            }
            MouseArea{
                anchors.fill: parent
                onClicked: lineTypePopup.visible = true
            }

        }

    }
    // Label Ends

    // Pivot Theme starts
    Rectangle{

        height: 20
        width: parent.width
        visible: pivotThemeVisible2

        Rectangle{
            anchors.fill: parent


            PivotThemesPopup{
                id: pivotThemePopup
                x: parent.width - 10
            }

            Text {
                text: qsTr("Themes")
                anchors.left: parent.left
                anchors.leftMargin: leftMargin
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: Constants.fontCategoryHeaderSmall
            }

            Image {
                height: editImageSize
                width: editImageSize
                source: "/Images/icons/Edit_20.png"
                anchors.right: parent.right
                anchors.rightMargin: leftMargin
                anchors.verticalCenter: parent.verticalCenter
            }

            MouseArea{
                anchors.fill: parent
                onClicked: pivotThemePopup.visible = true
            }

        }

    }
    // Theme Ends

    // Gride Line starts
    Rectangle{

        height: 30
        width: parent.width
        
        visible: gridLineVisible

        Rectangle{

            height: 20
            width: parent.width

            Text {
                text: qsTr("Grid Line")
                anchors.left: parent.left
                anchors.leftMargin: leftMargin
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: Constants.fontCategoryHeaderSmall
            }

            CheckBoxTpl{

                id: gridLineStatus
                checked: qmlChartConfig.gridLineStatus != undefined ? qmlChartConfig.gridLineStatus : true
                parent_dimension: editImageSize - 2
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 5
                anchors.top: parent.top
                onCheckedChanged: showGrid(checked);


            }

        }

    }
    // Gride Line Ends


    // Dynamic height starts
    Rectangle{

        height: 30
        width: parent.width
        visible: dynamicheightVisible

        Rectangle{

            height: 20
            width: parent.width

            Text {
                text: qsTr("Dynamic Height")
                anchors.left: parent.left
                anchors.leftMargin: leftMargin
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: Constants.fontCategoryHeaderSmall
            }

            CheckBoxTpl{
                id: dynamicHeightCheckbox
                checked: false
                parent_dimension: editImageSize - 2
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 5
                anchors.top: parent.top
                onCheckedChanged: toggleDynamicheight(checked);


            }

        }

    }
    // Dynamic height Ends


    // Bottom Pinch
    Rectangle{

        height: 40
        width: parent.width
        visible: bottomPinchVisible

        Rectangle{

            height: 30
            width: parent.width

            Text {
                text: qsTr("Bottom Pinch")
                anchors.left: parent.left
                anchors.leftMargin: leftMargin
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: Constants.fontCategoryHeaderSmall
            }

            TextField{
                id: bottomPinchValue
                height: 30
                width: 30
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 10
                anchors.top: parent.top
                text: "1"
                onTextChanged: updateBottomPinchValue()

            }

        }

    }

    




    // Merge Axis starts
    //    Rectangle{

    //        height: 30
    //        width: parent.width

    //        Rectangle{

    //            height: 20
    //            width: parent.width

    //            Text {
    //                text: qsTr("Merge Axis")
    //                anchors.left: parent.left
    //                anchors.leftMargin: leftMargin
    //                anchors.verticalCenter: parent.verticalCenter
    //                font.pixelSize: Constants.fontCategoryHeaderSmall
    //            }

    //            CheckBoxTpl{

    //                checked: false
    //                parent_dimension: editImageSize - 2
    //                anchors.right: parent.right
    //                anchors.verticalCenter: parent.verticalCenter
    //                anchors.rightMargin: 5
    //                anchors.top: parent.top

    //            }

    //        }

    //    }
    // Merge Axis Ends


}
