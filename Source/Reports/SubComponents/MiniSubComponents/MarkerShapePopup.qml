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
    visible: false

    ListModel{
        id: outlinedIcons
        ListElement{
            icon: "Ellipse.png"
            type: "circle"
            filled: false
        }
        ListElement{
            icon: "Rectangle.png"
            type: "rect"
            filled: false
        }
//        ListElement{
//            icon: "Polygon.png"
//            filled: false
//        }
//        ListElement{
//            icon: "add.png"
//            filled: false
//        }
    }

    ListModel{
        id: filledIcons
        ListElement{
            icon: "Ellipse_filled.png"
            type: "circle"
            filled: true
        }
        ListElement{
            icon: "Rectangle_filled.png"
            type: "rect"
            filled: true
        }
//        ListElement{
//            icon: "Polygon_filled.png"
//            filled: true
//        }
    }

    background: Rectangle{
        color: Constants.whiteColor
        border.color: Constants.darkThemeColor
    }

    function drawMarkerShape(filledStatus,markerShape){
        // var query = 'drawMarker('+filledStatus+',"'+markerShape+'")';
        d3PropertyConfig.filledStatus = filledStatus;
        d3PropertyConfig.markerShape = markerShape;
        d3PropertyConfig.markerStatus = true;        
        reDrawChart();
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
                        model: outlinedIcons
                        height: (shapeHeight+this.spacing)*outlinedIcons.count
                        spacing: 8
                        delegate: Image {
                            source: "/Images/icons/shapes/"+icon
                            height: shapeHeight
                            width: shapeWidth
                            MouseArea{
                                anchors.fill: parent
                                onClicked: drawMarkerShape(filled,type)
                            }
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
                        model: filledIcons
                        height: (shapeHeight+this.spacing)*filledIcons.count
                        spacing: 8
                        delegate: Image {
                            source: "/Images/icons/shapes/"+icon
                            height: shapeHeight
                            width: shapeWidth
                            MouseArea{
                                anchors.fill: parent
                                onClicked: drawMarkerShape(filled,type)
                            }
                        }
                    }

                }
            }

        }

    }
}
