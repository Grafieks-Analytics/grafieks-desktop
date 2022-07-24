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
    height: 65
    anchors.horizontalCenter: parent.horizontalCenter
    property alias componentName: filterDataDateRange.objectName
    property var modelContent: []
    property bool master: false

    // filterDateTypes: ["dataListMulti", "dataListSingle", "dataDropdownSingle", "dataDropdownMulti","dataDateRange", "dataDateBefore", "dataDateAfter", "dataDateRelative"]
    // property var filterDateUnits: ["Seconds", "Hours", "Days", "Weeks", "Months", "Quarters", "Years"]
    // property var filterComparators: ["Last", "Previous"]

    property var fromDateVar : ""
    property var toDateVar : ""
    property var referenceDateVar : ""
    property var customDateComparator : Constants.filterComparators[0]
    property var customDateValue : ""
    property var customDateUnit : Constants.filterComparators[0]
    property var toggleStatus : true


    // Subcomponents
    ListModel{
        id: listModel2
    }

    ListModel{
        id: listModel3
    }

    // Javascript

    onComponentNameChanged: {
        let currentSelectedColumn = DashboardParamsModel.currentSelectedColumn
        console.log("Date values Info oncompleted date", DashboardParamsModel.fetchColumnFilterType(DashboardParamsModel.currentDashboard,  currentSelectedColumn))

        var previousCheckValues = DashboardParamsModel.fetchColumnValueMap(DashboardParamsModel.currentDashboard, componentName)
        if(previousCheckValues.length > 0){
            // Info
            console.log("Date values Info", DashboardParamsModel.fetchColumnFilterType(DashboardParamsModel.currentDashboard, componentName))

            // Calendar values
            console.log("Date values", previousCheckValues)

            // Relative values
            console.log("Date values relative", DashboardParamsModel.fetchDateRelative(DashboardParamsModel.currentDashboard, componentName))
        }

        componentTitle.text = DashboardParamsModel.fetchColumnAliasName(DashboardParamsModel.currentDashboard, componentName)
    }

    Component.onCompleted: {

        popupq.open()

       

        Constants.filterComparators.forEach(function(item){
            listModel2.append({"name" : item})
        })

        Constants.filterDateUnits.forEach(function(item){
            listModel3.append({"name" : item})
        })
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
        } else if (currentColumnFilterType === Constants.filterDateTypes[7]) {
            let today= new Date();
            let relativeValue = getRelativeValue(new Date())
            updateValue = relativeValue + "," + today
            console.log(relativeValue, today)

            DashboardParamsModel.setDateRelative(DashboardParamsModel.currentDashboard, componentName, customDateComparator, customDateValue, customDateUnit)

        } else {
            updateValue = referenceDateVar
        }

        // Update new value
        DashboardParamsModel.setColumnValueMap(DashboardParamsModel.currentDashboard, componentName, updateValue)

        closePopup()
        

    }

    function getRelativeValue(today){
        let comparedDate = today
        switch(customDateUnit){

            // Seconds
        case Constants.filterDateUnits[0]:
            comparedDate.setSeconds(comparedDate.getSeconds() - customDateValue)
            break
            // Hours
        case Constants.filterDateUnits[1]:
            comparedDate.setHours(comparedDate.getHours() - customDateValue)
            break
            // Days
        case Constants.filterDateUnits[2]:
            comparedDate.setDate(comparedDate.getDate() - customDateValue)
            break
            // Weeks
        case Constants.filterDateUnits[3]:
            comparedDate.setDate(comparedDate.getDate() - customDateValue * 7)
            break
            // Months
        case Constants.filterDateUnits[4]:
            comparedDate.setMonth(comparedDate.getMonth() - customDateValue * 7)
            break
            // Quarters
        case Constants.filterDateUnits[5]:
            comparedDate.setMonth(comparedDate.getMonth() - customDateValue * 3)
            break
            // Years
        case Constants.filterDateUnits[6]:
            comparedDate.setYear(comparedDate.getFullYear() - customDateValue)
            break

        }

        return comparedDate
    }

    function filterClicked(){

        var columnAlias = DashboardParamsModel.fetchColumnAliasName(DashboardParamsModel.currentDashboard, componentName)
        var currentColumnType = TableColumnsModel.findColumnType(columnAlias)
        DashboardParamsModel.setCurrentColumnType(currentColumnType)
        DashboardParamsModel.setCurrentSelectedColumn(componentName)

        labelShapePopup1.visible = true
    }


    function fromDate(d){
        fromDateVar = d.toISOString().split('T')[0]
        console.log("valueDate from", fromDateVar)
    }

    function toDate(d){
        toDateVar = d.toISOString().split('T')[0]
        console.log("valueDate to", toDateVar)
    }
    function beforeDate(d){
        referenceDateVar = d.toISOString().split('T')[0]
        console.log("valueDate before", referenceDateVar)
    }
    function afterDate(d){
        referenceDateVar = d.toISOString().split('T')[0]
        console.log("valueDate after", referenceDateVar)
    }

    function setCustomDateComparator(p){
        customDateComparator = p
        console.log("custom date comparator", p)
    }

    function setCustomDateValue(p){
        customDateValue = p
        console.log("custom date value", p)
    }

    function setCustomDateUnit(p){
        customDateUnit = p
        console.log("custom date unit", p)
    }

    function closePopup(){
        popupq.close()
    }
    function toggleDateFilter(){
        if( toggleStatus){
            popupq.close()
            toggleStatus = false;
            return
        }
        else{
            popupq.open()
            toggleStatus = true;
            return
        }
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
            

            Popup {
                id: popupq
                x: -630
                y: 72
                width: 800
                height: 400
                modal: false
                focus: true
                closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
                background: Rectangle {
                    color: "white"
                    border.color: "lightgrey"
                }



                Rectangle{
                    id:container
                    height: parent.height-60
                    width: 200
                    // border.color: Constants.darkThemeColor
                    anchors.left:parent.left





                    TabBar {
                        id: bar
                        width: parent.width-20
                        height:parent.height
                        anchors.right:parent.right
                        anchors.top:parent.top
                        anchors.topMargin:-9
                        anchors.rightMargin:30
                        currentIndex:{
                            let currentSelectedColumn = DashboardParamsModel.currentSelectedColumn
                            if(GeneralParamsModel.isWorkbookInEditMode()){
                                if(DashboardParamsModel.fetchColumnFilterType(DashboardParamsModel.currentDashboard,  currentSelectedColumn) === Constants.filterDateTypes[7]){
                                    3
                                }
                                else if(DashboardParamsModel.fetchColumnFilterType(DashboardParamsModel.currentDashboard,  currentSelectedColumn) === Constants.filterDateTypes[6]){
                                    2
                                }
                                else if(DashboardParamsModel.fetchColumnFilterType(DashboardParamsModel.currentDashboard,  currentSelectedColumn) === Constants.filterDateTypes[5]){
                                    1
                                }
                                else if(DashboardParamsModel.fetchColumnFilterType(DashboardParamsModel.currentDashboard,  currentSelectedColumn) === Constants.filterDateTypes[4]){
                                    0
                                }
                            }

                            else{
                                0
                            }
                        }
                        TabButton {
                            id:btn1
                            width: 174
                            anchors.right:parent.right
                            // anchors.topMargin:10
                            // anchors.horizontalCenter: container.horizontalCenter
                            // text: qsTr("From - To")
                            onClicked:  setFilterType(Constants.filterDateTypes[4])
                            Rectangle {
                                Text {
                                    text: "From - To"
                                    color: "black"
                                    // anchors.horizontalCenter: parent.horizontalCenter
                                    padding:20
                                    anchors.verticalCenter: parent.verticalCenter


                                }

                                anchors.fill: parent
                                color:  (bar.currentIndex == 0) ? "lightgray" : "white"
                            }
                        }
                        TabButton {
                            id:btn2
                            anchors.top:btn1.bottom
                            width: 174
                            anchors.right:parent.right
                            // anchors.topMargin:20
                            anchors.horizontalCenter: container.horizontalCenter
                            // text: qsTr("Before")
                            onClicked:  setFilterType(Constants.filterDateTypes[5])
                            Rectangle {
                                Text {
                                    text: "Before"
                                    color: "black"
                                    // anchors.horizontalCenter: parent.horizontalCenter
                                    padding:20
                                    anchors.verticalCenter: parent.verticalCenter


                                }

                                anchors.fill: parent
                                color:  (bar.currentIndex == 1) ? "lightgray" : "white"
                            }
                        }
                        TabButton {
                            id:btn3
                            anchors.top:btn2.bottom
                            width: 174
                            anchors.right:parent.right
                            // anchors.topMargin:20
                            anchors.horizontalCenter: container.horizontalCenter
                            
                            onClicked: setFilterType(Constants.filterDateTypes[6])
                            // Rectangle {
                            //     anchors.fill: parent
                            //     color: ( parent.pressed ? "white" : "lightgray" )
                            //     opacity: 0.5
                            // }
                            Rectangle {
                                Text {
                                    text: "After"
                                    color: "black"
                                    // anchors.horizontalCenter: parent.horizontalCenter
                                    padding:20
                                    anchors.verticalCenter: parent.verticalCenter


                                }

                                anchors.fill: parent
                                color:  (bar.currentIndex == 2) ? "lightgray" : "white"
                            }
                        }
                        TabButton {
                            anchors.top:btn3.bottom
                            anchors.right:parent.right
                            width: 174
                            // anchors.topMargin:20
                            anchors.horizontalCenter: container.horizontalCenter
                            // text: qsTr("Relative")
                            onClicked:  setFilterType(Constants.filterDateTypes[7])
                            Rectangle {
                                Text {
                                    text: "Relative"
                                    color: "black"
                                    // anchors.horizontalCenter: parent.horizontalCenter
                                    padding:20
                                    anchors.verticalCenter: parent.verticalCenter


                                }

                                anchors.fill: parent
                                color:  (bar.currentIndex == 3) ? "lightgray" : "white"
                            }
                        }
                    }
                    
                    ToolSeparator{
                        orientation: Qt.vertical
                        height: parent.height + 10
                        anchors.top:parent.top
                        anchors.topMargin:-15
                        anchors.verticalCenter:parent.centerIn
                        anchors.right:bar.right
                        anchors.leftMargin:-10
                        anchors.bottom: allButtons.top
                    }
                }
                ToolSeparator{
                    orientation: Qt.Horizontal
                    width: parent.width + 30
                    anchors.rightMargin:-15
                    anchors.horizontalCenter:parent.centerIn
                    anchors.right:parent.right
                    anchors.bottom: allButtons.top
                }
                Rectangle{
                    id:allButtons
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
                            width:100
                            anchors.bottom:parent.bottom
                            

                            background: Rectangle {
                                id: filter_cancel_btn_background1q
                                // color:  "#2E87C5"
                                border.color:"#007bff"
                                radius: 5
                            }
                            contentItem: Text{
                                id: filter_cancel_btn_text1q
                                text: "ok"
                                color:  "#007bff"
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
                                // color:  "#2E87C5"
                                border.color:"#007bff"
                                radius: 5
                            }
                            contentItem: Text{
                                id: filter_cancel_btn_text1qa
                                text: "Remove Filter"
                                
                                color:  "#007bff"
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
                                // color:  "#2E87C5"
                                border.color:"#007bff"
                                radius: 5
                            }
                            contentItem: Text{
                                id: filter_cancel_btn_text1
                                text: "cancel"
                                
                                color:  "#007bff"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            onClicked: closePopup()

                        }

                    }
                }


                StackLayout {
                    width: parent.width
                    currentIndex:bar.currentIndex
                    anchors.right:parent.right
                    Item {
                        id: rangeDateTab
                        anchors.right:parent.right
                        Rectangle{
                            height:300
                            width:580
                            // color:"red"
                            anchors.right:parent.right
                            Old.Calendar {
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                id: calendar1
                                selectedDate: previousCheckValues
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
                            anchors.right:parent.right
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
                            anchors.right:parent.right
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
                            anchors.right:parent.right
                            // color:"pink"
                            Rectangle{
                                id: groupSelectRow
                                anchors.top: parent.top
                                anchors.right: parent.right
                                color:"transparent"

                                width: parent.width
                                height: 200
                                anchors.rightMargin: 20

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
                                        // displayText: {
                                        //     GeneralParamsModel.isWorkbookInEditMode()?DashboardParamsModel.fetchDateRelative(DashboardParamsModel.currentDashboard, DashboardParamsModel.currentSelectedColumn)[0]:""
                                        // }
                                        currentIndex:GeneralParamsModel.isWorkbookInEditMode()? model.find("Last"):0
                                        background: Rectangle {
                                            color:"white"
                                            border.width: parent && parent.activeFocus ? 2 : 1
                                            border.color: parent && parent.activeFocus ? comboBoxCustom.palette.highlight : comboBoxCustom.palette.button
                                        }
                                        onCurrentTextChanged: {
                                            setCustomDateComparator(currentText)
                                        }
                                    }
                                    TextField {
                                        id: numeroTelefoneTextField

                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.leftMargin:15
                                        // anchors.right: selectOptio3.right
                                        anchors.left: selectOption2.right
                                        text:{GeneralParamsModel.isWorkbookInEditMode()? DashboardParamsModel.fetchDateRelative(DashboardParamsModel.currentDashboard, "DashboardParamsModel.currentSelectedColumn")[1]:""}

                                        width: 100
                                        height: 50

                                        placeholderText: qsTr(" ")

                                        validator: IntValidator {
                                            bottom: 1
                                            top: 100
                                        }

                                        font.bold: true
                                        inputMethodHints: Qt.ImhDigitsOnly
                                        onTextChanged: setCustomDateValue(numeroTelefoneTextField.text)
                                    }
                                    ComboBox{
                                        id: selectOption3
                                        model: listModel3
                                        anchors.leftMargin:15
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: 150
                                        height: 50
                                        anchors.left: numeroTelefoneTextField.right
                                        currentIndex:GeneralParamsModel.isWorkbookInEditMode()? listModel3.find(DashboardParamsModel.fetchDateRelative(DashboardParamsModel.currentDashboard, DashboardParamsModel.currentSelectedColumn)[2]):0
                                        // displayText: {
                                        //     GeneralParamsModel.isWorkbookInEditMode()? DashboardParamsModel.fetchDateRelative(DashboardParamsModel.currentDashboard, DashboardParamsModel.currentSelectedColumn)[2]:""
                                        // }
                                        background: Rectangle {
                                            color:"white"
                                            border.width: parent && parent.activeFocus ? 2 : 1
                                            border.color: parent && parent.activeFocus ? comboBoxCustom.palette.highlight : comboBoxCustom.palette.button
                                        }
                                        onCurrentTextChanged: setCustomDateUnit(currentText)
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
                    // text: DashboardParamsModel.fetchColumnAliasName(currentDashboardId, componentName)
                    text:"DateFilter"
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
            // anchors.topMargin: 10
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
        Button {
            anchors.top:searchFilter.bottom
            width:parent.width

            // text: "open"
            // onClicked: popupq.open()
            onClicked: toggleDateFilter()

        }
        // BusyIndicatorTpl{
        //     id: idPlesaeWaitThorbber
        //     anchors.centerIn: parent
        // }

        // Text {
        //     id: idPlesaeWaitText
        //     text: Messages.loadingPleaseWait
        //     anchors.top: idPlesaeWaitThorbber.bottom
        //     anchors.horizontalCenter: parent.horizontalCenter
        // }


    }

}
