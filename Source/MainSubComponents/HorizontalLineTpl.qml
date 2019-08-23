import QtQuick 2.11

import "../../Constants.js" as Constants

Item{

    id: horizontal_line
    width: control.implicitWidth
    height: control.implicitHeight

    property alias line_color: control.color
    property alias line_width: control.width

    Rectangle {
        id: control
        implicitWidth: parent.vertical ? 1 : 24
        implicitHeight: parent.vertical ? 24 : 1
    }
}
