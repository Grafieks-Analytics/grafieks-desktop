import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2



Rectangle {
    id: win
    width: 86
    height: 560
    visible: true


    function test(){
        console.log("header selected")
    }

    ListModel {
        id: libraryModel
        ListElement {
            title: "A Masterpiece"
            author: "Gabriel"
        }
        ListElement {
            title: "Brilliance"
            author: "Jens"
        }
        ListElement {
            title: "Outstanding"
            author: "Frederik"
        }
        ListElement {
            title: "Outstanding"
            author: "Frederik"
        }
        ListElement {
            title: "Outstanding"
            author: "Frederik"
        }
        ListElement {
            title: "Outstanding"
            author: "Frederik"
        }
        ListElement {
            title: "Outstanding"
            author: "Frederik"
        }
        ListElement {
            title: "Outstanding"
            author: "Frederik"
        }
        ListElement {
            title: "Outstanding"
            author: "Frederik"
        }
        ListElement {
            title: "Outstanding"
            author: "Frederik"
        }
        ListElement {
            title: "Outstanding"
            author: "Frederik"
        }
        ListElement {
            title: "Outstanding"
            author: "Frederik"
        }
        ListElement {
            title: "Outstanding"
            author: "Frederik"
        }
        ListElement {
            title: "Outstanding"
            author: "Frederik"
        }
        ListElement {
            title: "Outstanding"
            author: "Frederik"
        }
        ListElement {
            title: "Outstanding"
            author: "Frederik"
        }
        ListElement {
            title: "Outstanding"
            author: "Frederik"
        }
        ListElement {
            title: "Outstanding"
            author: "Frederik"
        } ListElement {
            title: "Outstanding"
            author: "Frederik"
        } ListElement {
            title: "Outstanding"
            author: "Frederik"
        } ListElement {
            title: "Outstanding"
            author: "Frederik"
        } ListElement {
            title: "Outstanding"
            author: "Frederik"
        } ListElement {
            title: "Outstanding"
            author: "Frederik"
        } ListElement {
            title: "Outstanding"
            author: "Frederik"
        } ListElement {
            title: "Outstanding"
            author: "Frederik"
        } ListElement {
            title: "Outstanding"
            author: "Frederik"
        } ListElement {
            title: "Outstanding"
            author: "Frederik"
        } ListElement {
            title: "Outstanding"
            author: "Frederik"
        } ListElement {
            title: "Outstanding"
            author: "Frederik"
        } ListElement {
            title: "Outstanding"
            author: "Frederik"
        } ListElement {
            title: "Outstanding"
            author: "Frederik"
        } ListElement {
            title: "Outstanding"
            author: "Frederik"
        } ListElement {
            title: "Outstanding"
            author: "Frederik"
        } ListElement {
            title: "Outstanding"
            author: "Frederik"
        } ListElement {
            title: "Outstanding"
            author: "Frederik"
        } ListElement {
            title: "Outstanding"
            author: "Frederik"
        } ListElement {
            title: "Outstanding"
            author: "Frederik"
        }
    }

    TableView {

        width:if((tr.width+ty.width)>parent.width) {
                  parent.width
              }
              else{
                  tr.width+ty.width+17
              }

        height: parent.height/2

        alternatingRowColors: false
        backgroundVisible: false



        TableViewColumn {
            id:tr
            role: "title"
            title: "Title"
            width: 200




        }
        TableViewColumn {
            id:ty
            role: "author"
            title: "Author"
            width: 300


        }
        model: libraryModel

        style: TableViewStyle {


            headerDelegate: Rectangle {
                height: textItem.implicitHeight * 1.2
                width: textItem.implicitWidth
                color: "lightgrey"
                MouseArea{
                           anchors.fill: parent

                           onClicked:
                           {
                            // this click is not called.
                            console.log("Header Clicked..")
                           }
                }



                Text {
                    id: textItem
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: styleData.textAlignment
                    anchors.leftMargin: 12
                    text: styleData.value
                    elide: Text.ElideRight
                    color: textColor
                    renderType: Text.NativeRendering

//                    Text.selected: test();


                }
                Rectangle {
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 1
                    anchors.topMargin: 1
                    width: 1
                    color: "black"
                    border.color: "black"
                }
                Rectangle {
                    //                    anchors.right: parent.right
                    //                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    //                    anchors.bottomMargin: 1
                    //                    anchors.topMargin: 1
                    width: parent.width
                    height: 1

                    color: "black"
                    border.color: "black"
                }


            }


            itemDelegate: Rectangle {
                height: textItem.implicitHeight * 1.2
                width: textItem.implicitWidth
                color: "white"

                //                border.color: "black"
                Text {
                    id: textItem1
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: styleData.textAlignment
                    anchors.leftMargin: 12
                    text: styleData.value
                    elide: Text.ElideRight
                    color: textColor
                    renderType: Text.NativeRendering
                }
                Rectangle {
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    //                    anchors.bottomMargin: 1
                    //                    anchors.topMargin: 1
                    width: 1
                    color: "black"
                    border.color: "black"
                }
                Rectangle {
                    //                    anchors.right: parent.right
                    //                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    //                    anchors.bottomMargin: 1
                    //                    anchors.topMargin: 1
                    width: parent.width
                    height: 1

                    color: "black"
                    border.color: "black"
                }
            }

            //            rowDelegate: Rectangle {
            //                height: textItem.implicitHeight * 1.2
            //                width: textItem.implicitWidth
            ////                color: "green"
            //                border.color: "black"
            ////                Text {
            ////                    id: textItem1
            ////                    anchors.fill: parent
            ////                    verticalAlignment: Text.AlignVCenter
            ////                    horizontalAlignment: styleData.textAlignment
            ////                    anchors.leftMargin: 12
            ////                    text: "ravi"
            ////                    elide: Text.ElideRight
            ////                    color: textColor
            ////                    renderType: Text.NativeRendering

            ////                }
            //                Rectangle {
            //                    anchors.right: parent.right
            //                    anchors.top: parent.top
            //                    anchors.bottom: parent.bottom
            //                    anchors.bottomMargin: 1
            //                    anchors.topMargin: 1
            //                    width: 1
            //                    color: "green"
            //                    border.color: "green"
            //                }


            //            }

        }
    }
}
