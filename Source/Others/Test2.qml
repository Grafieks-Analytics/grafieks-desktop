import QtQuick 2.15
import QtWebEngine 1.4
import QtWebChannel 1.5


import QtQuick.Controls 2.15
import com.grafieks.singleton.constants 1.0

Item{
    id:root
    height: 500
    width:  500

    function callOdbc(){
//        MysqlConnect.tMysqlOdbcInstance("asdas","localhost", "grafieks_dummy", 3306, "root", "");
    }

    function osTest(){
        QtTest2.osTest()
    }


    Button{
        id: bb
        text: "Click me"
        onClicked: callOdbc()
    }

    Button{
        id: bb2
        text: "Click OS Test"
        onClicked: osTest()
    }

}
