import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import Qt.labs.qmlmodels 1.0

import com.grafieks.singleton.constants 1.0
import com.grafieks.singleton.messages 1.0

import "../../../MainSubComponents"
import "../MiniSubComponents"


Popup {
    id: labelShapePopup1
    
    
    width: 460
    height: 520
    
    x: -parent.width-labelShapePopup1.width+200
    y:70
    modal: false
    visible: false
    padding: 0

    Component{
        id: filterCustCat
        FilterCustomizeCategorical{}
    }

    Component{
        id: filterCustNum
        FilterCustomizeNumerical{}
    }
    
    Connections{
        target: DashboardParamsModel

        function onCurrentColumnTypeChanged(currentColumnType){

            switch(currentColumnType){

            case Constants.categoricalTab:
            case Constants.dateTab:
                filterCustomizeLoader.sourceComponent = filterCustCat
                break;

            case Constants.numericalTab:
                filterCustomizeLoader.sourceComponent = filterCustNum
                break;
            }
        }

        function onCurrentSelectedColumnChanged(currentSelectedColumn){
            var currentDashboard = DashboardParamsModel.currentDashboard
            var currentColumn = DashboardParamsModel.currentSelectedColumn
            var includeExclude = DashboardParamsModel.fetchIncludeExcludeMap(currentDashboard, currentColumn)

            if(includeExclude.toLowerCase() === "include"){
                control13.checked = true
            } else{
                control14.checked = true
            }
        }
        

    }

    
    function setAliasText(newAliasName){
        let currentDashboardId = DashboardParamsModel.currentDashboard
        let currentSelectedCol = DashboardParamsModel.currentSelectedColumn
        DashboardParamsModel.setColumnAliasName(currentDashboardId, currentSelectedCol, newAliasName)
    }
    
    function setIncludeExclude(newIncExc){
        let currentDashboardId = DashboardParamsModel.currentDashboard
        let currentSelectedCol = DashboardParamsModel.currentSelectedColumn
        DashboardParamsModel.setIncludeExcludeMap(currentDashboardId, currentSelectedCol, newIncExc)
    }
    
    
    function closePopup(){
        labelShapePopup1.close()
    }
    
    function propertyPressed(){
        firstLine.visible=true
        secondLine.visible=false
        thirdLine.visible=false
        
    }
    function filterTypePressed(){
        secondLine.visible=true
        firstLine.visible=false
        thirdLine.visible=false
    }
    function valuePressed(){
        thirdLine.visible=true
        firstLine.visible=false
        secondLine.visible=false
    }
    
    
    Rectangle{
        id:settingHead
        width:parent.width
        height: 40
        color: Constants.lightThemeColor
        
        Text {
            id: text8
            text: Messages.da_sub_fc_filterText
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
            MouseArea{
                anchors.fill: parent
                onClicked: closePopup()
            }
            
        }
    }
    
    
    Rectangle{
        id:settingFilterLeft
        anchors.top: settingHead.bottom
        height: parent.height-settingHead.height
        width:150
        border.color: Constants.themeColor
        
        Column{
            
            padding: 0
            anchors.left: parent.left
            anchors.leftMargin: 20
            TabBar {
                id: bar
                width: firstBtn.width
                height: 100
                anchors.left: parent.left
                anchors.leftMargin: -20
                anchors.top: settingFilterLeft.bottom
                
                TabButton {
                    id: firstBtn
                    width: 150
                    height: 70
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
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
                        text: Messages.da_sub_fc_propertyText
                        font.pixelSize: 17
                        anchors.verticalCenter: parent.verticalCenter
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
                        
                        text: Messages.da_sub_fc_filterTypeText
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
                        
                        text: Messages.da_sub_fc_valueText
                        font.pixelSize: 17
                        anchors.verticalCenter: parent.verticalCenter
                        x:30
                        verticalAlignment: Text.AlignVCenter
                        styleColor : "white"
                    }
                    onPressed:valuePressed()
                    
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
                            text: Messages.da_sub_fc_renameText
                            font.pixelSize: 17
                        }
                        
                        
                        TextField{
                            id: aliasText
                            width: 130
                            text: DashboardParamsModel.fetchColumnAliasName(DashboardParamsModel.currentDashboard, DashboardParamsModel.currentSelectedColumn)
                            selectByMouse: true
                            anchors.left: rename.right
                            anchors.leftMargin: 50
                            background: Rectangle {
                                border.color: Constants.themeColor
                                width: 130
                                border.width: Constants.borderWidth
                            }
                            onTextChanged: setAliasText(aliasText.text)
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
                    

                    // Load the filter type component here
                    // according to categorical, numerical and date
                    Loader{
                        id: filterCustomizeLoader
                    }

                }
            }
            
            
            
            
            
            
            
            Item {
                id: valueTab
                Rectangle{
                    height: settingFilterRight.height
                    width: settingFilterRight.width
                    ColumnLayout {
                        id: radioGroup6
                        anchors.top: propertyList.bottom
                        y:40
                        anchors.topMargin: 15
                        anchors.horizontalCenter:  parent.horizontalCenter
                        
                        
                        
                        spacing: 15
                        RadioButton {
                            id: control13
                            ButtonGroup.group: buttonGroupIncExcl
                            onCheckedChanged: setIncludeExclude("include")
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
                                text: Messages.filterInclude
                                elide: Text.ElideRight
                                font.pixelSize: 15
                                verticalAlignment: Text.AlignVCenter
                            }
                            
                        }
                        
                        RadioButton {
                            id: control14
                            ButtonGroup.group: buttonGroupIncExcl
                            onCheckedChanged: setIncludeExclude("exclude")
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
                                text: Messages.filterExclude
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
        height: 35
        width: parent.width
        border.color: Constants.themeColor
        
        
        TabBar{
            
            id: apply_btn1
            anchors.top: bottomButtons.top
            anchors.topMargin: 3
            
            anchors.right: parent.right
            anchors.rightMargin: 5
            width: parent.width/3-60
            height:24
            
            
            TabButton{
                id: filter_cancel_btn1
                text: Messages.closeBtnTxt
                
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
                onClicked: closePopup()
                
            }
            
        }
        
    }
}
