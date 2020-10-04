import QtQuick 2.15
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.1
import QtQuick.Window 2.1


SpinBox {
    id: fontSizeSpinBox
    value: 0
    onValueChanged: console.log('Value Changed')
}
