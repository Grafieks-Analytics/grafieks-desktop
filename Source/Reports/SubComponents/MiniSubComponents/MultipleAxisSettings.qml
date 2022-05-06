import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0
import com.grafieks.singleton.messages 1.0


Rectangle{

    property int boxHeight: 30

    anchors.left: menuContentSeparator.right
    height: parent.height
    width: parent.width - leftMenu.width - menuContentSeparator.width
    visible: true


    /***********************************************************************************************************************/
    // LIST MODEL STARTS

    ListModel{
        id: seriesList
        ListElement{
            itemName: "Total Quality"
        }
        ListElement{
            itemName: "Total Discount"
        }
        ListElement{
            itemName: "Total Profit"
        }
        ListElement{
            itemName: "Total Profit"
        }
    }


    // LIST MODEL ENDS
    /***********************************************************************************************************************/

    Row{

        anchors.fill: parent

        Rectangle{
            width: parent.width/5
            height: parent.height

            Column{
                spacing: 10
                anchors.left: parent.left
                anchors.leftMargin: 30
                anchors.top: parent.top
                anchors.topMargin: 20

                Rectangle{
                    width: parent.width - 30
                    height: boxHeight
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: Messages.re_mini_mas_series
                        font.bold: true
                    }
                }

                ListView{
                    width: parent.width - 30
                    model: seriesList
                    height: boxHeight * seriesList.count
                    spacing: 10
                    delegate: Rectangle{
                        width: parent.width - 30
                        height: boxHeight
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: qsTr(itemName)
                        }
                    }
                }

            }

        }

        Rectangle{
            width: parent.width*4/5
            height: parent.height

            Column{
                spacing: 10
                anchors.left: parent.left
                anchors.leftMargin: 30
                anchors.top: parent.top
                anchors.topMargin: 20
                anchors.fill: parent

                Rectangle{
                    height: boxHeight
                    width: parent.width
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: Messages.re_mini_mas_comboOptions
                        font.bold: true
                    }
                }


                Rectangle{
                    height: parent.height - boxHeight
                    width: parent.width

                    ListView{
                        width: parent.width - 30
                        model: seriesList
                        height: boxHeight * seriesList.count
                        spacing: 10
                        interactive: false
                        delegate: Rectangle{
                            width: parent.width - 30
                            height: boxHeight
                            ComboOptions{
                                anchors.fill: parent
                            }
                        }
                    }

                }



            }

        }

    }

}
