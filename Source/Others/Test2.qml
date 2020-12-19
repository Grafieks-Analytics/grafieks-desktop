import QtQuick 2.15
import QtWebEngine 1.4
import QtWebChannel 1.5


import QtQuick.Controls 2.15
import com.grafieks.singleton.constants 1.0

Item{
    id:root
    height: 500
    width:  500

    Component.onCompleted: {
//        ConnectorsLoginModel.mysqlLogin("localhost", "grafieks_dummy", 3306, "root", "");

    }

    Connections{
        target: ConnectorsLoginModel
        function onMysqlLoginStatus(status){
            console.log(status);
        }
    }

    Connections {
        target: ReportModelList
        function onSendData(xAxis,yAxis){
            const dataValues = JSON.stringify([xAxis,yAxis]);
            var scriptValue = 'window.addEventListener("resize", function () {
                    d3.selectAll("#my_dataviz").html("");
                    drawChart('+dataValues+');
                });';
            webEngineView.runJavaScript('drawChart('+dataValues+'); '+scriptValue);
        }
    }

    Rectangle{
        anchors.fill: parent
        color: "black"

        Button{
            text: "Click ME"
            z: 1000
            onClicked: {
                ReportModelList.getData();
            }
        }

        WebEngineView{
            id : webEngineView
            anchors.fill: parent
            url : "../Charts/BarChartArrayInput.html";
        }
    }

}
