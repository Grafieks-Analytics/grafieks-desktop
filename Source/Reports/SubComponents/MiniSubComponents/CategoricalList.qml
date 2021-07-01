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
    ScrollBar.vertical: ScrollBar {}



    Connections{
        target : ReportsDataModel

        function onSendFilteredColumn(allCategorical, allNumerical, allDates){
            categoricalList.model =  allCategorical
        }
    }

    anchors.top: categoricalHeading.bottom
    anchors.topMargin: 5
    height: parent.height-20
    width: parent.width
    delegate: DataPaneElement{
        id: dataPaneListElement
    }

}
