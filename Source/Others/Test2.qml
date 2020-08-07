import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Page {

    id : somepageid
    property int modelList: 0
    property int counter: 0

    ListModel {
        id: listModel
    }

    ListView{
        model: listModel
        anchors.top:  testButton.bottom
        height: parent.height

        delegate: Row{
            ComboBox{
                textRole: "elem"
                model:  ListModel{
                    ListElement{
                        elem: "A"
                    }
                    ListElement{
                        elem: "B"
                    }
                    ListElement{
                        elem: "C"
                    }
                }
                onCurrentIndexChanged: listModel.setProperty(index ,"value", currentIndex)
            }
        }
    }


    Button{
        id: testButton
        text: "Click to add Combobox"
        onClicked: {
            listModel.append({"value":0})
        }
    }
}
