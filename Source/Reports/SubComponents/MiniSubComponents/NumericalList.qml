import QtQuick 2.0
import QtQuick.Controls 2.15


ListView{
    id: numericalList

    flickableDirection: Flickable.VerticalFlick
    boundsBehavior: Flickable.StopAtBounds
    interactive: false
    clip: false
    ScrollBar.vertical: ScrollBar {
        policy: ScrollBar.AlwaysOn
        anchors.right: parent.right
        anchors.rightMargin: -6
    }

    property string itemType: "Numerical"


    Connections{
        target : ReportsDataModel

        function onSendFilteredColumn(allCategorical, allNumerical, allDates){
            numericalList.model =  allNumerical

        }
    }
    function appendToList(name){
        numericalModel.append({categoricalName: name});
    }

    function isDropEligible(itemType){
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

    anchors.top: numericalHeading.bottom
    anchors.topMargin: 5
    height: parent.height - numericalHeading.height - 5
    width: parent.width

    delegate: DataPaneElement{
        id: dataPaneListElement
    }

}


