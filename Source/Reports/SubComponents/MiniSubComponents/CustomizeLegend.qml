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

        legendStatusCheckbox.checked = false;
        
        right_radio.radio_checked = false;
        left_radio.radio_checked = false;
        top_radio.radio_checked = false;
        bottom_radio.radio_checked = false;

    }

    function setOldValues(reportProperties){
        
        var d3PropertiesConfig = JSON.parse(reportProperties.d3PropertiesConfig);
        var {  legendConfig = {}  } = d3PropertiesConfig || {};
        var { legendStatus, legendPosition } = legendConfig;

        legendStatusCheckbox.checked = legendStatus ? true : false 
        if(legendPosition){
            switch(legendPosition){
                case "right":
                    right_radio.radio_checked = true;
                    left_radio.radio_checked = false;
                    top_radio.radio_checked = false;
                    bottom_radio.radio_checked = false;
                    break;
                case "left":
                    right_radio.radio_checked = false;
                    left_radio.radio_checked = true;
                    top_radio.radio_checked = false;
                    bottom_radio.radio_checked = false;
                    break;
                case "bottom":
                    right_radio.radio_checked = false;
                    left_radio.radio_checked = false;
                    top_radio.radio_checked = false;
                    bottom_radio.radio_checked = true;
                    break;
                case "top":
                    right_radio.radio_checked = false;
                    left_radio.radio_checked = false;
                    top_radio.radio_checked = true;
                    bottom_radio.radio_checked = false;
                    break;
            }
            // legendStatusCheckbox.checked = legendStatusCheckbox.checked ? true : false 
        }else{
            right_radio.radio_checked = false;
            left_radio.radio_checked = false;
            top_radio.radio_checked = false;
            bottom_radio.radio_checked = false;
        }

    }
    

    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    function showLegend(checked){
        var legendConfig = d3PropertyConfig.legendConfig || {};
        legendConfig['legendStatus'] = checked;
        legendConfig['legendPosition'] = "right";
        if(checked){
            right_radio.radio_checked = true;
        }else{
            right_radio.radio_checked = false;
            left_radio.radio_checked = false;
            top_radio.radio_checked = false;
            bottom_radio.radio_checked = false;
        }
        d3PropertyConfig.legendConfig = legendConfig;
        qmlChartConfig.legendStatus = checked;
        reDrawChart();
    }

    function changeLegendPosition(checked,position){
        if(!checked){
            return;
        }
        var legendConfig = d3PropertyConfig.legendConfig || {};
        legendConfig['legendPosition'] = position;
        d3PropertyConfig.legendConfig = legendConfig;
        qmlChartConfig.legendConfig = { 
            right_radio: right_radio.radio_checked, 
            left_radio: left_radio.radio_checked, 
            top_radio: top_radio.radio_checked, 
            bottom_radio: bottom_radio.radio_checked
        } ;
        reDrawChart();
    }


    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts

    ButtonGroup{
        id: legendBtnGroup
    }


    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts



    // Show Legend Starts

    Rectangle{

        id:showLegendText1

        height: 30
        width: 150


        Rectangle{
            anchors.fill: parent
            anchors.top: parent.top
            anchors.topMargin: 10


            Text {
                text: qsTr("Show Legend")
                anchors.left: parent.left
                anchors.leftMargin: leftMargin
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: Constants.fontCategoryHeaderSmall
            }

            CheckBoxTpl{
                id: legendStatusCheckbox
                checked: false
                parent_dimension: editImageSize - 2
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 5
                anchors.top: parent.top
                onCheckedChanged: showLegend(checked);

            }


        }

    }

    // Show Legends Ends

    Rectangle{

        height: 110
        width: parent.width




        Row{

            id:rightLeft
            anchors.top: parent.top
            anchors.topMargin: 8

            width: parent.width
            height: parent.height/2

            Rectangle{
                height: parent.height
                width: parent.width/2


                Column{
                    anchors.fill: parent

                    Text {
                        text: qsTr("Right")
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: Constants.fontCategoryHeaderSmall
                    }

                    CustomRadioButton{
                        id:right_radio
                        radio_checked: false
                        parent_dimension: 12
                        width: parent.width
                        x: (parent.width/2 - this.parent_dimension)
                        ButtonGroup.group: legendBtnGroup
                        onCheckedChanged: changeLegendPosition(checked,'right')
                    }

                }


            }


            Rectangle{
                height: parent.height
                width: parent.width/2


                Column{
                    anchors.fill: parent

                    Text {
                        text: qsTr("Left")
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: Constants.fontCategoryHeaderSmall
                    }

                    CustomRadioButton{
                        id: left_radio
                        radio_checked: false
                        parent_dimension: 12
                        width: parent.width

                        x: (parent.width/2 - this.parent_dimension)
                        ButtonGroup.group: legendBtnGroup
                        onCheckedChanged: changeLegendPosition(checked,'left')

                    }

                }


            }



        }

        Row{

            anchors.top: rightLeft.bottom

            width: parent.width
            height: parent.height/2
            Rectangle{
                height: parent.height
                width: parent.width/2


                Column{
                    anchors.fill: parent

                    Text {
                        text: qsTr("Bottom")
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: Constants.fontCategoryHeaderSmall
                    }

                    CustomRadioButton{
                        id: bottom_radio
                        radio_checked: false
                        parent_dimension: 12
                        width: parent.width

                        x: (parent.width/2 - this.parent_dimension)
                        ButtonGroup.group: legendBtnGroup
                        onCheckedChanged: changeLegendPosition(checked,'bottom')
                    }

                }


            }


            Rectangle{
                height: parent.height
                width: parent.width/2


                Column{
                    anchors.fill: parent
                    Text {
                        text: qsTr("Top")
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: Constants.fontCategoryHeaderSmall
                    }

                    CustomRadioButton{
                        id: top_radio
                        radio_checked: false
                        parent_dimension: 12
                        width: parent.width

                        x: (parent.width/2 - this.parent_dimension)
                        ButtonGroup.group: legendBtnGroup
                        onCheckedChanged: changeLegendPosition(checked,'top')

                    }

                }


            }


        }


    }

    // Text Format starts
    // Rectangle{

    //     height: 20
    //     width: parent.width



    //     Rectangle{
    //         anchors.fill: parent
    //         anchors.top: parent.top
    //         anchors.topMargin: 5
    //         anchors.bottom:  parent.bottom
    //         anchors.bottomMargin:  20


    //         Text {
    //             text: qsTr("Text Format")
    //             anchors.left: parent.left
    //             anchors.leftMargin: leftMargin
    //             anchors.verticalCenter: parent.verticalCenter
    //             font.pixelSize: Constants.fontCategoryHeaderSmall
    //         }

    //         Image {
    //             height: editImageSize
    //             width: editImageSize
    //             source: "/Images/icons/Edit_20.png"
    //             anchors.right: parent.right
    //             anchors.rightMargin: leftMargin
    //             anchors.verticalCenter: parent.verticalCenter
    //         }

    //     }

    // }
    // Text Format Ends

}
