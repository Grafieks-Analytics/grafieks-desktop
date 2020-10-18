import QtQuick 2.0

import com.grafieks.singleton.constants 1.0

Column{

    property int leftMargin: 15

    property int spacingColorList: 5
    property int colorBoxHeight: 20
    property int colorListTopMargin: 5

    ListModel{
        id: colorListModel
        ListElement{
            textValue: "Quantity"
        }
        ListElement{
            textValue: "Quantity 1"
        }
        ListElement{
            textValue: "Quantity 2"
        }
    }


    Rectangle {
        height: allParameter.height + colorByText.height + 2*colorListTopMargin
        width: 150
        Text {
            id: colorByText
            x: leftMargin
            font.pixelSize: Constants.fontCategoryHeaderSmall
            text: "Color By"
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                console.log('Okay')
            }
        }

        Rectangle{

            id: allParameter
            anchors.top: colorByText.bottom
            anchors.topMargin: colorListTopMargin

            height: colorList.height + colorListModel.count*spacingColorList

            width: parent.width-2*leftMargin
            x:leftMargin


            border.color: Constants.themeColor

            ListView{
                id: colorList
                model: colorListModel
                spacing: spacingColorList
                height: colorListModel.count*colorBoxHeight + spacingColorList
                width: parent.width-10
                x:5
                anchors.top: parent.top
                anchors.topMargin: 5

                delegate: Rectangle{

                    height: colorBoxHeight
                    width: parent.width

                    color: "#BADCFF"

                    border.width: 1
                    border.color: "#CDE6FF"

                    Text {
                        text: textValue
                        anchors.centerIn: parent
                        font.pixelSize: Constants.fontCategoryHeaderSmall
                    }
                }
            }

        }
    }



}
