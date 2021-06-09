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
import "./MiniSubComponents"

Item {

    id: dashboard_filter
    width:200
    height:parent.height
    anchors.left: parent.left
    anchors.leftMargin: 3


    function hideColumn(){
        DashboardParamsModel.hideAllDashboardRight()
    }


 Rectangle{
     height:parent.height
     width:200
     color: "white"

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
            onClicked: hideColumn()

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
            text: "Apply"

            background: Rectangle {
                id: filter_apply_btn_background
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
