import QtQuick 2.0
// ListView {
//     id: root

//  // public
//     function set(date) { // new Date(2019, 10 - 1, 4)
//         selectedDate = new Date(date)
//         positionViewAtIndex((selectedDate.getFullYear()) * 12 + selectedDate.getMonth(), ListView.Center) // index from month year
//     }

//     signal clicked(date date);  // onClicked: print('onClicked', date.toDateString())

//  // private
//     property date selectedDate: new Date()

//     width: 500;  height: 100 // default size
//     snapMode:    ListView.SnapOneItem
//     orientation: Qt.Horizontal
//     clip:        true

//     model: 3000 * 12 // index == months since January of the year 0

//     delegate: Item {
//         property int year:      Math.floor(index / 12)
//         property int month:     index % 12 // 0 January
//         property int firstDay:  new Date(year, month, 1).getDay() // 0 Sunday to 6 Saturday

//         width: root.width;  height: root.height

//         Column {
//             Item { // month year header
//                 width: root.width;  height: root.height - grid.height

//                 Text { // month year
//                     anchors.centerIn: parent
//                     text: ['January', 'February', 'March', 'April', 'May', 'June',
//                            'July', 'August', 'September', 'October', 'November', 'December'][month] + ' ' + year
//                     font {pixelSize: 0.5 * grid.cellHeight}
//                 }
//             }

//             Grid { // 1 month calender
//                 id: grid

//                 width: root.width;  height: 0.875 * root.height
//                 property real cellWidth:  width  / columns;
//                 property real cellHeight: height / rows // width and height of each cell in the grid.

//                 columns: 7 // days
//                 rows:    7

//                 Repeater {
//                     model: grid.columns * grid.rows // 49 cells per month

//                     delegate: Rectangle { // index is 0 to 48
//                         property int day:  index - 7 // 0 = top left below Sunday (-7 to 41)
//                         property int date: day - firstDay + 1 // 1-31

//                         width: grid.cellWidth;  height: grid.cellHeight
//                         border.width: 0.3 * radius
//                         border.color: new Date(year, month, date).toDateString() == selectedDate.toDateString()  &&  text.text  &&  day >= 0?
//                                       'black': 'transparent' // selected
//                         radius: 0.02 * root.height
//                         opacity: !mouseArea.pressed? 1: 0.3  //  pressed state

//                         Text {
//                             id: text

//                             anchors.centerIn: parent
//                             font.pixelSize: 0.5 * parent.height
//                             font.bold:      new Date(year, month, date).toDateString() == new Date().toDateString() // today
//                             text: {
//                                 if(day < 0)                                               ['S', 'M', 'T', 'W', 'T', 'F', 'S'][index] // Su-Sa
//                                 else if(new Date(year, month, date).getMonth() == month)  date // 1-31
//                                 else                                                      ''
//                             }
//                         }

//                         MouseArea {
//                             id: mouseArea

//                             anchors.fill: parent
//                             enabled:    text.text  &&  day >= 0

//                             onClicked: {
//                                 selectedDate = new Date(year, month, date)
//                                 root.clicked(selectedDate)
//                             }
//                         }
//                     }
//                 }
//             }
//         }
//     }

//      // Component.onCompleted: set(new Date()) // today (otherwise Jan 0000)
// }
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
// Page {
//     id: page
//     property double currentTime: 0
//     GridView {
//         anchors.fill: parent
//         model: 2000
//         cellWidth: page.width
//         cellHeight: page.height
//         flow: GridView.FlowTopToBottom
//         snapMode: GridView.SnapOneRow
//         delegate: Item {
//             width: page.width
//             height: page.height
//             ColumnLayout {
//                 Text {
//                     text: Qt.formatDateTime(grid.year + "-" + (grid.month + 1).toString().padStart(2, "0") + "-01", "MMMM yyyy")
//                 }
//                 DayOfWeekRow {
//                     Layout.fillWidth: true
//                     locale: grid.locale
//                 }
//                 MonthGrid {
//                     id: grid
//                     Layout.fillWidth: true
//                     month: index % 12
//                     year: 2021 + Math.floor(index / 12)
//                     locale: Qt.locale("en_US")
//                     delegate: Text {
//                         horizontalAlignment: Text.AlignHCenter
//                         verticalAlignment: Text.AlignVCenter
//                         opacity: model.month === grid.month ? 1 : 0.2
//                         text: model.day
//                         font: grid.font
//                         required property var model
//                         Rectangle {
//                             anchors.fill: parent
//                             anchors.margins: -5
//                             z: -2
//                             radius: 5
//                             border.color: "red"
//                             border.width: 3
//                             color: "transparent"
//                             visible: currentTime === model.date.getTime()
//                         }
//                         MouseArea {
//                             anchors.fill: parent
//                             onClicked: currentTime = model.date.getTime()
//                         }
//                     }
//                 }
//             }    
//         }
//     }
// }

ListView {
    id: listview
    width: 155
    height: 220
    clip:true
    snapMode: ListView.SnapOneItem
    orientation: ListView.Horizontal
    highlightRangeMode: ListView.StrictlyEnforceRange
    property double currentTime: 0
    property date selectedDate: new Date()
    // signal clicked(date date);  // onClicked: print('onClicked', date.toDateString())
    function updateDate(d){}
    function set(date) { // new Date(2019, 10 - 1, 4)
        selectedDate = new Date(date)
        positionViewAtIndex((selectedDate.getFullYear()) * 12 + selectedDate.getMonth(), ListView.Center) // index from month year
    }


    // model: CalendarModel {
    //     from: new Date(2015, 12, 1)
    //     to: new Date(2023, 03, 31)
    // }
    model: 3000 * 12 // index == months since January of the year 0
    



    Rectangle{
        id:nextprev
        height:25
        width:155
        // color:"red"
        
        Button{
            anchors.left:parent.left
            text: "Prev"
            onClicked:{
                listview.currentIndex = listview.currentIndex - 1  }
        }
        Button{
            anchors.right:parent.right
            text: "Next"
            onClicked:{
                console.log("clicl",listview.currentIndex)
                listview.currentIndex = listview.currentIndex + 1  }
        }
    }
    

    delegate: ColumnLayout {
        anchors.top:parent.top
        anchors.topMargin:25
        
        Text {
            text: Qt.formatDateTime(monthGrid.year + "-" + (monthGrid.month + 1).toString().padStart(2, "0") + "-01", "MMMM yyyy")
        }
        DayOfWeekRow {
            locale: monthGrid.locale
            Layout.fillWidth: true
        }

        // MonthGrid {
        //     id: monthGrid
        //     month: model.month
        //     year: model.year
        //     locale: Qt.locale("en_AU")
        //     Layout.fillWidth: true
        // }
        MonthGrid {
            id: monthGrid
            Layout.fillWidth: true
            month: index % 12
            year: Math.floor(index / 12)
            locale: Qt.locale("en_US")
            delegate: Text {
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                opacity: model.month === monthGrid.month ? 1 : 0.2
                text: model.day
                font: monthGrid.font
                required property var model
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: -5
                    z: -2
                    radius: 5
                    border.color: "red"
                    border.width: 3
                    color: "transparent"
                    visible: currentTime === model.date.getTime()
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        currentTime = model.date.getTime()
                        console.log("current date = " , currentTime,model.date)
                        // selectedDate = new Date(year, month, model.date)
                        // listview.clicked("selectedDate",model.date)
                        updateDate(model.date);
                    }
                }
            }
        }
        // Grid { // 1 month calender
        //     id: grid

        //     width: listview.width;  height: 0.875 * listview.height
        //     property real cellWidth:  width  / columns;
        //     property real cellHeight: height / rows // width and height of each cell in the grid.

        //     columns: 7 // days
        //     rows:    7

        //     Repeater {
        //         model: grid.columns * grid.rows // 49 cells per month

        //         delegate: Rectangle { // index is 0 to 48
        //             property int day:  index - 7 // 0 = top left below Sunday (-7 to 41)
        //             property int date: day - firstDay + 1 // 1-31

        //             width: grid.cellWidth;  height: grid.cellHeight
        //             border.width: 0.3 * radius
        //             border.color: new Date(year, month, date).toDateString() == selectedDate.toDateString()  &&  text.text  &&  day >= 0?
        //                               'black': 'transparent' // selected
        //             radius: 0.02 * root.height
        //             opacity: !mouseArea.pressed? 1: 0.3  //  pressed state

        //             Text {
        //                 id: text

        //                 anchors.centerIn: parent
        //                 font.pixelSize: 0.5 * parent.height
        //                 font.bold:      new Date(year, month, date).toDateString() == new Date().toDateString() // today
        //                 text: {
        //                     if(day < 0)                                               ['S', 'M', 'T', 'W', 'T', 'F', 'S'][index] // Su-Sa
        //                     else if(new Date(year, month, date).getMonth() == month)  date // 1-31
        //                     else                                                      ''
        //                 }
        //             }

        //             MouseArea {
        //                 id: mouseArea

        //                 anchors.fill: parent
        //                 enabled:    text.text  &&  day >= 0

        //                 onClicked: {
        //                     selectedDate = new Date(year, month, date)
        //                     listview.clicked(selectedDate)
        //                 }
        //             }
        //         }
        //     }
        // }
    }
    

    ScrollIndicator.horizontal: ScrollIndicator { }

}

//import QtQuick 2.0

// ListView {
//     id: root


//     // public
//     function set(date) { // new Date(2019, 10 - 1, 4)
//         selectedDate = new Date(date)
//         positionViewAtIndex((selectedDate.getFullYear()) * 12 + selectedDate.getMonth(), ListView.Center) // index from month year
//     }

//     signal clicked(date date);  // onClicked: print('onClicked', date.toDateString())

//     // private
//     property date selectedDate: new Date()

//     width: 500;  height: 100 // default size
//     snapMode:    ListView.SnapOneItem
//     orientation: Qt.Horizontal
//     clip:        true

//     model: 3000 * 12 // index == months since January of the year 0

//     delegate: Item {
//         property int year:      Math.floor(index / 12)
//         property int month:     index % 12 // 0 January
//         property int firstDay:  new Date(year, month, 1).getDay() // 0 Sunday to 6 Saturday

//         width: root.width;  height: root.height

//         Column {
//             Item { // month year header
//                 width: root.width;  height: root.height - grid.height

//                 Text { // month year
//                     anchors.centerIn: parent
//                     text: ['January', 'February', 'March', 'April', 'May', 'June',
//                         'July', 'August', 'September', 'October', 'November', 'December'][month] + ' ' + year
//                     font {pixelSize: 0.5 * grid.cellHeight}
//                 }
//             }

//             Grid { // 1 month calender
//                 id: grid

//                 width: root.width;  height: 0.875 * root.height
//                 property real cellWidth:  width  / columns;
//                 property real cellHeight: height / rows // width and height of each cell in the grid.

//                 columns: 7 // days
//                 rows:    7

//                 Repeater {
//                     model: grid.columns * grid.rows // 49 cells per month

//                     delegate: Rectangle { // index is 0 to 48
//                         property int day:  index - 7 // 0 = top left below Sunday (-7 to 41)
//                         property int date: day - firstDay + 1 // 1-31

//                         width: grid.cellWidth;  height: grid.cellHeight
//                         border.width: 0.3 * radius
//                         border.color: new Date(year, month, date).toDateString() == selectedDate.toDateString()  &&  text.text  &&  day >= 0?
//                                           'black': 'transparent' // selected
//                         radius: 0.02 * root.height
//                         opacity: !mouseArea.pressed? 1: 0.3  //  pressed state

//                         Text {
//                             id: text

//                             anchors.centerIn: parent
//                             font.pixelSize: 0.5 * parent.height
//                             font.bold:      new Date(year, month, date).toDateString() == new Date().toDateString() // today
//                             text: {
//                                 if(day < 0)                                               ['S', 'M', 'T', 'W', 'T', 'F', 'S'][index] // Su-Sa
//                                 else if(new Date(year, month, date).getMonth() == month)  date // 1-31
//                                 else                                                      ''
//                             }
//                         }

//                         MouseArea {
//                             id: mouseArea

//                             anchors.fill: parent
//                             enabled:    text.text  &&  day >= 0

//                             onClicked: {
//                                 selectedDate = new Date(year, month, date)
//                                 root.clicked(selectedDate)
//                             }
//                         }
//                     }
//                 }
//             }
//         }

//         Button{
//             text: "click"
//             onClicked:{
//                 console.log("clicl",root.currentIndex)
//                 root.currentIndex = 2  }
//         }


//     }

//     // Component.onCompleted: set(new Date()) // today (otherwise Jan 0000)
// }
