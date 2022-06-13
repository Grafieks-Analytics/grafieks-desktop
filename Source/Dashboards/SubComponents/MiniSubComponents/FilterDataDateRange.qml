import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQml.Models 2.2
import QtQuick.Controls 1.4 as Old

import com.grafieks.singleton.constants 1.0
import com.grafieks.singleton.messages 1.0

import "../../../MainSubComponents"

Item {
    id: filterDataDateRange
    // width: 400
    width: parent.width-25
    height: 200
    anchors.horizontalCenter: parent.horizontalCenter
    property alias componentName: filterDataDateRange.objectName
    property var modelContent: []
    property bool master: false

    // filterDateTypes: ["dataListMulti", "dataListSingle", "dataDropdownSingle", "dataDropdownMulti","dataDateRange", "dataDateBefore", "dataDateAfter", "dataDateRelative"]

    property var fromDateVar : ""
    property var toDateVar : ""
    property var referenceDateVar : ""

    Popup {
        id: popup
        x: 100
        y: 100
        width: 200
        height: 300
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

        Rectangle{
            height: 300
            width: 300
            // color: "red"
            border.color: Constants.darkThemeColor
        }
    }

    function setFilterType(newFilter){
        let currentDashboardId = DashboardParamsModel.currentDashboard
        let currentSelectedCol = DashboardParamsModel.currentSelectedColumn
        DashboardParamsModel.setColumnFilterType(currentDashboardId, currentSelectedCol, newFilter)
    }

    function updateValue(){

        var updateValue = ""

        // Remove existing value
        DashboardParamsModel.deleteColumnValueMap(DashboardParamsModel.currentDashboard, componentName, "", true)

        // Fetch current filter type
        let currentDashboardId = DashboardParamsModel.currentDashboard
        let currentSelectedCol = DashboardParamsModel.currentSelectedColumn
        let currentColumnFilterType = DashboardParamsModel.fetchColumnFilterType(currentDashboardId, currentSelectedCol)

        if(currentColumnFilterType === Constants.filterDateTypes[4]){
            updateValue = fromDateVar + "," + toDateVar
        } else {
            updateValue = referenceDateVar
        }

        // Update new value
        DashboardParamsModel.setColumnValueMap(DashboardParamsModel.currentDashboard, componentName, updateValue)

        closePopup()

    }

    function filterClicked(){

        var columnAlias = DashboardParamsModel.fetchColumnAliasName(DashboardParamsModel.currentDashboard, componentName)
        var currentColumnType = TableColumnsModel.findColumnType(columnAlias)
        DashboardParamsModel.setCurrentColumnType(currentColumnType)
        DashboardParamsModel.setCurrentSelectedColumn(componentName)

        labelShapePopup1.visible = true
    }


    function fromDate(d){
        fromDateVar = d
        console.log("valueDate from", fromDateVar)
    }

    function toDate(d){
        toDateVar = d
        console.log("valueDate to", toDateVar)
    }
    function beforeDate(d){
        referenceDateVar = d
        console.log("valueDate before", referenceDateVar)
    }
    function afterDate(d){
        referenceDateVar = d
        console.log("valueDate after", referenceDateVar)
    }

    function closePopup(){
        popupq.close()
    }

    Component.onCompleted: {
        popupq.open()
    }

    ButtonGroup{
        id:buttonGroupSingleList
    }




    Rectangle{
        height: parent.height
        width: parent.width
        color: "white"
        border.color: Constants.darkThemeColor



        Rectangle{
            id:columnName
            width:parent.width
            height:25
            color: Constants.themeColor
            // Button {
            //     text: "Open"
            //     onClicked: popupq.open()
            // }

            Popup {
                id: popupq
                x: -680
                y: 50
                width: 800
                height: 400
                modal: false
                focus: true
                closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent



                Rectangle{
                    id:container
                    height: parent.height-60
                    width: 200
                    border.color: Constants.darkThemeColor
                    anchors.right:parent.right


                    TabBar {
                        id: bar
                        width: parent.width-10
                        height:parent.height
                        anchors.right:parent.right
                        TabButton {
                            id:btn1
                            width: 170
                            anchors.right:parent.right
                            anchors.topMargin:10
                            anchors.horizontalCenter: container.horizontalCenter
                            text: qsTr("From - To")
                            onClicked:  setFilterType(Constants.filterDateTypes[4])
                            Rectangle {
                                anchors.fill: parent
                                color: ( parent.pressed ? "white" : "#2E87C5" )
                                opacity: 0.5
                            }
                        }
                        TabButton {
                            id:btn2
                            anchors.top:btn1.bottom
                            width: 170
                            anchors.right:parent.right
                            anchors.topMargin:20
                            anchors.horizontalCenter: container.horizontalCenter
                            text: qsTr("Before")
                            onClicked:  setFilterType(Constants.filterDateTypes[5])
                            Rectangle {
                                anchors.fill: parent
                                color: ( parent.pressed ? "white" : "#2E87C5" )
                                opacity: 0.5
                            }
                        }
                        TabButton {
                            id:btn3
                            anchors.top:btn2.bottom
                            width: 170
                            anchors.right:parent.right
                            anchors.topMargin:20
                            anchors.horizontalCenter: container.horizontalCenter
                            text: qsTr("After")
                            onClicked: setFilterType(Constants.filterDateTypes[6])
                            Rectangle {
                                anchors.fill: parent
                                color: ( parent.pressed ? "white" : "#2E87C5" )
                                opacity: 0.5
                            }
                        }
                        TabButton {
                            anchors.top:btn3.bottom
                            anchors.right:parent.right
                            width: 170
                            anchors.topMargin:20
                            anchors.horizontalCenter: container.horizontalCenter
                            text: qsTr("Relative")
                            onClicked:  setFilterType(Constants.filterDateTypes[7])
                            Rectangle {
                                anchors.fill: parent
                                color: ( parent.pressed ? "white" : "#2E87C5" )
                                opacity: 0.5
                            }
                        }
                    }


                }
                Rectangle{
                    height:60
                    width:parent.width
                    anchors.bottom:parent.bottom

                    TabBar{

                        id: apply_btn1q
                        anchors.top: bottomButtons.top
                        anchors.topMargin: 3

                        anchors.left: parent.left
                        anchors.leftMargin: 5
                        width: parent.width/2-60
                        height:60


                        TabButton{
                            id:okBtn
                            height:40
                            anchors.bottom:parent.bottom
                            

                            background: Rectangle {
                                id: filter_cancel_btn_background1q
                                color:  "#2E87C5"
                            }
                            contentItem: Text{
                                id: filter_cancel_btn_text1q
                                text: "ok"
                                color:  "white"
                                horizontalAlignment: Text.AlignHCenter
                                anchors.bottom:parent.bottom
                                // verticalAlignment: Text.AlignVCenter
                            }
                            onClicked: updateValue()

                        }
                        TabButton{
                            height:40
                            anchors.bottom:parent.bottom
                            anchors.left:okBtn.right
                            anchors.leftMargin:15

                            background: Rectangle {
                                id: filter_cancel_btn_background1qa
                                color:  "white"
                                border.color:"#2E87C5"
                                border.width:2
                            }
                            contentItem: Text{
                                id: filter_cancel_btn_text1qa
                                text: "Remove Filter"
                                
                                color:  "#2E87C5"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            onClicked: closePopup()

                        }

                    }
                    TabBar{

                        id: apply_btn1
                        anchors.top: bottomButtons.top
                        anchors.topMargin: 3

                        anchors.right: parent.right
                        anchors.rightMargin: 5
                        width: parent.width/3-60
                        height:60



                        TabButton{
                            id: filter_cancel_btn1
                            height:40
                            anchors.bottom:parent.bottom

                            background: Rectangle {
                                id: filter_cancel_btn_background1
                                color:  "white"
                                border.color:"#2E87C5"
                                border.width:2
                            }
                            contentItem: Text{
                                id: filter_cancel_btn_text1
                                text: "cancel"
                                
                                color:  "#2E87C5"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            onClicked: closePopup()

                        }

                    }
                }


                StackLayout {
                    width: parent.width
                    currentIndex: bar.currentIndex
                    Item {
                        id: rangeDateTab
                        Rectangle{
                            height:300
                            width:580
                            // color:"red"
                            Old.Calendar {
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                id: calendar1
                                selectedDate: new Date()
                                onSelectedDateChanged:fromDate(selectedDate)
                            }
                            Old.Calendar {
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                id: calendar2
                                selectedDate: new Date()
                                onSelectedDateChanged:toDate(selectedDate)
                            }
                        }
                    }
                    Item {
                        id: beforeDateTab
                        Rectangle{
                            height:300
                            width:580
                            // color:"yellow"
                            Old.Calendar {
                                anchors.centerIn: parent
                                id: calendar3
                                selectedDate: new Date()
                                onSelectedDateChanged:beforeDate(selectedDate)
                            }
                        }
                    }
                    Item {
                        id: afterDateTab
                        Rectangle{
                            height:300
                            width:580
                            // color:"blue"
                            Old.Calendar {
                                anchors.centerIn: parent
                                id: calendar4
                                selectedDate: new Date()
                                onSelectedDateChanged:afterDate(selectedDate)
                            }
                        }
                    }
                    Item {
                        id: customDateTab
                        Rectangle{
                            height:300
                            width:580
                            // color:"pink"
                            Rectangle{
                                id: groupSelectRow
                                anchors.top: parent.top
                                anchors.right: parent.right
                                color:"transparent"

                                width: parent.width
                                height: 200
                                anchors.rightMargin: 20


                                ListModel{
                                    id: listModel2
                                    ListElement{
                                        menuItem:"Value 1"
                                    }
                                    ListElement{
                                        menuItem:"Value 2"
                                    }
                                    ListElement{
                                        menuItem:"Value 3"
                                    }
                                    ListElement{
                                        menuItem:"Value 4"
                                    }
                                    ListElement{
                                        menuItem:"Value 5"
                                    }
                                    ListElement{
                                        menuItem:"Value 6"
                                    }

                                }
                                ListModel{
                                    id: listModel3
                                    ListElement{
                                        menuItem:"Value 11"
                                    }
                                    ListElement{
                                        menuItem:"Value 21"
                                    }
                                    ListElement{
                                        menuItem:"Value 31"
                                    }
                                    ListElement{
                                        menuItem:"Value 41"
                                    }
                                    ListElement{
                                        menuItem:"Value 51"
                                    }
                                    ListElement{
                                        menuItem:"Value 61"
                                    }

                                }
                                Rectangle{
                                    height:80
                                    width:parent.width-20
                                    anchors.left:parent.left
                                    anchors.leftMargin:20
                                    ComboBox {
                                        id: selectOption2
                                        model: listModel2
                                        width: 200
                                        height: 50
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.left: parent.left
                                        anchors.leftMargin:25
                                        background: Rectangle {
                                            color:"white"
                                            border.width: parent && parent.activeFocus ? 2 : 1
                                            border.color: parent && parent.activeFocus ? comboBoxCustom.palette.highlight : comboBoxCustom.palette.button
                                        }
                                    }
                                    TextField {
                                        id: numeroTelefoneTextField

                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.leftMargin:15
                                        // anchors.right: selectOptio3.right
                                        anchors.left: selectOption2.right

                                        width: 100
                                        height: 50

                                        placeholderText: qsTr("7")

                                        validator: IntValidator {
                                            bottom: 1
                                            top: 100
                                        }

                                        font.bold: true

                                        inputMethodHints: Qt.ImhDigitsOnly
                                    }
                                    ComboBox{
                                        id: selectOption3
                                        model: listModel3
                                        anchors.leftMargin:15
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: 150
                                        height: 50
                                        anchors.left: numeroTelefoneTextField.right
                                        background: Rectangle {
                                            color:"white"
                                            border.width: parent && parent.activeFocus ? 2 : 1
                                            border.color: parent && parent.activeFocus ? comboBoxCustom.palette.highlight : comboBoxCustom.palette.button
                                        }
                                    }
                                }




                                

                            }
                        }
                    }
                }




            }

            border.color: Constants.darkThemeColor
            Row{

                spacing: 10

                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 15




                Text {
                    id: componentTitle
                    width:110
                    text: DashboardParamsModel.fetchColumnAliasName(currentDashboardId, componentName)
                    elide: Text.ElideRight
                    font.pixelSize: Constants.fontCategoryHeaderMedium
                    verticalAlignment: Text.AlignVCenter


                }

                Row{

                    height: parent.height
                    width: 40
                    spacing: 5
                    anchors.verticalCenter: parent.verticalCenter



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
                            onClicked: filterClicked()
                        }

                    }
                }

            }

        }

        Rectangle{
            id: searchFilter
            visible: false
            anchors.top: columnName.bottom
            anchors.topMargin: 10
            height: 0
            width: parent.width-10
            anchors.horizontalCenter: parent.horizontalCenter
            TextField{
                id: searchText
                width: parent.width-10
                selectByMouse: true
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top

                placeholderText: Messages.search
                background: Rectangle {
                    border.color: Constants.borderBlueColor
                    width: parent.width
                    border.width: Constants.borderWidth
                }
                onTextChanged: searchData(searchText.text)

            }

        }

        BusyIndicatorTpl{
            id: idPlesaeWaitThorbber
            anchors.centerIn: parent
        }

        Text {
            id: idPlesaeWaitText
            text: Messages.loadingPleaseWait
            anchors.top: idPlesaeWaitThorbber.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }


    }

}
