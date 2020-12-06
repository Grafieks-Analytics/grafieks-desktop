import QtQuick 2.15
import QtWebEngine 1.4
import QtWebChannel 1.5


import QtQuick.Controls 2.15
import com.grafieks.singleton.constants 1.0

Item{
    id:root
    height: 500
    width:  500

    property var dataValues: []

    Connections {
        target: ReportModelList
        function onSendData(xAxis,yAxis){
            myObject.dataValues.push(xAxis,yAxis);
            webEnginView.url = "../Charts/BarChartArrayInput.html";
        }
    }


    // Create WebChannel
    WebChannel{
        id:webChannel
    }



    //Now, let’s create an object that we want to publish to the HTML/JavaScript clients:
    QtObject {
        id: myObject
        objectName: "myObject"
        property var dataValues: [];

        // the identifier under which this object
        // will be known on the JavaScript side
        //WebChannel.id: "webChannel"

        property var send: function (arg) {
            sendTextMessage(arg);
        }

        // signals, methods and properties are
        // accessible to JavaScript code
        signal someSignal(string message);


        function someMethod(message) {
            console.log(message);
            someSignal(message);
            return dataValues;
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
            id : webEnginView
            anchors.fill: parent
            url : "";
            webChannel: webChannel
        }
    }


    Component.onCompleted: {
        webChannel.registerObject("foo", myObject);
        //Expose C++ object
        webChannel.registerObject("bar", ReportModelList);
    }
}
