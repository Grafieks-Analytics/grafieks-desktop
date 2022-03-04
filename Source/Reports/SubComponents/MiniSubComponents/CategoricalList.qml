import QtQuick 2.15
import QtQuick.Controls 2.15


ListView{

    id:categoricalList
    property string itemName: "";
    property string itemType: "Categorical";
    flickableDirection: Flickable.VerticalFlick
    boundsBehavior: Flickable.StopAtBounds
    interactive: true
    clip: false
    ScrollBar.vertical: ScrollBar {
        policy: ScrollBar.AlwaysOn
        anchors.right: parent.right
        anchors.rightMargin: -6
    }


    ListModel{
        id: listmodel
    }


    Connections{
        target : ReportsDataModel

        function onSendFilteredColumn(allCategoricalMap, allNumericalMap, allDatesMap){
            listmodel.clear()
            for(const [key, value] of Object.entries(allCategoricalMap)){
                console.log("FIELD NAME AND ALIAS", key, value)
                listmodel.append({"key" : key, "value": value})
            }

            categoricalList.model =  listmodel
        }
    }

    anchors.top: categoricalHeading.bottom
    anchors.topMargin: 5
    height: parent.height-20
    width: parent.width
    delegate: DataPaneElement{
        id: dataPaneListElement
        visible: key === false ? false : true
        height: key === false ? 0 : 24
        Component.onCompleted: {
            console.log('Debug: Index', itemType, key, value, itemName);
        }
    }

}
