import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../MainSubComponents"

Page{


    Rectangle{
        height: 300
        width: 500
        border.color: "red"
        Column{
            spacing: 10
            height: parent.height
            width: parent.width
            ListView{

                flickableDirection: Flickable.VerticalFlick
                boundsBehavior: Flickable.StopAtBounds

                model: 50
                height: parent.height
                width: parent.width
                spacing: 3
                delegate:Text{
                        text: qsTr("1")
                }


                clip: true
                Layout.fillWidth: true
                Layout.fillHeight: true
                ScrollBar.horizontal: CustomScrollBar {}
                ScrollBar.vertical: CustomScrollBar {}

            }
        }

    }

}
