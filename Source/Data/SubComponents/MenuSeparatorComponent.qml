import QtQuick 2.11
import QtQuick.Controls 2.4

Item{
    id : menuSeparatorComponent
    height: 1

    MenuSeparator{
        topPadding: 0
        bottomPadding: 0
        leftPadding: 35
        rightPadding: 5
        background: Rectangle{
            color: "#D7D9DF"
        }
    }
}
