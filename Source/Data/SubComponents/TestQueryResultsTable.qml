import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

Item{


    ListModel{
        id : testQueryModel
        ListElement{
            status: "tick"
            queryNumber:"1"
            action:"SELECT * from  accounts LIMIT 0, 1000"
            message:"1 row(s) returned"
            duration:"01.000 sec"
        }
        ListElement{
            status: "cross"
            queryNumber:"2"
            action:"SELECT * from  accountssad LIMIT 0, 1000"
            message:"Error Code: 1146. Table 'grafieks_my.accountsasd' doesn't exist"
            duration:""
        }
        ListElement{
            status: "tick"
            queryNumber:"3"
            action:"SELECT * from  accountsasda LIMIT 0, 1000"
            message:"2 row(s) returned"
            duration:"01.000 sec"
        }
    }

    TableView {
        id: testQueryResult
        anchors.top: linebar2.bottom
        model: testQueryModel
        width: parent.width
        height:300

        delegate: Row{
            height:30
            width: parent.width

            Column{
                width: 50
                height: parent.height
                topPadding: 5

                Row{
                    height: parent.height
                    width: parent.width
                    anchors.top: parent
                    anchors.topMargin: 3
                    anchors.left: parent.left
                    leftPadding: 20

                    Image {
                        id: statusImg
                        height: 18
                        width: 18
                        source: "../../Images/icons/tick.png"
                    }

                }

            }

            Column{
                width: 50
                height: parent.height

                Row{
                    height: parent.height
                    width: parent.width
                    anchors.left: parent
                    anchors.leftMargin: 2

                    Text {
                        text: qsTr(queryNumber)
                        padding: 5
                        leftPadding: 20
                    }
                }

            }


            Column{
                width: parent.width * 0.4
                height: 30

                Row{
                    height: parent.height
                    width: parent.width
                    anchors.left: parent

                    Text {
                        text: qsTr(action)
                        padding: 5
                        leftPadding: 20
                    }
                }

            }

            Column{
                width: parent.width * 0.3
                height: 30

                Row{
                    height: parent.height
                    width: parent.width
                    anchors.left: parent

                    Text {
                        text: qsTr(message)
                        padding: 5
                        leftPadding: 20
                    }
                }
            }

            Column{
                width: parent.width * 0.1
                height: 30

                Row{
                    height: parent.height
                    width: parent.width

                    Text {
                        text: qsTr(duration)
                        padding: 5
                        leftPadding: 20
                    }
                }
            }

        }

    }
}
