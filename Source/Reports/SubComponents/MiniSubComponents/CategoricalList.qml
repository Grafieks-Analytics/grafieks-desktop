import QtQuick 2.15
import QtQuick.Controls 2.15


ListView{

    id:categoricalList
    property string itemName: "";
    property string itemType: "Categorical";

    ListModel{
        id: categoricalModel
        ListElement{
            categoricalName: "Customer Name"
        }
        ListElement{
            categoricalName: "Customer Name 1"
        }
        ListElement{
            categoricalName: "Customer Name 2"
        }
        ListElement{
            categoricalName: "Customer Name 3"
        }
    }

    Connections{
        target : ChartsModel

        function onSendFilteredColumn(allCategorical, allNumerical, allDates){
            console.log(allCategorical, allNumerical, allDates)
            categoricalModel.clear()
            categoricalList.model =  allCategorical
        }
    }

    model: categoricalModel
    anchors.top: categoricalHeading.bottom
    anchors.topMargin: 5
    height: parent.height - categoricalHeading.height - 5
    width: parent.width
    interactive: false
    delegate: DataPaneElement{
        id: dataPaneListElement
    }

}
