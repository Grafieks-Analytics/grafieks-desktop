import QtQuick 2.11
import QtQuick.Controls 2.4

Item
{
    ListModel {
        id: elementModel
        ListElement { content: "1"}
    }

    Column {
        id:col
        spacing: 2
        Repeater {
            model: elementModel
            Text { text: content;}
        }
    }

    Button
    {
        id: deleteButton; x: 200; y: 200; height: 50; width: 50; text: "Delete"
        onClicked:
        {
            //How to remove perticular element from above column ?
            elementModel.remove(1)
        }
    }

    Button
    {
        id: addButton; x: 400; y: 200; height: 50; width: 50; text: "Add"
        onClicked:
        {
            // Code to add controls dynamically to column.
            elementModel.insert(1, { "content": Math.random(3).toString()})
        }

    }
}
