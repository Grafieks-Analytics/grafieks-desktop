import QtQuick 2.12
import QtQuick.Controls 2.4

Item {

    TableView {
        id: testQueryResult
        model: testQueryModel
        rowHeightProvider: function (column) { return 30; }
        width: parent.width
        visible: false
        columnSpacing: 1
        rowSpacing: 1
        height:parent.height
        boundsBehavior : Flickable.StopAtBounds
        clip:true
        ScrollBar.horizontal: ScrollBar{}
        ScrollBar.vertical: ScrollBar{}
        topMargin: columnsHeader.implicitHeight

        delegate: Row{
            id: resultQueryRow
            height:30
            width: parent.width

            Column{
                width: 50
                height: parent.height
                topPadding: 5

                Row{
                    height: parent.height
                    width: parent.width
                    anchors.top: parent
                    anchors.topMargin: 3
                    anchors.left: parent.left
                    leftPadding: 20

                    Image {
                        id: statusImg
                        height: 18
                        width: 18
                        source: "../../../Images/icons/tick.png"
                    }

                }

            }

            Column{
                width: 50
                height: parent.height

                Row{
                    height: parent.height
                    width: parent.width
                    anchors.left: parent
                    anchors.leftMargin: 2

                    Text {
                        text: qsTr(queryNumber)
                        padding: 5
                        leftPadding: 20
                    }
                }

            }


            Column{
                width: parent.width * 0.4
                height: 30

                Row{
                    height: parent.height
                    width: parent.width
                    anchors.left: parent

                    Text {
                        text: qsTr(action)
                        padding: 5
                        leftPadding: 20
                    }
                }

            }

            Column{
                width: parent.width * 0.4
                height: 30

                Row{
                    height: parent.height
                    width: parent.width
                    anchors.left: parent

                    Text {
                        text: qsTr(message)
                        padding: 5
                        leftPadding: 20
                    }
                }
            }

            Column{
                width: parent.width * 0.1
                height: 30

                Row{
                    height: parent.height
                    width: parent.width

                    Text {
                        text: qsTr(duration)
                        padding: 5
                        leftPadding: 20
                    }
                }
            }

        }

        Rectangle { // mask the headers
            z: 3
            color: "#222222"
            y: testQueryResult.contentY
            x: testQueryResult.contentX
            width: testQueryResult.leftMargin
            height: testQueryResult.topMargin
        }
        Row {
            id: columnsHeader
            y: testQueryResult.contentY
            z: 3
            width: parent.width

            Label {
                id: statusColumn
                width: 50
                height: 30
                text: ""
                color: 'black'
                padding: 10
                leftPadding: 20
                verticalAlignment: Text.AlignVCenter
                background: Rectangle{
                    color: 'white'
                }
            }
            Label {
                id: numberCoulmn
                width: 50
                height: 30
                text: "#"
                color: 'black'
                padding: 10
                leftPadding: 20
                verticalAlignment: Text.AlignVCenter
                background: Rectangle{
                    color: 'white'
                }

            }
            Label {
                id: actionCoulmn
                width: parent.width * 0.4
                height: 30
                text: "Action"
                color: 'black'
                padding: 10
                leftPadding: 20
                verticalAlignment: Text.AlignVCenter
                background: Rectangle{
                    color: 'white'
                }

            }
            Label {

                id: messageColumn
                width: parent.width * 0.4
                height: 30
                text: "Message"
                color: 'black'
                padding: 10
                leftPadding: 20
                verticalAlignment: Text.AlignVCenter
                background: Rectangle{
                    color: 'white'
                }

            }
            Label {
                id: durationColumn
                width: parent.width  - ( statusColumn.width + numberCoulmn.width + actionCoulmn.width + messageColumn.width)
                height: 30
                text: "Duration"
                color: 'black'
                padding: 10
                leftPadding: 20
                verticalAlignment: Text.AlignVCenter
                background: Rectangle{
                    color: 'white'
                }

            }

        }

        ScrollIndicator.horizontal: ScrollIndicator { }
        ScrollIndicator.vertical: ScrollIndicator { }

    }

}
