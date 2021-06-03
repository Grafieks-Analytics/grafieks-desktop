import QtQuick 2.15
import QtQuick.Controls 2.15
import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

ListView {

    id: dateChecksItem
    flickableDirection: Flickable.VerticalFlick
    boundsBehavior: Flickable.StopAtBounds
    interactive: true
    clip: true
    height: parent.height-dataTypeDate.height-5
    width: parent.width-15
    ScrollBar.vertical: ScrollBar {}


    Connections{
        target : TableColumnsModel

        function onSendFilteredColumn(allCategorical, allNumerical, allDates){
            dateChecksItem.model =  allDates
        }
    }

    function handleCheckChange(colName, status){
        if(colName !== "")
            TableColumnsModel.setColumnVisibility(colName, status)
    }

    delegate: CheckBoxTpl{
        id: checkBox1
        height: 30
        checkbox_text: modelData
        checkbox_checked: true
        parent_dimension: 16
        onCheckedChanged: handleCheckChange(checkBox1.checkbox_text, checked)
    }

}
