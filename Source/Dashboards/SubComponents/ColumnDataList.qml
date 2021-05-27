import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents"
import "./MiniSubComponents"


Rectangle {
    id: rectangle1

    width: parent.width-20
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: apply_btn.bottom
    anchors.topMargin: 10
    height: 600
    color: "white"
    border.color: Constants.themeColor

    Connections{
        target: TableColumnsModel

        function onVisibleColumnListChanged(visibleColumns){
            console.log("VISIBLE COLUMNS", visibleColumns)
            filterDataListview.model = visibleColumns
        }
    }

    ListView{
        id: filterDataListview
        height: 600
        width: parent.width
        delegate:FilterDataList{
            id: filterDataListdelegate
            componentName: modelData
        }
    }


//    FilterDataSingleDropdown{
//        id: filterDataSingleDropdownComponent
//    }

//    FilterDataMultiDropdown{
//        id: filterDataMultiDropdownComponent
//    }
}




