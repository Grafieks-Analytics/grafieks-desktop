import QtQuick 2.15
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0

import "./MiniSubComponents"

Item {

    id: joinBoxItem
    property var objectName

    objectName: objectName

    // Set the join type
    function setJoinOption(joinType, icon){
        DSParamsModel.setJoinType(joinType)
        iconId.source = icon
    }

    Rectangle{
        id: joinBoxRectangle
        width:35
        height:35
        color: "transparent"

        Image{
            id: iconId
            source: "../../../Images/icons/inner_join_32.png"
        }

        MouseArea{
            anchors.fill: parent
            onClicked: {
                joinPopup.visible = true
//                contextMenu.popup()
            }

            Menu {
                id: contextMenu
                MenuItem {
                    text: "Inner Join"
                    display: AbstractButton.TextBesideIcon
                    icon.source: "../../../Images/icons/inner_join_32.png"
                    icon.color: "transparent"
                    onTriggered: setJoinOption(Constants.innerJoin, icon.source)
                }
                MenuItem {
                    text: "Left Join"
                    display: AbstractButton.TextBesideIcon
                    icon.source: "../../../Images/icons/left_join_32.png"
                    icon.color: "transparent"
                    onTriggered: setJoinOption(Constants.leftJoin, icon.source)
                }
                MenuItem {
                    text: "Right Join"
                    display: AbstractButton.TextBesideIcon
                    icon.source: "../../../Images/icons/right_join_32.png"
                    icon.color: "transparent"
                    onTriggered: setJoinOption(Constants.rightJoin, icon.source)
                }
                MenuItem {
                    text: "Full Join"
                    display: AbstractButton.TextBesideIcon
                    icon.source: "../../../Images/icons/outer_join_32.png"
                    icon.color: "transparent"
                    onTriggered: setJoinOption(Constants.fullJoin, icon.source)
                }
            }
        }
    }

}
