import QtQuick 2.0
import QtQuick.Controls 2.15
import com.grafieks.singleton.constants 1.0


ListView{
    id: numericalList

    flickableDirection: Flickable.VerticalFlick
    boundsBehavior: Flickable.StopAtBounds
    interactive: true
    clip: false
    ScrollBar.vertical: ScrollBar {
        policy: ScrollBar.AlwaysOn
        anchors.right: parent.right
        anchors.rightMargin: -6
    }

    property string itemType: "Numerical"

    ListModel{
        id: listmodel
    }


    Connections{
        target : ReportsDataModel

        function onSendFilteredColumn(allCategoricalMap, allNumericalMap, allDatesMap){
            listmodel.clear()
            listmodel.append({"key" : Constants.tempGrafieksValue, "value": ""})
            for(const [key, value] of Object.entries(allNumericalMap)){
                console.log("FIELD NAME AND ALIAS", key, value)
                listmodel.append({"key" : key, "value": value})
            }

            numericalList.model =  listmodel
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
    height: parent.height - 20
    width: parent.width

    delegate: DataPaneElement{
        id: dataPaneListElement
        visible: key === Constants.tempGrafieksValue ? false : true
        height: key === Constants.tempGrafieksValue ? 0 : 24
    }

}


