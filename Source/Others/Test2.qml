import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Page {

    id : somepageid


    CheckBox {
        checked: true
        text: qsTr("Check Me")
        indicator.width: 15
        indicator.height: 15

        onCheckedChanged: {
            console.log(checked)
        }

        onCheckStateChanged: {
            console.log(checked)
        }

    }
}
