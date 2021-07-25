import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQml.Models 2.2



Rectangle {
    id: win
    width: parent.width
    height: parent.height
    visible: true
    property bool master : false

    ListModel{
        id: listModel
        dynamicRoles: true
        Component.onCompleted: {
            var numbers = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40]
            for(var i in numbers){
                var number = numbers[i]
                listModel.append({"number": number, "checked": true})
            }
            master = true
        }
    }
    CheckBox {
        id: mainCheckBox
        checked: true
        text: "All"
        indicator.width: 15
        indicator.height: 15
        onCheckStateChanged: {
            for(var i =0; i < listModel.count; ++i){
                listModel.setProperty(i, "checked", checked)
            }
            if(checked === true){
                master = true
            }
        }
    }
    ListView {
        id: multiSelectCheckList
        model: listModel
        height: parent.height
        width: parent.width
        anchors {
            top: mainCheckBox.bottom
            margins: 10
        }

        delegate: CheckBox {
            id: modelCheckBoxes
            checked: model.checked
            text: model.number
            indicator.width: 15
            indicator.height: 15

            onCheckedChanged: {
                if(master === true && checked === false){
                    master = false
                    mainCheckBox.checked = false
                }

                if(master === false && checked === true){
                    listModel.setProperty(model.number - 1, "checked", true)
                }
            }
        }
    }
}
