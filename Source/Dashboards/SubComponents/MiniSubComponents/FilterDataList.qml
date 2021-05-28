import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

Item {
    id: filterDataItem
    width: parent.width
    height: 200
    property alias componentName: filterDataItem.objectName

    onComponentNameChanged: {
       dataListView.model = TableColumnsModel.fetchColumnData(componentName)
    }


    Connections{
        target: DashboardParamsModel

        function onAliasChanged(newAlias, columnName){
            if(columnName === componentName){
                componentTitle.text = newAlias
            }
        }
    }

    function toggleSearch(){

        if(searchFilter.visible){
            searchFilter.visible=false
            searchFilter.height=0
            return
        }
        searchFilter.visible=true
        searchFilter.height=30
    }

    function searchData(searchText){
        console.log(searchText, componentName)
        dataListView.model = TableColumnsModel.searchColumnData(searchText, componentName)
    }

    function filterClicked(){
        DashboardParamsModel.setCurrentSelectedColumn(componentName)
        labelShapePopup1.visible = true
    }


    Component{
        id:singleselect
        Row{
            CustomRadioButton{
                ButtonGroup.group: buttonGroupSingle
                radio_text: modelData
                radio_checked: false
                parent_dimension: 16
            }
        }
    }

    Component{
        id:multipleselect
        Row{
            CheckBoxTpl{
                checkbox_text: modelData
                checkbox_checked: true
                parent_dimension: 14
            }
        }
    }

    Rectangle{
        id:columnName
        width:parent.width
        height:25

        border.color: Constants.themeColor
        Row{

            spacing: 45
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter


            Text {
                id: componentTitle
                text: componentName
                font.pixelSize: 12
                verticalAlignment: Text.AlignVCenter
            }

            Row{

                height: parent.height
                width: 40
                spacing: 5
                Image {
                    source: "/Images/icons/iconmonstr-search-thin.svg"
                    width: 14
                    height: 14

                    MouseArea{
                        anchors.fill: parent
                        onClicked:  toggleSearch()
                    }
                }
                Image {
                    source: "/Images/icons/customize.png"
                    width: 16
                    height: 16
                    MouseArea{
                        anchors.fill: parent
                        onClicked: filterClicked()
                    }

                }
            }

        }

    }

    Rectangle{
        id: searchFilter
        visible: false
        anchors.top: columnName.bottom
        height: 0
        width: parent.width
        TextField{
            id: searchText
            width: parent.width-10
            selectByMouse: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top

            placeholderText: qsTr("Search")
            background: Rectangle {
                border.color: Constants.themeColor
                width: parent.width
                border.width: Constants.borderWidth
            }
            onTextChanged: searchData(searchText.text)

        }

    }

    ListView{
        id: dataListView
        topMargin: 10
        height:150
        flickableDirection: Flickable.VerticalFlick
        boundsBehavior: Flickable.StopAtBounds
        clip: true
        ScrollBar.vertical: CustomScrollBar {}
        width: parent.width
        anchors.top: searchFilter.bottom

        delegate:{
            if(0){
                return singleselect
            } else if(1){
                return multipleselect
            } else{
                return null
            }
        }
    }
}
