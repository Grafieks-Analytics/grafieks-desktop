/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Data
** Data Query Modeller
**
****************************************************************************/

import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

Rectangle{
    id: listContent
    height: parent.height - 80 - 40
    width: parent.width - 40
    x:20
    y:10
    anchors.top:  fullExtactRadioBtn.bottom
    color: Constants.whiteColor
    border.color: Constants.darkThemeColor

    Row{
        id: selectTypeRadioBtn
        height: 40
        width: parent.width

        Column{

            id: multiSelectRadioColumn
            anchors.top: selectTypeRadioBtn.top

            padding: 10
            leftPadding: 30

            RadioButtonTpl{
                id: multiSelectRadio
                radio_text: qsTr("Multi Select")
                radio_checked: true
                parent_dimension: 16

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        singleSelectRadio.radio_checked = false
                        multiSelectRadio.radio_checked = true
                        multiSelectCheckList.visible = true
                        singleSelectCheckList.visible = false
                    }
                }
            }

        }

        Column{
            id: singleSelectRadioColumn

            padding: 10
            anchors.right: selectTypeRadioBtn.right
            rightPadding: 30

            RadioButtonTpl{
                id: singleSelectRadio
                radio_text: qsTr("Single Select")
                radio_checked: false
                parent_dimension: 16


                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        singleSelectRadio.radio_checked = true
                        multiSelectRadio.radio_checked = false
                        multiSelectCheckList.visible = false
                        singleSelectCheckList.visible = true
                    }
                }

            }
        }
    }

    Row{
        id: searchTextBox
        anchors.top: selectTypeRadioBtn.bottom
        anchors.topMargin: 8
        width: parent.width
        height: 40

        Rectangle{

            height: 30
            radius: 4
            width: parent.width - 8
            anchors.left: searchTextBox.left
            anchors.leftMargin: 4

            TextField{
                placeholderText: "Search"
                leftPadding: 20
                height: 40
                anchors.top: searchTextBox.top
                width: parent.width - 20
                x: 10

                background: Rectangle{
                    border.color: Constants.borderBlueColor
                    radius: 4
                }
            }
        }

    }


    Rectangle{
        id: listInnerContent
        height: listContent.height - ( selectTypeRadioBtn.height  + searchTextBox.height + includeExcludeRow.height + footerContent.height)
        width: parent.width - 30
        anchors.top: searchTextBox.bottom
        anchors.left: searchTextBox.left
        anchors.leftMargin: 15
        anchors.topMargin: 8

        color: Constants.themeColor
        border.color: Constants.darkThemeColor



        ListView{

            id: multiSelectCheckList
            model: checkListModel
            height: parent.height
            width: parent.width

            delegate: Row{

                height: 20
                width: parent.width

                Column{
                    CheckBox {
                        checked: true
                        text: qsTr(textValue)
                        indicator.width: 15
                        indicator.height: 15

                    }
                }

            }
        }


        ListView{

            id: singleSelectCheckList
            model: checkListModel
            height: parent.height
            width: parent.width
            visible: false

            delegate: Row{

                height: 20
                width: parent.width

                Column{
                    RadioButtonTpl {
                        radio_checked: true
                        radio_text: qsTr(textValue)
                        parent_dimension: 16

                    }
                }

            }
        }


        ScrollIndicator.horizontal: ScrollIndicator { }
        ScrollIndicator.vertical: ScrollIndicator { }

    }

    Row{
        id: includeExcludeRow
        anchors.top:  listInnerContent.bottom
        anchors.left: parent.left
        height: 30
        width: parent.width
        anchors.leftMargin: 10

        Column{
            anchors.left: includeExcludeRow.left

            CheckBox {
                checked: true
                text: qsTr("Include Null")
                indicator.width: 15
                indicator.height: 15

            }
        }

        Column{
            anchors.right: includeExcludeRow.right
            anchors.rightMargin: 30
            CheckBox {
                checked: true
                text: qsTr("Exclude")
                indicator.width: 15
                indicator.height: 15
            }
        }

    }

}
