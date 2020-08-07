import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Page {

    id : somepageid

    Column{
        Button{
            id: btn1
            text: "btn a"
            onClicked: {
                filterList.searchByCategory("category a")
            }
        }

        Button{
            id: btn2
            text: "btn b"
            onClicked: {
                filterList.searchByCategory("category b")
            }
        }
    }

    ListView{
        id: lv1
        model: filterList
        height: 100
        delegate: Row{
            Text{
                text: name
            }
        }
    }

    ListView{
        id: lv2
        anchors.top: lv1.bottom
        model: filterList
        height: 100
        delegate: Row{
            Text{
                text: name
            }
        }
    }

}
