import QtQuick 2.15
import QtQuick.Controls 2.15

import "../MainSubComponents"

Page{
    id: x1
    width: parent.width
    height: parent.height

    property var xa : {"tableID" : 1, "sa": "b"}

    Component.onCompleted: {
        xa.tableID = 3
    }

}
