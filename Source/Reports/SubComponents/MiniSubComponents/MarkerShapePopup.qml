import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents";
import "../MiniSubComponents";

Popup {

    property int shapeWidth: 20
    property int shapeHeight: 20

    width: shapeHeight*4
    height: 120
    x: 10
    modal: false
    visible: true

    ListModel{
        id: outlined
        ListElement{
            icon: "Ellipse.png"
        }
        ListElement{
            icon: "Rectangle.png"
        }
        ListElement{
            icon: "Polygon.png"
        }
        ListElement{
            icon: "add.png"
        }
    }

    ListModel{
        id: filled
        ListElement{
            icon: "Ellipse_filled.png"
        }
        ListElement{
            icon: "Rectangle_filled.png"
        }
        ListElement{
            icon: "Polygon_filled.png"
        }
    }

    background: Rectangle{
        color: Constants.whiteColor
        border.color: Constants.themeColor
    }


    Rectangle{
        anchors.fill: parent

        Row{
            anchors.fill: parent
            spacing: 10

            Rectangle{
                width: (parent.width - parent.spacing)/2
                height: parent.height

                Column{
                    anchors.fill: parent

                    ListView{
                        model: outlined
                        height: shapeHeight*4
                        spacing: 5
                        delegate: Image {
                            source: "/Images/icons/shapes/"+icon
                            height: shapeHeight
                            width: shapeWidth
                        }
                    }

                }
            }
            Rectangle{
                width: (parent.width - parent.spacing)/2
                height: parent.height

                Column{

                    anchors.fill: parent
                    ListView{
                        model: filled
                        height: shapeHeight*4
                        spacing: 5
                        delegate: Image {
                            source: "/Images/icons/shapes/"+icon
                            height: shapeHeight
                            width: shapeWidth
                        }
                    }

                }
            }

        }

    }
}
