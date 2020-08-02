/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Data
** Data Query Modeller
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"


Rectangle{

    id: heading

    height: parent.height - 80 - 40
    width: parent.width - 40
    x:20
    y:30
    anchors.top:  fullExtactRadioBtn.bottom
    color: Constants.whiteColor
    border.color: Constants.darkThemeColor

    visible: false


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


    function onMonthTabClicked(){
        yearTabContent.visible = false
        quarterTabContent.visible = false
        monthTabContent.visible = true
        dayTabContent.visible = false

        monthTabBackground.color = Constants.themeColor
        quarterTabBackground.color = Qt.binding(function(){
            return quarterTab.hovered ? Constants.themeColor : Constants.whiteColor
        })
        yearTabBackground.color = Qt.binding(function(){
            return yearTab.hovered ? Constants.themeColor : Constants.whiteColor
        })
        dayTabBackground.color = Qt.binding(function(){
            return dayTab.hovered ? Constants.themeColor : Constants.whiteColor
        })
    }


    function onDayTabClicked(){
        yearTabContent.visible = false
        quarterTabContent.visible = false
        monthTabContent.visible = false
        dayTabContent.visible = true

        dayTabBackground.color = Constants.themeColor
        quarterTabBackground.color = Qt.binding(function(){
            return quarterTab.hovered ? Constants.themeColor : Constants.whiteColor
        })
        monthTabBackground.color = Qt.binding(function(){
            return monthTab.hovered ? Constants.themeColor : Constants.whiteColor
        })
        yearTabBackground.color = Qt.binding(function(){
            return yearTab.hovered ? Constants.themeColor : Constants.whiteColor
        })
    }

    function onQuarterTabClicked(){

        yearTabContent.visible = false
        quarterTabContent.visible = true
        monthTabContent.visible = false
        dayTabContent.visible = false

        quarterTabBackground.color = Constants.themeColor
        yearTabBackground.color = Qt.binding(function(){
            return yearTab.hovered ? Constants.themeColor : Constants.whiteColor
        })
        monthTabBackground.color = Qt.binding(function(){
            return monthTab.hovered ? Constants.themeColor : Constants.whiteColor
        })
        dayTabBackground.color = Qt.binding(function(){
            return dayTab.hovered ? Constants.themeColor : Constants.whiteColor
        })
    }

    function onYearTabClicked(){
        yearTabContent.visible = true
        quarterTabContent.visible = false
        monthTabContent.visible = false
        dayTabContent.visible = false

        yearTabBackground.color = Constants.themeColor
        quarterTabBackground.color = Qt.binding(function(){
            return quarterTab.hovered ? Constants.themeColor : Constants.whiteColor
        })
        monthTabBackground.color = Qt.binding(function(){
            return monthTab.hovered ? Constants.themeColor : Constants.whiteColor
        })
        dayTabBackground.color = Qt.binding(function(){
            return dayTab.hovered ? Constants.themeColor : Constants.whiteColor
        })
    }

    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts




    Rectangle{

        id: submenuTab
        height: 30
        width: parent.width
        y:1
        x:1

        Button{
            id:yearTab
            height: parent.height
            width: parent.width/4 - 0.5
            anchors.left: parent.left

            Text {
                text: qsTr("Year")
                anchors.centerIn: parent
            }

            background: Rectangle{
                id:yearTabBackground
                color: Constants.themeColor
                border.color: Constants.darkThemeColor
            }

            onClicked: {
                onYearTabClicked()
            }
        }


        Button{
            id: quarterTab
            height: parent.height
            width: parent.width/4 - 0.5
            anchors.left: yearTab.right
            Text {
                text: qsTr("Quarter")
                anchors.centerIn: parent
            }

            background: Rectangle{
                id:quarterTabBackground
                color: quarterTab.hovered ? Constants.themeColor : Constants.whiteColor
                border.color: Constants.darkThemeColor
            }

            onClicked: {

                onQuarterTabClicked()
            }
        }


        Button{
            id: monthTab
            height: parent.height
            width: parent.width/4 - 0.5

            anchors.left: quarterTab.right
            Text {
                text: qsTr("Month")
                anchors.centerIn: parent
            }

            background: Rectangle{
                id: monthTabBackground
                color: monthTab.hovered ? Constants.themeColor : Constants.whiteColor
                border.color: Constants.darkThemeColor
            }


            onClicked: {
                onMonthTabClicked()
            }
        }


        Button{
            id:dayTab
            height: parent.height
            width: parent.width/4 - 0.5

            anchors.left: monthTab.right

            Text {
                id:dayText
                text: qsTr("Day")
                anchors.centerIn: parent
            }

            background: Rectangle{
                id:dayTabBackground
                color: dayTab.hovered ? Constants.themeColor : Constants.whiteColor
                border.color: Constants.darkThemeColor
            }


            onClicked: {
                onDayTabClicked()
            }
        }

    }

    Row{
        anchors.top: submenuTab.bottom

        height: parent.height - submenuTab.height - 20

        DateTimeFrameYearContent{
            id: yearTabContent
        }

        DateTimeFrameQuarterContent{
            id: quarterTabContent
            visible: false
        }
        DateTimeFrameMonthContent{
            id: monthTabContent
            visible: false
        }
        DateTimeFrameDayContent{
            id: dayTabContent
            visible: false
        }



    }



    // Page Design Ends
    /***********************************************************************************************************************/


}
