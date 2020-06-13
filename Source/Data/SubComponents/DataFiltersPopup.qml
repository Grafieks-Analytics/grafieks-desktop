import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents"

Popup {
    id: dataFilterPopup
    width: 400
    height: 400
    x: parent.width/2 - dataFilterPopup.width/2
    y: 10
    modal: true
    visible: false
    padding: 0

    background: Rectangle{
        color: Constants.themeColor
        border.color: Constants.darkThemeColor
    }

    ListModel{
        id: checkListModel

        ListElement{
            textValue:"All"
        }

        ListElement{
            textValue:"All 1"
        }

        ListElement{
            textValue:"All 2"
        }

        ListElement{
            textValue:"All 3"
        }
    }

    Row{
        id: fullExtactRadioBtn
        height: 40
        width: parent.width

        Column{

            id: listRadioColumn
            anchors.top: fullExtactRadioBtn.top

            padding: 10
            leftPadding: 30

            RadioButtonTpl{
                id: listRadio
                radio_text: qsTr("List")
                radio_checked: false
                parent_dimension: 16
            }

        }

        Column{
            id: wildcardRadioColumn

            anchors.top: fullExtactRadioBtn.top
            padding: 10
            leftPadding: 50

            RadioButtonTpl{
                id: wildcardRadio
                radio_text: qsTr("Wildcard")
                radio_checked: false
                parent_dimension: 16

            }
        }
        Column{
            id: topRadioColumn

            anchors.top: fullExtactRadioBtn.top
            padding: 10
            leftPadding: 50

            RadioButtonTpl{
                id: topRadio
                radio_text: qsTr("Top")
                radio_checked: false
                parent_dimension: 16
            }
        }
    }

    Rectangle{
        id: content
        height: parent.height - 80
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
                    radio_checked: false
                    parent_dimension: 16
                }

            }

            Column{
                id: singleSelectRadioColumn

                anchors.top: selectTypeRadioBtn.top
                padding: 10
                leftPadding: 100

                RadioButtonTpl{
                    id: singleSelectRadio
                    radio_text: qsTr("Single Select")
                    radio_checked: false
                    parent_dimension: 16

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
            id: innerContent
            height: 180
            width: parent.width - 30

            anchors.top: searchTextBox.bottom
            anchors.left: searchTextBox.left
            anchors.leftMargin: 15
            anchors.topMargin: 8

            color: Constants.themeColor
            border.color: Constants.darkThemeColor



            ListView{

                id: checkList
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


        }

        Row{
            anchors.top:  innerContent.bottom
            anchors.left: parent.left
            height: 30
            id: includeExcludeRow
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

    Row{
        anchors.top:content.bottom
        anchors.right: parent.right
        anchors.topMargin: 5
        anchors.rightMargin: 20
        spacing: 5

        Button{
            id: cancel_btn1
            text: "Cancel"
            onClicked: {
                dataFilterPopup.visible = false
            }

            background: Rectangle {
                id: cancel_btn1_background
                color: cancel_btn1.pressed? Constants.themeColor: Constants.darkThemeColor

            }

            contentItem: Text{
                id:cancel_btn1_text
                text: cancel_btn1.text
                color:"black"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }


        }


        Button{
            id: apply_btn1
            text: "Apply"

            background: Rectangle {
                id: apply_btn1_background
                color: apply_btn1.pressed? Constants.themeColor: Constants.darkThemeColor

            }

            contentItem: Text{
                id:apply_btn1_text
                text: apply_btn1.text
                color:"black"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: {
                dataFilterPopup.visible = false
            }
        }
    }
}
