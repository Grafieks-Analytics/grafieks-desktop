import QtQuick 2.15
import QtQuick.Controls 2.15

import "../MainSubComponents"

Page{
    width: parent.width
    height: parent.height


    ListModel{
        id: newListmodel
    }


    Row{
        id: row1
        Button{
            id: add
            text: "Add more"
            onClicked: newListmodel.append({name: "hello"})
        }
        Button{
            id: clear
            text: "Clear all"
            onClicked: newListmodel.clear()
        }
    }

    ListView{
        id: listView
        anchors.top: row1.bottom
        width: parent.width
        model: newListmodel
        height: newListmodel.count * 40
        delegate:Text {
            id: newText
            text: name
        }

    }
}
