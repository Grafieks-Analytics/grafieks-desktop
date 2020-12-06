import QtQuick 2.15
import QtWebEngine 1.4
import QtWebChannel 1.5

Item{
    id:root
    height: 500
    width:  500

    property var dataValues: []

    Connections {
        target: ReportModelList
        function onSendData(xAxis,yAxis){
            console.log(xAxis)
            console.log(yAxis)
            dataValues.push(xAxis,yAxis);
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
//        property var dataValues: [["India","SA","AUS","CHINA","America"],[120,211,311,324,132]];
        property var dataValues: root.dataValues;


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

        WebEngineView{
            id : webEnginView
            anchors.fill: parent
            url : "../Charts/BarChartArrayInput.html";
            webChannel: webChannel
        }
    }

    Component.onCompleted: {
        console.log(ReportModelList.getData());
        webChannel.registerObject("foo", myObject);
        //Expose C++ object
        webChannel.registerObject("bar", ReportModelList);
    }
}
