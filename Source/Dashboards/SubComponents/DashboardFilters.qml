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
import com.grafieks.singleton.messages 1.0

import "../../MainSubComponents"
import "./MiniSubComponents"

Item {

    id: dashboard_filter
    width:204
    height:parent.height
    anchors.left: parent.left
    anchors.leftMargin: 3


    Connections{
        target: ReportParamsModel

        function onGenerateWorkbookReports(){
            DashboardParamsModel.applyFilterToDashboard(DashboardParamsModel.currentDashboard)
        }
    }

    function hideColumn(){
        DashboardParamsModel.hideAllDashboardRight()
    }


 Rectangle{
     height:parent.height
     width:204
     color: "white"
     y:5

    Rectangle{
        id: show_filter
        height:28
        width:parent.width
        anchors.top: parent.top
        anchors.topMargin: 4
        anchors.left: parent.left
        anchors.leftMargin: 5
        Text{
            text: Messages.da_sub_df_header

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
        height:24

        TabButton{
            id: filter_cancel_btn
            text: Messages.cancelBtnTxt
            onClicked: hideColumn()

            background: Rectangle {
                id: filter_cancel_btn_background
                color:  filter_cancel_btn.pressed? Constants.darkThemeColor: Constants.redThemeColor
                height:24



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
            onClicked: {
                let currentDashboard = DashboardParamsModel.currentDashboard
                DashboardParamsModel.applyFilterToDashboard(currentDashboard)
                TableColumnsModel.redrawCharts(currentDashboard)
            }


            background: Rectangle {
                id: filter_apply_btn_background
                height:24
                color:  filter_apply_btn.pressed? Constants.darkThemeColor: Constants.greenThemeColor

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

    ColumnDataList{
        id: columnDataListComponent
    }

    // Customize filter popup
    FilterCustomize{
        id: labelShapePopup1
    }
}
}
