import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Dialogs

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents";
import "../MiniSubComponents";

Popup {

    
   Connections{
        target: ReportParamsModel

        function onEditReportToggleChanged(reportId){
            if(reportId=="-1"){
                 return;
            }
            if(reportId != "false"){
                var reportProperties = ReportParamsModel.getReport(reportIdMain);
                setOldValues(reportProperties)
            }
            else{
                resetAllValues();
            }
        }
    }
    
    function resetAllValues(){
        customSlider.value = 75;
    }

    function setOldValues(reportProperties){
        
        var qmlChartConfigProperties = JSON.parse(reportProperties.qmlChartConfig);
        var { sizePopupValue  } = qmlChartConfigProperties || {};
        if(sizePopupValue){
            customSlider.value = sizePopupValue;
        }
    }

    width: parent.width - 20
    x: 10
    height: 50
    modal: false

    background: Rectangle{
        color: Constants.whiteColor
        border.color: Constants.themeColor
    }

    CustomSlider {
        id: customSlider
        from: 8
        value: 20
        to: 99
        width: parent.width

        onValueChanged: {
            resizePaddingInner(1-value/100,value);
        }
    }

}
