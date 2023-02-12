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
                console.log("key", key, "value", value)
                listmodel.append({"key" : key, "value": value, "calculated": false})
            }

            numericalList.model =  listmodel
        }
    }

    Connections{
        target: CalculatedFields

        function onSignalCalculatedFields(calculatedFields){
            for(const [key, value] of Object.entries(calculatedFields)){
                if(value[2] === Constants.numericalItemType) {
                    listmodel.append({"key" : key, "value": key, "calculated": true})
                }
            }
            numericalList.model =  listmodel
        }
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


