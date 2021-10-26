import QtQuick 2.15
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

Column{

    property int leftMargin: 15

    property int spacingColorList: 5
    property int colorBoxHeight: 20
    property int colorListTopMargin: 5
    property int editImageSize: 16

    spacing: 4

    /***********************************************************************************************************************/
    // LIST MODEL STARTS


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
            console.log('Table time!? Editing?');
            
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

        console.log('Table time!? Resetting');
        dynamicHeightCheckbox.checked = false;
        alternateRowsCheckStatus = true
        searchCheckStatus = true
        compactStatusCheckStatus = false


    }

    function setOldValues(reportProperties){
        
        console.log('Tablee time!? :grin:');
        var d3PropertiesConfig = JSON.parse(reportProperties.d3PropertiesConfig);

    }


    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    function toggleCellBorders(checkedStatus){
        report_desiner_page.d3PropertyConfig['cellBorderStatus'] = checkedStatus;
        report_desiner_page.reDrawChart();
    }
    function toggleHoverStatus(checkedStatus){
        report_desiner_page.d3PropertyConfig['hoverStatus'] = checkedStatus;
        report_desiner_page.reDrawChart();
    }
    function toggleCompactStatus(checkedStatus){
        report_desiner_page.d3PropertyConfig['compactStatus'] = checkedStatus;
        compactStatusCheckStatus = checkedStatus;
        report_desiner_page.reDrawChart();
    }
    function toggleSearch(checkedStatus){
        report_desiner_page.d3PropertyConfig['searchStatus'] = checkedStatus;
        searchCheckStatus = checkedStatus;
        report_desiner_page.reDrawChart();
    }
    function toggleRowAlternateStatus(checkedStatus){
        console.log('Debug:: Alternate changed? ', checkedStatus);
        report_desiner_page.d3PropertyConfig['rowAlternateStatus'] = checkedStatus;
        alternateRowsCheckStatus = checkedStatus
        report_desiner_page.reDrawChart();
    }

    

    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts


    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts



    // Row Total Starts

    Rectangle{

        height: 35
        width: 150

        Rectangle{
            anchors.fill: parent

            Text {
                text: qsTr("Alternate Rows")
                anchors.left: parent.left
                anchors.leftMargin: leftMargin
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: Constants.fontCategoryHeaderSmall
            }

            CheckBoxTpl{

                id: alternateRows
                checked: alternateRowsCheckStatus
                parent_dimension: editImageSize - 2
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 5
                anchors.top: parent.top
                onCheckedChanged: toggleRowAlternateStatus(checked);

            }

        }

    }

    // Row Total Ends



    // Row Total Starts

    Rectangle{

        height: 35
        width: 150
        visible: false

        Rectangle{
            anchors.fill: parent
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                text: qsTr("Cell Borders")
                anchors.left: parent.left
                anchors.leftMargin: leftMargin
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: Constants.fontCategoryHeaderSmall
            }

            CheckBoxTpl{

                checked: true
                parent_dimension: editImageSize - 2
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 5
                anchors.top: parent.top
                onCheckedChanged: toggleCellBorders(checked);

            }

        }

    }


    // Row Total Ends

    


    // Row Total Starts

    // Hiding hover status for future release
    Rectangle{

        height: 35
        width: 150
        visible: false
        Rectangle{
            anchors.fill: parent
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                text: qsTr("Hover Status")
                anchors.left: parent.left
                anchors.leftMargin: leftMargin
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: Constants.fontCategoryHeaderSmall
            }

            CheckBoxTpl{

                checked: true
                parent_dimension: editImageSize - 2
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 5
                anchors.top: parent.top
                onCheckedChanged: toggleHoverStatus(checked);

            }

        }

    }


    // Row Total Ends

    


    // Row Total Starts

    Rectangle{

        height: 35
        width: 150

        Rectangle{
            anchors.fill: parent
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                text: qsTr("Compact Status")
                anchors.left: parent.left
                anchors.leftMargin: leftMargin
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: Constants.fontCategoryHeaderSmall
            }

            CheckBoxTpl{

                id: compactStatusCheckbox
                checked: compactStatusCheckStatus
                parent_dimension: editImageSize - 2
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 5
                anchors.top: parent.top
                onCheckedChanged: toggleCompactStatus(checked);

            }

        }

    }
    Rectangle{

        height: 35
        width: 150

        Rectangle{
            anchors.fill: parent
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                text: qsTr("Quick Search")
                anchors.left: parent.left
                anchors.leftMargin: leftMargin
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: Constants.fontCategoryHeaderSmall
            }

            CheckBoxTpl{

                id: searchStatusCheckBox
                checked: searchCheckStatus
                parent_dimension: editImageSize - 2
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 5
                anchors.top: parent.top
                onCheckedChanged: toggleSearch(checked);

            }

        }

    }


    // Row Total Ends





}
