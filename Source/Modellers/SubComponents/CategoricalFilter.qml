import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents"
import "../SubComponents/MiniSubComponents"

Popup {
    id: categoricalFilterPopup
    width: parent.width
    height: parent.height
    x: 0
    y: 0
    modal: true
    visible: false
    padding: 0
    closePolicy: Popup.NoAutoClose

    background: Rectangle{
        color: Constants.themeColor
        border.color: Constants.darkThemeColor
    }


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



    function closeCategoricalFilterPopup(){
        categoricalFilterPopup.visible = false

        // Reset all DSParams
        DSParamsModel.resetFilter();
    }

    function onApplyClicked(){
        categoricalFilterPopup.visible = false

        var filterIndex = DSParamsModel.filterIndex
        var section = DSParamsModel.section
        var category = DSParamsModel.category
        var subCategory = DSParamsModel.subCategory
        var tableName = DSParamsModel.tableName
        var columnName = DSParamsModel.colName
        var relation = DSParamsModel.relation
        var value = DSParamsModel.value
        var includeNull = DSParamsModel.includeNull
        var exclude = DSParamsModel.exclude



        // Save the filter
        if(DSParamsModel.mode === Constants.modeCreate){
            FilterListModel.newFilter(section, category, subCategory, tableName, columnName, relation, value, includeNull, exclude)

        } else{
            FilterListModel.updateFilter(filterIndex, section, category, subCategory, tableName, columnName, relation, value, includeNull, exclude)
        }

        // Reset all DSParams
        DSParamsModel.resetFilter();


    }

    function onListClicked(){

        listRadio.radio_checked = true
        wildcardRadio.radio_checked = false
        topRadio.radio_checked = false

        listContent.visible = true
        wildcardContent.visible = false
        topContent.visible = false

        // Set the main category of the filter
        DSParamsModel.setCategory(Constants.categoryMainListType)
    }


    function onWildcardClicked(){
        listRadio.radio_checked = false
        wildcardRadio.radio_checked = true
        topRadio.radio_checked = false


        listContent.visible = false
        wildcardContent.visible = true
        topContent.visible = false

        // Set the main category of the filter
        DSParamsModel.setCategory(Constants.categoryMainWildCardType)
    }


    function onTopClicked(){

        listRadio.radio_checked = false
        wildcardRadio.radio_checked = false
        topRadio.radio_checked = true


        listContent.visible = false
        wildcardContent.visible = false
        topContent.visible = true

        // Set the main category of the filter
        DSParamsModel.setCategory(Constants.categoryMainTopType)
    }


    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts




    // Popup Header starts

    Rectangle{
        id: headerPopup
        color: Constants.whiteColor
        border.color: "transparent"
        height: 40
        width: parent.width - 2
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 1
        anchors.leftMargin: 1


        Text{
            id : text1
            text: "Data Source Filter heading"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left : parent.left
            font.pixelSize: 15
            anchors.leftMargin: 10
        }
        Image {
            id: close_icn
            source: "../../../Images/icons/outline_close_black_18dp2x.png"
            anchors.verticalCenter: parent.verticalCenter
            anchors.right:  parent.right
            height: 25
            width: 25
            anchors.rightMargin: 5
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    closeCategoricalFilterPopup()
                }
            }
        }

    }

    // Popup Header ends


    //    Menu Starts

    Rectangle{
        id: fullExtactRadioBtn
        height: 40
        width: parent.width
        anchors.top: headerPopup.bottom

        color:"transparent"

        Column{

            id: listRadioColumn
            anchors.top: fullExtactRadioBtn.top

            width: parent.width/3
            anchors.left: parent.left
            leftPadding: 30
            topPadding: 8
            anchors.verticalCenter: parent.verticalCenter

            RadioButtonTpl{
                id: listRadio
                text: qsTr("List")
                checked: true
                parent_dimension: 16

                MouseArea{
                    anchors.fill:parent
                    onClicked: {
                        onListClicked()
                    }
                }
            }

        }
        Column{
            id: wildcardRadioColumn
            topPadding: 10
            bottomPadding: 10
            leftPadding: 50
            width: parent.width /3
            anchors.top: fullExtactRadioBtn.top
            anchors.centerIn: parent

            RadioButtonTpl{
                id: wildcardRadio
                text: qsTr("Wildcard")
                checked: false
                parent_dimension: 16

                MouseArea{
                    anchors.fill:parent
                    onClicked: {
                        onWildcardClicked()
                    }
                }

            }
        }
        Column{
            id: topRadioColumn

            anchors.right: fullExtactRadioBtn.right
            topPadding: 8
            rightPadding: 30

            RadioButtonTpl{
                id: topRadio
                text: qsTr("Top")
                checked: false
                parent_dimension: 16

                MouseArea{
                    anchors.fill:parent
                    onClicked: {
                        onTopClicked()
                    }
                }
            }
        }
    }

    //   Menu Ends

    //    Top Menu Contents

    CategoricalFilterListContent{
        id: listContent
    }

    CategoricalFilterWildcardContent{
        id: wildcardContent
    }

    CategoricalFilterTopContent{
        id: topContent
    }

    // Footer starts

    Rectangle{
        id: footerContent
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        anchors.rightMargin: 20

        height: 30
        width: parent.width
        color:"transparent"

        CustomButton{
            id: resetBtn
            textValue: "Reset"

            anchors.left: parent.left
            anchors.leftMargin: 20


            onClicked: {
                categoricalFilterPopup.visible = false
                DSParamsModel.resetFilter();
            }
        }



        CustomButton{
            id: apply_btn1
            textValue: "Apply"

            anchors.right: parent.right
            anchors.rightMargin: 20


            onClicked: {
                onApplyClicked()
            }
        }


        CustomButton{
            id: cancel_btn1

            anchors.right: apply_btn1.left
            anchors.rightMargin: 20

            textValue: "Cancel"
            onClicked: {
                closeCategoricalFilterPopup()

            }

        }


    }

    // Footer ends


    // Page Design Ends
    /***********************************************************************************************************************/

}
