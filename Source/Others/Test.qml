import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../MainSubComponents"

Page{

    ButtonGroup{
        id: buttons
    }

    Column{
        spacing: 10

        RadioButtonTpl{
            ButtonGroup.group: buttons
            radio_text: qsTr("This Year")
            radio_checked: false
            parent_dimension: 16
        }

        RadioButtonTpl{
            ButtonGroup.group: buttons
            radio_text: qsTr("This Year 2")
            radio_checked: false
            parent_dimension: 16
        }
    }


}
