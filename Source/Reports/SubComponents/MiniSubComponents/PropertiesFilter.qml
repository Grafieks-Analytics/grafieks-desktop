import QtQuick 2.15
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0

import "../../SubComponents"
import "../../../MainSubComponents"

Column{

    id: propertiesFilter

    property int leftMargin: 15

    property int spacingColorList: 5
    property int colorBoxHeight: 20
    property int colorListTopMargin: 5
    property int editImageSize: 16
    property bool colorByActive: ReportParamsModel.colorByActive;

    spacing: 4

    /***********************************************************************************************************************/
    // LIST MODEL STARTS


    ListModel{
        id: colorListModel
    }

    ListModel{
        id: fonts
        ListElement{
            fontName:"Default"
        }
    }

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

    onColorByActiveChanged: {
        if(colorByActive){
            allParameter.border.color = Constants.grafieksLightGreenColor;
            allParameter.border.width = Constants.dropEligibleBorderWidth;;
        }else{
            allParameter.border.color = Constants.themeColor;
            allParameter.border.width = Constants.dropActiveBorderWidth;
        }
    }


    Component.onCompleted: {

        ReportParamsModel.colorByActive = false;
        allParameter.border.color =  Constants.themeColor
        allParameter.border.width =  2


    }


    function onDropAreaEntered(element){
        element.border.width = Constants.dropActiveBorderWidth;
        if(!isDropEligible()){
            element.border.color = Constants.redColor
            return
        }
        element.border.color = Constants.grafieksLightGreenColor
    }

    function onDropAreaExited(element){
        element.border.width = Constants.dropEligibleBorderWidth;
        if(!isDropEligible()){
            element.border.color = Constants.themeColor
            return
        }
    }

    function onDropAreaDropped(element){
        element.border.width = Constants.dropEligibleBorderWidth

        var itemType = ReportParamsModel.itemType;
        var itemName = ReportParamsModel.itemName;

        if(!isDropEligible()){
            element.border.color = Constants.themeColor
            return;
        }        

        if(isDropEligible()){
            colorListModel.append({textValue: itemName})
            ReportParamsModel.lastDropped = itemType;
            return;
        }

    }

    function isDropEligible(){

        var itemType = ReportParamsModel.itemType;
        var lastDropped = ReportParamsModel.lastDropped;
        if(!lastDropped){
            return true;
        }
        if(lastDropped !== itemType){
            return false;
        }
        if(itemType.toLowerCase() === "numerical"){
            return true;
        }
        return false;
    }

    function onDropAreaPositionChanged(drag){
        console.log('Position change!!');
    }

    function openEditColorPopup(){
        editColorPopup.visible = true
    }

    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts


    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts



    // Color By Component Starts
    Rectangle {
        id: colorByComponent
        height: allParameter.height + colorByText.height + 2*colorListTopMargin
        width: 150
        Text {
            id: colorByText
            x: leftMargin
            anchors.top: parent.top
            anchors.topMargin: 5
            font.pixelSize: Constants.fontCategoryHeaderSmall
            text: "Color By"
        }
        Image {
            height: editImageSize
            width: editImageSize
            source: "/Images/icons/Edit_20.png"
            anchors.top: parent.top
            anchors.topMargin: 5
            anchors.right: parent.right
            anchors.rightMargin: leftMargin

            MouseArea{
                anchors.fill: parent
                onClicked: openEditColorPopup()
            }
        }

        Rectangle{
            id: allParameter

            width: parent.width-2*leftMargin
            height: !colorListModel.count ? 30 : (colorList.height + 5 * colorListModel.count)
            x:leftMargin
            anchors.top: colorByText.bottom
            anchors.topMargin: colorListTopMargin

            border.color: Constants.themeColor
            border.width: 1

            DropArea {
                id: dropArea
                height: parent.height
                width: parent.width
                onEntered:  onDropAreaEntered(parent)
                onExited:  onDropAreaExited(parent)
                onDropped: onDropAreaDropped(parent)

            }

            // list view for dropped colors
            ListView{
                id: colorList
                height: colorListModel.count*colorBoxHeight + spacingColorList
                width: parent.width-10
                x:5
                anchors.top: parent.top
                anchors.topMargin: 5
                model: colorListModel
                spacing: spacingColorList
                delegate: Rectangle{
                    height: colorBoxHeight
                    width: parent.width
                    color: "#BADCFF"
                    border.width: 1
                    border.color: "#CDE6FF"
                    Text {
                        text: textValue
                        anchors.centerIn: parent
                        width: parent.width - 10
                        elide: Text.ElideRight
                        font.pixelSize: Constants.fontCategoryHeaderSmall
                    }
                    MouseArea{
                        anchors.fill: parent
                        drag.target: parent;

                    }
                }
            }
             // list view ends!


        }
    }


    // Color By Component Ends



    // Tool tip starts
    Rectangle{

        height: 20
        width: parent.width

        Rectangle{
            anchors.fill: parent

            Text {
                text: qsTr("Tool Tip")
                anchors.left: parent.left
                anchors.leftMargin: leftMargin
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: Constants.fontCategoryHeaderSmall
            }

            Image {
                height: editImageSize
                width: editImageSize
                source: "/Images/icons/Edit_20.png"
                anchors.right: parent.right
                anchors.rightMargin: leftMargin
                anchors.verticalCenter: parent.verticalCenter
            }
            MouseArea{
                anchors.fill: parent
                onClicked: toolTipPopup.visible = true
            }

        }

    }
    // Tool tip Ends


    // Size starts
    Rectangle{

        height: 20
        width: parent.width


        Rectangle{
            anchors.fill: parent

            SizePopup{
                id: sizePopup
            }

            Text {
                text: qsTr("Size")
                anchors.left: parent.left
                anchors.leftMargin: leftMargin
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: Constants.fontCategoryHeaderSmall
            }

            Image {
                height: editImageSize
                width: editImageSize
                source: "/Images/icons/Edit_20.png"
                anchors.right: parent.right
                anchors.rightMargin: leftMargin
                anchors.verticalCenter: parent.verticalCenter
                MouseArea{
                    anchors.fill: parent
                    onClicked: sizePopup.visible = true
                }
            }

        }

    }
    // Size Ends


    // Marker Shape starts
    Rectangle{

        height: 20
        width: parent.width

        Rectangle{
            anchors.fill: parent

            MarkerShapePopup{
                id: markerShapePopup
                x: parent.width - 10
            }

            Text {
                text: qsTr("Marker Shape")
                anchors.left: parent.left
                anchors.leftMargin: leftMargin
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: Constants.fontCategoryHeaderSmall
            }

            Image {
                height: editImageSize
                width: editImageSize
                source: "/Images/icons/Edit_20.png"
                anchors.right: parent.right
                anchors.rightMargin: leftMargin
                anchors.verticalCenter: parent.verticalCenter
                MouseArea{
                    anchors.fill: parent
                    onClicked: markerShapePopup.visible = true
                }
            }

        }

    }
    // Marker Shape Ends


    // Label starts


    // Tool tip starts
    Rectangle{

        height: 20
        width: parent.width

        Rectangle{
            anchors.fill: parent

            LabelPopup{
                id: labelShapePopup
                x: parent.width - 10
            }

            Text {
                text: qsTr("Label")
                anchors.left: parent.left
                anchors.leftMargin: leftMargin
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: Constants.fontCategoryHeaderSmall
            }

            Image {
                height: editImageSize
                width: editImageSize
                source: "/Images/icons/Edit_20.png"
                anchors.right: parent.right
                anchors.rightMargin: leftMargin
                anchors.verticalCenter: parent.verticalCenter
            }
            MouseArea{
                anchors.fill: parent
                onClicked: labelShapePopup.visible = true
            }

        }

    }
    // Label Ends


//    Rectangle{

//        height: 20
//        width: parent.width


//        Rectangle{
//            anchors.fill: parent

//            Text {
//                text: qsTr("Label")
//                anchors.left: parent.left
//                anchors.leftMargin: leftMargin
//                anchors.verticalCenter: parent.verticalCenter
//                font.pixelSize: Constants.fontCategoryHeaderSmall
//            }

//            CheckBoxTpl{

//                checked: false
//                parent_dimension: editImageSize - 2
//                anchors.right: parent.right
//                anchors.verticalCenter: parent.verticalCenter
//                anchors.rightMargin: 5
//                anchors.top: parent.top

//            }

//        }

//    }
    // Label Ends

    // Merge Axis starts
    Rectangle{

        height: 30
        width: parent.width

        Rectangle{

            height: 20
            width: parent.width

            Text {
                text: qsTr("Merge Axis")
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

            }

        }

    }
    // Merge Axis Ends


}
