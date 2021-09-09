/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Dashboard/Subcomponents
** Dashboard Customize
**
****************************************************************************/
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import com.grafieks.singleton.constants 1.0
import "./MiniSubComponents"
Item{

    id: listViewElem
    width:200
    height: parent.height
    property string itemName : ""
    property string reportId : ""
    property var editIconVisible: false
    property var reportListDataValues:
    /***********************************************************************************************************************/
    // LIST MODEL STARTS
    ListModel {
        id: nestedModel
        ListElement {
            categoryName: "General"
            collapsed: false
            subItems: [
                ListElement { itemName: "Name" }
            ]
        }
        ListElement {
            categoryName: "Style"
            collapsed: false
            subItems: [
                ListElement { itemName: "Background Color" },
                ListElement { itemName: "Report Border" }
            ]
        }
        ListElement {
            categoryName: "Canvas Size"
            collapsed: false
            subItems: [
                ListElement { itemName: "Background Color" },
                ListElement { itemName: "Report Border" }
            ]
        }
        ListElement {
            categoryName: "Widgets"
            collapsed: false
            subItems: [
                ListElement { itemName: "Text" },
                ListElement { itemName: "Blank" },
                ListElement { itemName: "Image" }
            ]
        }
        ListElement {
            categoryName: "Reports"
            collapsed: false
            subItems: []
        }
    }


    ListModel{
        id: allReportsModel
    }
    
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

        function onReportListChanged(){
            allReportsModel.clear();
            const reportListData = ReportParamsModel.getReportsList();
            for(let reportId in reportListData){
                console.log("Reports Id", reportId)
                allReportsModel.append({ reportName: reportListData[reportId], reportId: reportId })
            }
        }
    }


    // Connections Ends
    /***********************************************************************************************************************/
    /***********************************************************************************************************************/

    // JAVASCRIPT FUNCTION STARTS
    function editSelectedReport(){
        stacklayout_home.currentIndex = 7
    }



    function showEditIcon(){

        editIconVisible = true

    }
    function hideEditIcon(){

        editIconVisible = false

    }


    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/
    /***********************************************************************************************************************/
    // SubComponents Starts
    Component {
        id: categoryDelegate
        Column {
            width: 200
            Rectangle {
                id: categoryItem
                height: 30
                width: 200
                color: Constants.themeColor
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    x: 15
                    font.pixelSize: 12
                    text: categoryName
                }
                Image {
                    id: drop_icon
                    source: "/Images/icons/Up_20.png"
                    width: 10
                    height: 10
                    anchors.right: parent.right
                    anchors.rightMargin: 5
                    anchors.verticalCenter: parent.verticalCenter
                    visible: true
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            nestedModel.setProperty(index, "collapsed", !collapsed)
                            // [TAG: Refactor]
                            // We can use ternary operator here
                            if(collapsed === true){
                                drop_icon.source = "/Images/icons/Down_20.png"
                            }
                            else{
                                drop_icon.source = "/Images/icons/Up_20.png"
                            }
                        }
                    }
                }
            }

            // Loader Docs: Allows dynamic loading of a subtree from a URL or Component.
            // Since there is a nested structure we have used Loader here

            Loader {
                id: subItemLoader
                visible: !collapsed // this is list model's key ( Using it as a flag to collapse the compenent )
                property variant subItemModel : subItems // The nested model will have subItems as next list modal
                sourceComponent: {
                    
                    // [TAG: Refactor]
                    // Switch case should be used here
                    // return null in case of if( collapsed ) | Else is not required. add switch case instead of that.

                    if(collapsed){
                        null
                    }else{
                        if(categoryName == "General"){
                            return generalComponent
                        }else if(categoryName == "Style"){
                            return styleComponent
                        }else if(categoryName == "Canvas Size"){
                            return canvasMenuComponent
                        }
                        else if(categoryName == "Widgets"){
                            return subItemColumnDelegateWidgets
                        }
                        else if(categoryName == "Reports"){
                            return reportsListComponent
                        }
                        else{
                            return subItemColumnDelegate
                        }
                    }

                }
                onStatusChanged: {

                    // [TAG: Optimization]
                    // Some optimmization scope available here as well
                    // Check from where this item.model is getting accessed.
                    // Bit confusing. Not accounting it for version 1 release.
                    // Will get this corrected in the next release

                    // if (status == Loader.Ready && (categoryName == "Reports") ){
                        
                    //     item.model = subItemModel;
                    // }
                    // else 
                    if (status == Loader.Ready && (categoryName == "Widgets")){
                        item.model = subItemModel
                    }
                }
            }
        }
    }
    Component {
        id: subItemColumnDelegateWidgets
        Column {
            property alias model : subItemRepeater.model
            width: 200
            Repeater {
                id: subItemRepeater
                property string itemName : ""
                delegate: Rectangle {
                    id: dragRect
                    height: 25
                    width: 200
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        x: 30
                        font.pixelSize: 12
                        text: itemName
                    }
                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        drag.target:  dragRect
                        drag.minimumX: -( new_dashboard_page.width - parent.width)
                        drag.maximumX: 0
                        drag.onActiveChanged: {
                            if (mouseArea.drag.active) {
                                listViewElem.itemName = itemName
                            }
                            dragRect.Drag.drop();
                        }
                    }
                    states: [
                        State {
                            when: dragRect.Drag.active
                            ParentChange {
                                target: dragRect
                                parent: subItemRepeater
                            }
                            AnchorChanges {
                                target: dragRect
                                anchors.horizontalCenter: undefined
                                anchors.verticalCenter: undefined
                            }
                        }
                    ]
                    Drag.active: mouseArea.drag.active
                    Drag.hotSpot.x: - dragRect.width / 2
                    Drag.hotSpot.y: - dragRect.height / 2
                    Drag.keys: ['1','2']
                }
            }
        }
    }


    // Reports list component
    Component{
        id: reportsListComponent
        Column {
            width: 200
            anchors.top: parent.top

            // This repeater displays all the added reports
            // Working: Singal is emitted whenever add report is fired
            // on Report List addition, List model is changed
            // Check needs to be added when report is edited.

            Repeater {
                id: subItemRepeater
                model: allReportsModel
                delegate: Rectangle {
                    id: dragRect
                    height: 25
                    width: 200
                    Row{
                        anchors.left: parent.left
                        anchors.fill: parent
                        height: parent.height

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            x: 30
                            font.pixelSize: 12
                            text: reportName
                        }
                        Rectangle {
                            height: parent.height
                            width: 50
                            anchors.right: parent.right
                            anchors.rightMargin:  20
                            Image{
                                id: resizeReport
                                height: 16
                                width: 16
                                anchors.right: parent.right
                                anchors.rightMargin:  20
                                visible: editIconVisible
                                source: "/Images/icons/edit gray.png"
                                anchors.verticalCenter: parent.verticalCenter
                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: editSelectedReport()
                                }
                            }
                        }

                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        drag.target:  dragRect
                        drag.minimumX: -( new_dashboard_page.width - parent.width)
                        drag.maximumX: 0
                        drag.onActiveChanged: {
                            if (mouseArea.drag.active) {
                                listViewElem.itemName = reportName
                                listViewElem.reportId = reportId
                            }
                            dragRect.Drag.drop();
                        }
                        hoverEnabled: true
                        onEntered: showEditIcon()
                        onExited: hideEditIcon()
                    }
                    states: [
                        State {
                            when: dragRect.Drag.active
                            ParentChange {
                                target: dragRect
                                parent: subItemRepeater
                            }
                            AnchorChanges {
                                target: dragRect
                                anchors.horizontalCenter: undefined
                                anchors.verticalCenter: undefined
                            }
                        }
                    ]
                    Drag.active: mouseArea.drag.active
                    Drag.hotSpot.x: - dragRect.width / 2
                    Drag.hotSpot.y: - dragRect.height / 2
                    Drag.keys: ['1','2']
                }
            }
        }
    }


    Component {

        // Defailt  Column
        // Sub Items passed from parent is iterated here.
        // Each item is added as a sepate row.
        
        id: subItemColumnDelegate
        Column {
            property alias model : subItemRepeater.model
            width: 200
            Repeater {
                id: subItemRepeater
                property string itemName : ""
                delegate: Rectangle {
                    id: dragRect
                    height: 25
                    width: 200
                    anchors.topMargin: 50


                    Row{
                        //                        spacing: 50
                        //                        anchors.leftMargin: 20
                        anchors.left: parent.left
                        anchors.fill: parent
                        height: parent.height

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            x: 30
                            //                            anchors.left: parent.left
                            //                           anchors.leftMargin: 0

                            font.pixelSize: 12
                            text: itemName
                        }
                        Rectangle {
                            height: parent.height
                            width: 50
                            anchors.right: parent.right
                            anchors.rightMargin:  20
                            //                                           color: "red"

                            Image{
                                id: resizeReport
                                height: 16
                                width: 16
                                anchors.right: parent.right
                                anchors.rightMargin:  20
                                visible: editIconVisible

                                source: "/Images/icons/edit gray.png"
                                anchors.verticalCenter: parent.verticalCenter
                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: editSelectedReport()
                                }
                            }
                        }

                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        drag.target:  dragRect
                        drag.minimumX: -( new_dashboard_page.width - parent.width)
                        drag.maximumX: 0
                        drag.onActiveChanged: {
                            if (mouseArea.drag.active) {
                                listViewElem.itemName = itemName
                            }
                            dragRect.Drag.drop();
                        }
                        hoverEnabled: true
                        onEntered: showEditIcon()
                        onExited: hideEditIcon()
                    }
                    states: [
                        State {
                            when: dragRect.Drag.active
                            ParentChange {
                                target: dragRect
                                parent: subItemRepeater
                            }
                            AnchorChanges {
                                target: dragRect
                                anchors.horizontalCenter: undefined
                                anchors.verticalCenter: undefined
                            }
                        }
                    ]
                    Drag.active: mouseArea.drag.active
                    Drag.hotSpot.x: - dragRect.width / 2
                    Drag.hotSpot.y: - dragRect.height / 2
                    Drag.keys: ['1','2']
                }
            }
        }
    }
    Component{
        id: generalComponent
        CustomizeGeneralMenu{
            height: 60
            width: listViewElem.width
        }
    }
    Component{
        id: styleComponent
        CustomizeStyleMenu{
            height: 120
            width: listViewElem.width
        }
    }
    Component{
        id: canvasMenuComponent
        CustomizeCanvasSizeMenu{
            height: 70
            width: listViewElem.width
        }
    }
    // SubComponents Ends
    /***********************************************************************************************************************/
    /***********************************************************************************************************************/
    // Page Design Starts
    // Item 1 Starts
    ListView {
        anchors.fill: parent
        model: nestedModel
        interactive: false
        delegate: categoryDelegate
    }
}

