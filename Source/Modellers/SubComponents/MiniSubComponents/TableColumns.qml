import QtQuick 2.15

import "../../../MainSubComponents"

Item {

    id: tableColumnsComponent
    height:columnListView.height
    z: 2

    property alias objectName: tableColumnsComponent.objectName // Table name sent here
    property var tableColumnsMap : new Map()
    property var itemMap: new Map()
    property bool halt : true


    signal onColumnStateChanged(bool state, string colName, string tableName)


    ListModel{
        id: newListModel
    }


    Connections{
        target: TableColumnsModel

        function onColumnListObtained(allColumns, tableName){
            onReceivingSignal(allColumns, tableName);
            halt = true
        }
    }


    function onReceivingSignal(allColumns, tableName){

        if(tableColumnsComponent.objectName === tableName && itemMap.size <= 0){
            allColumns.forEach(function(item){

                let colName = item[0]
                let colType = item[1]

                itemMap.set(colName, colType)
                newListModel.append({colName: colName, colType: colType, tableName: tableName})
            })

            tableColumnsMap.set(tableName, itemMap)
            columnListView.model = newListModel
            columnListView.height = newListModel.count * 40
        }
    }



    ListView{
        id: columnListView

        delegate: Rectangle{
            id: innerListView
            height: 40
            width: 100

            CheckBoxTpl{
                id: checkBox1
                checkbox_text: colName
                checkbox_checked: true
                parent_dimension: 16

                onClicked: onColumnStateChanged(checked, colName, tableName)
            }
        }
    }
}
