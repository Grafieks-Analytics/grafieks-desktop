import QtQuick 2.15
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0
import com.grafieks.singleton.messages 1.0

import "../../MainSubComponents"
import "./MiniSubComponents"

Item {

    id: dashboard_filter_add
    width:parent.width
    height:parent.height


    anchors.left: parent.left
    anchors.leftMargin: 3

    Connections{
        target : TableColumnsModel

        function onSendFilteredColumn(currentDashboard, allCategoricalMap, allNumericalMap, allDatesMap){

            idPlesaeWaitThorbberCategorical.visible = false
            idPlesaeWaitTextCategorical.visible = false
            idPlesaeWaitThorbberDate.visible = false
            idPlesaeWaitTextDate.visible = false
            idPlesaeWaitThorbberNumerical.visible = true
            idPlesaeWaitTextNumerical.visible = true
        }

        function onFetchingFilteredColumn(){
            idPlesaeWaitThorbberCategorical.visible = true
            idPlesaeWaitTextCategorical.visible = true
            idPlesaeWaitThorbberDate.visible = true
            idPlesaeWaitTextDate.visible = true
            idPlesaeWaitThorbberNumerical.visible = true
            idPlesaeWaitTextNumerical.visible = true
        }
    }


    function searchTableColumns(searchText){
        TableColumnsModel.searchColumnNames(DashboardParamsModel.currentDashboard, searchText)
    }

    function addNewFilterColumns(){
        var currentDashboardId = DashboardParamsModel.currentDashboard
        TableColumnsModel.applyColumnVisibility(currentDashboardId)

        if(GeneralParamsModel.getAPISwitch())
            TableColumnsModel.fetchColumnDataAPI(DashboardParamsModel.fetchShowColumns(currentDashboardId), currentDashboardId)
    }

    function hideColumn(){
        DashboardParamsModel.hideAllDashboardRight()
    }

    Rectangle{
        id: add_filter
        height:28
        width:500
        anchors.top: parent.top
        anchors.topMargin: 4
        anchors.left: parent.left
        anchors.leftMargin: 5
        Text{
            text: Messages.da_sub_dfa_header

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
        anchors.top: add_filter.bottom
        anchors.topMargin: 4
        anchors.left: parent.left
        anchors.leftMargin: 5
        width: parent.width
        height:23

        TabButton{
            id: filter_cancel_btn
            text: Messages.cancelBtnTxt
            onClicked: hideColumn()


            background: Rectangle {
                id: filter_cancel_btn_background
                color:  filter_cancel_btn.pressed? Constants.darkThemeColor: Constants.redThemeColor
                //                color:  filter_cancel_btn.pressed? Constants.darkThemeColor: "#F4F4F4"


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
            text: Messages.applyBtnTxt
            onClicked: addNewFilterColumns()

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

    //search
    Rectangle{
        id: filterSearch
        //        color: "red"

        anchors.top: apply_btn.bottom
        anchors.topMargin: 10
        height:50
        width:parent.width-5
        anchors.left: parent.left
        anchors.leftMargin: 5

        Row{

            id: searchBox
            width: parent.width-20
            anchors.verticalCenter: parent.verticalCenter


            TextField{
                id:searchTextBox
                placeholderText: Messages.search
                selectByMouse: true
                width: parent.width - search_icon.width
                height:30
                cursorVisible: true
                anchors.top: row_querymodeller_right_col.top
                anchors.topMargin: 5
                font.pointSize: 10

                background: Rectangle{
                    border.width: 0
                }

                onTextChanged: searchTableColumns(searchTextBox.text)

            }

        }

        ToolSeparator{
            id: toolsep3
            orientation: Qt.Horizontal
            width: parent.width - 20
            anchors.top: searchBox.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: -5
        }
    }

    ToolSeparator{
        id: toolsep4
        orientation: Qt.Horizontal
        width: parent.width - 15
        anchors.top: filterSearch.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        //        anchors.margins: 5
    }


    Column {
        //        spacing: 5
        anchors.top: toolsep4.top
        width: parent.width
        //        anchors.topMargin: 4
        height: parent.height-add_filter.height-filterSearch.height-20

        Rectangle {
            id: rectangle1
            width: parent.width
            anchors.topMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 4
            height:  parent.height/3-10
            color: "white"
            //            border.color: Constants.darkThemeColor

            Rectangle{
                id:categoricalCheckboxesRect
                height: 25
                width: parent.width
                color: Constants.themeColor
                anchors.top: parent.top
                border.color: Constants.darkThemeColor

                Text {
                    id: text4

                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter

                    text: Messages.filterCategorical
                    font.pixelSize: 15

                }
            }

            BusyIndicatorTpl{
                id: idPlesaeWaitThorbberCategorical
                anchors.centerIn: parent
            }

            Text {
                id: idPlesaeWaitTextCategorical
                text: Messages.loadingPleaseWait
                anchors.top: idPlesaeWaitThorbberCategorical.bottom
                anchors.horizontalCenter: parent.horizontalCenter
            }

            CategoricalList{
                id: categoricalCheckboxes
                anchors.top: categoricalCheckboxesRect.bottom
                anchors.topMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 10


            }
        }

        Rectangle {
            id: rectangle3

            width: parent.width
            anchors.topMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 4
            height:  parent.height/3-10
            color: "white"
            //            border.color: Constants.darkThemeColor

            Rectangle{
                id:dataTypeNumericalRect
                height: 25
                width: parent.width
                color: Constants.themeColor
                anchors.top: parent.top
                border.color: Constants.darkThemeColor

                Text {
                    id: dataTypeNumerical


                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter

                    text: Messages.filterNumerical
                    font.pixelSize: 15


                }

            }

            BusyIndicatorTpl{
                id: idPlesaeWaitThorbberNumerical
                anchors.centerIn: parent
            }

            Text {
                id: idPlesaeWaitTextNumerical
                text: Messages.loadingPleaseWait
                anchors.top: idPlesaeWaitThorbberNumerical.bottom
                anchors.horizontalCenter: parent.horizontalCenter
            }

            NumericalList{
                id: numericalCheckboxes
                anchors.top: dataTypeNumericalRect.bottom
                anchors.topMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 10
            }
        }

        Rectangle {
            id: rectangle2

            width: parent.width
            anchors.topMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 4
            height:  parent.height/3-10
            color: "white"
            //            border.color: Constants.darkThemeColor
            Rectangle{
                id:dataTypeDateRect
                height: 25
                width: parent.width
                color: Constants.themeColor
                anchors.top: parent.top
                border.color: Constants.darkThemeColor


                Text {
                    id: dataTypeDate


                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    //                anchors.bottom: parent.bottom
                    //                anchors.bottomMargin: 0

                    text: Messages.filterDate
                    font.pixelSize: 15


                }
            }

            BusyIndicatorTpl{
                id: idPlesaeWaitThorbberDate
                anchors.centerIn: parent
            }

            Text {
                id: idPlesaeWaitTextDate
                text: Messages.loadingPleaseWait
                anchors.top: idPlesaeWaitThorbberDate.bottom
                anchors.horizontalCenter: parent.horizontalCenter
            }

            DateList{
                id: dateCheckboxes
                anchors.top: dataTypeDateRect.bottom
                anchors.topMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 10

            }

        }
    }

}
