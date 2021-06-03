import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents"

// Data Preview - Table View From Query Results

Rectangle {
    id: win
    width: parent.width
    height: parent.height
    visible: true




    property var roleNames:["a", "b", "c"]
    property var newObject: []
    property var previousModelData: 0
    property var counter : 0

    Connections{
        target: QueryModel

        // This one is for table data
        function onSqlHasData(hasData){
            view.model = hasData === true? QueryModel: ""

        }

        // This slot is for updating headers
        // This is also returning an array of strings
        function onHeaderDataChanged(tableHeaders){
            setHeaders(tableHeaders)
        }

        // Clear table
        function onClearTablePreview(){
            clearTable()
        }

    }
    Connections{
        target: DuckQueryModel

        // This one is for table data
        function onDuckHasData(hasData){
            view.model = hasData === true? DuckQueryModel: ""

        }

        // This slot is for updating headers
        // This is also returning an array of strings
        function onHeaderDataChanged(tableHeaders){
            setHeaders(tableHeaders)
        }

        // Clear table
        function onClearTablePreview(){
            clearTable()
        }

    }
    Connections{
        target: ForwardOnlyQueryModel

        // This one is for table data
        function onSqlHasData(hasData){
            view.model = hasData === true? ForwardOnlyQueryModel: ""

        }

        // This slot is for updating headers
        // This is also returning an array of strings
        function onHeaderDataChanged(tableHeaders){
            setHeaders(tableHeaders)
        }

        // Clear table
        function onClearTablePreview(){
            clearTable()
        }

    }

    function setHeaders(tableHeaders){
        if(tableHeaders.length > 0){
            roleNames = tableHeaders

            for(var i=0; i<roleNames.length; i++){
                var role  = roleNames[i]
                var columnString = 'import QtQuick 2.3; import QtQuick.Controls 1.2; TableViewColumn {role: "' + role + '"; title: "' + role + '"; }';
                newObject[i] = Qt.createQmlObject(columnString, view)
                view.addColumn(newObject[i])
            }
        }
    }

    // This
    function clearTable(){
        for(var i=0; i<roleNames.length; i++){
            view.removeColumn(newObject[i])
            delete newObject[i]

        }
    }


//    Button{
//        id: clearBtn
//        text: "Clear"
//        height: 30
//        onClicked: clearTable()
//    }

    TableView {
        id:view
        width: parent.width
        height: parent.height
//        anchors.top: clearBtn.bottom
        alternatingRowColors: false



        style: TableViewStyle {
            headerDelegate: Rectangle {
                height: textItem.implicitHeight * 1.8
                width: textItem.implicitWidth
                color: Constants.themeColor

                Text {
                    id: textItem
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: styleData.textAlignment
                    anchors.leftMargin: 12
                    text: styleData.value
                    elide: Text.ElideRight
                    color: textColor
                    font.bold: true
                    renderType: Text.NativeRendering


                }
                Rectangle {
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 1
                    anchors.topMargin: 1

                    width: 1
                    color: Constants.darkThemeColor
                    border.color: Constants.darkThemeColor
                }
                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: 1
                    color: Constants.darkThemeColor
                    border.color: Constants.darkThemeColor
                }
            }

            itemDelegate: Rectangle {
                color: "white"



                Text {
                    id: textItem1
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    objectName: modelData
                    horizontalAlignment: styleData.textAlignment
                    anchors.leftMargin: 12
                    elide: Text.ElideRight
                    color: textColor
                    renderType: Text.NativeRendering

                    onObjectNameChanged: {
                        if(previousModelData === modelData){
                            counter++
                            textItem1.text = QueryModel.data(QueryModel.index(modelData-1,counter))
                        } else{
                            counter = 0;
                            previousModelData = modelData
                            textItem1.text = QueryModel.data(QueryModel.index(previousModelData - 1,counter))
                        }
                    }
                }
                Rectangle {
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: 1
                    color: Constants.darkThemeColor
                    border.color: Constants.darkThemeColor
                }
                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: 1
                    color: Constants.darkThemeColor
                    border.color: Constants.darkThemeColor
                }
            }
        }
    }
}
