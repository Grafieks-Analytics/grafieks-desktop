import QtQuick 2.15
import QtQuick.Controls 2.15


ListView{

    id:categoricalList
    property string itemName: "";
    property string itemType: "Categorical";
    flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds
            interactive: true
             clip: true
             ScrollBar.vertical: ScrollBar {}



    Connections{
        target : ChartsModel

        function onSendFilteredColumn(allCategorical, allNumerical, allDates){
            categoricalList.model =  allCategorical
        }
    }

    anchors.top: categoricalHeading.bottom
    anchors.topMargin: 5
    height: parent.height - categoricalHeading.height - 5
    width: parent.width
//    interactive: false
    delegate: DataPaneElement{
        id: dataPaneListElement
    }

}
