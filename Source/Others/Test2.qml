import QtQuick 2.12
import QtQuick.Controls 1.4
import QtQuick.Window 2.11

Item {
    visible: true
    width: 640
    height: 480

//    Button{
//        text: "click"
//        onClicked: {
//            Testing.click()
//        }
//    }

//    TableView {
//        id: tableView

//        columnWidthProvider: function (column) { return 100; }
//        rowHeightProvider: function (column) { return 60; }
//        anchors.fill: parent
//        leftMargin: rowsHeader.implicitWidth
//        topMargin: columnsHeader.implicitHeight
//        model: QtTest2
//        ScrollBar.horizontal: ScrollBar{}
//        ScrollBar.vertical: ScrollBar{}
//        clip: true
//        boundsBehavior : Flickable.StopAtBounds
//        delegate: Rectangle {
//            Text {
//                text: 'asd'
//                anchors.fill: parent
//                anchors.margins: 10
//                color: 'black'
//                font.pixelSize: 15
//                verticalAlignment: Text.AlignVCenter
//            }
//        }
//        Rectangle { // mask the headers
//            z: 3
//            color: "#222222"
//            y: tableView.contentY
//            x: tableView.contentX
//            width: tableView.leftMargin
//            height: tableView.topMargin
//        }

//        Row {
//            id: columnsHeader
//            y: tableView.contentY
//            z: 2
//            Repeater {
//                model: tableView.columns > 0 ? tableView.columns : 1
//                Label {
//                    width: tableView.columnWidthProvider(modelData)
//                    height: 35
////                    text: QtTest2.headerData(modelData, Qt.Horizontal)
//                    text: "s"
//                    color: 'black'
//                    font.pixelSize: 15
//                    padding: 10
//                    verticalAlignment: Text.AlignVCenter

//                    background: Rectangle { color: "beige" }
//                }
//            }
//        }

//        Column {
//            id: rowsHeader
//            x: tableView.contentX
//            z: 2
//            Repeater {
//                model: tableView.rows > 0 ? tableView.rows : 1
//                Label {
//                    width: 60
//                    height: tableView.rowHeightProvider(modelData)
////                    text: QtTest2.headerData(modelData, Qt.Vertical)
//                    text: "aim"
//                    color: 'black'
//                    font.pixelSize: 15
//                    padding: 10
//                    verticalAlignment: Text.AlignVCenter

//                    background: Rectangle { color: "beige" }
//                }
//            }
//        }

//        ScrollIndicator.horizontal: ScrollIndicator { }
//        ScrollIndicator.vertical: ScrollIndicator { }

//    }

//    Rectangle {
//        width:400;
//        height: 600;

//        Rectangle {
//                id:comboBox
//                property variant items: ["Item 1", "Item 2", "Item 3"]
//                property alias selectedItem: chosenItemText.text;
//                property alias selectedIndex: listView.currentIndex;
//                signal comboClicked;
//                width: 100;
//                height: 30;
//                z: 100;
//                smooth:true;

//                Rectangle {
//                    id:chosenItem
//                    radius:4;
//                    width:parent.width;
//                    height:comboBox.height;
//                    color: "lightsteelblue"
//                    smooth:true;
//                    Text {
//                        anchors.top: parent.top;
//                        anchors.left: parent.left;
//                        anchors.margins: 8;
//                        id:chosenItemText
//                        text:comboBox.items[0];
//                        font.family: "Arial"
//                        font.pointSize: 14;
//                        smooth:true
//                    }

//                    MouseArea {
//                        anchors.fill: parent;
//                        onClicked: {
//                            comboBox.state = comboBox.state==="dropDown"?"":"dropDown"
//                        }
//                    }
//                }

//                Rectangle {
//                    id:dropDown
//                    width:comboBox.width;
//                    height:0;
//                    clip:true;
//                    radius:4;
//                    anchors.top: chosenItem.bottom;
//                    anchors.margins: 2;
//                    color: "lightgray"

//                    ListView {
//                        id:listView
//                        height:500;
//                        model: comboBox.items
//                        currentIndex: 0
//                        delegate: Item{
//                            width:comboBox.width;
//                            height: comboBox.height;

//                            Text {
//                                text: modelData
//                                anchors.top: parent.top;
//                                anchors.left: parent.left;
//                                anchors.margins: 5;

//                            }
//                            MouseArea {
//                                anchors.fill: parent;
//                                onClicked: {
//                                    comboBox.state = ""
//                                    var prevSelection = chosenItemText.text
//                                    chosenItemText.text = modelData
//                                    if(chosenItemText.text != prevSelection){
//                                        comboBox.comboClicked();
//                                    }
//                                    listView.currentIndex = index;
//                                }
//                            }
//                        }
//                    }
//                }

//                Component {
//                    id: highlight
//                    Rectangle {
//                        width:comboBox.width;
//                        height:comboBox.height;
//                        color: "red";
//                        radius: 4
//                    }
//                }

//                states: State {
//                    name: "dropDown";
//                    PropertyChanges { target: dropDown; height:40*comboBox.items.length }
//                }

//                transitions: Transition {
//                    NumberAnimation { target: dropDown; properties: "height"; easing.type: Easing.OutExpo; duration: 1000 }
//                }
//            }
//        }



    Rectangle {
        width: 64
        height: 64
        property alias value: list.currentIndex
        property alias label: caption.text

        Text {
            id: caption
            text: "Spinner"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Rectangle {
            anchors.top: caption.bottom
            anchors.topMargin: 4
            anchors.horizontalCenter: parent.horizontalCenter
            height: 48
            width: 32
            color: "black"
            ListView {
                id: list
                anchors.fill: parent
                highlightRangeMode: ListView.StrictlyEnforceRange
                preferredHighlightBegin: height/3
                preferredHighlightEnd: height/3
                clip: true
                model: 64
                delegate: Text {
                    font.pixelSize: 18;
                    color: "white";
                    text: index;
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
            Rectangle {
                anchors.fill: parent
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#FF000000" }
                    GradientStop { position: 0.2; color: "#00000000" }
                    GradientStop { position: 0.8; color: "#00000000" }
                    GradientStop { position: 1.0; color: "#FF000000" }
                }
            }
        }
    }

    Calendar {
        minimumDate: new Date(2017, 0, 1)
        maximumDate: new Date(2018, 0, 1)
    }
}
