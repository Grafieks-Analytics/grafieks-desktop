import QtQuick 2.15
import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

ListView {

    id: categoricalChecksItem
    flickableDirection: Flickable.VerticalFlick
    boundsBehavior: Flickable.StopAtBounds
    interactive: false
    clip: false
//    anchors.top: text4.bottom
//    anchors.topMargin: 5
    height: parent.height
    width: parent.width


    Connections{
        target : TableColumnsModel

        function onSendFilteredColumn(allCategorical, allNumerical, allDates){
            categoricalChecksItem.model =  allCategorical
        }
    }

    delegate: CheckBoxTpl{
        id: checkBox1
        height: 20
        checkbox_text: modelData
        checkbox_checked: true
        parent_dimension: 16
    }

}
