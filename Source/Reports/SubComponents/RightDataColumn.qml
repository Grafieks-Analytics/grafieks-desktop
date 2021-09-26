import QtQuick 2.15
import QtQuick.Controls 2.15
import com.grafieks.singleton.constants 1.0

import "./MiniSubComponents";

Column{

    property int leftMargin: 10

    anchors.fill: parent
    anchors.left: parent.left
//    anchors.leftMargin: leftMargin
//    spacing: 5

    /***********************************************************************************************************************/
    // LIST MODEL STARTS


    // LIST MODEL ENDS
    /***********************************************************************************************************************/


    /***********************************************************************************************************************/
    // SIGNALS STARTS

    // SIGNALS ENDS
    /***********************************************************************************************************************/



    /***********************************************************************************************************************/
    // Connections Starts



    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    Component.onCompleted: {

    }

    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/


    Rectangle{
        height: parent.height/3 - 6
        width: parent.width
        color: "white"
//        x:-leftMargin
//        border.color: Constants.darkThemeColor
//         anchors.horizontalCenter: parent.horizontalCenter

            z: -12000

        Rectangle{
            id:categoricalHeadingRect
            z:10
            color: "white"
            height: 25
            width:parent.width
            Rectangle{
                id:categoricalRect
                height: 25
                width: parent.width
                color: Constants.themeColor
                anchors.top: parent.top
//                x:-leftMargin
                border.color: Constants.darkThemeColor
            Text {
                id: categoricalHeading
                text: qsTr("Categorical")
                anchors.left: parent.left

                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: Constants.fontCategoryHeader
                z: 100
            }
            }
        }


        CategoricalList{
            id: categoricalList
            anchors.top: categoricalHeadingRect.bottom
            height: parent.height - 40
            width: parent.width-10
             anchors.horizontalCenter: parent.horizontalCenter

        }

    }

//    ToolSeparator{

//        orientation: Qt.Horizontal;
//        width: parent.width + leftMargin
//        height: 1
//        x:-leftMargin
//        background: Rectangle{
//            color: Constants.darkThemeColor
//        }
//    }


    Rectangle{
        height: parent.height/3 - 6
        width: parent.width
        color: "white"

            z: -120000

//        x:-leftMargin
//        border.color: Constants.darkThemeColor
//         anchors.horizontalCenter: parent.horizontalCenter

        Rectangle{
            id:numericalRect
            height: 25
            width: parent.width
            color: Constants.themeColor
//            anchors.top: parent.top
//            x:-leftMargin

            border.color: Constants.darkThemeColor

        Text {
            id: numericalHeading
            text: qsTr("Numerical")
            anchors.left: parent.left

            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: Constants.fontCategoryHeader
        }
}

        NumericalList{
            id: numericalList
            anchors.top: numericalRect.bottom
             height: parent.height - 40
            width: parent.width-10
             anchors.horizontalCenter: parent.horizontalCenter
             z: 20000    
        }

    }


//    ToolSeparator{
//        orientation: Qt.Horizontal;
//        width: parent.width + leftMargin
//        height: 1
//        x:-leftMargin
//        background: Rectangle{
//            color: Constants.darkThemeColor
//        }
//    }

    Rectangle{
        height: parent.height/3 - 6
         width: parent.width
        color: "white"
            z: -120000

//        border.color: Constants.darkThemeColor
//          anchors.horizontalCenter: parent.horizontalCenter

        Rectangle{
            id:dateRect
            height: 25
            width: parent.width
            color: Constants.themeColor
//            anchors.top: parent.top
//            x:-leftMargin

            border.color: Constants.darkThemeColor
        Text {
            id: dateHeading
            text: qsTr("Date")
            anchors.left: parent.left

            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: Constants.fontCategoryHeader
        }
        }

        DateList{
            id: dateList
             anchors.top: dateRect.bottom
             height: parent.height - 40
             width: parent.width-10
             anchors.horizontalCenter:  parent.horizontalCenter
             z: 20000    
        }

    }


}
