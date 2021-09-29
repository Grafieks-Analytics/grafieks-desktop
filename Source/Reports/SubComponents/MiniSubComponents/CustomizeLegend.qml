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



    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    function showLegend(checked){
        var legendConfig = d3PropertyConfig.legendConfig || {};
        legendConfig['legendStatus'] = checked;
        legendConfig['legendPosition'] = "right";
        right_radio.radio_checked = true;
        d3PropertyConfig.legendConfig = legendConfig;
        reDrawChart();
    }

    function changeLegendPosition(checked,position){
        if(!checked){
            return;
        }
        var legendConfig = d3PropertyConfig.legendConfig || {};
        legendConfig['legendPosition'] = position;
        d3PropertyConfig.legendConfig = legendConfig;
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
