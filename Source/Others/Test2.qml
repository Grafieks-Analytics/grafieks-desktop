import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Page {

    id : somepageid

    Button {
        id: x
        text: "bat"

        onClicked: {
            QueryStatsModel.setProfiling(true)
            QueryModel.setTmpSql("SELECT * FROM dashboards");
            QueryModel.callSql()
            QueryStatsModel.showStats()
        }
    }

    ListModel{
        id: y
        ListElement{
            name: "a"
            surname: "b"
        }
    }

    TableView{
        id: a
        anchors.top: x.bottom
        model: QueryStatsModel
        height: 500
        width: 400
        delegate:
            Text {
            text: display

        }
    }

}
