import QtQuick 2.15
import QtQuick.Controls 
import QtQuick.Layouts 1.0
import QtQuick.Dialogs
// import QtQuick.Window 2.1


SpinBox {
    id: fontSizeSpinBox
    value: 0
    editable:true

}
// SpinBox {
//     id: fontSizeSpinBox
//     from: 0
//     value: 110
//     to: 100 * 100
//     stepSize: 100
//     // editable:true
//     anchors.centerIn: parent

//     property int decimals: 2
//     property real realValue: value / 100

//     validator: DoubleValidator {
//         bottom: Math.min(spinbox.from, spinbox.to)
//         top:  Math.max(spinbox.from, spinbox.to)
//     }

//     textFromValue: function(value, locale) {
//         return Number(value / 100).toLocaleString(locale, 'f', spinbox.decimals)
//     }

//     valueFromText: function(text, locale) {
//         return Number.fromLocaleString(locale, text) * 100
//     }
// }
