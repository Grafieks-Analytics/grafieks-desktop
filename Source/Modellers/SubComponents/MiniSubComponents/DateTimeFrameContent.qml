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

    height: parent.height - 80 - 40
    width: parent.width - 40
    x:20
    y:30
    color: Constants.whiteColor
    border.color: Constants.darkThemeColor
    property int counter: 0

    visible: false


    /***********************************************************************************************************************/
    // LIST MODEL STARTS


    // LIST MODEL ENDS
    /***********************************************************************************************************************/


    /***********************************************************************************************************************/
    // SIGNALS STARTS

     signal signalTimeFrameRadioEditYear(string relation, string slug, string value)
     signal signalTimeFrameRadioEditDay(string relation, string slug, string value)
     signal signalTimeFrameRadioEditMonth(string relation, string slug, string value)
     signal signalTimeFrameRadioEditQuarter(string relation, string slug, string value)

    // SIGNALS ENDS
    /***********************************************************************************************************************/



    /***********************************************************************************************************************/
    // Connections Starts
    Connections{
        target: DSParamsModel

        function onResetInput(){
            onYearTabClicked()
            DSParamsModel.setExcludeMap(counter, false)
            DSParamsModel.setIncludeNullMap(counter, true)
        }

        function onInternalCounterChanged(){
            counter = DSParamsModel.internalCounter
        }

        function onFilterIndexChanged(){
            counter = DSParamsModel.filterIndex
        }
    }

    Connections{
        target: QueryDataModel

        function onColumnListModelDataChanged(colData, options, searchMode){

            if(DSParamsModel.section === Constants.dateTab && DSParamsModel.category === Constants.dateMainTimeFrameType ){

                var jsonOptions = JSON.parse(options)
                var subCategory = jsonOptions.subCategory
                var relation = jsonOptions.relation
                var slug = jsonOptions.slug
                var value = jsonOptions.values

                if(subCategory.toLowerCase() === "day"){
                    onDayTabClicked()
                    dateTimeFrameContent.signalTimeFrameRadioEditDay(relation, slug, value)
                }
                else if(subCategory.toLowerCase() === "year"){
                    onYearTabClicked()
                    dateTimeFrameContent.signalTimeFrameRadioEditYear(relation, slug, value)
                }
                else if(subCategory.toLowerCase() === "month"){
                    onMonthTabClicked()
                    dateTimeFrameContent.signalTimeFrameRadioEditMonth(relation, slug, value)
                }
                else{
                    onQuarterTabClicked()
                    dateTimeFrameContent.signalTimeFrameRadioEditQuarter(relation, slug, value)
                }
            }
        }
    }


    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    Component.onCompleted: {
        dateTimeFrameContent.signalTimeFrameRadioEditYear.connect(yearTabContent.slotEditYear)
        dateTimeFrameContent.signalTimeFrameRadioEditDay.connect(dayTabContent.slotEditDay)
        dateTimeFrameContent.signalTimeFrameRadioEditMonth.connect(monthTabContent.slotEditMonth)
        dateTimeFrameContent.signalTimeFrameRadioEditQuarter.connect(quarterTabContent.slotEditQuarter)
    }

    function slotDataCleared(){

    }

    function slotEditModeTimeFrame(subCategory, relation, slug, value){
        dateTimeFrameContent.visible = true


        if(subCategory.toLowerCase() === "day"){
            onDayTabClicked()
            dateTimeFrameContent.signalTimeFrameRadioEditDay(relation, slug, value)
        }
        else if(subCategory.toLowerCase() === "year"){
            onYearTabClicked()
            dateTimeFrameContent.signalTimeFrameRadioEditYear(relation, slug, value)
        }
        else if(subCategory.toLowerCase() === "month"){
            onMonthTabClicked()
            dateTimeFrameContent.signalTimeFrameRadioEditMonth(relation, slug, value)
        }
        else{
            onQuarterTabClicked()
            dateTimeFrameContent.signalTimeFrameRadioEditQuarter(relation, slug, value)
        }
    }

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
