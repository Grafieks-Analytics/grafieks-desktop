import QtQuick 2.11
import QtQuick.Controls 2.4

Item
{
    ListModel {
        id: elementModel
        ListElement { elementColor: "red"; elementWidth: 50; elementHeight: 50}
        ListElement { elementColor: "green"; elementWidth: 20; elementHeight: 50}
        ListElement { elementColor: "blue"; elementWidth: 50; elementHeight: 20}
    }

    Column {
        id:col
        spacing: 2
        Repeater {
            model: elementModel
            Rectangle { color: elementColor; width: elementWidth; height: elementHeight }
        }
    }

    Button
    {
        id: deleteButton; x: 200; y: 200; height: 50; width: 50; text: "Delete"
        onClicked:
        {
            //How to remove perticular element from above column ?
            elementModel.remove(index)
        }
    }

    Button
    {
        id: addButton; x: 400; y: 200; height: 50; width: 50; text: "Add"
        onClicked:
        {
            // Code to add controls dynamically to column.
            elementModel.insert(index, { "elementColor": "red", "elementWidth": 50, "elementHeight": 50})
        }

    }
}
