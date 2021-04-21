/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Dashboard/Subcomponents
** Dashboard Filters
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3


import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents"
import "../../Reports/SubComponents/MiniSubComponents"

Item {


    ListModel{
        id:filterData
        ListElement{
            name:"All"
        }
        ListElement{
            name:"data2"
        }
        ListElement{
            name:"data3"
        }
        ListElement{
            name:"data4"
        }
        ListElement{
            name:"data5"
        }
        ListElement{
            name:"data5"
        }
        ListElement{
            name:"data5"
        }

    }
    //    js funct
    function toggleSearch(){

        if(searchFilter.visible){
            searchFilter.visible=false
            searchFilter.height=0
            return
        }
        searchFilter.visible=true
        searchFilter.height=30
    }


    function propertyPressed(){
        firstLine.visible=true
        secondLine.visible=false
        thirdLine.visible=false
        fourthLine.visible=false

    }
    function filterTypePressed(){
        secondLine.visible=true
        firstLine.visible=false
        thirdLine.visible=false
        fourthLine.visible=false
    }
    function valuePressed(){
        thirdLine.visible=true
        firstLine.visible=false
        secondLine.visible=false
        fourthLine.visible=false
    }
    function applyPressed(){
        fourthLine.visible=true
        firstLine.visible=false
        secondLine.visible=false
        thirdLine.visible=false
    }

    Component{
        id:multipleselect
        Row{
            CheckBoxTpl{
                checkbox_text: qsTr(name)
                checkbox_checked: true
                parent_dimension: 14
            }
        }
    }
    ButtonGroup{
        id:buttonGroupSingle
    }
    ButtonGroup{
        id:buttonGroupFilterType
    }

    Component{
        id:singleselect
        Row{
            CustomRadioButton{
                ButtonGroup.group: buttonGroupSingle
                radio_text: qsTr(name)
                radio_checked: false
                parent_dimension: 16
            }
        }
    }



    id: dashboard_filter
    width:200
    height:parent.height

    anchors.left: parent.left
    anchors.leftMargin: 3
    Rectangle{
        id: show_filter
        height:28
        width:parent.width-5
        anchors.top: parent.top
        anchors.topMargin: 4
        anchors.left: parent.left
        anchors.leftMargin: 5
        Text{
            text: "Select Filter"

            anchors.topMargin: 5


            id:selectFilter
            font.pointSize: 9


            anchors.top: parent.top
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

        }
    }
    TabBar{

        id: apply_btn
        anchors.horizontalCenter: rectangle4.horizontalCenter
        anchors.top: show_filter.bottom
        anchors.topMargin: 4
        anchors.left: parent.left
        anchors.leftMargin: 5
        width: parent.width-10
        height:23

        TabButton{
            id: filter_cancel_btn
            text: "Cancel"

            background: Rectangle {
                id: filter_cancel_btn_background
                color:  filter_cancel_btn.pressed? Constants.darkThemeColor: Constants.redThemeColor



            }
            contentItem: Text{
                id: filter_cancel_btn_text
                text: filter_cancel_btn.text
                color:  "black"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        TabButton{
            id: filter_apply_btn
            text: "Add"

            background: Rectangle {
                id: filter_apply_btn_background
                color:  filter_apply_btn.pressed? Constants.darkThemeColor: Constants.greenThemeColor
                //                color:  filter_apply_btn.pressed? Constants.darkThemeColor: "#F4F4F4"

            }
            contentItem: Text{
                id: filter_apply_btn_text
                text: filter_apply_btn.text
                color:  "black"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

    }



    Rectangle {
        id: rectangle1

        width: parent.width-20
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: apply_btn.bottom
        anchors.topMargin: 10
        height: 200
        color: "white"
        border.color: Constants.themeColor
        Rectangle{
            id:columnName

            width:parent.width
            height:25

            border.color: Constants.themeColor
            Row{

                spacing: 45




                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter


                Text {
                    id: text4
                    text: qsTr("Customer Name")
                    font.pixelSize: 12
                    verticalAlignment: Text.AlignVCenter
                }

                Row{

                    height: parent.height
                    width: 40
                    spacing: 5
                    Image {
                        source: "/Images/icons/iconmonstr-search-thin.svg"
                        width: 14
                        height: 14

                        MouseArea{
                            anchors.fill: parent
                            onClicked:  toggleSearch()
                        }
                    }
                    Image {
                        source: "/Images/icons/customize.png"
                        width: 16
                        height: 16
                        MouseArea{
                            anchors.fill: parent
                            onClicked: labelShapePopup1.visible = true
                        }

                    }
                }

            }

        }

        Rectangle{
            id: searchFilter
            visible: false
            anchors.top: columnName.bottom
            height: 0
            width: parent.width
            //                color: "red"
            TextField{


                width: parent.width-10
                selectByMouse: true
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top


                placeholderText: qsTr("Search")
                background: Rectangle {
                    border.color: Constants.themeColor
                    width: parent.width
                    border.width: Constants.borderWidth
                }
            }

        }




        ListView{
            anchors.top: searchFilter.bottom
            topMargin: 10
            height:150
            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds
            clip: true
            ScrollBar.vertical: CustomScrollBar {}
            width: parent.width
            model: filterData
            delegate:{
                if(0){
                    return multipleselect
                }
                else if(1){
                    return singleselect
                }

                else{
                    return null
                }

            }
        }

        ComboBox {
            id:control
            y:200
            width: parent.width
            model: filterData
            indicator: Canvas {
                id: canvas
                x: control.width - width - control.rightPadding
                y: control.topPadding + (control.availableHeight - height) / 2
                width: 12
                height: 8
                contextType: "2d"

                Connections {
                    target: control
                    onPressedChanged: canvas.requestPaint()
                }

                onPaint: {
                    context.reset();
                    context.moveTo(0, 0);
                    context.lineTo(width, 0);
                    context.lineTo(width / 2, height);
                    context.closePath();
                    context.fillStyle = control.pressed ? "#black" : "#gray";
                    context.fill();
                }
            }
        }
        ComboBox {
            id: comboBox
            indicator: Canvas {
                id: canvasMultiselect
                x: comboBox.width - width - comboBox.rightPadding
                y: comboBox.topPadding + (comboBox.availableHeight - height) / 2
                width: 12
                height: 8
                contextType: "2d"

                Connections {
                    target: comboBox
                    onPressedChanged: canvas.requestPaint()
                }

                onPaint: {
                    context.reset();
                    context.moveTo(0, 0);
                    context.lineTo(width, 0);
                    context.lineTo(width / 2, height);
                    context.closePath();
                    context.fillStyle = comboBox.pressed ? "#black" : "#gray";
                    context.fill();
                }
            }
            y:260
            //                anchors.centerIn: parent
            width: parent.width

            //                displayText: "Select"

            model: filterData
            // ComboBox closes the popup when its items (anything AbstractButton derivative) are
            //  activated. Wrapping the delegate into a plain Item prevents that.
            delegate: Item {
                width: parent.width
                height: checkDelegate.height

                function toggle() { checkDelegate.toggle() }
                //                    CheckBoxTpl{
                //                        checkbox_text: qsTr(name)
                //                        checkbox_checked: true
                //                        parent_dimension: 14
                //                    }
                CheckDelegate {
                    id: checkDelegate
                    indicator: Rectangle {
                        id: parent_border
                        implicitHeight: 16
                        implicitWidth: 16
                        x:  checkDelegate.leftPadding
                        y: parent.height / 2 - height / 2
                        border.color: "black"


                        Rectangle {
                            id: child_border
                            width: 8
                            height: width
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: checkDelegate.down ?  Constants.darkThemeColor : "black"
                            visible: checkDelegate.checked
                        }
                    }
                    anchors.fill: parent
                    //                    text: model.name
                    contentItem: Text {
                        text: model.name
                        elide: Text.ElideLeft
                        leftPadding: checkDelegate.indicator.width + checkDelegate.spacing
                    }



                    highlighted: comboBox.highlightedIndex == index
                    checked: model.selected
                    onCheckedChanged: model.selected = checked
                }
            }
        }
    }


    Popup {
        id: labelShapePopup1


        width: 460
        height: 520

        x: -parent.width-labelShapePopup1.width+200
        y:70
        modal: false
        visible: false
        padding: 0


        Rectangle{
            id:settingHead
            width:parent.width
            height: 40
            color: Constants.lightThemeColor

            Text {
                id: text8
                text: qsTr("Filter")
                font.pixelSize: 17
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
            }
            Image {
                source: "/Images/icons/close gray.png"
                width: 14
                height: 14
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin:10

            }
        }


        Rectangle{
            id:settingFilterLeft
            anchors.top: settingHead.bottom
            //            anchors.topMargin: 19
            height: parent.height-settingHead.height
            width:150
            border.color: Constants.themeColor

            Column{

                //                spacing: 30
                padding: 0
                anchors.left: parent.left
                anchors.leftMargin: 20
                //                y:10
                TabBar {
                    id: bar
                    width: firstBtn.width
                    height: 100
                    anchors.left: parent.left
                    anchors.leftMargin: -20
                    anchors.top: settingFilterLeft.bottom
                    //                    anchors.topMargin: 800
                    //                    spacing: 5
                    //                    topPadding: 10

                    TabButton {
                        id: firstBtn
                        width: 150
                        height: 70
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        //                         topPadding: 100
                        //                         bottomPadding: 100
                        background: Rectangle{
                            height: 50
                            width:150
                            color: "white"
                            anchors.verticalCenter: parent.verticalCenter
                            Rectangle {
                                id:firstLine
                                width: parent.width-50
                                height: 3
                                visible: true
                                color: "#009B8F"
                                anchors.bottom: parent.bottom
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                        Text {
                            text: qsTr("Property")
                            font.pixelSize: 17
                            anchors.verticalCenter: parent.verticalCenter
                            //                            anchors.horizontalCenter: parent.horizontalCenter
                            x:30
                            verticalAlignment: Text.AlignVCenter
                            styleColor : "white"
                        }
                        onPressed:propertyPressed()
                    }
                    TabButton {
                        id: secondBtn
                        width: 150
                        height: 70
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: firstBtn.bottom
                        anchors.topMargin: parent.spacing
                        background: Rectangle{
                            height: 50
                            width:150
                            color: "white"
                            anchors.verticalCenter: parent.verticalCenter
                            Rectangle {
                                id:secondLine
                                visible: false
                                width: parent.width-50
                                height: 3
                                color: "#009B8F"
                                anchors.bottom: parent.bottom
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                        Text {

                            text: qsTr("Filter Type")
                            font.pixelSize: 17
                            anchors.verticalCenter: parent.verticalCenter
                            x:30
                            verticalAlignment: Text.AlignVCenter
                            styleColor : "white"
                        }

                        onPressed:filterTypePressed()
                    }
                    TabButton {
                        id: thirdBtn
                        width: 150
                        height: 70
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: secondBtn.bottom
                        anchors.topMargin: parent.spacing
                        background: Rectangle{
                            id:backgroundColor
                            height: 50
                            width:150
                            color: "white"
                            anchors.verticalCenter: parent.verticalCenter
                            Rectangle {
                                id:thirdLine
                                visible: false
                                width: parent.width-50
                                height: 3
                                color: "#009B8F"
                                anchors.bottom: parent.bottom
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                        Text {

                            text: qsTr("Value")
                            font.pixelSize: 17
                            anchors.verticalCenter: parent.verticalCenter
                            x:30
                            verticalAlignment: Text.AlignVCenter
                            styleColor : "white"
                        }
                        onPressed:valuePressed()

                    }
                    TabButton {
                        id: fourthBtn
                        width: 150
                        height: 70
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: thirdBtn.bottom
                        anchors.topMargin: parent.spacing
                        background: Rectangle{
                            height: 50
                            width:150
                            color: "white"
                            anchors.verticalCenter: parent.verticalCenter
                            Rectangle {
                                id:fourthLine
                                visible: false
                                width: parent.width-50
                                height: 3
                                color: "#009B8F"
                                anchors.bottom: parent.bottom
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                        Text {

                            text: qsTr("Apply")
                            font.pixelSize: 17
                            anchors.verticalCenter: parent.verticalCenter
                            x:30
                            verticalAlignment: Text.AlignVCenter
                            styleColor : "white"
                        }
                        onPressed:applyPressed()
                    }
                }


            }
        }
        Rectangle{
            id:settingFilterRight
            anchors.top: settingHead.bottom
            anchors.left: settingFilterLeft.right
            height: parent.height-settingHead.height
            width:parent.width - settingFilterLeft.width
            border.color: Constants.themeColor
            StackLayout {
                width: parent.width
                currentIndex: bar.currentIndex
                anchors.top: settingHead.bottom
                Item {
                    id: propertyTab
                    Rectangle{
                        height: settingFilterRight.height
                        width: settingFilterRight.width
                        color: "white"
                        border.color: Constants.themeColor
                        anchors.horizontalCenter: parent.horizontalCenter

                        Row{
                            id: renameEdit
                            y:40
                            spacing:1
                            height: 50
                            width: parent.width/1.5
                            anchors.horizontalCenter:  parent.horizontalCenter

                            Text {
                                id: rename
                                text: qsTr("Rename")
                                font.pixelSize: 17

                                //                                anchors.horizontalCenter:  parent.horizontalCenter
                                //                                horizontalAlignment: Text.horizontalAlignment
                                //                                anchors.left: parent.left
                                //                                anchors.leftMargin: 10
                            }


                            TextField{
                                width: 130
                                selectByMouse: true
                                //                                anchors.horizontalCenter: parent.horizontalCenter
                                //                                anchors.top: parent.top
                                anchors.left: rename.right
                                anchors.leftMargin: 50


                                placeholderText: qsTr("Rename")
                                background: Rectangle {

                                    border.color: Constants.themeColor
                                    width: 130
                                    border.width: Constants.borderWidth
                                }
                            }




                        }

                        Text {
                            id: propertyList
                            text: qsTr("Show only")
                            font.pixelSize: 17


                            anchors.horizontalCenter:  parent.horizontalCenter
                            horizontalAlignment: Text.horizontalAlignment
                            anchors.left: parent.left
                            anchors.leftMargin: 50
                            anchors.top: renameEdit.bottom
                        }
                        ColumnLayout {
                            id: radioGroup5
                            anchors.top: propertyList.bottom
                            anchors.topMargin: 15
                            anchors.horizontalCenter:  parent.horizontalCenter



                            spacing: 15
                            RadioButton {
                                id: control9
                                ButtonGroup.group: buttonGroupFilterType
                                indicator: Rectangle {
                                    implicitWidth: 16
                                    implicitHeight: 16
                                    x: control9.width - width - control9.rightPadding
                                    y: parent.height / 2 - height / 2
                                    radius: 13
                                    color: "transparent"
                                    border.color: "black"

                                    Rectangle {
                                        width: 16/2
                                        height: width
                                        radius: width/2
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        color: "black"
                                        visible: control9.checked
                                    }
                                }

                                contentItem: Text {
                                    rightPadding: control9.indicator.width + control9.spacing+60
                                    text: qsTr("Relevant Data")
                                    elide: Text.ElideRight
                                    font.pixelSize: 15
                                    verticalAlignment: Text.AlignVCenter
                                }



                            }

                            RadioButton {
                                id: control10
                                ButtonGroup.group: buttonGroupFilterType
                                indicator: Rectangle {
                                    implicitWidth: 16
                                    implicitHeight: 16
                                    x: control10.width - width - control10.rightPadding
                                    y: parent.height / 2 - height / 2
                                    radius: 13
                                    color: "transparent"
                                    border.color: "black"

                                    Rectangle {
                                        width: 16/2
                                        height: width
                                        radius: width/2
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        color: "black"
                                        visible: control10.checked
                                    }
                                }

                                contentItem: Text {
                                    rightPadding: control10.indicator.width + control10.spacing+102
                                    text: qsTr("All Data")
                                    elide: Text.ElideRight
                                    font.pixelSize: 15
                                    verticalAlignment: Text.AlignVCenter
                                }



                            }


                        }

                    }
                }
                Item {
                    id: filterTypeTab
                    Rectangle{
                        height: settingFilterRight.height-50
                        width: settingFilterRight.width-80
                        y:40
                        anchors.horizontalCenter: parent.horizontalCenter
                        //                        color: "yellow"

                        Text {
                            id: listText
                            text: qsTr("List")
                            font.pixelSize: 17

                            anchors.horizontalCenter:  parent.horizontalCenter
                            horizontalAlignment: Text.horizontalAlignment
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                        }
                        ColumnLayout {
                            id: radioGroup1
                            anchors.top: listText.bottom
                            anchors.topMargin: 15
                            x:15

                            spacing: 15
                            RadioButton {
                                id: control1
                                ButtonGroup.group: buttonGroupFilterType
                                indicator: Rectangle {
                                    implicitWidth: 16
                                    implicitHeight: 16
                                    x: control1.width - width - control1.rightPadding
                                    y: parent.height / 2 - height / 2
                                    radius: 13
                                    color: "transparent"
                                    border.color: "black"

                                    Rectangle {
                                        width: 16/2
                                        height: width
                                        radius: width/2
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        color: "black"
                                        visible: control1.checked
                                    }
                                }

                                contentItem: Text {
                                    rightPadding: control1.indicator.width + control1.spacing+60
                                    text: qsTr("Single Value")
                                    elide: Text.ElideRight
                                    font.pixelSize: 15
                                    verticalAlignment: Text.AlignVCenter
                                }



                            }

                            RadioButton {
                                id: control2
                                ButtonGroup.group: buttonGroupFilterType
                                indicator: Rectangle {
                                    implicitWidth: 16
                                    implicitHeight: 16
                                    x: control2.width - width - control2.rightPadding
                                    y: parent.height / 2 - height / 2
                                    radius: 13
                                    color: "transparent"
                                    border.color: "black"

                                    Rectangle {
                                        width: 16/2
                                        height: width
                                        radius: width/2
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        color: "black"
                                        visible: control2.checked
                                    }
                                }

                                contentItem: Text {
                                    rightPadding: control2.indicator.width + control2.spacing+49
                                    text: qsTr("Multiple Value")
                                    elide: Text.ElideRight
                                    font.pixelSize: 15
                                    verticalAlignment: Text.AlignVCenter
                                }



                            }

                        }
                        Text {
                            id: dropDownText
                            text: qsTr("Drop Down")
                            font.pixelSize: 17
                            anchors.top: radioGroup1.bottom

                            anchors.horizontalCenter:  parent.horizontalCenter
                            horizontalAlignment: Text.horizontalAlignment
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            anchors.margins: 15

                        }
                        ColumnLayout {
                            anchors.top: dropDownText.bottom
                            x:15
                            anchors.margins: 15
                            spacing: 15
                            RadioButton {
                                id: control3
                                ButtonGroup.group: buttonGroupFilterType
                                indicator: Rectangle {
                                    implicitWidth: 16
                                    implicitHeight: 16
                                    x: control3.width - width - control3.rightPadding
                                    y: parent.height / 2 - height / 2
                                    radius: 13
                                    color: "transparent"
                                    border.color: "black"

                                    Rectangle {
                                        width: 16/2
                                        height: width
                                        radius: width/2
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        color: "black"
                                        visible: control3.checked
                                    }
                                }

                                contentItem: Text {
                                    rightPadding: control3.indicator.width + control3.spacing+60
                                    text: qsTr("Single Value")
                                    elide: Text.ElideRight
                                    font.pixelSize: 15
                                    verticalAlignment: Text.AlignVCenter
                                }



                            }
                            RadioButton {
                                id: control4
                                ButtonGroup.group: buttonGroupFilterType
                                indicator: Rectangle {
                                    implicitWidth: 16
                                    implicitHeight: 16
                                    x: control4.width - width - control4.rightPadding
                                    y: parent.height / 2 - height / 2
                                    radius: 13
                                    color: "transparent"
                                    border.color: "black"

                                    Rectangle {
                                        width: 16/2
                                        height: width
                                        radius: width/2
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        color: "black"
                                        visible: control4.checked
                                    }
                                }

                                contentItem: Text {
                                    rightPadding: control4.indicator.width + control4.spacing+49
                                    text: qsTr("Multiple Value")
                                    elide: Text.ElideRight
                                    font.pixelSize: 15
                                    verticalAlignment: Text.AlignVCenter
                                }



                            }


                        }
                    }
                }
                Item {
                    id: valueTab
                    Rectangle{
                        height: settingFilterRight.height
                        width: settingFilterRight.width
//                        color: "blue"
                        ColumnLayout {
                            id: radioGroup6
                            anchors.top: propertyList.bottom
                           y:40
                            anchors.topMargin: 15
                            anchors.horizontalCenter:  parent.horizontalCenter



                            spacing: 15
                            RadioButton {
                                id: control13
                                ButtonGroup.group: buttonGroupFilterType
                                indicator: Rectangle {
                                    implicitWidth: 16
                                    implicitHeight: 16
                                    x: control13.width - width - control13.rightPadding
                                    y: parent.height / 2 - height / 2
                                    radius: 13
                                    color: "transparent"
                                    border.color: "black"

                                    Rectangle {
                                        width: 16/2
                                        height: width
                                        radius: width/2
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        color: "black"
                                        visible: control13.checked
                                    }
                                }

                                contentItem: Text {
                                    rightPadding: control13.indicator.width + control13.spacing+60
                                    text: qsTr("Include")
                                    elide: Text.ElideRight
                                    font.pixelSize: 15
                                    verticalAlignment: Text.AlignVCenter
                                }



                            }

                            RadioButton {
                                id: control14
                                ButtonGroup.group: buttonGroupFilterType
                                indicator: Rectangle {
                                    implicitWidth: 16
                                    implicitHeight: 16
                                    x: control14.width - width - control14.rightPadding
                                    y: parent.height / 2 - height / 2
                                    radius: 13
                                    color: "transparent"
                                    border.color: "black"

                                    Rectangle {
                                        width: 16/2
                                        height: width
                                        radius: width/2
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        color: "black"
                                        visible: control14.checked
                                    }
                                }

                                contentItem: Text {
                                    rightPadding: control14.indicator.width + control14.spacing+60
                                    text: qsTr("Exclude")
                                    elide: Text.ElideRight
                                    font.pixelSize: 15
                                    verticalAlignment: Text.AlignVCenter
                                }



                            }

                        }

                    }
                }
                Item {
                    id:applyTab
                    Rectangle{
                        height: settingFilterRight.height
                        width: settingFilterRight.width
//                        color: "green"

                        RadioButton {
                            id: control15
                            ButtonGroup.group: buttonGroupFilterType
                             anchors.horizontalCenter:  parent.horizontalCenter
                                 y:40
                            indicator: Rectangle {
                                implicitWidth: 16
                                implicitHeight: 16
                                x: control15.width - width - control15.rightPadding
                                y: parent.height / 2 - height / 2
                                radius: 13
                                color: "transparent"
                                border.color: "black"

                                Rectangle {
                                    width: 16/2
                                    height: width
                                    radius: width/2
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    color: "black"
                                    visible: control15.checked
                                }
                            }

                            contentItem: Text {
                                rightPadding: control15.indicator.width + control15.spacing+60
                                text: qsTr("All Dashboards")
                                elide: Text.ElideRight
                                font.pixelSize: 15
                                verticalAlignment: Text.AlignVCenter
                            }



                        }
                        Text {
                            id: applyList
                            text: qsTr("In this Dashboard")
                            font.pixelSize: 17


                            anchors.horizontalCenter:  parent.horizontalCenter
                            horizontalAlignment: Text.horizontalAlignment
                            anchors.left: parent.left
                            anchors.leftMargin: 63
                            anchors.top: control15.bottom
                            anchors.topMargin: 20

                        }
                        ColumnLayout {
                            id: radioGroup7
                            anchors.top: applyList.bottom
                            anchors.topMargin: 15
//                            anchors.horizontalCenter:  parent.horizontalCenter

                            x:70


                            spacing: 15
                            RadioButton {
                                id: control16
                                ButtonGroup.group: buttonGroupFilterType
                                indicator: Rectangle {
                                    implicitWidth: 16
                                    implicitHeight: 16
                                    x: control16.width - width - control16.rightPadding
                                    y: parent.height / 2 - height / 2
                                    radius: 13
                                    color: "transparent"
                                    border.color: "black"

                                    Rectangle {
                                        width: 16/2
                                        height: width
                                        radius: width/2
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        color: "black"
                                        visible: control16.checked
                                    }
                                }

                                contentItem: Text {
                                    rightPadding: control16.indicator.width + control16.spacing+130
                                    text: qsTr("All")
                                    elide: Text.ElideRight
                                    font.pixelSize: 15
                                    verticalAlignment: Text.AlignVCenter
                                }



                            }

                            RadioButton {
                                id: control17
                                ButtonGroup.group: buttonGroupFilterType
                                indicator: Rectangle {
                                    implicitWidth: 16
                                    implicitHeight: 16
                                    x: control17.width - width - control17.rightPadding
                                    y: parent.height / 2 - height / 2
                                    radius: 13
                                    color: "transparent"
                                    border.color: "black"

                                    Rectangle {
                                        width: 16/2
                                        height: width
                                        radius: width/2
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        color: "black"
                                        visible: control17.checked
                                    }
                                }

                                contentItem: Text {
                                    rightPadding: control17.indicator.width + control17.spacing+90
                                    text: qsTr("Report 1")
                                    elide: Text.ElideRight
                                    font.pixelSize: 15
                                    verticalAlignment: Text.AlignVCenter
                                }



                            }


                        }
                    }
                }
            }
        }

        Rectangle{
            id:bottomButtons
            anchors.top: settingFilterLeft.bottom
//                         color: "red"
            height: 35
            width: parent.width
            border.color: Constants.themeColor


            TabBar{

                id: apply_btn1

//                                 anchors.verticalCenter: parent.verticalCenter
                anchors.top: bottomButtons.top
                anchors.topMargin: 3

                anchors.right: parent.right
                anchors.rightMargin: 5
                width: parent.width/3
                height:24


                TabButton{
                    id: filter_cancel_btn1
                    text: "Cancel"

                    background: Rectangle {
                        id: filter_cancel_btn_background1
                        color:  filter_cancel_btn1.pressed? Constants.darkThemeColor: Constants.redThemeColor



                    }
                    contentItem: Text{
                        id: filter_cancel_btn_text1
                        text: filter_cancel_btn1.text
                        color:  "black"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                TabButton{
                    id: filter_apply_btn1
                    text: "Ok"

                    background: Rectangle {
                        id: filter_apply_btn_background1
                        color:  filter_apply_btn1.pressed? Constants.darkThemeColor: Constants.greenThemeColor
                        //                color:  filter_apply_btn.pressed? Constants.darkThemeColor: "#F4F4F4"

                    }
                    contentItem: Text{
                        id: filter_apply_btn_text1
                        text: filter_apply_btn1.text
                        color:  "black"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

            }

        }
    }

    //    Rectangle {
    //        id: rectangle2
    //        //            x: 8
    //        y: 210
    //        width: parent.width
    //        height: 80
    //        anchors.left: parent.left
    //        anchors.leftMargin: 5
    //        color: "white"
    //        border.color: Constants.themeColor

    //        ToolSeparator {
    //            id: toolSeparator
    //            x: 8
    //            y: 23
    //            width: 169
    //            height: 13
    //            orientation: Qt.Horizontal
    //        }

    //        Text {
    //            id: text1
    //            x: 15
    //            y: 8
    //            text: qsTr("PO Number")
    //            font.pixelSize: 12
    //        }

    //        ToolSeparator {
    //            id: toolSeparator3
    //            x: 8
    //            y: -123
    //            width: 169
    //            height: 13
    //            orientation: Qt.Horizontal
    //        }
    //    }

    //    Rectangle {
    //        id: rectangle3
    //        //            x: 8
    //        y: 330
    //        width: parent.width
    //        anchors.left: parent.left
    //        anchors.leftMargin: 5
    //        height: 70
    //        color: "white"
    //        border.color: Constants.themeColor

    //        ToolSeparator {
    //            id: toolSeparator1
    //            x: 8
    //            y: 18
    //            width: 169
    //            height: 13
    //            orientation: Qt.Horizontal
    //        }

    //        Text {
    //            id: text2
    //            x: 15
    //            y: 8
    //            text: qsTr("Sales")
    //            font.pixelSize: 12
    //        }



    //        SliderTpl {
    //            id: rangeSlider
    //            x: 15
    //            y: 37
    //            slider_height: 10
    //            slider_width: 150
    //            knob_size: 16

    //        }


    //    }

    //    Rectangle {
    //        id: rectangle4
    //        x: 8
    //        y: 323
    //        width: 185
    //        height: 150
    //        color: "white"
    //        border.color: Constants.themeColor



    //        CustomRadioButton{
    //            id: radioButton
    //            x: 14
    //            y: 32
    //            radio_text: qsTr("Radio Button")
    //            radio_checked: false
    //            parent_dimension: 16
    //        }

    //        CustomRadioButton{
    //            id: radioButton1
    //            x: 14
    //            y: 65
    //            radio_text: qsTr("Radio Button")
    //            radio_checked: false
    //            parent_dimension: 16
    //        }

    //        CustomRadioButton{
    //            id: radioButton2
    //            x: 14
    //            y: 102
    //            radio_text: qsTr("Radio Button")
    //            radio_checked: false
    //            parent_dimension: 16
    //        }


    //        ToolSeparator {
    //            id: toolSeparator2
    //            x: 8
    //            y: 24
    //            width: 169
    //            height: 13
    //            orientation: Qt.Horizontal
    //        }

    //        Text {
    //            id: text3
    //            x: 14
    //            y: 8
    //            text: qsTr("Order Creation Date")
    //            font.pixelSize: 12
    //        }
    //    }

}
