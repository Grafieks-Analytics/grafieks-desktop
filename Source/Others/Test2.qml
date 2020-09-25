import QtQuick 2.15
import QtQuick.Controls 2.15

import "../MainSubComponents"

Page{
    id: x1
    width: parent.width
    height: parent.height


    ListView{

        id: list1
        model: SchedulerModel
        height: 1000

        delegate: Rectangle{
            height: 20
            width: parent.width
            Text {
                id: name
                text: Name
            }
        }
    }
}
