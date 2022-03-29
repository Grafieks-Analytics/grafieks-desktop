import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQml.Models 2.2

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

Item{
    id: filterDataSingleItem
    height: control.height + columnName.height
    width: parent.width-25
    anchors.horizontalCenter: parent.horizontalCenter
    property alias componentName: filterDataSingleItem.objectName
    property var modelContent: []
    property bool master: false

    ListModel{
        id: listModel
        dynamicRoles: true
    }


    onComponentNameChanged: {
        if(GeneralParamsModel.getAPISwitch()) {
            TableColumnsModel.fetchColumnDataAPI(componentName, DashboardParamsModel.currentDashboard)
        } else if(GeneralParamsModel.getFromLiveFile() || GeneralParamsModel.getFromLiveQuery()){
            modelContent = TableColumnsModel.fetchColumnDataLive(componentName)
            processDataList(modelContent)
        } else {
            modelContent = TableColumnsModel.fetchColumnData(componentName)
            processDataList(modelContent)
        }

    }

    Connections{
        target: DashboardParamsModel

        function onAliasChanged(newAlias, columnName, dashboardId){
            if(columnName === componentName && dashboardId === DashboardParamsModel.currentDashboard){
                componentTitle.text = newAlias
            }
        }
    }

    Connections {
        target: TableColumnsModel

        function onColumnDataChanged(columnData, columnName, dashboardId){
            if(columnName === componentName && dashboardId === DashboardParamsModel.currentDashboard)
                processDataList(columnData)
        }
    }


    function processDataList(modelContent){
        modelContent.unshift("Select All")
        control.model = modelContent

        var previousCheckValues = DashboardParamsModel.fetchColumnValueMap(DashboardParamsModel.currentDashboard, componentName)
        var i = 0;
        listModel.clear()
        modelContent.forEach(item => {
                                 listModel.append({"name": item, "checked": true, "index": i})
                                 if(previousCheckValues.length > 0 && item === previousCheckValues[0]){
                                     control.currentIndex = i
                                 }
                                 i++
                             })

        componentTitle.text = DashboardParamsModel.fetchColumnAliasName(DashboardParamsModel.currentDashboard, componentName)
    }

    function onRadioSelect(modelData){

        // Remove existing items
        DashboardParamsModel.deleteColumnValueMap(DashboardParamsModel.currentDashboard, componentName, "", true)

        // Start pushing the individual checked item in the array
        DashboardParamsModel.setColumnValueMap(DashboardParamsModel.currentDashboard, componentName, modelData)

    }


    function filterClicked(){

        var columnAlias = DashboardParamsModel.fetchColumnAliasName(DashboardParamsModel.currentDashboard, componentName)
        var currentColumnType = TableColumnsModel.findColumnType(columnAlias)
        DashboardParamsModel.setCurrentColumnType(currentColumnType)
        DashboardParamsModel.setCurrentSelectedColumn(componentName)

        labelShapePopup1.visible = true
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
            id:control
            model: listModel
            width: parent.width
            anchors.top : columnName.bottom

            indicator: Canvas {
                id: canvas
                x: control.width - width - control.rightPadding
                y: control.topPadding + (control.availableHeight - height) / 2
                width: 12
                height: 8
                contextType: "2d"

                Connections {
                    target: control
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
                    context.fillStyle = control.pressed ? "#black" : "#gray";
                    context.fill();
                }
            }

            onCurrentValueChanged: onRadioSelect(currentValue)
        }
    }
}
