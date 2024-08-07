import QtQuick 2.15
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0
import com.grafieks.singleton.messages 1.0

import "../../../MainSubComponents"

Column{

    property int leftMargin: 15

    property int spacingColorList: 5
    property int colorBoxHeight: 20
    property int colorListTopMargin: 5
    property int editImageSize: 16

    spacing: 4

    
    property var grandTotalVisible: !!report_desiner_page.subMenuCustomizationsAvailable.includes('grand total');
    property var rowTotalVisible: !!report_desiner_page.subMenuCustomizationsAvailable.includes('row total');
    property var subTotalVisible: !!report_desiner_page.subMenuCustomizationsAvailable.includes('sub total');
    property var exportVisible:  !!report_desiner_page.subMenuCustomizationsAvailable.includes('export report');

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

    function showRowTotal(checkedStatus){
        report_desiner_page.d3PropertyConfig['columnWiseGrandTotal'] = checkedStatus;
        qmlChartConfig.columnGrandTotalStatus = checkedStatus;
        report_desiner_page.updateChart();
        totalRowTotalCheckStatus = checkedStatus;
    }
    function showColumnTotal(checkedStatus){
        report_desiner_page.d3PropertyConfig['rowWiseGrandTotal'] = checkedStatus;
        // report_desiner_page.d3PropertyConfig['totalStatus'] = checkedStatus;
        tableGrandTotalCheckStatus = checkedStatus;
        report_desiner_page.updateChart();
        qmlChartConfig.grandTotalStatus = checkedStatus;
        //        report_desiner_page.d3PropertyConfig['searchStatus'] = checkedStatus;
        // report_desiner_page.updateChart();
    }
    function showSubTotal(checkedStatus){
        report_desiner_page.d3PropertyConfig['subTotalVisible'] = checkedStatus;
        qmlChartConfig.subTotalStatus = checkedStatus;
        totalSubTotalCheckStatus = checkedStatus;
        report_desiner_page.updateChart();
    }


    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts

    ButtonGroup{
        id:rowTotalBtnGroup
    }
    ButtonGroup{
        id:grandTotalBtnGroup
    }
    ButtonGroup{
        id:subTotalBtnGroup
    }

    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts



    // Row Total Starts

    Rectangle{

        height: 35
        width: 150
        visible: rowTotalVisible

        Rectangle{
            anchors.fill: parent

            Text {
                text: Messages.re_mini_ct_rowTotal
                anchors.left: parent.left
                anchors.leftMargin: leftMargin
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: Constants.fontCategoryHeaderSmall
            }

            CheckBoxTpl{

                checked: totalRowTotalCheckStatus
                parent_dimension: editImageSize - 2
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 5
                anchors.top: parent.top
                onCheckedChanged: showRowTotal(checked);

            }

        }

    }

    /*
    Tag: Future Release
    
    Rectangle{

        height: 35
        width: parent.width

        Row{

            width: parent.width
            height: parent.height

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

                    Rectangle{
                        height: 50
                        width: parent.width

                        CustomRadioButton{
                            radio_checked: false
                            parent_dimension: 12
                            width: parent.width
                            x: (parent.width/2 - this.parent_dimension)
                            ButtonGroup.group: rowTotalBtnGroup
                        }


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

                    Rectangle{
                        height: 50
                        width: parent.width

                        CustomRadioButton{
                            radio_checked: false
                            parent_dimension: 12
                            width: parent.width
                            x: (parent.width/2 - this.parent_dimension)
                            ButtonGroup.group: rowTotalBtnGroup
                        }


                    }


                }


            }

        }


    }
*/

    // Row Total Ends



    // Row Total Starts

    Rectangle{

        height: 35
        width: 150
        visible: grandTotalVisible

        Rectangle{
            anchors.fill: parent
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                text: Messages.re_mini_ct_grandTotal
                anchors.left: parent.left
                anchors.leftMargin: leftMargin
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: Constants.fontCategoryHeaderSmall
            }

            CheckBoxTpl{

                checked: tableGrandTotalCheckStatus
                parent_dimension: editImageSize - 2
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 5
                anchors.top: parent.top
                onCheckedChanged: showColumnTotal(checked);

            }

            //            HorizontalLineTpl{
            //                id: linebar2
            //                line_color: Constants.darkThemeColor
            //                line_width: parent.width-25
            //                anchors.horizontalCenter: parent.horizontalCenter
            //                anchors.top: parent.bottom
            //                width: parent.width-20
            //                height: 4

            //            }

        }

    }

    /*
    Tag: Future Release
    
    Rectangle{

        height: 35
        width: parent.width


        Row{

            width: parent.width
            height: parent.height

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

                    Rectangle{
                        height: 50
                        width: parent.width

                        CustomRadioButton{
                            radio_checked: false
                            parent_dimension: 12
                            width: parent.width
                            x: (parent.width/2 - this.parent_dimension)
                            ButtonGroup.group: grandTotalBtnGroup
                        }


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

                    Rectangle{
                        height: 50
                        width: parent.width

                        CustomRadioButton{
                            radio_checked: false
                            parent_dimension: 12
                            width: parent.width
                            x: (parent.width/2 - this.parent_dimension)
                            ButtonGroup.group: grandTotalBtnGroup
                        }


                    }


                }


            }

        }


    }

*/

    // Row Total Ends




    // Row Total Starts

    Rectangle{

        height: 35
        width: 150
        visible: subTotalVisible

        Rectangle{
            anchors.fill: parent

            Text {
                text: Messages.re_mini_ct_subTotal
                anchors.left: parent.left
                anchors.leftMargin: leftMargin
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: Constants.fontCategoryHeaderSmall
            }

            CheckBoxTpl{

                checked: totalSubTotalCheckStatus
                parent_dimension: editImageSize - 2
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 5
                anchors.top: parent.top
                onCheckedChanged: showSubTotal(checked);

            }

        }

    }

    // Grand Total

    /*
    Tag: Future Release
    
    Rectangle{

        height: 50
        width: parent.width

        Row{

            width: parent.width
            height: parent.height

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

                    Rectangle{
                        height: 50
                        width: parent.width

                        CustomRadioButton{
                            radio_checked: false
                            parent_dimension: 12
                            width: parent.width
                            x: (parent.width/2 - this.parent_dimension)
                            ButtonGroup.group: grandTotalBtnGroup
                        }


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

                    Rectangle{
                        height: 50
                        width: parent.width

                        CustomRadioButton{
                            radio_checked: false
                            parent_dimension: 12
                            width: parent.width
                            x: (parent.width/2 - this.parent_dimension)
                            ButtonGroup.group: grandTotalBtnGroup
                        }


                    }


                }


            }

        }


    }

    */

    // Row Total Ends



    Rectangle{

        height: 35
        width: 150
        visible: exportVisible

        CustomButton {
            textValue: Messages.re_mini_ct_exportReport
            anchors.left: parent.left
            anchors.leftMargin: leftMargin
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: Constants.fontCategoryHeaderSmall
            onClicked : report_desiner_page.exportPivotChart()
        }

    }




}
