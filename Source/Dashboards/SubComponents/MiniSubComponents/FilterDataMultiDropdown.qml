import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

Item {

    id: filterDataMultiItem
    height: comboBox.height + columnName.height
    width: parent.width-25
    anchors.horizontalCenter: parent.horizontalCenter
    property var modelContent: []
    property alias componentName: filterDataMultiItem.objectName

    onComponentNameChanged: {
        modelContent = TableColumnsModel.fetchColumnData(componentName)
        modelContent.unshift("Select All")
        comboBox.model = modelContent
        componentTitle.text = DashboardParamsModel.fetchColumnAliasName(DashboardParamsModel.currentDashboard, componentName)

        // for the first time, select all values
        selectAll(true)

    }

    Connections{
        target: DashboardParamsModel

        function onAliasChanged(newAlias, columnName, dashboardId){
            if(columnName === componentName && dashboardId === DashboardParamsModel.currentDashboard){
                componentTitle.text = newAlias
            }
        }
    }

    function onMultiSelectCheckboxSelected(modelData,checked, index){

        if(checked === true){

            // Start pushing the individual checked item in the array
            DashboardParamsModel.setColumnValueMap(DashboardParamsModel.currentDashboard, componentName, modelData)

        } else{
            // Remove item if unchecked
            DashboardParamsModel.deleteColumnValueMap(DashboardParamsModel.currentDashboard, componentName, modelData)
            selectAll(false)
        }

    }

    function filterClicked(){

        var currentColumnType = TableColumnsModel.findColumnType(componentName)
        DashboardParamsModel.setCurrentColumnType(currentColumnType)
        DashboardParamsModel.setCurrentSelectedColumn(componentName)

        labelShapePopup1.visible = true
    }

    function selectAll(checkedState){
        DashboardParamsModel.setSelectAll(checkedState, componentName, DashboardParamsModel.currentDashboard)

        if(checkedState === true){
            modelContent.forEach(item => {
                                     DashboardParamsModel.setColumnValueMap(DashboardParamsModel.currentDashboard, componentName, item)
                                 })

        } else {
            DashboardParamsModel.deleteColumnValueMap(DashboardParamsModel.currentDashboard, componentName, "", true)

        }
    }

    ButtonGroup {
        id: childGroup
        exclusive: false
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

            border.color: Constants.darkThemeColor
            Row{

                spacing: 15
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 15


                Text {
                    id: componentTitle
                    width:123
                    elide: Text.ElideRight
                    font.pixelSize: Constants.fontCategoryHeaderMedium
                    verticalAlignment: Text.AlignVCenter
                }

                Row{

                    height: parent.height
                    width: 40
                    spacing: 15
                    anchors.verticalCenter: parent.verticalCenter
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


        ComboBox {
            id: comboBox
            width: parent.width
            anchors.top : columnName.bottom

            indicator: Canvas {
                id: canvasMultiselect
                x: comboBox.width - width - comboBox.rightPadding
                y: comboBox.topPadding + (comboBox.availableHeight - height) / 2
                width: 12
                height: 8
                contextType: "2d"

                Connections {
                    target: comboBox
                    function onPressedChanged(){
                        canvas.requestPaint()
                    }
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

            // ComboBox closes the popup when its items (anything AbstractButton derivative) are
            //  activated. Wrapping the delegate into a plain Item prevents that.
            delegate: Item {
                width: parent.width
                height: checkDelegate.height

                function toggle() {
                    checkDelegate.toggle()
                }

                CheckDelegate {
                    id: checkDelegate
                    checked: childGroup.checkState
                    ButtonGroup.group: childGroup

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
                    contentItem: Text {
                        text: modelData
                        elide: Text.ElideLeft
                        leftPadding: checkDelegate.indicator.width + checkDelegate.spacing
                    }
                    highlighted: comboBox.highlightedIndex == index

                    onCheckedChanged: {

                        if(index === 0){
                            childGroup.checkState = checkState
                        } else {
                            onMultiSelectCheckboxSelected(modelData,checked, index)
                        }
                    }

//                    Connections{
//                        target: DashboardParamsModel
//                        function onSelectAllChanged(status, columnName, dashboardId){
//                            if(columnName === componentName && dashboardId === DashboardParamsModel.currentDashboard){
//                                checkDelegate.checked = status
//                            }
//                        }
//                    }
                }
            }
        }
    }
}
