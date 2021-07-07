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

    width: 160
    height: 120
    x: 10
    modal: false
    visible: false

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


    ListModel{
        id: fonts
        ListElement{
            fontName:"Default"
        }
    }


    function showLabel(checked){
           var labelConfig = d3PropertyConfig.labelConfig || {};
           labelConfig['labelStatus'] = checked;
           d3PropertyConfig.labelConfig = labelConfig;
           reDrawChart();
       }


    background: Rectangle{
        color: Constants.whiteColor
        border.color: Constants.darkThemeColor
    }

    Rectangle{
        anchors.fill: parent

        Column{
            anchors.fill: parent
            spacing: 10


            Rectangle{

                height: 20
                width: parent.width


                Rectangle{
                    anchors.fill: parent

                    Text {
                        text: qsTr("Data Label")
                        anchors.left: parent.left
                        anchors.leftMargin: leftMargin
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: Constants.fontCategoryHeaderSmall
                    }

                    CheckBoxTpl{

                        checked: false
                        parent_dimension: editImageSize - 2
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.rightMargin: 5
                        anchors.top: parent.top

                        onCheckedChanged: showLabel(checked);


                    }

                }

            }

            Rectangle{
                height: 20
                width: parent.width
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("Font")
                }
            }

            Rectangle{
                height: 30
                width: parent.width

                CustomComboBox{
                    id: fontSizes
                    height: 500

                    Component.onCompleted: {
                        let fontFamilies = Qt.fontFamilies();
                        for(let i=0; i<fontFamilies.length;i++){
                            fonts.append({"fontName": fontFamilies[i]});
                        }
                        fontSizes.model = fonts
                    }
//                    popup: Popup {
//                //                            y: control.height - 1
//                            implicitWidth:  200

//                //                            implicitHeight: contentItem.implicitHeight
//                        implicitHeight: 500
//                //                            padding: 1


//                        contentItem: ListView {
//                                     clip: true
//                                     implicitHeight: 20
//                                     model:  fonts
//                                     currentIndex: fontSizes.highlightedIndex

//                                     ScrollIndicator.vertical: ScrollIndicator { }
//                                 }

//                    }







                    model: fonts
                    textRole: "fontName"
                    width: parent.width-2*leftMargin
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: leftMargin
                    anchors.top: parent.top

                }

            }


        }

    }
}
