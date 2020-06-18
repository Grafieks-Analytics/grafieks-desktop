import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents"

Popup {
    id: dataFilterPopup
    width: parent.width
    height: parent.width
    x: 0
    y: 0
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

            width: parent.width/3
            anchors.left: parent.left
            leftPadding: 30
            topPadding: 8
            anchors.verticalCenter: parent.verticalCenter

            RadioButtonTpl{
                id: listRadio
                radio_text: qsTr("List")
                radio_checked: true
                parent_dimension: 16

                MouseArea{
                    anchors.fill:parent
                    onClicked: {
                        listRadio.radio_checked = true
                        wildcardRadio.radio_checked = false
                        topRadio.radio_checked = false

                        listContent.visible = true
                        wildcardContent.visible = false
                        topContent.visible = false
                    }
                }
            }

        }
        Column{
            id: wildcardRadioColumn
            topPadding: 10
            bottomPadding: 10
            leftPadding: 50
            width: parent.width /3
            anchors.top: fullExtactRadioBtn.top
            anchors.centerIn: parent

            RadioButtonTpl{
                id: wildcardRadio
                radio_text: qsTr("Wildcard")
                radio_checked: false
                parent_dimension: 16

                MouseArea{
                    anchors.fill:parent
                    onClicked: {
                        listRadio.radio_checked = false
                        wildcardRadio.radio_checked = true
                        topRadio.radio_checked = false


                        listContent.visible = false
                        wildcardContent.visible = true
                        topContent.visible = false
                    }
                }

            }
        }
        Column{
            id: topRadioColumn

            anchors.right: fullExtactRadioBtn.right
            topPadding: 8
            rightPadding: 30

            RadioButtonTpl{
                id: topRadio
                radio_text: qsTr("Top")
                radio_checked: false
                parent_dimension: 16


                MouseArea{
                    anchors.fill:parent
                    onClicked: {
                        listRadio.radio_checked = false
                        wildcardRadio.radio_checked = false
                        topRadio.radio_checked = true


                        listContent.visible = false
                        wildcardContent.visible = false
                        topContent.visible = true
                    }
                }
            }
        }
    }

    Rectangle{
        id: listContent
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

    Rectangle{
        id: wildcardContent
        height: parent.height - 80
        width: parent.width - 40
        x:20
        y:10
        anchors.top:  fullExtactRadioBtn.bottom
        color: Constants.whiteColor
        border.color: Constants.darkThemeColor
        visible: false

        Row{
            id: wildcardContentHeading
            width: parent.width
            Column{
                anchors.left: parent.left
                leftPadding: 20
                topPadding: 10
                Text {
                    id: addWildcard
                    text: qsTr("Add Wildcard")
                }
            }
            Column{
                anchors.right: parent.right
                rightPadding: 20
                CheckBox {
                    checked: false
                    text: qsTr("Exclude")
                    indicator.width: 15
                    indicator.height: 15

                }


            }
        }

        Row{
            id:selectWildcard
            height:30

            width: parent.width
            Rectangle{

                width: parent.width
                anchors.top: parent.top
                border.color: Constants.borderBlueColor
                TextField{
                    height: 30

                }

            }

        }
    }

    Rectangle{
        id: topContent
        height: parent.height - 80
        width: parent.width - 40
        x:20
        y:10
        visible: false
        anchors.top:  fullExtactRadioBtn.bottom
        color: Constants.whiteColor
        border.color: Constants.darkThemeColor


    }

    Row{
        id: footerContent
        anchors.bottom: parent.bottom
//        anchors.right: parent.right
        anchors.bottomMargin: 5
        anchors.rightMargin: 20
        spacing: 5
        height: 30
        width: parent.width


        Button{
            id: resetBtn
            text: "Reset"

            anchors.left: parent.left
            anchors.leftMargin: 20


            background: Rectangle {
                id: resetBtnBackground
                color: resetBtn.hovered? Constants.buttonHoverColor    : Constants.darkThemeColor

            }

            contentItem: Text{
                id:resetBtnText
                text: resetBtn.text
                color:"black"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: {
                dataFilterPopup.visible = false
            }
        }



        Button{
            id: apply_btn1
            text: "Apply"

            anchors.right: parent.right
            anchors.rightMargin: 20


            background: Rectangle {
                id: apply_btn1_background
                color: apply_btn1.hovered? Constants.buttonHoverColor    : Constants.darkThemeColor

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


        Button{
            id: cancel_btn1

            anchors.right: apply_btn1.left
            anchors.rightMargin: 20

            text: "Cancel"
            onClicked: {
                dataFilterPopup.visible = false
            }

            background: Rectangle {
                id: cancel_btn1_background
                color: cancel_btn1.hovered? Constants.buttonHoverColor    : Constants.darkThemeColor

            }

            contentItem: Text{
                id:cancel_btn1_text
                text: cancel_btn1.text
                color:"black"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }


        }


        }
}
